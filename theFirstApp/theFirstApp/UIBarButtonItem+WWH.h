//
//  UIBarButtonItem+WWH.h
//  theFirstApp
//
//  Created by david on 15/7/22.
//  Copyright (c) 2015年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (WWH)
/**
 *  快速创建一个显示图片的item
 */
+ (UIBarButtonItem *)itemWithIcon:(NSString *)icon highlightIcon:(NSString *)hightlightIcon target:(id)target action:(SEL)action;

@end
