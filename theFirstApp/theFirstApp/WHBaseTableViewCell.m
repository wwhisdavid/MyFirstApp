//
//  WHBaseTableViewCell.m
//  theFirstApp
//
//  Created by david on 15/7/25.
//  Copyright (c) 2015年 david. All rights reserved.
//

#import "WHBaseTableViewCell.h"
#import "Masonry.h"

@implementation WHBaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

#pragma mark - public

- (void)initView
{
    self.backgroundColor = [UIColor clearColor];
    
    _top = 8.f;
    _bottom = 8.f;
    _left = 8.f;
    _right = 8.f;
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = WHColor(229, 149, 97, 1.0);
    _bgView.userInteractionEnabled = NO;
    [self.contentView addSubview:_bgView];
    
    __weak __typeof(&*self)weakSelf = self;
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView).with.insets(UIEdgeInsetsMake(weakSelf.top, weakSelf.left, weakSelf.bottom, weakSelf.right));
    }];
}

- (void)updateConstraintsForEdge
{
    __weak __typeof(&*self)weakSelf = self;
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView).with.insets(UIEdgeInsetsMake(weakSelf.top, weakSelf.left, weakSelf.bottom, weakSelf.right));
    }];
}

#pragma mark - setter

- (void)setTop:(CGFloat)top
{
    if (_top == top) {
        return;
    }
    _top = top;
    [self updateConstraintsForEdge];
}

- (void)setBottom:(CGFloat)bottom
{
    if (_bottom == bottom) {
        return;
    }
    _bottom = bottom;
    [self updateConstraintsForEdge];
}

- (void)setLeft:(CGFloat)left
{
    if (_left == left) {
        return;
    }
    _left = left;
    [self updateConstraintsForEdge];
}

- (void)setRight:(CGFloat)right
{
    if (_right == right) {
        return;
    }
    _right = right;
    [self updateConstraintsForEdge];
}

@end
