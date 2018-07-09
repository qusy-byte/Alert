//
//  YBDAlertView.h
//  YBDAlertController
//
//  Created by Jadyn on 2018/1/17.
//  Copyright © 2018年 Jadyn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBDAlertView;


typedef NS_ENUM(NSInteger,YBDAlertViewType) {
    YBDAlertViewTypeNormal = 0,    // 普通
    YBDAlertViewTypeTextField,     // 带textField
    YBDAlertViewTypeTextView,     // 带textView
    YBDAlertViewTypeControll,     // 按钮带颜色的
    YBDAlertViewTypeImageNormal,     // 带图片的、图片越界
    YBDAlertViewTypeImageClose,     // 带图片的、关闭
};

/**
 点击按钮回调
 
 @param alertView 当前alertView
 @param currentItemIndex 当前按钮的tag值
 @param currentItemTitle 当前按钮的title
 */
typedef void(^YBDCustomAlertViewItemClickHandle)(YBDAlertView *alertView, NSInteger currentItemIndex, NSString *currentItemTitle);

@interface YBDAlertView : UIView

/**
 输入框内容
 */
@property (nonatomic,readonly) NSString *inputText;

/**
 创建一个alertView
 
 @param title alertView的标题
 @param message alertView的提示信息
 @param imageName 图片标题
 @param type alertView的类型
 @param itemTitle alertView的按钮名称 注意：最多三个按钮
 @return alertView
 */
+ (instancetype)alertViewWithTitle:(NSString *)title message:(NSString *)message imageName:(NSString *)imageName type:(YBDAlertViewType)type ItemTitles:(NSString *)itemTitle,...NS_REQUIRES_NIL_TERMINATION;

/**
 展示alertView
 */
- (void)show;

/**
 设置点击回调
 
 @param itemClickHandle 回调函数
 */
- (void)setupAlertViewItemClickHandel:(YBDCustomAlertViewItemClickHandle)itemClickHandle;

@end
