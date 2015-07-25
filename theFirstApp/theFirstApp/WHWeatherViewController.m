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
#import "WHWeatherCell.h"
#import "MJRefresh.h"


@interface WHWeatherViewController()

/**
 *  存放天气模型的数组
 */
@property (nonatomic, strong) NSMutableArray *weatherArray;

@end

@implementation WHWeatherViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //右边扫一扫按钮
    self.view.backgroundColor = [UIColor whiteColor];
    //左边侧边栏
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"burger" highlightIcon:@"burger" target:self action:@selector(testScanf)];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(testScanf)];
    UIBarButtonItem *delItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteClick)];
    
    self.navigationItem.rightBarButtonItems = @[addItem,delItem];
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithIcon:@"globe" highlightIcon:@"globe" target:self action:@selector(testScanf)];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(didRefresh)];
    // 马上进入刷新状态
    [self.tableView.header beginRefreshing];
}
/**
 *  删除
 */
- (void)deleteClick
{
    [self.tableView setEditing:!self.tableView.isEditing animated:YES];
}
/**
 *  刷新
 */
- (void)didRefresh
{
    [self.tableView reloadData];
    [self.tableView.header endRefreshing];
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
    [DBtool closeDB];
    
    
}

#pragma mark - getter

- (NSMutableArray *)weatherArray
{

    WHWeatherDBTool *DBTool = [[WHWeatherDBTool alloc] init];
    _weatherArray = [NSMutableArray arrayWithArray:[DBTool weathers]];
    return _weatherArray;
}

#pragma mark ---- delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}
/**
 *  实现这个方法，就自动实现滑动删除，点删除按钮就会调用
 *
 *  @param editingStyle 编辑的行为
 *  @param indexPath    行号
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark ---- datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.weatherArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WHWeatherCell *cell = [WHWeatherCell cellWithTable:tableView];
    cell.weatherModel = self.weatherArray[indexPath.row];
    return cell;
}

@end