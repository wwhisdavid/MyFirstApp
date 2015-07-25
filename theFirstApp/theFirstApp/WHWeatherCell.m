//
//  WHWeatherCell.m
//  theFirstApp
//
//  Created by deyi on 15/7/25.
//  Copyright (c) 2015年 deyi. All rights reserved.
//

#import "WHWeatherCell.h"
#import "Masonry.h"

@implementation WHWeatherCell




/**
 *  类方法创建cell
 */
+ (WHWeatherCell *)cellWithTable:(UITableView *)tableView
{
    static NSString *weatherCellID = @"weatherCellID";
    WHWeatherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"weatherCellID"];
    if (cell == nil) {
        cell = [[WHWeatherCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:weatherCellID];
    }
    return cell;
}


- (void)initView
{
    [super initView];
    
    [self setupAllChildView];
    
    [self autoLayout];
}


- (void)setupAllChildView
{
    self.bgView.backgroundColor = WHColor(229, 149, 97, 1.0);
    
    UILabel *city = [[UILabel alloc] init];
    city.textColor = [UIColor whiteColor];
    city.font = [UIFont systemFontOfSize:28.0];
    city.text = @"未 知";
    
    [self.bgView addSubview:city];
    self.city = city;

    UIView *borderView = [[UIView alloc] init];
    [borderView.layer setMasksToBounds:YES];
    [borderView.layer setCornerRadius:5.0];
    [borderView.layer setBorderColor:WHColor(240, 240, 240, 1.0).CGColor];
    [borderView.layer setBorderWidth:2.0];
    borderView.backgroundColor = [UIColor clearColor];
    [self.bgView addSubview:borderView];
    self.borderView = borderView;
    
    UILabel *weather = [[UILabel alloc] init];
    weather.font = [UIFont systemFontOfSize:18.0];
    weather.text = @"未 知";
    weather.textColor = WHColor(240, 240, 240, 1.0);
    weather.backgroundColor = [UIColor clearColor];
    [self.bgView addSubview:weather];
    self.weather = weather;
}

- (void)autoLayout
{
    __weak __typeof(&*self)weakSelf = self;
    
    [self.city mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView).with.offset(30.0);
        make.left.equalTo(weakSelf.contentView).with.offset(30.0);
    }];
    
    [self.weather mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.contentView).with.offset(- 25.0);
        make.right.equalTo(weakSelf.contentView).with.offset(- 25.0);
    }];
    
    [self.borderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.weather).with.insets(UIEdgeInsetsMake(-3, -3, -3, -3));
    }];
}

#pragma mark - setter

- (void)setWeatherModel:(WHWeather *)weatherModel
{
    _weatherModel = weatherModel;
    self.weather.text = weatherModel.weather;
    self.city.text = weatherModel.city;
}

@end
