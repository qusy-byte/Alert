//
//  YBDProgressHUD.m
//  YBDAlertController
//
//  Created by Jadyn_Qu on 2018/2/5.
//  Copyright © 2018年 Jadyn. All rights reserved.
//

#import "YBDProgressHUD.h"
#import "YBDAlertConstant.h"

@interface YBDProgressHUD ()

/**
 背景视图
 */
@property (nonatomic,weak) UIView *backgroundView;
/**
 内容视图
 */
@property (nonatomic,weak) UIView *contentView;
/**
 loading
 */
@property (weak, nonatomic) UIActivityIndicatorView *activityIndicatorView;
/**
 loading
 */
@property (weak, nonatomic) UILabel *messageLabel;
/**
 loading
 */
@property (copy, nonatomic) NSString *message;

@end


@implementation YBDProgressHUD

+ (instancetype)showMessageWith:(NSString *)message {
    return [self showMessageWith:message toView:nil];
}

+ (instancetype)showMessageWith:(NSString *)message toView:(UIView *)view {
    YBDProgressHUD *hud = [[YBDProgressHUD alloc] initWithFrame:(CGRect){CGPointZero,CGSizeMake(ybd_mainWidth, ybd_mainHeight)}];
    hud.message = message;
    
    // 创建控件
    [hud setupSubview];
    
    // 约束位置
    [hud setupLayout];
    
    // 展示
    [hud showTo:view];
    
    // 消失
//    [hud performSelector:@selector(dismiss) withObject:nil afterDelay:2];
    
    return hud;
}

- (void)hiddeProgressHUD {
    [self dismiss];
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self backgroundView];
    }
    return self;
}

#pragma mark
#pragma mark --- 创建和约束 ---
- (void)setupSubview {
    // 创建loading
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.color = ybd_Color(@"#EA3E4E");
    [self.contentView addSubview:activityView];
    self.activityIndicatorView = activityView;
    
    // 创建提示
    if (self.message.length > 0) {
        UILabel *label = [UILabel new];
        label.text = self.message;
        label.textColor = ybd_Color(hudTextColor);
        label.font = [UIFont fontWithName:@"Arial-BoldMT" size:hudFont];
        label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:label];
        self.messageLabel = label;
    }
}

- (void)setupLayout {
    
    CGFloat intervalH = 10; //间隔高度
    CGFloat intervalN = 2; //间隔个数
    
    // 计算message的size
    CGSize messageSize = CGSizeZero;
    CGFloat maxW = ybd_mainWidth-80;
    CGFloat maxH = 60;
    if (self.message.length > 0) {
        messageSize = [self.messageLabel.text boundingRectWithSize:CGSizeMake(maxW, maxH) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.messageLabel.font} context:nil].size;
        intervalN = 3;
    }
    
    // 约束contentView
    CGFloat activityW = CGRectGetWidth(self.activityIndicatorView.frame);
    CGFloat hudW = messageSize.width >= hudW_H ? messageSize.width + 20 : hudW_H;
    CGFloat hudMH =messageSize.height+activityW+intervalH*intervalN;
    CGFloat hudH = hudMH >= hudW_H ? hudMH : hudW_H;
    self.contentView.bounds = (CGRect){CGPointZero, CGSizeMake(hudW, hudH)};
    
    // 约束activityIndicatorView
    CGFloat activityY = self.message.length > 0 ? intervalH : (hudW_H-activityW)/2;
    self.activityIndicatorView.frame = CGRectMake((CGRectGetWidth(self.contentView.frame)-activityW)/2, activityY, activityW, activityW);
    
    // 约束messageLabel
    self.messageLabel.frame = CGRectMake((CGRectGetWidth(self.contentView.frame)-messageSize.width)/2, CGRectGetMaxY(self.activityIndicatorView.frame)+intervalH, messageSize.width, messageSize.height);
    
}

#pragma mark
#pragma mark --- show & dismiss ---
- (void)showTo:(UIView *)view{
    [self.activityIndicatorView startAnimating];
    
    if (view) {
        // 如果hud存在，就return出去
        if ([view viewWithTag:hudTag]) return;
        [view addSubview:self];
    }else {
        
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        // 如果hud存在，就return出去
        if ([keyWindow viewWithTag:hudTag]) return;
        [keyWindow addSubview:self];
    }
    
    self.backgroundView.alpha = 0.0f;
    self.contentView.alpha = 0.0f;
    self.tag = hudTag;
    
    [UIView animateWithDuration:0.22f delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        self.backgroundView.alpha = 1.0f;
        self.contentView.alpha = 1.0f;
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss{
    [UIView animateWithDuration:0.22f delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        self.backgroundView.alpha = 0.0f;
        self.contentView.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        [self.activityIndicatorView stopAnimating];
        [self removeFromSuperview];
    }];
}

#pragma mark
#pragma mark --- lazy ---
- (UIView *)backgroundView{
    if (!_backgroundView) {
        UIView *view = [[UIView alloc] initWithFrame:(CGRect){CGPointZero,CGSizeMake(ybd_mainWidth, ybd_mainHeight)}];
        view.backgroundColor = ybd_Color(@"#12");
        [self addSubview:view];
        _backgroundView = view;
    }
    
    return _backgroundView;
}

- (UIView *)contentView{
    if (!_contentView) {
        UIView *view = [[UIView alloc] initWithFrame:(CGRect){CGPointZero,CGSizeMake(hudW_H, hudW_H)}];
        view.center = self.center;
        view.backgroundColor = ybd_AlphaColor(aBlackColor, 0.4f);
        view.layer.cornerRadius = hudRadios;
        [self addSubview:view];
        _contentView = view;
    }
    return _contentView;
}

@end










