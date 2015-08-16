//
//  UIBarButtonItem+WWH.m
//  theFirstApp
//
//  Created by david on 15/7/22.
//  Copyright (c) 2015年 david. All rights reserved.
//

#import "UIBarButtonItem+WWH.h"

@implementation UIBarButtonItem (WWH)

+ (UIBarButtonItem *)itemWithIcon:(NSString *)icon highlightIcon:(NSString *)hightlightIcon target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:hightlightIcon] forState:UIControlStateHighlighted];
    button.frame = (CGRect){CGPointZero, button.currentBackgroundImage.size};
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end
