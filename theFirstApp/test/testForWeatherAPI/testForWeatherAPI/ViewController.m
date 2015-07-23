//
//  ViewController.m
//  testForWeatherAPI
//
//  Created by deyi on 15/7/22.
//  Copyright (c) 2015年 deyi. All rights reserved.
//

#import "ViewController.h"
#import "MJExtension.h"
#import "WHWeather.h"
#import "WHResponseEntity.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.JSONStr = [NSString string];
    NSString *httpUrl = @"http://apis.baidu.com/apistore/weatherservice/weather";
    NSString *httpArg = @"citypinyin=wuhan";
    [self request:httpUrl withHttpArg:httpArg];
}

- (void)request:(NSString *)httpUrl withHttpArg:(NSString *)httpArg{
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@?%@",httpUrl,httpArg ];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"GET"];
    [request addValue:@"5d3bf69215c9a2c4265d8dddd000f0d7123" forHTTPHeaderField:@"apikey"];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            NSLog(@"Httperror:%@%ld",connectionError.localizedDescription, connectionError.code);
            
            self.JSONStr = @"111111";//无网络连接
        }
        else{
            NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"HttpResponseCode:%ld", responseCode);
//            NSLog(@"HttpResponseBody %@",responseString);
            NSDictionary *weatherDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",weatherDict);
            
            WHResponseEntity *entity = [WHResponseEntity objectWithKeyValues:weatherDict];
            NSLog(@"%@%d%@",entity.errMsg,entity.errNum,entity.retData);
            
            WHWeather *weather = [WHWeather objectWithKeyValues:entity.retData];
            NSLog(@"%@..%@..%@",weather.city,weather.citycode,weather.date);
//            WHWeather *weather = [[WHWeather alloc] init];
//            weather.city = weatherDict[@"city"];
//            NSLog(@"%@",weather.city);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
