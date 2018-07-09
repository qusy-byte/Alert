//
//  YBDAlertConstant.h
//  YBDAlertController
//
//  Created by Jadyn on 2018/1/17.
//  Copyright © 2018年 Jadyn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/***  当前屏幕宽度 */
#define ybd_mainWidth [[UIScreen mainScreen] bounds].size.width
/***  当前屏幕高度 */
#define ybd_mainHeight [[UIScreen mainScreen] bounds].size.height

/***  颜色转换 */
#define ybd_Color(color) [YBDAlertConstant ybd_colorWithHexString:color Alpha:1.0f]
#define ybd_AlphaColor(color,alpha) [YBDAlertConstant ybd_colorWithHexString:color Alpha:alpha]

/** 输出调试 */
#ifdef DEBUG
#define YBDLog(fmt , ...) NSLog((@"\n---文件名:%s\n" "---行号:%d, " "---函数名:%s\n" fmt "\n<<<-------0--------0-0--------0------->>>"), __FILE__, __LINE__, __FUNCTION__, ##__VA_ARGS__);
#else
#define YBDLog(...)
#endif

@interface YBDAlertConstant : NSObject

#pragma mark -------- base static -----------

/**
 控件的默认圆角
 */
extern CGFloat const aDefaultRadios;

/**
 黑色
 */
extern NSString * const aBlackColor;

/**
 白色
 */
extern NSString * const aWhiteColor;

/**
 字体黑色
 */
extern NSString * const aDarkTextColor;

/**
 字体浅色
 */
extern NSString * const aLightTextColor;

/**
 线的颜色
 */
extern NSString * const aLineColor;

#pragma mark -------- actionsheet static -----------

/**
 actionsheet tag
 */
extern NSInteger const acTag;

/**
 actionsheet item font
 */
extern NSInteger const acItemFont;

/**
 actionsheet title font
 */
extern NSInteger const acTitleFont;

/**
 actionsheet message font
 */
extern NSInteger const acMessageFont;

/**
 actionsheet按钮的默认高度
 */
extern CGFloat const acItemHeight;

/**
 actionsheet头部的最小高度(有标题时，最小是此值)
 */
extern CGFloat const acHeadMinHeight;

/**
 actionsheet头部最大高度
 */
extern CGFloat const acHeadMaxHeight;

#pragma mark -------- alert static -----------

/**
 alert tag
 */
extern NSInteger const alTag;

/**
 alert item font
 */
extern NSInteger const alItemFont;

/**
 alert title font
 */
extern NSInteger const alTitleFont;

/**
 alert message font
 */
extern NSInteger const alMessageFont;

/**
 alert按钮的默认高度
 */
extern CGFloat const alItemHeight;

/**
 alert头部的最小高度(有标题时，最小是此值)
 */
extern CGFloat const alHeadMinHeight;

/**
 alert头部的最大高度
 */
extern CGFloat const alHeadMaxHeight;

/**
 alert宽度与屏幕宽度比
 */
extern CGFloat const alWdithScale;

#pragma mark -------- select static -----------

/**
 select tag
 */
extern NSInteger const asTag;

/**
 select按钮的默认高度
 */
extern CGFloat const asItemHeight;

/**
 select宽度
 */
extern CGFloat const asWidth;

#pragma mark -------- progressHUD -----------

/**
 progressHUD tag
 */
extern NSInteger const hudTag;

/**
 progressHUD按钮的默认高度、宽度
 */
extern CGFloat const hudW_H;

/**
 progressHUD按钮的默认圆角
 */
extern CGFloat const hudRadios;

/**
 progressHUD按钮的默认字体大小
 */
extern CGFloat const hudFont;

/**
 progressHUD字体颜色
 */
extern NSString * const hudTextColor;

#pragma mark -------- 颜色转换方法 -----------
+ (UIColor *)ybd_colorWithHexString:(NSString *)color Alpha:(CGFloat)alpha;

/**
 获取渐变layer

 @return layer
 */
+ (CAGradientLayer *)ybd_layerGradualColor;

@end







