//
//  WHAddWeatherCityViewController.h
//  theFirstApp
//
//  Created by david on 15/7/25.
//  Copyright (c) 2015年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WHAddWeatherCityViewController;
@class WHWeatherCity;

@protocol WHAddWeatherCityViewControllerDelegate <NSObject>

@optional

- (void)addWeatherCityViewController:(WHAddWeatherCityViewController *)addVc didAddCity:(WHWeatherCity *)weatherCity;

@end

@interface WHAddWeatherCityViewController : UIViewController

/**
 *  背景滚动view
 */
@property (nonatomic, strong) UIScrollView *bgScrollView;

/**
 *  城市名（label）
 */
@property (nonatomic, strong) UILabel *cityTitle;

/**
 *  输入框
 */
@property (nonatomic, strong) UITextField *cityTextField;

/**
 *  确认按钮
 */
@property (nonatomic, strong) UIButton *sureBtn;

@property (nonatomic, weak) id<WHAddWeatherCityViewControllerDelegate> delegate;

@end
