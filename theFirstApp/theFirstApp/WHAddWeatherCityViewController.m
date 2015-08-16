//
//  WHAddWeatherCityViewController.m
//  theFirstApp
//
//  Created by david on 15/7/25.
//  Copyright (c) 2015年 david. All rights reserved.
//

#import "WHAddWeatherCityViewController.h"
#import "Masonry.h"
#import "MBProgressHUD+wwh.h"
#import "WHWeatherCity.h"

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;


@interface WHAddWeatherCityViewController()

@property (nonatomic, strong) NSMutableArray *animateConstaints;

@end

@implementation WHAddWeatherCityViewController

#pragma mark - life circle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initViewController];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_cityTextField becomeFirstResponder];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - init

- (void)initViewController
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"添加城市";
    
    [self setupAllChildViews];
    [self setConstraints];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardChangeFrame:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    
}

- (void)setupAllChildViews
{
    //背景scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scrollView];
    self.bgScrollView = scrollView;
    
    
    UILabel *cityTitle = [[UILabel alloc] init];
    cityTitle.text = @"城市名 :";
    cityTitle.textAlignment = NSTextAlignmentRight;
    cityTitle.textColor = WHColor(229, 149, 97, 1.0);
    cityTitle.font = [UIFont systemFontOfSize:16.0];
    cityTitle.backgroundColor = [UIColor clearColor];
    [self.bgScrollView addSubview:cityTitle];
    self.cityTitle = cityTitle;
    
    UITextField *cityTextField = [[UITextField alloc] init];
    cityTextField.placeholder = @"请输入您要添加的城市";
    cityTextField.font = [UIFont systemFontOfSize:14.0];
    [cityTextField.layer setBorderWidth:1.0];
    [cityTextField.layer setBorderColor:WHColor(229, 149, 97, 1.0).CGColor];
    cityTextField.layer.cornerRadius = 5.0;
    cityTextField.clipsToBounds = YES;
    [cityTextField setBackgroundColor:[UIColor whiteColor]];
    [self.bgScrollView addSubview:cityTextField];
    self.cityTextField = cityTextField;
    
    UIButton *sureBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.layer.cornerRadius = 5.0;
    sureBtn.clipsToBounds = YES;
    [sureBtn setTitle:@"确 定" forState:UIControlStateNormal];
    sureBtn.titleLabel.textColor = [UIColor whiteColor];
    [sureBtn setBackgroundColor:WHColor(229, 149, 97, 1.0)];
    [self.bgScrollView addSubview:sureBtn];
    self.sureBtn = sureBtn;
    [self.sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setConstraints
{
    WS(ws);
    [self.bgScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        [self.animateConstaints addObjectsFromArray:
         @[ make.edges.equalTo(ws.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0)),
            ]
         ];
    }];
    
    [self.cityTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.bgScrollView).with.offset(20.0);
        make.top.equalTo(ws.bgScrollView.mas_top).with.offset(40.0);
        make.height.mas_equalTo(40.0);
        make.width.mas_equalTo(180.0);
    }];
    
    [self.cityTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.cityTextField);
        make.height.equalTo(ws.cityTextField);
        make.right.equalTo(ws.cityTextField.mas_left).with.offset(- 10.0);
        make.width.mas_equalTo(80.0);
    }];
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.bgScrollView);
        make.top.equalTo(ws.cityTextField.mas_bottom).with.offset(20.0);
        make.height.mas_equalTo(30.0);
        make.width.mas_equalTo(120.0);
    }];
}
#pragma mark - Action

- (void)keyboardChangeFrame:(NSNotification*)aNotification
{
    NSDictionary *info = [aNotification userInfo];
    NSValue *keyboardFrame = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    //取出约束并改变
    for (MASConstraint *constraint in self.animateConstaints) {
        constraint.insets = UIEdgeInsetsMake(0, 0, [keyboardFrame CGRectValue].size.height, 0);
    }
    
    NSNumber *keyboardDuration = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    //刷新约束，形成动画效果
    [UIView animateWithDuration:[keyboardDuration doubleValue]
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];
}

- (void)keyboardWillHide:(NSNotification*)aNotification
{
    for (MASConstraint *constraint in self.animateConstaints) {
        constraint.insets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)sureBtnClick
{
    if (self.cityTextField == nil) {
        [MBProgressHUD showError:@"请输入城市名！"];
        return;
    }
//    else if (){
//    
//    }
    [self.navigationController popViewControllerAnimated:YES];
    if([self.delegate respondsToSelector:@selector(addWeatherCityViewController:didAddCity:)]){
        WHWeatherCity *city = [[WHWeatherCity alloc] init];
        city.name = self.cityTextField.text;
        [self.delegate addWeatherCityViewController:self didAddCity:city];
    }    
}

#pragma mark - lazy load
- (NSMutableArray *)animateConstaints
{
    if (_animateConstaints == nil) {
        _animateConstaints = [NSMutableArray array];
    }
    return _animateConstaints;
}
@end
