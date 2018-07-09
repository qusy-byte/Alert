//
//  YBDActionSheetView.h
//  YBDAlertController
//
//  Created by Jadyn on 2018/1/17.
//  Copyright © 2018年 Jadyn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBDActionSheetView;

/**
 Actionsheet点击事件
 
 @param actionSheet 当前的Actionsheet
 @param currentIndex 当前点击的按钮
 @param currentTitle 当前按钮的title
 */
typedef void(^YBDCustomActionSheetItemClickHandle)(YBDActionSheetView *actionSheet, NSInteger currentIndex, NSString *currentTitle);

@interface YBDActionSheetView : UIView

/**
 创建Actionsheet
 
 @param title Actionsheet的标题
 @param message Actionsheet的提示信息
 @param cancelTitle Actionsheet的取消按钮标题
 @param actionTitles Actionsheet的其他按钮标题
 @return Actionsheet
 */
+ (instancetype)actionSheetWithTitle:(NSString *)title message:(NSString *)message cancel:(NSString *)cancelTitle ActionTitles:(NSString *)actionTitles,...NS_REQUIRES_NIL_TERMINATION;

/**
 Actionsheet出现
 */
- (void)show;

/**
 Actionsheet的按钮点击事件
 
 @param itemClickHandle 点击事件回调
 */
- (void)setCustomActionSheetItemClickHandle:(YBDCustomActionSheetItemClickHandle)itemClickHandle;

/**
 Actionsheet的取消按钮点击事件
 
 @param cancleItemClickHandle 取消点击事件回调
 */
- (void)setCustomActionSheetCancelItemClickHandle:(YBDCustomActionSheetItemClickHandle)cancleItemClickHandle;

@end







