//
//  WHWeaterResposeEntity.h
//  theFirstApp
//
//  Created by david on 15/7/23.
//  Copyright (c) 2015年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WHWeatherResposeEntity : NSObject

@property (nonatomic , assign) NSInteger errNum;
@property (nonatomic , copy) NSString *errMsg;
@property (nonatomic , strong) NSDictionary *retData;

@end
