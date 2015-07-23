//
//  WHResponseEntity.h
//  testForWeatherAPI
//
//  Created by david on 15/7/22.
//  Copyright (c) 2015年 deyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WHWeather.h"

@interface WHResponseEntity : NSObject

@property (nonatomic , assign) NSInteger errNum;
@property (nonatomic , copy) NSString *errMsg;
@property (nonatomic , strong) NSDictionary *retData;



@end
