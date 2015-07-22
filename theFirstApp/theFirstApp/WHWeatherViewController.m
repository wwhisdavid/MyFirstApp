//
//  WHWeatherViewController.m
//  theFirstApp
//
//  Created by deyi on 15/7/22.
//  Copyright (c) 2015年 deyi. All rights reserved.
//

#import "WHWeatherViewController.h"
#import "UIBarButtonItem+WWH.h"
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
    WHLog(@"scanf");
}

@end
