//
//  WHBaseTableViewCell.h
//  theFirstApp
//
//  Created by deyi on 15/7/25.
//  Copyright (c) 2015年 deyi. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface WHBaseTableViewCell : UITableViewCell

/**
 *  cell的背景View,用于设置内边距
 */
@property (nonatomic, strong) UIView *bgView;

/**
 *  上边距
 */
@property (nonatomic, assign) CGFloat top;

/**
 *  下边距
 */
@property (nonatomic, assign) CGFloat bottom;

/**
 *  左边距
 */
@property (nonatomic, assign) CGFloat left;

/**
 *  右边距
 */
@property (nonatomic, assign) CGFloat right;

/**
 *  初始化bgView的方法
 */
- (void)initView;

/**
 *  更新对边距的约束
 */
- (void)updateConstraintsForEdge;

@end
