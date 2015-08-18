//
//  WHWeatherNetworkingTool.h
//  theFirstApp
//
//  Created by david on 15/7/23.
//  Copyright (c) 2015年 david. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WHWeatherNetworkingTool;
@protocol WHWeatherNetworkingToolDelegate <NSObject>

@optional
- (void)weatherNetworkingTool:(WHWeatherNetworkingTool *)weatherNetworkingTool callbackWithCanQuery:(NSInteger)canQuery;

@end

@interface WHWeatherNetworkingTool : NSObject


//@property (nonatomic , copy) NSMutableString *JSONStr;
@property (nonatomic, assign) NSInteger canQuery;
@property (nonatomic, weak) id<WHWeatherNetworkingToolDelegate> delegate;
/**
 *  提供一个方法，传入url，发送网络请求给对应的天气服务器，得到JSON并转换为字符串
 */
- (NSString *)JSONStrWithRequest:(NSString *)httpUrl andHttpArg:(NSString *)httpArg;

/**
 *  提供一个方法，传入url，得到服务器回传data，并转为对应模型
 */
+ (void)modelWithRequest:(NSString *)httpUrl andHttpArg:(NSString *)httpArg;

/**
 *  提供一个方法，传入城市名，得到是否能够查询
 */
- (NSInteger)canQueryTheCity:(NSString *)cityName;


@end
