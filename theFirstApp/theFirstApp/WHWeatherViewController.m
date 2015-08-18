//
//  WHWeatherViewController.m
//  theFirstApp
//
//  Created by david on 15/7/22.
//  Copyright (c) 2015年 david. All rights reserved.
//

#import "WHWeatherViewController.h"
#import "WHAddWeatherCityViewController.h"
#import "UIBarButtonItem+WWH.h"
#import "WHWeatherDBTool.h"
#import "WHWeatherNetworkingTool.h"
#import "WHWeather.h"
#import "WHWeatherCell.h"
#import "MJRefresh.h"
#import "WHAddWeatherCityViewController.h"
#import "MBProgressHUD+wwh.h"

// 文件路径
#define WHWeatherCityFilepath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"weatherCities.data"]

@interface WHWeatherViewController() <WHAddWeatherCityViewControllerDelegate>

/**
 *  存放天气模型的数组
 */
@property (nonatomic, strong) NSMutableArray *weatherArray;

@end

@implementation WHWeatherViewController

#pragma mark - life circle

- (void)viewDidLoad
{
    [super viewDidLoad];
    //右边扫一扫按钮
    self.view.backgroundColor = [UIColor whiteColor];
    //左边侧边栏
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"burger" highlightIcon:@"burger" target:self action:@selector(testScanf)];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addClick)];
    UIBarButtonItem *delItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteClick)];
    
    self.navigationItem.rightBarButtonItems = @[addItem,delItem];
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithIcon:@"globe" highlightIcon:@"globe" target:self action:@selector(testScanf)];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(didRefresh)];
    // 马上进入刷新状态
    [self.tableView.header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
/**
 *  添加城市
 */
- (void)addClick
{
    WHAddWeatherCityViewController *addVc = [[WHAddWeatherCityViewController alloc] init];
    addVc.delegate = self;
    [self.navigationController pushViewController:addVc animated:YES];
    self.tabBarController.tabBar.hidden = YES;
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
    [self testScanf];
    [self.tableView reloadData];
    [self.tableView.header endRefreshing];
}
    
// test
- (void)testScanf
{
    [WHWeatherDBTool initialize];
    NSString *httpUrl = @"http://apis.baidu.com/apistore/weatherservice/cityname";
    NSArray *cityNames = [WHWeatherDBTool getAllCitiesName];
    if (cityNames.count == 0) {
        [MBProgressHUD showError:@"无选中城市，请添加!"];
        return;
    }
    
    WHWeatherNetworkingTool *tool = [[WHWeatherNetworkingTool alloc] init];
    WHWeatherDBTool *DBtool = [[WHWeatherDBTool alloc] init];
    NSArray *array = [NSArray array];

    for (NSString *cityName in cityNames) {
        NSString *utf8 = [cityName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *httpArg = [NSString stringWithFormat:@"cityname=%@", utf8];
        
        NSString *JSONStr = [NSString string];
        JSONStr = [tool JSONStrWithRequest:httpUrl andHttpArg:httpArg];
    }
    
    array = [DBtool weathers];
    

    self.weatherArray = [NSMutableArray arrayWithArray:[DBtool weathers]];
    [DBtool closeDB];
    
    
}

#pragma mark - getter

- (NSMutableArray *)weatherArray
{
    if (_weatherArray == nil) {
        _weatherArray = [[NSMutableArray alloc] init];
    }
//    WHWeatherDBTool *DBTool = [[WHWeatherDBTool alloc] init];
//    _weatherArray = [NSMutableArray arrayWithArray:[DBTool weathers]];
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
    if (editingStyle == UITableViewCellEditingStyleDelete) {
       
        //1.删除模型数据,注意，要到数据库删除。
        [_weatherArray removeObjectAtIndex:indexPath.row];
        NSString *str = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
        [WHWeatherDBTool deleteWeatherJSONStrWithID:str];
        [WHWeatherDBTool deleteWeatherCityNameID:str];
        
        //2.刷新表格（局部）
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
    }
}

/**
 *  实现这个方法确定每行操作方式。
 */
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

#pragma mark ---- datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

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

#pragma mark - WHAddWeatherCityViewControllerDelegate

- (void)addWeatherCityViewController:(WHAddWeatherCityViewController *)addVc didAddCityName:(NSString *)name
{
    [WHWeatherDBTool addWeatherName:name];
}

@end
