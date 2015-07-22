//
//  UIImage+ResizedImage.h
//  theFirstApp
//
//  Created by deyi on 15/7/22.
//  Copyright (c) 2015年 deyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ResizedImage)

/**
 *  返回一张自由拉伸的图片
 */
+ (UIImage *)resizedImageWithName:(NSString *)name;

@end
