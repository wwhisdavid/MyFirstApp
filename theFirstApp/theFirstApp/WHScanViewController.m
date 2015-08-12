//
//  WHScanViewController.m
//  theFirstApp
//
//  Created by deyi on 15/7/22.
//  Copyright (c) 2015年 deyi. All rights reserved.
//


#import "WHScanViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface DyScannerViewController ()

- (void)updateCaptureLayout;

@end

@implementation DyScannerViewController


#pragma mark - getter and setter

- (ZXCapture *)capture
{
    if (!_capture) {
        _capture = [[ZXCapture alloc] init];
        _capture.camera = _capture.back;
        _capture.focusMode = AVCaptureFocusModeContinuousAutoFocus;
        _capture.rotation = 90.0f;
    }
    return _capture;
}

- (UIView *)scanBgView
{
    if (!_scanBgView) {
        CGFloat scanBgViewY = IOS7_OR_LATER ? 64.f : 44.f;
        CGFloat scanBgViewH = _toolView.frame.origin.y - scanBgViewY;
        _scanBgView = [[UIView alloc] initWithFrame:CGRectMake(0.f, scanBgViewY, self.view.frame.size.width, scanBgViewH)];
        _scanBgView.backgroundColor = [UIColor clearColor];
        _scanBgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        if (1) {
            CGFloat scanRectViewY = 60.f;
            CGFloat scanRectViewH = 260.f;
            CGFloat scanRectViewW = 260.f;
            CGFloat scanRectViewX = (_scanBgView.frame.size.width - scanRectViewW ) / 2.0;
            _scanRectView = [[UIView alloc] initWithFrame:CGRectMake(scanRectViewX, scanRectViewY, scanRectViewW, scanRectViewH)];
            _scanRectView.backgroundColor = [UIColor clearColor];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:_scanRectView.bounds];
            imageView.backgroundColor = [UIColor clearColor];
            imageView.image = [UIImage imageNamed:@"scanningFrame"];
            [_scanRectView addSubview:imageView];
            
            CGFloat animateImageViewH = 4.f;
            UIImageView *animateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, _scanRectView.frame.size.width, animateImageViewH)];
            animateImageView.tag = 100;
            animateImageView.image = [UIImage imageNamed:@"scanningHorizonLine"];
            [_scanRectView addSubview:animateImageView];
            
            [_scanBgView addSubview:_scanRectView];
        }
        {
            CGRect frame = _scanRectView.frame;
            CGFloat detaSpace = 3.f;
            frame.origin.x += detaSpace;
            frame.origin.y += detaSpace;
            frame.size.height -= detaSpace * 2.0;
            frame.size.width -= detaSpace * 2.0;
            
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:_scanBgView.bounds cornerRadius:0];
            UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:frame];
            [path appendPath:rectPath];
            [path setUsesEvenOddFillRule:YES];
            
            CAShapeLayer *fillLayer = [CAShapeLayer layer];
            fillLayer.path = path.CGPath;
            fillLayer.fillRule = kCAFillRuleEvenOdd;
            fillLayer.fillColor = [UIColor colorWithWhite:0.0 alpha:0.8].CGColor;
            fillLayer.opacity = 0.5;
            [_scanBgView.layer addSublayer:fillLayer];
        }
        [_scanBgView bringSubviewToFront:_scanRectView];
    }
    return _scanBgView;
}


- (UIView *)toolView
{
    if (!_toolView) {
        CGFloat toolViewH = 80.f;
        CGFloat toolViewY = self.view.frame.size.height - toolViewH;
        _toolView = [[UIView alloc] initWithFrame:CGRectMake(0.f, toolViewY, self.view.frame.size.width, toolViewH)];
        _toolView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        _toolView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5f];
        
        NSInteger buttonAcount = 2;
        CGFloat buttonW = 50.f;
        CGFloat buttonH = 50.f;
        CGFloat buttonY = (_toolView.frame.size.height - buttonH) / 2.0;
        CGFloat buttonSpace = (_toolView.frame.size.width - buttonW * buttonAcount ) / (buttonAcount + 1);
        for (NSInteger index = 0; index < buttonAcount; index ++) {
            CGFloat buttonX = buttonSpace * (index + 1) + buttonW * index;
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
            button.tag = 100 + index;
            [button addTarget:self action:@selector(toolButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            if (index == 0) {
                [button setBackgroundImage:[UIImage imageNamed:@"scanningPhotoLib"] forState:UIControlStateNormal];
            } else if (index == 1) {
                [button setBackgroundImage:[UIImage imageNamed:@"scanningLighting"] forState:UIControlStateNormal];
            }
            [_toolView addSubview:button];
        }
    }
    return _toolView;
}

-(AVCaptureSession *)captureSesion
{
    if(!_captureSession)
    {
        _captureSession = [[AVCaptureSession alloc] init];
    }
    return _captureSession;
}

-(AVCaptureDevice *)captureDevice
{
    if(!_captureDevice)
    {
        _captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    return _captureDevice;
}

- (void)setEnableScanAnimation:(BOOL)enableScanAnimation
{
    if (_enableScanAnimation == enableScanAnimation) {
        return;
    }
    _enableScanAnimation = enableScanAnimation;
}

#pragma mark - action

- (void)toolButtonPressed:(id)sender
{
    UIButton *button = (UIButton*)sender;
    if (button.tag == 100) {
        [self takePhoto];
    } else {
        [self switchFlashlight];
    }
}


#pragma mark - View Controller Methods

- (void)dealloc {
    [_capture.layer removeFromSuperlayer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    
    [self.view.layer addSublayer:self.capture.layer];
    [self.view addSubview:self.toolView];
    [self.view addSubview:self.scanBgView];
    [self startScanAnimation];
    [self setEnableScanAnimation:YES];
    [self updateCaptureLayout];
    
    if (IOS7_OR_LATER) {
        [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _statusBarStyle = [[UIApplication sharedApplication] statusBarStyle];
    _tintColor = self.navigationController.navigationBar.tintColor;
    _titleTextAttributes = self.navigationController.navigationBar.titleTextAttributes;
    _translucent = self.navigationController.navigationBar.translucent;
    
    _backgroundImage = [[UINavigationBar appearance] backgroundImageForBarMetrics:UIBarMetricsDefault];
    
    if (IOS7_OR_LATER) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    } else {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
    }
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor],NSForegroundColorAttributeName,
                                                                     nil]];
    [self startScan];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self updateCaptureLayout];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stopScan];
    
    [[UIApplication sharedApplication] setStatusBarStyle:_statusBarStyle animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:_backgroundImage forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = _tintColor;
    [self.navigationController.navigationBar setTitleTextAttributes:_titleTextAttributes];
    self.navigationController.navigationBar.translucent = _translucent;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

#pragma mark - Private Methods

- (NSString *)barcodeFormatToString:(ZXBarcodeFormat)format {
    switch (format) {
        case kBarcodeFormatAztec:
            return @"Aztec";
            
        case kBarcodeFormatCodabar:
            return @"CODABAR";
            
        case kBarcodeFormatCode39:
            return @"Code 39";
            
        case kBarcodeFormatCode93:
            return @"Code 93";
            
        case kBarcodeFormatCode128:
            return @"Code 128";
            
        case kBarcodeFormatDataMatrix:
            return @"Data Matrix";
            
        case kBarcodeFormatEan8:
            return @"EAN-8";
            
        case kBarcodeFormatEan13:
            return @"EAN-13";
            
        case kBarcodeFormatITF:
            return @"ITF";
            
        case kBarcodeFormatPDF417:
            return @"PDF417";
            
        case kBarcodeFormatQRCode:
            return @"QR Code";
            
        case kBarcodeFormatRSS14:
            return @"RSS 14";
            
        case kBarcodeFormatRSSExpanded:
            return @"RSS Expanded";
            
        case kBarcodeFormatUPCA:
            return @"UPCA";
            
        case kBarcodeFormatUPCE:
            return @"UPCE";
            
        case kBarcodeFormatUPCEANExtension:
            return @"UPC/EAN extension";
            
        default:
            return @"Unknown";
    }
}

#pragma mark - ZXCaptureDelegate Methods

- (void)captureResult:(ZXCapture *)capture result:(ZXResult *)result {
    if (!result) return;
    
    // We got a result. Display information about the result onscreen.
    NSString *formatString = [self barcodeFormatToString:result.barcodeFormat];
    NSString *display = [NSString stringWithFormat:@"Scanned!\n\nFormat: %@\n\nContents:\n%@", formatString, result.text];
    NSLog(@"%@",display);
    self.scanResult = result.text;
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [self stopScan];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self parseScanResult:_scanResult];
    });
}

#pragma mark - UINavigationControllerDelegate

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
        CGImageRef imageToDecode = image.CGImage;  // Given a CGImage in which we are looking for barcodes
        
        ZXLuminanceSource *source = [[ZXCGImageLuminanceSource alloc] initWithCGImage:imageToDecode];
        ZXBinaryBitmap *bitmap = [ZXBinaryBitmap binaryBitmapWithBinarizer:[ZXHybridBinarizer binarizerWithSource:source]];
        
        NSError *error = nil;
        
        // There are a number of hints we can give to the reader, including
        // possible formats, allowed lengths, and the string encoding.
        ZXDecodeHints *hints = [ZXDecodeHints hints];
        
        ZXMultiFormatReader *reader = [ZXMultiFormatReader reader];
        
        [MBProgressHUD showDurationProgressHUDWithMessage:NSLocalizedString(@"正在处理...", nil)];
        
        ZXResult *result = [reader decode:bitmap
                                    hints:hints
                                    error:&error];
        
        if (result) {
            [MBProgressHUD hideDurationProgressHUD];
            // The coded result as a string. The raw data can be accessed with
            // result.rawBytes and result.length.
            NSString *contents = result.text;
            
            // The barcode format, such as a QR code or UPC-A
            //            ZXBarcodeFormat format = result.barcodeFormat;
            self.scanResult = contents;
            [self stopScan];
            [self parseScanResult:_scanResult];
        } else {
            // Use error to determine why we didn't get a result, such as a barcode
            // not being found, an invalid checksum, or a format inconsistency.
            NSLog(@"%@",error.localizedDescription);
            NSLog(@"%@",error);
            [MBProgressHUD hideDurationProgressHUDWithFailedMessage:NSLocalizedString(@"扫码失败!", nil)];
        }
    }];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex) {
        [self performSelector:@selector(startScan) withObject:nil afterDelay:0.5];
    } else {
        if (alertView.tag == 1000) { // 是验证码
            [MBProgressHUD showDurationProgressHUDWithMessage:NSLocalizedString(@"正在处理...", nil)];
            [self userCodeWithCode:self.scanResult success:^(NSString *message) {
                [MBProgressHUD hideDurationProgressHUDWithSuccessfulMessage:message];
                [self performSelector:@selector(startScan) withObject:nil afterDelay:2.0];
            } failure:^(NSString *message) {
                [MBProgressHUD hideDurationProgressHUDWithFailedMessage:message];
                [self performSelector:@selector(startScan) withObject:nil afterDelay:2.0];
            }];
        } else {
        }
    }
}

#pragma mark - private

- (void)stopScan
{
    [self setEnableScanAnimation:NO];
    _capture.delegate = nil;
    [_capture stop];
}

- (void)startScan
{
    [self setEnableScanAnimation:YES];
    _capture.delegate = self;
}

- (void)parseScanResult:(NSString*)result
{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"扫码结果", nil) message:result delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"打开", nil), nil];
        alertView.tag = 1001;
        [alertView show];
}


- (void)updateCaptureLayout
{
    _capture.layer.frame = self.view.bounds;
    CGAffineTransform captureSizeTransform = CGAffineTransformMakeScale(320 / self.view.frame.size.width, 480 / self.view.frame.size.height);
    CGRect parentRect = [_scanRectView.superview convertRect:_scanRectView.frame toView:self.view];
    CGRect scanRect = CGRectApplyAffineTransform(parentRect, captureSizeTransform);
    //    CGFloat space = -40.f;
    //    scanRect.origin.x -= space;
    //    scanRect.origin.y -= space;
    //    scanRect.size.width += space * 2.0;
    //    scanRect.size.height += space * 2.0;
    _capture.scanRect = scanRect;
}

- (void)startScanAnimation
{
    if (!_enableScanAnimation) {
        [self performSelector:@selector(startScanAnimation) withObject:nil afterDelay:2.0];
    } else {
        UIImageView *animateImageView = (UIImageView *)[_scanRectView viewWithTag:100];
        {
            [UIView animateWithDuration:2.0 animations:^{
                [animateImageView setNewY:(_scanRectView.frame.size.height - animateImageView.frame.size.height - 4.f)];
            } completion:^(BOOL finished) {
                if (!_enableScanAnimation) {
                    [self performSelector:@selector(startScanAnimation) withObject:nil afterDelay:2.0];
                } else {
                    [UIView animateWithDuration:2.0 animations:^{
                        [animateImageView setNewY:4.f];
                    } completion:^(BOOL finished) {
                        [self startScanAnimation];
                    }];
                }
            }];
        }
    }
}

/**
 *  从相册选择照片扫描
 */
- (void)takePhoto
{
    //判断是否可以打开相机，模拟器此功能无法使用
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController * picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:^{
            
        }];
    } else {
        
    }
}

/**
 *  打开关闭闪光灯
 */
- (void)switchFlashlight
{
    if ([_captureSession isRunning]) {
        [self closeFlashlight];
    } else {
        [self openFlashlight];
    }
}

/**
 *  打开闪光灯
 */
-(void)openFlashlight
{
    if([self.captureDevice hasTorch] && [self.captureDevice hasFlash])
    {
        if(self.captureDevice.torchMode == AVCaptureTorchModeOff)
        {
            [self.captureSession beginConfiguration];
            [self.captureDevice lockForConfiguration:nil];
            [self.captureDevice setTorchMode:AVCaptureTorchModeOn];
            [self.captureDevice setFlashMode:AVCaptureFlashModeOn];
            [self.captureDevice unlockForConfiguration];
            [self.captureSession commitConfiguration];
        }
    }
    
    [self.captureSession startRunning];
}

/**
 *  关闭闪光灯
 */
-(void)closeFlashlight
{
    [self.captureSession beginConfiguration];
    [self.captureDevice lockForConfiguration:nil];
    if(self.captureDevice.torchMode == AVCaptureTorchModeOn)
    {
        [self.captureDevice setTorchMode:AVCaptureTorchModeOff];
        [self.captureDevice setFlashMode:AVCaptureFlashModeOff];
    }
    [self.captureDevice unlockForConfiguration];
    [self.captureSession commitConfiguration];
    [self.captureSession stopRunning];
}

@end
