//
//  WHScanViewController.m
//  theFirstApp
//
//  Created by deyi on 15/7/22.
//  Copyright (c) 2015年 deyi. All rights reserved.
//

#import "WHScanViewController.h"
#import "UIBarButtonItem+WWH.h"
@interface WHScanViewController ()

@end

@implementation WHScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    //左边侧边栏
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"burger" highlightIcon:@"burger" target:self action:@selector(testScanf)];
}
// test
- (void)testScanf
{
    WHLog(@"scanf");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
