//
//  WHAddWeatherCityViewController.m
//  theFirstApp
//
//  Created by david on 15/7/25.
//  Copyright (c) 2015年 deyi. All rights reserved.
//

#import "WHAddWeatherCityViewController.h"
#import "Masonry.h"

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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - init

- (void)initViewController
{
    self.view.backgroundColor = WHColor(236, 115, 6, 1.0);
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
    cityTitle.textColor = [UIColor whiteColor];
    cityTitle.font = [UIFont systemFontOfSize:16.0];
    cityTitle.backgroundColor = [UIColor clearColor];
    [self.bgScrollView addSubview:cityTitle];
    self.cityTitle = cityTitle;
    
    UITextField *cityTextField = [[UITextField alloc] init];
    cityTextField.placeholder = @"请输入您要添加的城市";
    cityTextField.font = [UIFont systemFontOfSize:16.0];
    cityTextField.layer.cornerRadius = 5.0;
    cityTextField.clipsToBounds = YES;
    [cityTextField setBackgroundColor:[UIColor whiteColor]];
    [self.bgScrollView addSubview:cityTextField];
    self.cityTextField = cityTextField;
    
    UIButton *sureBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.layer.cornerRadius = 5.0;
    sureBtn.clipsToBounds = YES;
    [sureBtn setTitle:@"确 定" forState:UIControlStateNormal];
    sureBtn.titleLabel.textColor = WHColor(221, 138, 78, 1.0);
    [sureBtn setBackgroundColor:[UIColor whiteColor]];
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
        make.right.equalTo(ws.cityTextField.mas_left);
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
    WHLog(@"--------------");
    [self.navigationController popToRootViewControllerAnimated:YES];
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