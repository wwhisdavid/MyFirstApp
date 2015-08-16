//
//  MBProgressHUD+wwh.h
//  theFirstApp
//
//  Created by david on 15/8/16.
//  Copyright (c) 2015年 david. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (wwh)

+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;


+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;

+ (MBProgressHUD *)showMessage:(NSString *)message;

+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;

@end
