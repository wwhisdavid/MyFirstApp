//
//  WHTabBarButton.m
//  theFirstApp
//
//  Created by deyi on 15/7/22.
//  Copyright (c) 2015年 deyi. All rights reserved.
//

#import "WHTabBarButton.h"
#import "WHBadgeButton.h"

// 按钮的默认文字颜色
#define  WHTabBarButtonTitleColor WHColor(134, 134, 134, 1.0)
// 按钮的选中文字颜色
#define  WHTabBarButtonTitleSelectedColor  WHColor(236, 115, 6, 1.0)
@interface WHTabBarButton()

/**
 *  提醒数字
 */
@property (nonatomic, weak)WHBadgeButton *badgeButton;

@end

@implementation WHTabBarButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //图标居中
        self.imageView.contentMode = UIViewContentModeCenter;
        //文字居中
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        //文字颜色
        [self setTitleColor:WHTabBarButtonTitleColor forState:UIControlStateNormal];
        [self setTitleColor:WHTabBarButtonTitleSelectedColor forState:UIControlStateSelected];
         
        //添加一个数字提醒
         WHBadgeButton *badgeButton = [[WHBadgeButton alloc] init];
         badgeButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:badgeButton];
        self.badgeButton = badgeButton;
    }
    return self;
}

//重写去掉高亮状态
- (void)setHighlighted:(BOOL)highlighted {}

//内部图片的frame
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = contentRect.size.width;
    CGFloat imageH = contentRect.size.height * 0.6;
    return CGRectMake(0, 0, imageW, imageH);
}
//内部文字的frame
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleY = contentRect.size.height * 0.6;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height - titleY;
    return CGRectMake(0, titleY, titleW, titleH);
}

//设置item
- (void)setItem:(UITabBarItem *)item
{
    _item = item;
    
    //KVO 监听属性改变
    [item addObserver:self forKeyPath:@"badgeValue" options:0 context:nil];
    [item addObserver:self forKeyPath:@"title" options:0 context:nil];
    [item addObserver:self forKeyPath:@"image" options:0 context:nil];
    [item addObserver:self forKeyPath:@"selectImage" options:0 context:nil];
    
    [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];
}

- (void)dealloc
{
    [self.item removeObserver:self forKeyPath:@"badgeValue"];
    [self.item removeObserver:self forKeyPath:@"title"];
    [self.item removeObserver:self forKeyPath:@"image"];
    [self.item removeObserver:self forKeyPath:@"selectedImage"];
}
/**
 *  监听到某个对象的属性改变了，就会调用
 *
 *  @param keyPath 属性名
 *  @param object  哪个对象的属性被改变
 *  @param change  属性的改变
 */
-  (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    //设置文字
    [self setTitle:self.item.title forState:UIControlStateSelected];
    [self setTitle:self.item.title forState:UIControlStateNormal];
    
    //设置图片
    [self setImage:self.item.image forState:UIControlStateNormal];
    [self setImage:self.item.selectedImage forState:UIControlStateSelected];
    
    //设置提醒数字
    self.badgeButton.badgeValue = self.item.badgeValue;
    
    //设置提醒数字位置
    CGFloat badgeY = 5;
    CGFloat badgeX = self.frame.size.width - self.badgeButton.frame.size.width - 10;
    CGRect badgeF = self.badgeButton.frame;
    badgeF.origin.x = badgeX;
    badgeF.origin.y = badgeY;
    self.badgeButton.frame = badgeF;
}
@end
