//
//  WHWeatherViewController.m
//  theFirstApp
//
//  Created by deyi on 15/7/22.
//  Copyright (c) 2015年 deyi. All rights reserved.
//

#import "WHWeatherViewController.h"
#import "UIBarButtonItem+WWH.h"
#import "WHWeatherDBTool.h"
#import "WHWeatherNetworkingTool.h"
#import "WHWeather.h"
@implementation WHWeatherViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //右边扫一扫按钮
    self.view.backgroundColor = [UIColor whiteColor];
    //左边侧边栏
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"burger" highlightIcon:@"burger" target:self action:@selector(testScanf)];
}
// test
- (void)testScanf
{
    [WHWeatherDBTool initialize];
    NSString *httpUrl = @"http://apis.baidu.com/apistore/weatherservice/weather";
    NSString *httpArg = @"citypinyin=wuhan";
    WHWeatherNetworkingTool *tool = [[WHWeatherNetworkingTool alloc] init];

    
//    dispatch_queue_t q = dispatch_queue_create("weather queue", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_async(q, ^{
    NSString *JSONStr = [NSString string];
    JSONStr = [tool JSONStrWithRequest:httpUrl andHttpArg:httpArg];
//    });
    
    WHWeatherDBTool *DBtool = [[WHWeatherDBTool alloc] init];
    NSArray *array = [NSArray array];
    array = [DBtool weathers];
    WHWeather *weather = [[WHWeather alloc] init];
    weather = [DBtool weather:array];
    
    NSLog(@"%@---====--",weather.city);
}

#pragma mark ---- datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
