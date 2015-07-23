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
 *  从数据库获得存有天气的weather的json的stringArray
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

@end
