//
//  WHLocationManager.h
//  theFirstApp
//
//  Created by david on 15/8/16.
//  Copyright (c) 2015年 david. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

//通知名称
static NSString * const kLocationAuthorizationStatusChanged = @"kLocationAuthorizationStatusChanged";
static NSString * const kLocationUpdated = @"kLocationUpdated";
static NSString * const kLocationFail = @"kLocationFail";

@interface WHLocationManager : NSObject <CLLocationManagerDelegate>


@property(nonatomic,strong)CLLocationManager *locationManager;
@property(nonatomic,assign)BOOL locationSuccess;

@property(nonatomic,assign)CLLocationCoordinate2D appleCoordinate;
@property(nonatomic,assign)CLLocationCoordinate2D baiduCoordinate;

/**
 *  创建单例
 */
+ (WHLocationManager*)shareLocationManager;

/**
 *  更新位置
 */
- (void)refreshLocation;

@end
