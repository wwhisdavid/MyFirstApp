//
//  WHTabBar.h
//  theFirstApp
//
//  Created by david on 15/7/22.
//  Copyright (c) 2015年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WHTabBar;

@protocol WHTabBarDelegate <NSObject>

@optional

- (void)tabBar:(WHTabBar *)tabBar didSelectItemFrom:(int)from to:(int)to;

@end

@interface WHTabBar : UIView

- (void)addTabBarButtonWithItem:(UITabBarItem *)item;

@property (nonatomic, weak) id<WHTabBarDelegate> delegate;

@end
