//
//  WHLocationManager.m
//  theFirstApp
//
//  Created by david on 15/8/16.
//  Copyright (c) 2015年 david. All rights reserved.
//

#import "WHLocationManager.h"
#import "MBProgressHUD+wwh.h"

@implementation WHLocationManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _locationSuccess = NO;

        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 100.0f;
    }
    return self;
}

+ (WHLocationManager *)shareLocationManager
{
    static WHLocationManager *__locationManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __locationManager = [[WHLocationManager alloc] init];
    });
    return __locationManager;
}

- (void)refreshLocation
{
    if (_locationManager) {
        [_locationManager stopUpdatingLocation];
    }
    [_locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

/**
 *  权限改变调用
 */
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    //权限改变发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kLocationAuthorizationStatusChanged object:self];
    if (status == kCLAuthorizationStatusAuthorizedAlways) {
        [self startGetAppleLocation];
    } else if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self startGetAppleLocation];
    } else if (status == kCLAuthorizationStatusDenied) {
        [self showLocationAlertView];
    } else if (status == kCLAuthorizationStatusNotDetermined) {
        //请求权限
        if([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [_locationManager requestWhenInUseAuthorization]; // 仅在前台定位
        } else {
            [self startGetAppleLocation];
        }
    } else if (status == kCLAuthorizationStatusRestricted) {
        [self showLocationAlertView];
    } else if (status == kCLAuthorizationStatusAuthorized) {
        [self startGetAppleLocation];
    }
}

/**
 *  位置改变调用
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = [locations lastObject];
    self.appleCoordinate = newLocation.coordinate;

    NSLog(@"new location :%f,%f",self.appleCoordinate.latitude,self.appleCoordinate.longitude);
    self.locationSuccess = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:kLocationUpdated object:self];
    
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
     [MBProgressHUD showError:@"定位失败！"];
     [[NSNotificationCenter defaultCenter] postNotificationName:kLocationFail object:self];
}

#pragma mark - private

- (void)showLocationAlertView
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请到设置->隐私->定位服务中打开定位服务，否则无法使用定位功能" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)startGetAppleLocation
{
    [_locationManager startUpdatingLocation];
}


@end
