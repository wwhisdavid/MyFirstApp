//
//  WHScanViewController.h
//  theFirstApp
//
//  Created by deyi on 15/7/22.
//  Copyright (c) 2015年 deyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZXingObjC/ZXingObjC.h>


@interface DyScannerViewController : UIViewController
<ZXCaptureDelegate
,UINavigationControllerDelegate
,UIImagePickerControllerDelegate>
{
    UIStatusBarStyle _statusBarStyle;
    NSDictionary *_titleTextAttributes;
    UIColor *_barTintColor;
    UIColor *_tintColor;
    UIImage *_backgroundImage;
    BOOL _translucent;
    
    BOOL _isCameraValid;
}

@property (nonatomic, strong) ZXCapture *capture;
@property (nonatomic, strong) UIView *scanRectView;
@property (nonatomic, strong) UIView *scanBgView;
@property (nonatomic, strong) UIView *toolView;

/**
 *  调用闪光灯的时候创建的类
 */
@property(nonatomic,strong)AVCaptureSession * captureSession;
@property(nonatomic,strong)AVCaptureDevice * captureDevice;
@property(nonatomic,strong)NSString *scanResult;
@property(nonatomic,assign)BOOL enableScanAnimation;

@end
