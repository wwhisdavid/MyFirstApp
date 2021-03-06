//
//  WHWeatherNetworkingTool.m
//  theFirstApp
//
//  Created by david on 15/7/23.
//  Copyright (c) 2015年 david. All rights reserved.
//
/*
 {
 WD = "\U65e0\U6301\U7eed\U98ce\U5411";
 WS = "\U5fae\U98ce(<10m/h)";
 altitude = 27;
 city = "\U6b66\U6c49";
 citycode = 101200101;
 date = "15-08-16";
 "h_tmp" = 33;
 "l_tmp" = 24;
 latitude = "30.573";
 longitude = "114.279";
 pinyin = wuhan;
 postCode = 430000;
 sunrise = "05:49";
 sunset = "19:04";
 temp = 33;
 time = "11:00";
 weather = "\U591a\U4e91";
 }

 */

#import "WHWeatherNetworkingTool.h"
#import "WHWeatherDBTool.h"
#import "MBProgressHUD+wwh.h"
#import <CoreFoundation/CoreFoundation.h>

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
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
        if (connectionError || data == nil) {
            WHLog(@"Httperror:%@%ld",connectionError.localizedDescription, connectionError.code);
            str = [NSMutableString stringWithString:@"111111"];
            [WHWeatherDBTool initialize];
            [MBProgressHUD showError:@"请求出错！"];
            
        }
        else{
            NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            WHLog(@"HttpResponseCode:%ld", responseCode);
            WHLog(@"HttpresponseString:%@", responseString);
            str = [NSMutableString stringWithString:responseString];
            NSDictionary *returnDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if (returnDict[@"errorNum"] != 0) {
                [MBProgressHUD showError:@"服务器故障，请稍后再试！"];
                return;
            }
            NSDictionary *retData = returnDict[@"retData"];
            
            [WHWeatherDBTool initialize];
            NSString *cityName = [retData[@"city"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [WHWeatherDBTool addWeatherJSONStr:str andCityName:cityName];
        }
    }];
    return nil;
}



+ (void)modelWithRequest:(NSString *)httpUrl andHttpArg:(NSString *)httpArg
{
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@?%@",httpUrl,httpArg ];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"GET"];
    [request addValue:@"5d3bf69215c9a2c4265d8dddd000f0d7" forHTTPHeaderField:@"apikey"];
    
    __block NSMutableString *str = nil;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError || data == nil) {
            WHLog(@"Httperror:%@%ld",connectionError.localizedDescription, connectionError.code);
            str = [NSMutableString stringWithString:@"111111"];
            [WHWeatherDBTool initialize];
            [MBProgressHUD showError:@"请求出错！"];
            
        }
        else{
            NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            WHLog(@"HttpResponseCode:%ld", responseCode);
            WHLog(@"HttpresponseString:%@", responseString);
            str = [NSMutableString stringWithString:responseString];
            NSDictionary *returnDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if (returnDict[@"errorNum"] != 0) {
                [MBProgressHUD showError:@"服务器故障，请稍后再试！"];
                return;
            }
            NSDictionary *retData = returnDict[@"retData"];
            
            [WHWeatherDBTool initialize];
            NSString *cityName = [[NSString alloc] initWithData:retData[@"city"] encoding:NSUTF8StringEncoding];
            [WHWeatherDBTool addWeatherJSONStr:str andCityName:cityName];

        }
    }];
}
/*{
 WD = "\U65e0\U6301\U7eed\U98ce\U5411";
 WS = "\U5fae\U98ce(<10m/h)";
 altitude = 27;
 city = "\U6b66\U6c49";
 citycode = 101200101;
 date = "15-08-16";
 "h_tmp" = 33;
 "l_tmp" = 24;
 latitude = "30.573";
 longitude = "114.279";
 pinyin = wuhan;
 postCode = 430000;
 sunrise = "05:49";
 sunset = "19:04";
 temp = 33;
 time = "11:00";
 weather = "\U591a\U4e91";
 }
*/

- (NSInteger)canQueryTheCity:(NSString *)cityName
{
    NSString *httpUrl = @"http://apis.baidu.com/apistore/weatherservice/citylist";
    NSString *utf8Str = [cityName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *httpArg = [NSString stringWithFormat:@"cityname=%@", utf8Str];
    NSString *urlStr = [[NSString alloc] initWithFormat: @"%@?%@", httpUrl, httpArg];
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    [request addValue: @"5d3bf69215c9a2c4265d8dddd000f0d7" forHTTPHeaderField: @"apikey"];
    
    WS(ws);
    [MBProgressHUD showMessage:@"正在帮您查询...."];
    WHLog(@"%@", [NSThread currentThread]);
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *returnDict = [NSJSONSerialization JSONObjectWithData:data
                                                                   options:NSJSONReadingMutableLeaves
                                                                     error:nil];

        NSString *retuenErrorNum = [NSString stringWithFormat:@"%@", returnDict[@"errNum"] ];
        if (![retuenErrorNum isEqualToString:@"0"]) {
            WHLog(@"%@", returnDict[@"errNum"]);
            NSString *errorMsg = returnDict[@"errMsg"];
            [MBProgressHUD showError:errorMsg];
            ws.canQuery = 1;//发送请求有误
            if ([self.delegate respondsToSelector:@selector(weatherNetworkingTool:callbackWithCanQuery:)]) {
                [self.delegate weatherNetworkingTool:self callbackWithCanQuery:ws.canQuery];
                
            }
        }
        else{
            ws.canQuery = 2;//接收成功
            if ([self.delegate respondsToSelector:@selector(weatherNetworkingTool:callbackWithCanQuery:)]) {
                [self.delegate weatherNetworkingTool:self callbackWithCanQuery:ws.canQuery];
            }
        }
        
    }];
    return 0;
}
@end
