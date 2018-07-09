//
//  YBDActionSheetView.m
//  YBDAlertController
//
//  Created by Jadyn on 2018/1/17.
//  Copyright © 2018年 Jadyn. All rights reserved.
//

#import "YBDActionSheetView.h"
#import "YBDAlertConstant.h"

@interface YBDActionSheetView ()

/**
 subTitles数组
 */
@property (nonatomic,strong) NSMutableArray *subTitlesArray;

/**
 取消按钮
 */
@property (nonatomic,copy) NSString *cancelTitle;

/**
 标题
 */
@property (nonatomic,copy) NSString *title;

/**
 提示消息
 */
@property (nonatomic,copy) NSString *message;

/**
 背景
 */
@property (nonatomic,weak) UIView *backgrounView;

/**
 内容视图
 */
@property (nonatomic,strong) UIView *contentView;

/**
 titleView
 */
@property (nonatomic,weak) UIView *titleView;
/**
 titleLabel
 */
@property (nonatomic,weak) UILabel *titleLabel;

/**
 messageLabel
 */
@property (nonatomic,weak) UILabel *messageLabel;
/**
 cancelButton
 */
@property (nonatomic,weak) UIButton *cancelButton;
/**
 items
 */
@property (nonatomic,strong) NSMutableArray <UIButton *> *items;

/**
 contentHeight
 */
@property (nonatomic,assign) CGFloat contentHeight;

@end

@implementation YBDActionSheetView {
    YBDCustomActionSheetItemClickHandle _clickHandle; // 点击回调
    YBDCustomActionSheetItemClickHandle _cancelHandle; // 取消回调
}

+ (instancetype)actionSheetWithTitle:(NSString *)title message:(NSString *)message cancel:(NSString *)cancelTitle ActionTitles:(NSString *)actionTitle, ...{
    
    YBDActionSheetView *sheetView = [[YBDActionSheetView alloc] initWithFrame:(CGRect){CGPointZero,CGSizeMake(ybd_mainWidth, ybd_mainHeight)}];
    sheetView.cancelTitle = cancelTitle;
    sheetView.title = title;
    sheetView.message = message;
    
    // subTitle
    NSString *subTitle;
    
    // C语言提供的处理变长参数的一种方法
    va_list argumentList;
    
    if (actionTitle) {
        [sheetView.subTitlesArray addObject:actionTitle];
        
        // va_start初始化刚定义的va_list变量
        va_start(argumentList, actionTitle);
        
        // va_arg返回可变的参数
        while ((subTitle = va_arg(argumentList, id))) {
            NSString *actionT = [subTitle copy];
            [sheetView.subTitlesArray addObject:actionT];
        }
        
        // va_end宏结束可变参数的获取
        va_end(argumentList);
    }
    
    YBDLog(@"subTitles = %@",sheetView.subTitlesArray);
    
    // 添加按钮
    [sheetView setupActionSheetItem];
    
    return sheetView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self backgrounView];
    }
    
    return self;
}

#pragma mark
#pragma mark --- 回调 ---
- (void)setCustomActionSheetItemClickHandle:(YBDCustomActionSheetItemClickHandle)itemClickHandle{
    _clickHandle = itemClickHandle;
}

- (void)setCustomActionSheetCancelItemClickHandle:(YBDCustomActionSheetItemClickHandle)cancleItemClickHandle{
    _cancelHandle = cancleItemClickHandle;
}

#pragma mark
#pragma mark --- ActionSheet show Or dismiss ---
- (void)show{
    
    // 如果存在，就return出去
    if ([[UIApplication sharedApplication].keyWindow viewWithTag:acTag]) {
        return;
    }
    
    self.backgrounView.alpha = 0.0f;
    self.contentView.alpha = 0.0f;
    self.contentView.frame = CGRectMake(0, ybd_mainHeight, ybd_mainWidth, self.contentHeight);
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    self.tag = acTag;
    
    [UIView animateWithDuration:0.22 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.backgrounView.alpha = 1.0f;
        self.contentView.alpha = 1.0f;
        self.contentView.frame = CGRectMake(0, ybd_mainHeight-self.contentHeight, ybd_mainWidth, self.contentHeight);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss{
    [UIView animateWithDuration:0.22 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.backgrounView.alpha = 0.0f;
        self.contentView.alpha = 0.0f;
        self.contentView.frame = CGRectMake(0, ybd_mainHeight, ybd_mainWidth, 300);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark
#pragma mark --- 创建按钮 ---
- (void)setupActionSheetItem{
    
    UIView *titleView = [[UIView alloc] init];
    titleView.backgroundColor = ybd_Color(aWhiteColor);
    [self.contentView addSubview:titleView];
    self.titleView = titleView;
    
    if (self.title.length > 0) {
        
        // 标题
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = self.title;
        titleLabel.backgroundColor = ybd_Color(aWhiteColor);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:acTitleFont];
        [self.titleView addSubview:titleLabel];
        self.titleLabel = titleLabel;
    }
    
    if (self.message.length > 0) {
        
        // 提示信息
        UILabel *messageLabel = [[UILabel alloc] init];
        messageLabel.backgroundColor = ybd_Color(aWhiteColor);
        messageLabel.numberOfLines = 0;
        messageLabel.text = self.message.length > 0 ? self.message : @"";
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont systemFontOfSize:acMessageFont];
        [self.titleView addSubview:messageLabel];
        self.messageLabel = messageLabel;
    }
    
    // 按钮
    for (NSInteger i = 0 ; i < self.subTitlesArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = ybd_Color(aWhiteColor);
        button.titleLabel.font = [UIFont systemFontOfSize:acItemFont];
        [button setTitle:self.subTitlesArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.tag = i + 100;
        [button addTarget:self action:@selector(actionSheetItemClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        
        // item数组
        [self.items addObject:button];
    }
    
    if (self.cancelTitle.length > 0) {
        
        // 取消按钮
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.backgroundColor = ybd_Color(aWhiteColor);
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:acItemFont];
        [cancelBtn setTitle:self.cancelTitle forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(actionSheetCancelItemClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:cancelBtn];
        self.cancelButton = cancelBtn;
    }
    
    // 约束位置
    [self setupSubviewsFrame];
    
}

#pragma mark
#pragma mark --- layoutSubviews ---
- (void)setupSubviewsFrame{
    
    // 约束标题
    CGFloat titleHeight = self.title.length > 0 ? 30.0 : 0.0;
    
    // 约束提示
    CGFloat messageHeight = self.message.length > 0 ? [self getHeightWith:self.message font:12] : 0.0f;
    
    CGFloat titleViewHeight = 0.0;
    if (self.message.length == 0) {
        titleViewHeight = acHeadMinHeight;
        titleHeight = acHeadMinHeight;
    }else{
        if ((titleHeight + messageHeight) <= acHeadMinHeight) {
            titleViewHeight = acHeadMinHeight + 10;
            messageHeight = acHeadMinHeight - titleHeight;
        }else if ((titleHeight + messageHeight) > acHeadMaxHeight){
            titleViewHeight = acHeadMaxHeight + 10;
            messageHeight = acHeadMaxHeight - titleHeight;
        }else{
            titleViewHeight = titleHeight + messageHeight + 10;
        }
    }
    
    if (self.title.length == 0 && self.message.length == 0) {
        titleViewHeight = 0;
    }
    
    self.titleLabel.frame = CGRectMake(0, 0, ybd_mainWidth, titleHeight);
    
    CGFloat messageY = self.title.length > 0 ? CGRectGetMaxY(self.titleLabel.frame) : (titleViewHeight-messageHeight)/2;
    self.messageLabel.frame = CGRectMake(30, messageY, ybd_mainWidth-60, messageHeight);
    
    self.titleView.frame = CGRectMake(0, 0, ybd_mainWidth, titleViewHeight);
    
    // 约束item
    CGFloat itemY = CGRectGetMaxY(self.titleView.frame) + 1;
    
    [self.items enumerateObjectsUsingBlock:^(UIButton *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        obj.frame = CGRectMake(0, itemY + (acItemHeight + 1) * idx, ybd_mainWidth, acItemHeight);
    }];
    
    // 约束cancel
    UIButton *lastItem = [self.items lastObject];
    CGFloat cancelY = CGRectGetMaxY(lastItem.frame);
    self.cancelButton.frame = CGRectMake(0, cancelY + 5, ybd_mainWidth, acItemHeight);
    
    // 约束 contentView
    UIButton *button = self.cancelTitle.length > 0 ? self.cancelButton : lastItem;
    CGFloat contentHeight = CGRectGetMaxY(button.frame);
    self.contentHeight = contentHeight;
    
}

#pragma mark
#pragma mark --- 计算size ---
- (CGFloat)getHeightWith:(NSString *)string font:(CGFloat)font{
    
    CGFloat height = 0.0;
    
    CGSize size = [string boundingRectWithSize:CGSizeMake(ybd_mainWidth-100, 300) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
    
    height = size.height;
    
    return height;
}

#pragma mark
#pragma mark --- 按钮点击事件 ---
- (void)actionSheetItemClick:(UIButton *)button{
    
    // 点击按钮，触发回调
    _clickHandle(self, button.tag, button.currentTitle);
    
    // Actionsheet消失
    [self dismiss];
}

- (void)actionSheetCancelItemClick:(UIButton *)button{
    
    // 点击按钮，触发回调
    _cancelHandle(self, button.tag, button.currentTitle);
    
    // Actionsheet消失
    [self dismiss];
}

#pragma mark
#pragma mark --- lazy ---
- (NSMutableArray *)subTitlesArray{
    
    if (!_subTitlesArray) {
        _subTitlesArray = [NSMutableArray array];
    }
    
    return _subTitlesArray;
}

- (UIView *)backgrounView{
    
    if (!_backgrounView) {
        UIView *view = [[UIView alloc] initWithFrame:(CGRect){CGPointZero,CGSizeMake(ybd_mainWidth, ybd_mainHeight)}];
        view.backgroundColor = ybd_AlphaColor(aBlackColor, 0.3f);
        [self addSubview:view];
        _backgrounView = view;
        
        UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [view addGestureRecognizer:tapG];
    }
    
    return _backgrounView;
}

- (UIView *)contentView{
    if (!_contentView) {
        UIView *view = [[UIView alloc] initWithFrame:(CGRect){CGPointMake(0, ybd_mainHeight-300),CGSizeMake(ybd_mainWidth, 300)}];
        view.backgroundColor = [UIColor clearColor];
        [self addSubview:view];
        _contentView = view;
    }
    
    return _contentView;
}

- (NSMutableArray *)items{
    if (!_items) {
        _items = [NSMutableArray array];
    }
    
    return _items;
}

@end














