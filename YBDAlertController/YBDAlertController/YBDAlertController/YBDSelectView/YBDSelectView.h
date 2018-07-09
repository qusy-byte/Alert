//
//  YBDSelectView.h
//  YBDAlertController
//
//  Created by Jadyn on 2018/1/17.
//  Copyright © 2018年 Jadyn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBDSelectView;

/**
 点击item的回调
 
 @param selectTableView 当前的select
 @param currentIndex 当前点击的item的index
 @param currentTitle 当前点击的item的title
 */
typedef void(^YBDSelectTableViewItemClickHandle)(YBDSelectView *selectTableView, NSInteger currentIndex, NSString *currentTitle);

@interface YBDSelectView : UIView

/**
 origin
 */
@property (nonatomic,assign) CGPoint origin;

/**
 创建selectTableView
 
 @param icons 图标
 @param titles 标题
 @return selectTableView
 */
+ (instancetype)selectTableViewWithIcon:(NSArray *)icons title:(NSArray *)titles;

/**
 selectTableView show
 */
- (void)show;

/**
 设置点击回调函数
 
 @param handle 回调
 */
- (void)setSelectTableViewItemClickHandle:(YBDSelectTableViewItemClickHandle)handle;

@end
