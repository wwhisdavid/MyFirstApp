//
//  WHBadgeButton.m
//  theFirstApp
//
//  Created by david on 15/7/22.
//  Copyright (c) 2015年 david. All rights reserved.
//

#import "WHBadgeButton.h"

@implementation WHBadgeButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.hidden = YES;
        self.userInteractionEnabled = NO;
#warning 图标图片和平铺未实现
        [self setBackgroundColor:[UIColor whiteColor]];
        self.titleLabel.font = [UIFont systemFontOfSize:11.0];
    }
    return self;
}

- (void)setBadgeValue:(NSString *)badgeValue
{
#warning copy
    _badgeValue = [badgeValue copy];
    
    if (badgeValue) {
        self.hidden = NO;
        //设置文字
        [self setTitle:badgeValue forState:UIControlStateNormal];
        
        //设置frame
        CGRect frame = self.frame;
        CGFloat badgeH = self.currentBackgroundImage.size.height;
        CGFloat badgeW = self.currentBackgroundImage.size.width;
        if (badgeValue.length > 1) {
            //文字尺寸
            CGSize badgeSize = [badgeValue sizeWithFont:self.titleLabel.font];
            badgeW = badgeSize.width = 10;
        }
        frame.size.width = badgeW;
        frame.size.height = badgeH;
        self.frame = frame;
    }
    else{
        self.hidden = YES;
    }
}

@end
