//
//  WHWeather.h
//  theFirstApp
//
//  Created by david on 15/7/23.
//  Copyright (c) 2015年 deyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WHWeather : NSObject
/**
 *  城市
 */
@property (nonatomic , copy) NSString *city;
/**
 *  日期
 */
@property (nonatomic , copy) NSString *data;
/**
 *  发布时间
 */
@property (nonatomic , copy) NSString *time;
/**
 *  邮编
 */
@property (nonatomic , copy) NSString *postCode;
/**
 *  经度
 */
@property (nonatomic , copy) NSString *longtitude;
/**
 *  纬度
 */
@property (nonatomic , copy) NSString *altitude;
/**
 *  天气
 */
@property (nonatomic , copy) NSString *weather;
/**
 *  当前温度
 */
@property (nonatomic , copy) NSString *temp;
/**
 *  最低温度
 */
@property (nonatomic , copy) NSString *l_tmp;
/**
 *  最高温度
 */
@property (nonatomic , copy) NSString *h_tmp;
/**
 *  风向
 */
@property (nonatomic , copy) NSString *WD;
/**
 *  风力
 */
@property (nonatomic , copy) NSString *WS;
/**
 *  日出时间
 */
@property (nonatomic , copy) NSString *sunrise;
/**
 *  日落时间
 */
@property (nonatomic , copy) NSString *sunset;




@end
