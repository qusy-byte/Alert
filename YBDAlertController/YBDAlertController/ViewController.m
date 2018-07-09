//
//  ViewController.m
//  YBDAlertController
//
//  Created by Jadyn on 2018/1/17.
//  Copyright © 2018年 Jadyn. All rights reserved.
//

#import "ViewController.h"
#import "YBDActionSheetView.h"
#import "YBDAlertView.h"
#import "YBDSelectView.h"
#import "YBDProgressHUD.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)actionSheetClick:(UIButton *)sender {
    
    YBDActionSheetView *actionView = [YBDActionSheetView actionSheetWithTitle:nil message:nil cancel:nil ActionTitles:@"拍照片", @"看视频", @"打游戏", nil];
    [actionView show];
    
    // item 回调
    [actionView setCustomActionSheetItemClickHandle:^(YBDActionSheetView *actionSheet, NSInteger currentIndex, NSString *currentTitle) {
        
        NSLog(@" currentIndex = %zd, currentTitle = %@",currentIndex, currentTitle);
        
    }];
    
    // cancel 回调
    [actionView setCustomActionSheetCancelItemClickHandle:^(YBDActionSheetView *actionSheet, NSInteger currentIndex, NSString *currentTitle) {
        
        NSLog(@" currentIndex = %zd, currentTitle = %@",currentIndex, currentTitle);
        
    }];
    
}

- (IBAction)alertViewClick:(UIButton *)sender {
    
    YBDAlertView *alertView = [YBDAlertView alertViewWithTitle:@"温馨提示" message:@"你还未绑定银行卡，请先绑定400-091-8080" imageName:@"icon_head" type:YBDAlertViewTypeNormal ItemTitles: @"知道了", nil];
    [alertView show];
    
    [alertView setupAlertViewItemClickHandel:^(YBDAlertView *alertView, NSInteger currentItemIndex, NSString *currentItemTitle) {
        
        NSLog(@" currentItemIndex = %zd, currentItemTitle = %@",currentItemIndex, currentItemTitle);
    }];
    
}

- (IBAction)selectViewClick:(UIButton *)sender {
//    NSArray *icons = @[@"收藏",@"客服",@"拍照",@"提示"];
    NSArray *titles = @[@"我的收藏",@"联系客服",@"上传头像",@"我的提示"];
    
    YBDSelectView *selectView = [YBDSelectView selectTableViewWithIcon:nil title:titles];
    selectView.origin = CGPointMake(sender.frame.origin.x, CGRectGetMaxY(sender.frame));
    [selectView show];
    
    [selectView setSelectTableViewItemClickHandle:^(YBDSelectView *selectTableView, NSInteger currentIndex, NSString *currentTitle) {
        
        NSLog(@" currentIndex = %zd, currentTitle = %@",currentIndex, currentTitle);
    }];
}

- (IBAction)progressHUDClick:(UIButton *)sender {
    
    YBDProgressHUD *hud = [YBDProgressHUD showMessageWith:@"加载中..."];
   
    [self performSelector:@selector(dismissHud:) withObject:hud afterDelay:2.0f];
}
- (void)dismissHud:(YBDProgressHUD *)hud {
    [hud hiddeProgressHUD];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end








