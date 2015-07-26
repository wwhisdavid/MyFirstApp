//
//  WHAddWeatherCityViewController.m
//  theFirstApp
//
//  Created by david on 15/7/25.
//  Copyright (c) 2015年 deyi. All rights reserved.
//

#import "WHAddWeatherCityViewController.h"
#import "Masonry.h"

@implementation WHAddWeatherCityViewController

#pragma mark - life circle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initViewController];
}

#pragma mark - init

- (void)initViewController
{
    self.view.backgroundColor = WHColor(236, 115, 6, 1.0);
    self.title = @"添加城市";
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
#warning 7.25 night
    UILabel *cityTitle = [[UILabel alloc] init];
    cityTitle.text = @"城 市 名 :";
    cityTitle.textColor = [UIColor whiteColor];
    cityTitle.font = [UIFont systemFontOfSize:20.0];
    cityTitle.backgroundColor = [UIColor clearColor];
    [self.view addSubview:cityTitle];
    self.cityTitle = cityTitle;
    
    
}
@end
