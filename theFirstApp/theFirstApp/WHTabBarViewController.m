//
//  WHTabBarViewController.m
//  theFirstApp
//
//  Created by david on 15/7/22.
//  Copyright (c) 2015年 david. All rights reserved.
//

#import "WHTabBarViewController.h"
#import "WHWeatherViewController.h"
#import "WHNavigationController.h"
#import "WHMapViewController.h"
#import "WHScanViewController.h"

#import "WHTabBar.h"

@interface WHTabBarViewController() <WHTabBarDelegate>
/**
 *  自定义的tabbar
 */
@property (nonatomic, weak) WHTabBar *customTabBar;

@end

@implementation WHTabBarViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    //初始化TabBar
    [self setupTabBar];
    
    //初始化所以子控制器
    [self setupAllChildViewControllers];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //删除自带的UITabbarButton
    for (UIView *child in self.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
        NSLog(@"%@",self.tabBar.subviews);
    }
}
/**
 *  初始化TabBar
 */
- (void)setupTabBar
{
    WHTabBar *customTabBar = [[WHTabBar alloc] init];
    customTabBar.frame = self.tabBar.bounds;
//    customTabBar.backgroundColor = [UIColor colorWithRed:22/255.0 green:110/255.0 blue:245/255.0 alpha:1.0];
//    customTabBar.backgroundColor = WHColor(22, 110, 245, 0.8);
    customTabBar.delegate = self;
    [self.tabBar addSubview:customTabBar];
    self.customTabBar = customTabBar;
}

/**
 *  监听tabbar按钮的改变
 *
 *  @param from   原来选中位置
 *  @param to     选中的位置
 */
- (void)tabBar:(WHTabBar *)tabBar didSelectItemFrom:(int)from to:(int)to
{
    self.selectedIndex = to;
}

/**
 *  初始化所以子控制器
 */
- (void)setupAllChildViewControllers
{
    //1. 天气
    WHWeatherViewController *weather = [[WHWeatherViewController alloc] init];
    [self setupChildViewController:weather title:@"天气" imageName:@"tabbar_home_os7" selectedImageNmae:@"tabbar_home_selected_os7"];
    
    //2. 地图
    WHMapViewController *map = [[WHMapViewController alloc] init];
    [self setupChildViewController:map title:@"地图" imageName:@"tabbar_message_center_os7" selectedImageNmae:@"tabbar_message_center_selected_os7"];
    
    //3. 扫一扫
    WHScanViewController *scan = [[WHScanViewController alloc] init];
    [self setupChildViewController:scan title:@"扫一扫" imageName:@"navigationbar_pop_os7" selectedImageNmae:@"navigationbar_pop_highlighted_os7"];
}
/**
 *  初始化一个子控制器
 *
 *  @param childVC           需要初始化的控制器
 *  @param title             标题
 *  @param imageName         图标
 *  @param selectedImageName 选中的图标
 */
- (void)setupChildViewController:(UIViewController *)childVC title:(NSString *)title imageName:(NSString *)imageName selectedImageNmae:(NSString *)selectedImageName
{
    //1.设置控制器属性
    childVC.title = title;
    //设置图标
    childVC.tabBarItem.image = [UIImage imageNamed:imageName];
    //设置选中图片
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    childVC.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //2.包装一个导航控制器
    WHNavigationController *nav = [[WHNavigationController alloc] initWithRootViewController:childVC];
    
    //给tabbarVC设置子控制器
    [self addChildViewController:nav];
    
    //3.添加tabbar内部按钮
    [self.customTabBar addTabBarButtonWithItem:childVC.tabBarItem];
}

@end
