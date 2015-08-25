//
//  WHTabBar.m
//  theFirstApp
//
//  Created by david on 15/7/22.
//  Copyright (c) 2015年 david. All rights reserved.
//

#import "WHTabBar.h"
#import "WHTabBarButton.h"

@interface WHTabBar()
/**
 *  存放tabbar按钮
 */
@property (nonatomic, strong) NSMutableArray *tabBarButtons;
/**
 *  选中的按钮
 */
@property (nonatomic, weak) WHTabBarButton *selectedButton;

@end

@implementation WHTabBar

- (NSMutableArray *)tabBarButtons
{
    if (_tabBarButtons == nil) {
        _tabBarButtons = [NSMutableArray array];
    }
    return _tabBarButtons;
}

- (void)addTabBarButtonWithItem:(UITabBarItem *)item
{
    //1.创建按钮
    WHTabBarButton *button = [[WHTabBarButton alloc] init];
    [self addSubview:button];
    //添加按钮到数组中
    [self.tabBarButtons addObject:button];
    
    //2.设置数据
    button.item = item;
    
    //3.监听事件点击
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    
    //4.默认选中第0个按钮
    if (self.tabBarButtons.count == 1) {
        [self buttonClick:button];
    }
}

/**
 *  监听按钮点击
 */
- (void)buttonClick:(WHTabBarButton *)button
{
    //1.通知代理
    if([self.delegate respondsToSelector:@selector(tabBar:didSelectItemFrom:to:)]){
        [self.delegate tabBar:self didSelectItemFrom:self.selectedButton.tag to:button.tag];
    }

    //2.设置按钮状态
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // button frame
    CGFloat buttonH = self.frame.size.height;
    CGFloat buttonW = self.frame.size.width / self.subviews.count;
    CGFloat buttonY = 0;
    for (int i = 0; i < self.tabBarButtons.count; i ++) {
        //1.取出按钮
        WHTabBarButton *button = self.tabBarButtons[i];
        
        //2.设置frame
        CGFloat buttonX = i * buttonW;
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        //3.绑定tag
        button.tag = i;
    }
}

@end
