//
//  WHWeatherDBTool.h
//  theFirstApp
//
//  Created by david on 15/7/22.
//  Copyright (c) 2015年 deyi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WHWeather;

@interface WHWeatherDBTool : NSObject

/**
 *  从数据库获得存有天气的jsonstr并转为weather对象，放进数组返回
 */
- (NSArray *)weathers;

/**
 *  将json的string存入数据库
 */
+ (void)addWeatherJSONStr:(NSString *)JSONStr;

/**
 *  提供方法传入JSONStr数组，返回对应对象
 */
- (WHWeather *)weather:(NSArray *)JSONStrArray;

/**
 *  删除一条数据
 */
+ (void)deleteWeatherJSONStrWithID:(NSString *)ID;

/**
 *  关闭数据库
 */
- (void)closeDB;
@end

