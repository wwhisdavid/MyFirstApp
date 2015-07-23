//
//  WHWeatherNetworkingTool.m
//  theFirstApp
//
//  Created by david on 15/7/23.
//  Copyright (c) 2015年 deyi. All rights reserved.
//

#import "WHWeatherNetworkingTool.h"
@implementation WHWeatherNetworkingTool



- (NSString *)JSONStrWithRequest:(NSString *)httpUrl andHttpArg:(NSString *)httpArg
{   _JSONStr = [NSString string];
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@?%@",httpUrl,httpArg ];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"GET"];
    [request addValue:@"5d3bf69215c9a2c4265d8dddd000f0d7" forHTTPHeaderField:@"apikey"];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            WHLog(@"Httperror:%@%ld",connectionError.localizedDescription, connectionError.code);
            _JSONStr = @"111111";
        }
        else{
            NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            WHLog(@"HttpResponseCode:%ld", responseCode);
            WHLog(@"HttpresponseString:%@", responseString);
            _JSONStr = responseString;
         
            
            
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
    return _JSONStr;
    
}

@end
