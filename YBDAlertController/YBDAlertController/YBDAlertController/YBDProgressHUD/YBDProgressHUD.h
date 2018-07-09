//
//  YBDProgressHUD.h
//  YBDAlertController
//
//  Created by Jadyn_Qu on 2018/2/5.
//  Copyright © 2018年 Jadyn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,YBDProgressHUDType) {
    YBDProgressHUDTypeNormal = 0,    // 普通样式
};

@interface YBDProgressHUD : UIView

+ (instancetype)showMessageWith:(NSString *)message;
+ (instancetype)showMessageWith:(NSString *)message toView:(UIView *)view;

- (void)hiddeProgressHUD;

@end
