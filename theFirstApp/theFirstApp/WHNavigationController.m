//
//  WHNavigationController.m
//  theFirstApp
//
//  Created by david on 15/7/22.
//  Copyright (c) 2015年 david. All rights reserved.
//

#import "WHNavigationController.h"
#import "UIBarButtonItem+WWH.h"
@implementation WHNavigationController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置导航栏和标题颜色
    self.navigationBar.barTintColor = WHColor(229, 139, 79, 0.8);
    self.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor whiteColor],
                                               UITextAttributeFont : [UIFont boldSystemFontOfSize:18]};
    
    
}

@end
