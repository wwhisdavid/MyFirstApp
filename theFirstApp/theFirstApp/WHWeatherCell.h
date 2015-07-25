//
//  WHWeatherCell.h
//  theFirstApp
//
//  Created by deyi on 15/7/25.
//  Copyright (c) 2015年 deyi. All rights reserved.
//

#import "WHBaseTableViewCell.h"
#import "WHWeather.h"

@interface WHWeatherCell : WHBaseTableViewCell

+ (WHWeatherCell *)cellWithTable:(UITableView *)tableView;


/**
 *  城市名
 */
@property (nonatomic, strong) UILabel *city;

/**
 *  天气
 */
@property (nonatomic, strong) UILabel *weather;

/**
 *  天气的边框背景
 */
@property (nonatomic, strong) UIView *borderView;

@property (nonatomic, strong) WHWeather *weatherModel;

@end
