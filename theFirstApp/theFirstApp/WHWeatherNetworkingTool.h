//
//  WHWeatherNetworkingTool.h
//  theFirstApp
//
//  Created by david on 15/7/23.
//  Copyright (c) 2015年 deyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WHWeatherNetworkingTool : NSObject


@property (nonatomic , copy) NSString *JSONStr;


/**
 *  提供一个类方法，传入url，发送网络请求给对应的天气服务器，得到JSON并转换为字符串
 */
- (NSString *)JSONStrWithRequest:(NSString *)httpUrl andHttpArg:(NSString *)httpArg;

@end
