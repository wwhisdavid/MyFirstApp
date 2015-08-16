//
//  CLLocation+wwh.h
//  theFirstApp
//
//  Created by david on 15/8/16.
//  Copyright (c) 2015年 david. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>


@interface CLLocation (wwh)

//从地图坐标转化到火星坐标
- (CLLocation*)locationMarsFromEarth;

//从火星坐标转化到百度坐标
- (CLLocation*)locationBaiduFromMars;

//从百度坐标到火星坐标
- (CLLocation*)locationMarsFromBaidu;

//从火星坐标到地图坐标
//- (CLLocation*)locationEarthFromMars; // 未实现

//从百度坐标转化到火星坐标
+ (CLLocationCoordinate2D)getMarsCoordinateFromBaidu:(CLLocationCoordinate2D)coordinate;

//从火星坐标转化到百度坐标
+ (CLLocationCoordinate2D)getBaiduCoordinateFromMars:(CLLocationCoordinate2D)coordinate;

@end
