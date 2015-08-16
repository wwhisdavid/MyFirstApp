//
//  WHMapViewController.m
//  theFirstApp
//
//  Created by david on 15/7/22.
//  Copyright (c) 2015年 david. All rights reserved.
//

#import "WHMapViewController.h"
#import "UIBarButtonItem+WWH.h"
#import "MBProgressHUD+wwh.h"
#import "WHLocationManager.h"
#import "CLLocation+wwh.h"

#define CanNotLocateSelf _mapView.userLocation.coordinate.latitude == 0 || _mapView.userLocation.coordinate.longitude == 0
@interface WHMapViewController () <MKMapViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, assign) CLLocationCoordinate2D userLocation;

- (void)updateMapView;

@end


@implementation WHMapViewController

#pragma mark - getter and setter

- (MKMapView *)mapView
{
    if (!_mapView) {
        _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
        _mapView.backgroundColor = [UIColor whiteColor];
        _mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _mapView.showsUserLocation = YES;
        _mapView.delegate = self;
        _mapView.mapType = MKMapTypeStandard;
        _mapView.userTrackingMode = MKUserTrackingModeFollow;
    }
    return _mapView;
}

- (void)setAnnotation:(WHAnnotation *)annotation
{
    if (_annotation && _mapView) {
        [_mapView removeAnnotation:_annotation];
    }
    _annotation = annotation;
    [self updateMapView];
}

- (CLGeocoder *)geocoder
{
    if (_geocoder == nil) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

#pragma mark - action

//-(void)goPoP{
//    [self.navigationController popViewControllerAnimated:YES];
//}

-(void)dingwei
{
    [_mapView setCenterCoordinate:_mapView.userLocation.coordinate animated:YES];
}

- (void)openBaidu
{
    UIApplication *application = [UIApplication sharedApplication];
    CLLocationCoordinate2D baiduFromCoordinate = [CLLocation getBaiduCoordinateFromMars:_mapView.userLocation.coordinate];
    NSLog(@"latitude = %f, longitude = %f", _mapView.userLocation.coordinate.latitude, _mapView.userLocation.coordinate.longitude);
    
    CLLocationCoordinate2D baiduToCoordinate = [CLLocation getBaiduCoordinateFromMars:_annotation.coordinate];
    if (CanNotLocateSelf) {
        NSString *strUrl = [NSString stringWithFormat:@"baidumap://map/marker?location=%f,%f&title=目的地&content=%@&src=theFirstApp, ", baiduToCoordinate.latitude,baiduToCoordinate.longitude,self.annotation.title];
        strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        self.urlStr = strUrl;
    }
    else{
        NSString *strUrl = [NSString stringWithFormat:@"baidumap://map/direction?origin=%f,%f&destination=%f,%f&mode=driving&src=theFirstApp",baiduFromCoordinate.latitude,baiduFromCoordinate.longitude,baiduToCoordinate.latitude,baiduToCoordinate.longitude];
        strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        self.urlStr = strUrl;
    }
    NSURL *url = [NSURL URLWithString:self.urlStr];
    /* test */
    //    NSString *str = @"baidumap://map/marker?location=40.047669,116.313082&title=我的位置&content=百度奎科大厦&src=you";
    //    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //    url = [NSURL URLWithString:str];
    
    if ([application canOpenURL:[NSURL URLWithString:@"baidumap://map/"]]) {
        [application openURL:url];
    }
    else{
        [MBProgressHUD showError:@"无百度地图,请下载或使用苹果地图!"];
    }
    
}

- (void)openGaode
{
    UIApplication *application = [UIApplication sharedApplication];
    
    if (CanNotLocateSelf) {
        NSString *strUrl = [NSString stringWithFormat:@"iosamap://viewMap?sourceApplication=wwh&poiname=%@&lat=%f&lon=%f&dev=1", self.annotation.title, _annotation.coordinate.latitude, _annotation.coordinate.longitude];
        strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        self.urlStr = strUrl;
    }
    else{
        NSString *strUrl = [NSString stringWithFormat:@"iosamap://path?sourceApplication=wwh&sid=BGVIS1&slat=%f&slon=%f&sname=我的位置&did=BGVIS2&dlat=%f&dlon=%f&dname=%@&dev=0&m=0&t=0", _mapView.userLocation.coordinate.latitude, _mapView.userLocation.coordinate.longitude, _annotation.coordinate.latitude, _annotation.coordinate.longitude, self.annotation.title];
        strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        self.urlStr = strUrl;
    }
    
    NSURL *url = [NSURL URLWithString:self.urlStr];
    if ([application canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        [application openURL:url];
    }
    else{
        [MBProgressHUD showError:@"无高德地图,请下载或使用苹果地图!"];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //左边侧边栏
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"burger" highlightIcon:@"burger" target:self action:@selector(testScanf)];
    
    [self.view addSubview:self.mapView];
    
//    UIButton *fanhui_btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [fanhui_btn setBackgroundImage:[UIImage imageNamed:@"mapback"] forState:UIControlStateNormal];
//    [fanhui_btn addTarget:self action:@selector(goPoP) forControlEvents:UIControlEventTouchUpInside];
//    fanhui_btn.frame = CGRectMake(0,28, 95/2, 66/2);
//    [self.view addSubview:fanhui_btn];
    
    UIButton *dingwei_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    dingwei_btn.frame = CGRectMake(30, self.view.frame.size.height - 66/2 - 20 - 10, 68/2, 66/2);
    [dingwei_btn setBackgroundImage:[UIImage imageNamed:@"mapdingwei"] forState:UIControlStateNormal];
    [dingwei_btn addTarget:self action:@selector(dingwei) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dingwei_btn];
    
    [[WHLocationManager shareLocationManager] refreshLocation];
    
    [self updateMapView];
    
    NSLog(@"%f", _mapView.userLocation.coordinate.longitude);
    

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}
// test
- (void)testScanf
{
    WHLog(@"scanf");
}
    
#pragma mark - MKMapViewDelegate
    
- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView
{
    //    NSLog(@"mapViewWillStartLoadingMap");
}
- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    //    NSLog(@"mapViewDidFinishLoadingMap");
}

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error
{
    NSLog(@"error:%@",error);
}

/**
 *  每次创建大头针会调用，使用方法同cell
 */
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[WHAnnotation class]] == NO) {
        return nil;
    }
    static NSString *ID = @"anno";
    
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (pinView == nil) {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:ID];
        pinView.pinColor = MKPinAnnotationColorRed;
        pinView.animatesDrop = YES;
        pinView.canShowCallout = YES;
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setImage:[UIImage imageNamed:@"mapdingwei"] forState:UIControlStateNormal];
        rightBtn.frame = CGRectMake(0, 0, 30, 30);
        [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
        pinView.rightCalloutAccessoryView = rightBtn;
    }
    pinView.annotation = annotation;
    return pinView;
}

/**
 *  地理编码获取位置
 */
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    //    [self.geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
    //        CLPlacemark *placeMark = [placemarks firstObject];
    //        userLocation.title = placeMark.name;
    //        userLocation.subtitle = placeMark.locality;
    //    }];
    //
    //    [self.mapView setCenterCoordinate:self.annotation.coordinate animated:YES];
    
    //    self.userLocation = userLocation.location.coordinate;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    //    NSLog(@"didSelectAnnotationView");
}

#pragma mark - private

- (void)updateMapView
{
    if (!_mapView || !_annotation) {
        return;
    }
    if(CLLocationCoordinate2DIsValid(_annotation.coordinate))
    {
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(_annotation.coordinate, 200.0, 200.0);
        region = [_mapView regionThatFits:region];
        [_mapView setRegion:region animated:YES];
        [_mapView setCenterCoordinate:_annotation.coordinate animated:YES];
        [_mapView addAnnotation:_annotation];
        [_mapView selectAnnotation:_annotation animated:YES];
        
        //        MKCoordinateSpan span = MKCoordinateSpanMake(0.002, 0.002);
        //        MKCoordinateRegion region = MKCoordinateRegionMake(self.annotation.coordinate, span);
        //        [self.mapView setRegion:region animated:YES];
    }
}

/**
 调用Map客户端 显示用户当前位置到指定位置的驾车路线
 @param desCoordinate:目的地的经纬度（注意：纬度在前，经度在后）
 @param desName:目的地标识显示的文字信息，默认值为“目的地”
 */
- (void)callMapShowPathFromCurrentLocationTo:(CLLocationCoordinate2D)desCoordinate andDesName:(NSString *)desName{
    
    //ios_version为 >=6.0时 调用苹果地图客户端
    
    //验证MKMapItem的有效性
    Class itemClass = [MKMapItem class];
    if (itemClass && [itemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)]) {
        desName = desName?desName:@"目的地";
        MKPlacemark *palcemake = [[MKPlacemark alloc] initWithCoordinate:desCoordinate addressDictionary:nil];
        MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:palcemake];
        mapItem.name = desName;
        NSDictionary *dicOfMode = [NSDictionary dictionaryWithObjectsAndKeys:
                                   MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsDirectionsModeKey, nil];
        
        if (CanNotLocateSelf) {
            NSArray *array = [NSArray arrayWithObject:mapItem];
            [MKMapItem openMapsWithItems:array launchOptions:nil];
        }
        else{
            [mapItem openInMapsWithLaunchOptions:dicOfMode];
        }
        
        
        
    }
    
}

- (void)rightBtnClick
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"苹果地图", @"百度地图", @"高德地图", nil];
    [actionSheet showInView:self.mapView];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //苹果地图
    if (!buttonIndex) {
        [self callMapShowPathFromCurrentLocationTo:self.annotation.coordinate andDesName:self.annotation.title];
    }
    else if(buttonIndex == 1){
//        [self openBaidu];
    }
    else if(buttonIndex == 2){
        [self openGaode];
    }
}

@end
