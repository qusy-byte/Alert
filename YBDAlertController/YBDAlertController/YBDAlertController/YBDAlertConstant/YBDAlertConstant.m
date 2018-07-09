//
//  YBDAlertConstant.m
//  YBDAlertController
//
//  Created by Jadyn on 2018/1/17.
//  Copyright © 2018年 Jadyn. All rights reserved.
//

#import "YBDAlertConstant.h"

@implementation YBDAlertConstant

/**
 控件的默认圆角
 */
CGFloat const aDefaultRadios = 4.0f;

/**
 黑色
 */
NSString * const aBlackColor = @"#000000";

/**
 白色
 */
NSString * const aWhiteColor = @"#FFFFFF";

/**
 字体黑色
 */
NSString * const aDarkTextColor = @"#333333";

/**
 字体浅色
 */
NSString * const aLightTextColor = @"#666666";

/**
 线的颜色
 */
NSString * const aLineColor = @"#EBEBEB";

#pragma mark -------- actionsheet static -----------

/**
 actionsheet tag
 */
NSInteger const acTag = 111110;

/**
 actionsheet item font
 */
NSInteger const acItemFont = 18;

/**
 actionsheet title font
 */
NSInteger const acTitleFont = 15;

/**
 actionsheet message font
 */
NSInteger const acMessageFont = 14;

/**
 actionsheet按钮的默认高度
 */
CGFloat const acItemHeight = 50;

/**
 actionsheet按钮的最小高度(有标题时，最小是此值)
 */
CGFloat const acHeadMinHeight = 60;

/**
 actionsheet头部最大高度
 */
CGFloat const acHeadMaxHeight = 120;

#pragma mark -------- alert static -----------

/**
 alert tag
 */
NSInteger const alTag = 111111;

/**
 alert item font
 */
NSInteger const alItemFont = 18;

/**
 alert title font
 */
NSInteger const alTitleFont = 16;

/**
 alert message font
 */
NSInteger const alMessageFont = 14;

/**
 alert按钮的默认高度
 */
CGFloat const alItemHeight = 50;

/**
 alert头部的最小高度(有标题时，最小是此值)
 */
CGFloat const alHeadMinHeight = 70;

/**
 alert头部的最大高度
 */
CGFloat const alHeadMaxHeight = 150;

/**
 alert宽度与屏幕宽度比
 */
CGFloat const alWdithScale = 0.85;

#pragma mark -------- select static -----------

/**
 select tag
 */
NSInteger const asTag = 111112;

/**
 select按钮的默认高度
 */
CGFloat const asItemHeight = 44;

/**
 select宽度
 */
CGFloat const asWidth = 130;

#pragma mark -------- progressHUD -----------

/**
 progressHUD tag
 */
NSInteger const hudTag = 111112;

/**
 progressHUD按钮的默认高度、宽度
 */
CGFloat const hudW_H = 80;

/**
 progressHUD按钮的默认圆角
 */
CGFloat const hudRadios = 10;

/**
 progressHUD按钮的默认字体大小
 */
CGFloat const hudFont = 15;

/**
 progressHUD字体颜色
 */
NSString * const hudTextColor = @"#FFFFFF";

#pragma mark
#pragma mark --- 颜色转换方法 ---
+ (UIColor *)ybd_colorWithHexString:(NSString *)color Alpha:(CGFloat)alpha
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // 判断前缀
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:alpha];
}

+ (CAGradientLayer *)ybd_layerGradualColor {
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)ybd_Color(@"#6367f2").CGColor, (__bridge id)ybd_Color(@"#ac49f6").CGColor];
    gradientLayer.locations = @[@0.0,@1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    
    return gradientLayer;
}

@end
















