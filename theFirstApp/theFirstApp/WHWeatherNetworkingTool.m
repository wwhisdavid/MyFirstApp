//
//  WHWeatherNetworkingTool.m
//  theFirstApp
//
//  Created by david on 15/7/23.
//  Copyright (c) 2015年 deyi. All rights reserved.
//

#import "WHWeatherNetworkingTool.h"
#import "WHWeatherDBTool.h"

@implementation WHWeatherNetworkingTool

- (NSString *)JSONStrWithRequest:(NSString *)httpUrl andHttpArg:(NSString *)httpArg
{
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@?%@",httpUrl,httpArg ];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"GET"];
    [request addValue:@"5d3bf69215c9a2c4265d8dddd000f0d7" forHTTPHeaderField:@"apikey"];
    
    __block NSMutableString *str = nil;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            WHLog(@"Httperror:%@%ld",connectionError.localizedDescription, connectionError.code);
            str = [NSMutableString stringWithString:@"111111"];
            [WHWeatherDBTool initialize];
            [WHWeatherDBTool addWeatherJSONStr:str];
        }
        else{
            NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            WHLog(@"HttpResponseCode:%ld", responseCode);
            WHLog(@"HttpresponseString:%@", responseString);
            str = [NSMutableString stringWithString:responseString];
            [WHWeatherDBTool initialize];
            [WHWeatherDBTool addWeatherJSONStr:str];
            
            //            NSLog(@"HttpResponseBody %@",responseString);
//            NSDictionary *weatherDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//            WHLog(@"%@",weatherDict);
            
//            WHResponseEntity *entity = [WHResponseEntity objectWithKeyValues:weatherDict];
//            NSLog(@"%@%d%@",entity.errMsg,entity.errNum,entity.retData);
//            
//            WHWeather *weather = [WHWeather objectWithKeyValues:entity.retData];
//            NSLog(@"%@..%@..%@",weather.city,weather.citycode,weather.date);
            
            //            WHWeather *weather = [[WHWeather alloc] init];
            //            weather.city = weatherDict[@"city"];
            //            NSLog(@"%@",weather.city);
        }
    }];
    

    return nil;
    
}

@end
