//
//  YBDAlertView.m
//  YBDAlertController
//
//  Created by Jadyn on 2018/1/17.
//  Copyright © 2018年 Jadyn. All rights reserved.
//

#import "YBDAlertView.h"
#import "YBDAlertConstant.h"

#define  kAlertViewWidth ybd_mainWidth *alWdithScale

@interface YBDAlertView () <UITextViewDelegate,UITextFieldDelegate>

/**
 背景视图
 */
@property (nonatomic,weak) UIView *backgroundView;

/**
 内容视图
 */
@property (nonatomic,weak) UIView *contentView;

/**
 alertView title
 */
@property (nonatomic,copy) NSString *title;

/**
 alertView message
 */
@property (nonatomic,copy) NSString *message;

/**
 alertView message
 */
@property (nonatomic,copy) NSString *imageName;

/**
 alertView的按钮titles
 */
@property (nonatomic,strong) NSMutableArray *itemTitles;

/**
 titleLabel
 */
@property (nonatomic,weak) UILabel *titleLabel;

/**
 messageLabel
 */
@property (nonatomic,weak) UILabel *messageLabel;

/**
 imageView
 */
@property (nonatomic,weak) UIImageView *imageView;

/**
 closeButton
 */
@property (nonatomic,weak) UIButton *closeButton;

/**
 按钮数组
 */
@property (nonatomic,strong) NSMutableArray *items;

/**
 horizontalLine
 */
@property (nonatomic,weak) UILabel *horizontalLine;

/**
 verticalLine
 */
@property (nonatomic,weak) UILabel *verticalLine;

/**
 输入框内容
 */
@property (nonatomic,copy) NSString *inputText;

/**
 输入框
 */
@property (nonatomic,weak) UITextView *inputTextView;

/**
 输入框
 */
@property (nonatomic,weak) UITextField *inputTextField;

/**
 placeholder
 */
@property (nonatomic,weak) UILabel *placeholderLabel;

/**
 alertView 类型
 */
@property (nonatomic,assign) YBDAlertViewType type;

@end

@implementation YBDAlertView {
    YBDCustomAlertViewItemClickHandle _clickHandle;
}

+ (instancetype)alertViewWithTitle:(NSString *)title message:(NSString *)message imageName:(NSString *)imageName type:(YBDAlertViewType)type ItemTitles:(NSString *)itemTitle, ...{
    
    YBDAlertView *alertView = [[YBDAlertView alloc] initWithFrame:(CGRect){CGPointZero,CGSizeMake(ybd_mainWidth, ybd_mainHeight)}];
    alertView.title = title;
    alertView.message = message;
    alertView.imageName = imageName;
    alertView.type = type;
    
    // 按钮标题
    NSString *subTitle;
    
    // C语言提供的处理变长参数的一种方法
    va_list argumentList;
    
    if (itemTitle) {
        [alertView.itemTitles addObject:itemTitle];
        
        // va_start初始化刚定义的va_list变量
        va_start(argumentList, itemTitle);
        
        // va_arg返回可变的参数
        while ((subTitle = va_arg(argumentList, id))) {
            NSString *itemT = [subTitle copy];
            [alertView.itemTitles addObject:itemT];
        }
        
        // va_end宏结束可变参数的获取
        va_end(argumentList);
    }
    
    // 创建子视图
    [alertView setupAlertViewItems];
    
    return alertView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self backgroundView];
    }
    return self;
}

#pragma mark
#pragma mark --- 创建子视图 ---
- (void)setupAlertViewItems{
    
    if (self.type == YBDAlertViewTypeImageClose) {
        
        [self setupImageClose];
        
    }else if (self.type == YBDAlertViewTypeImageNormal) {
        
        [self setupImageNormal];
        
    }else if (self.type == YBDAlertViewTypeNormal) {
        
        [self setupNormal];
        
    }else if (self.type == YBDAlertViewTypeTextView) {
        
        [self setupTextView];
        
    }else if (self.type == YBDAlertViewTypeTextField) {
        
        [self setupTextField];
        
    }else if (self.type == YBDAlertViewTypeControll) {
        
        [self setupControll];
        
    }
}

#pragma mark
#pragma mark --- YBDAlertViewTypeNormal ---
- (void)setupNormal {
    // 标题
    if (self.title.length > 0) {
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:alTitleFont];
        titleLabel.text = self.title.length > 0 ? self.title : @"";;
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
    }
    
    if (self.message.length > 0) {
        
        // 提示语
        UILabel *messageLabel = [[UILabel alloc] init];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.numberOfLines = 0;
        messageLabel.font = [UIFont systemFontOfSize:alMessageFont];
        messageLabel.textColor = ybd_Color(aLightTextColor);
        messageLabel.text = self.message.length > 0 ? self.message : @"";
        [self.contentView addSubview:messageLabel];
        self.messageLabel = messageLabel;
    }
    
    // line
    UILabel *horizontalLine = [[UILabel alloc] init];
    horizontalLine.backgroundColor = ybd_Color(aLineColor);
    [self.contentView addSubview:horizontalLine];
    self.horizontalLine = horizontalLine;
    
    UILabel *verticalLine = [[UILabel alloc] init];
    verticalLine.backgroundColor = ybd_Color(aLineColor);
    [self.contentView addSubview:verticalLine];
    self.verticalLine = verticalLine;
    
    if (self.itemTitles.count > 0) {
        
        // 按钮 限制最多三个按钮
        NSInteger itemCount = self.itemTitles.count > 3 ? 3 : self.itemTitles.count;
        for (NSInteger i = 0; i < itemCount; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = ybd_Color(aWhiteColor);
            button.titleLabel.font = [UIFont systemFontOfSize:alItemFont];
            [button setTitle:self.itemTitles[i] forState:UIControlStateNormal];
            [button setTitleColor:ybd_Color(aLightTextColor) forState:UIControlStateNormal];
            button.tag = i + 100;
            [button addTarget:self action:@selector(alertViewItemClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:button];
            
            // item数组
            [self.items addObject:button];
        }
    }
    
    [self layoutNormal];
}

- (void)layoutNormal {
    // 标题的高
    CGFloat titleHeight = 25;
    
    // 提示消息的高
    CGFloat messageHeight = self.message.length > 0 ? [self getHeightWith:self.message font:12] : 0.0f;
    
    // 重新计算
    if (self.message.length == 0) {
        titleHeight = alHeadMinHeight;
    }else{
        if ((titleHeight + messageHeight) <= alHeadMinHeight) {
            messageHeight = alHeadMinHeight - titleHeight;
        }else if ((titleHeight + messageHeight) > alHeadMaxHeight){
            messageHeight = alHeadMaxHeight - titleHeight;
        }
        
    }
    
    // 约束标题
    self.titleLabel.frame = CGRectMake(0, 20, kAlertViewWidth, titleHeight);
    
    // 约束提示消息
    CGFloat messageY = CGRectGetMaxY(self.titleLabel.frame);
    self.messageLabel.frame = CGRectMake(20, messageY, kAlertViewWidth-40, messageHeight);
    
    // 约束line的高
    CGFloat Y = 0.0;
    Y = CGRectGetMaxY(self.messageLabel.frame);
    
    CGFloat lineY = self.message.length > 0 ? Y : CGRectGetMaxY(self.titleLabel.frame);
    
    self.horizontalLine.frame = CGRectMake(0, lineY+10, kAlertViewWidth, 1);
    
    // 约束item的高
    CGFloat itemY = CGRectGetMaxY(self.horizontalLine.frame);
    
    if (self.items.count == 3) {
        UIButton *button0 = self.items[0];
        UIButton *button1 = self.items[1];
        UIButton *button2 = self.items[2];
        
        button0.frame = CGRectMake(0, itemY, kAlertViewWidth/2.0-1, alItemHeight);
        button1.frame = CGRectMake(kAlertViewWidth/2.0+0.5, itemY, kAlertViewWidth/2.0-1, alItemHeight);
        button2.frame = CGRectMake(0, CGRectGetMaxY(button0.frame), kAlertViewWidth, alItemHeight);
        
        self.verticalLine.frame = CGRectMake(CGRectGetMaxX(button0.frame), CGRectGetMinY(button0.frame), 1, alItemHeight);
        
    }else if (self.items.count == 2){
        
        UIButton *button0 = self.items[0];
        UIButton *button1 = self.items[1];
        
        button0.frame = CGRectMake(0, itemY, kAlertViewWidth/2.0-1, alItemHeight);
        button1.frame = CGRectMake(kAlertViewWidth/2.0+0.5, itemY, kAlertViewWidth/2.0-1, alItemHeight);
        
        self.verticalLine.frame = CGRectMake(CGRectGetMaxX(button0.frame), CGRectGetMinY(button0.frame), 1, alItemHeight);
        
    }else if (self.items.count == 1){
        
        UIButton *button0 = self.items[0];
        button0.frame = CGRectMake(0, itemY, kAlertViewWidth, alItemHeight);
    }
    
    // 约束content的高
    UIButton *button = [self.items lastObject];
    CGFloat contentViewHeight = self.items.count > 0 ? CGRectGetMaxY(button.frame) : CGRectGetMaxY(self.messageLabel.frame)+10;
    self.contentView.bounds = (CGRect){CGPointZero,CGSizeMake(kAlertViewWidth, contentViewHeight)};
}

#pragma mark
#pragma mark --- YBDAlertViewTypeTextField ---
- (void)setupTextField {
    // 标题
    if (self.title.length > 0) {
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:alTitleFont];
        titleLabel.text = self.title.length > 0 ? self.title : @"";;
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
    }
    
    if (self.message.length > 0) {
        
        // 提示语
        UITextField *textField = [[UITextField alloc] init];
        textField.font = [UIFont systemFontOfSize:alMessageFont];
        textField.placeholder = self.message;
        textField.layer.borderWidth = 1.0f;
        textField.layer.borderColor = ybd_Color(aLineColor).CGColor;
        textField.layer.cornerRadius = aDefaultRadios;
        textField.backgroundColor = [UIColor clearColor];
        textField.delegate = self;
        [self.contentView addSubview:textField];
        self.inputTextField = textField;
    }
    
    
    // line
    UILabel *horizontalLine = [[UILabel alloc] init];
    horizontalLine.backgroundColor = ybd_Color(aLineColor);
    [self.contentView addSubview:horizontalLine];
    self.horizontalLine = horizontalLine;
    
    UILabel *verticalLine = [[UILabel alloc] init];
    verticalLine.backgroundColor = ybd_Color(aLineColor);
    [self.contentView addSubview:verticalLine];
    self.verticalLine = verticalLine;
    
    if (self.itemTitles.count > 0) {
        
        // 按钮 限制最多三个按钮
        NSInteger itemCount = self.itemTitles.count > 3 ? 3 : self.itemTitles.count;
        for (NSInteger i = 0; i < itemCount; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = ybd_Color(aWhiteColor);
            button.titleLabel.font = [UIFont systemFontOfSize:alItemFont];
            [button setTitle:self.itemTitles[i] forState:UIControlStateNormal];
            [button setTitleColor:ybd_Color(aLightTextColor) forState:UIControlStateNormal];
            button.tag = i + 100;
            [button addTarget:self action:@selector(alertViewItemClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:button];
            
            // item数组
            [self.items addObject:button];
        }
    }
    
    [self layoutTextField];
}

- (void)layoutTextField {
    // 标题的高
    CGFloat titleHeight = 25;
    
    // 提示消息的高
    CGFloat messageHeight = self.message.length > 0 ? [self getHeightWith:self.message font:12] : 0.0f;
    
    // 重新计算
    if (self.message.length == 0) {
        titleHeight = alHeadMinHeight;
    }else{
        if ((titleHeight + messageHeight) <= alHeadMinHeight) {
            messageHeight = alHeadMinHeight - titleHeight;
        }else if ((titleHeight + messageHeight) > alHeadMaxHeight){
            messageHeight = alHeadMaxHeight - titleHeight;
        }
        
    }
    
    // 约束标题
    self.titleLabel.frame = CGRectMake(0, 20, kAlertViewWidth, titleHeight);
    
    // 约束提示消息
    CGFloat messageY = CGRectGetMaxY(self.titleLabel.frame);
    CGFloat width = [self.title boundingRectWithSize:CGSizeMake(kAlertViewWidth, 50) options:0 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:alTitleFont]} context:nil].size.width;
    CGFloat maxWith = kAlertViewWidth-40;
    CGFloat minWith = 180;
    if (width >= maxWith) {
        width = maxWith;
    }else if (width <= minWith) {
        width = minWith;
    }
    self.inputTextField.frame = CGRectMake((kAlertViewWidth - width)/2, messageY+10, width, 50);
    
    // 约束line的高
    CGFloat Y = 0.0;
    Y = CGRectGetMaxY(self.inputTextField.frame)+5;
    
    CGFloat lineY = self.message.length > 0 ? Y : CGRectGetMaxY(self.titleLabel.frame);
    
    self.horizontalLine.frame = CGRectMake(0, lineY+10, kAlertViewWidth, 1);
    
    // 约束item的高
    CGFloat itemY = CGRectGetMaxY(self.horizontalLine.frame);
    
    if (self.items.count == 3) {
        UIButton *button0 = self.items[0];
        UIButton *button1 = self.items[1];
        UIButton *button2 = self.items[2];
        
        button0.frame = CGRectMake(0, itemY, kAlertViewWidth/2.0-1, alItemHeight);
        button1.frame = CGRectMake(kAlertViewWidth/2.0+0.5, itemY, kAlertViewWidth/2.0-1, alItemHeight);
        button2.frame = CGRectMake(0, CGRectGetMaxY(button0.frame), kAlertViewWidth, alItemHeight);
        
        self.verticalLine.frame = CGRectMake(CGRectGetMaxX(button0.frame), CGRectGetMinY(button0.frame), 1, alItemHeight);
        
    }else if (self.items.count == 2){
        
        UIButton *button0 = self.items[0];
        UIButton *button1 = self.items[1];
        
        button0.frame = CGRectMake(0, itemY, kAlertViewWidth/2.0-1, alItemHeight);
        button1.frame = CGRectMake(kAlertViewWidth/2.0+0.5, itemY, kAlertViewWidth/2.0-1, alItemHeight);
        
        self.verticalLine.frame = CGRectMake(CGRectGetMaxX(button0.frame), CGRectGetMinY(button0.frame), 1, alItemHeight);
        
    }else if (self.items.count == 1){
        
        UIButton *button0 = self.items[0];
        button0.frame = CGRectMake(0, itemY, kAlertViewWidth, alItemHeight);
    }
    
    // 约束content的高
    UIButton *button = [self.items lastObject];
    CGFloat contentViewHeight = self.items.count > 0 ? CGRectGetMaxY(button.frame) : CGRectGetMaxY(self.messageLabel.frame)+10;
    self.contentView.bounds = (CGRect){CGPointZero,CGSizeMake(kAlertViewWidth, contentViewHeight)};
}

#pragma mark
#pragma mark --- YBDAlertViewTypeTextView ---
- (void)setupTextView {
    // 标题
    if (self.title.length > 0) {
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:alTitleFont];
        titleLabel.text = self.title.length > 0 ? self.title : @"";;
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
    }
    
    if (self.message.length > 0) {
        
        // 提示语
        UILabel *placeholderLabel = [[UILabel alloc] init];
        placeholderLabel.textAlignment = NSTextAlignmentLeft;
        placeholderLabel.font = [UIFont systemFontOfSize:alMessageFont];
        placeholderLabel.numberOfLines = 0;
        placeholderLabel.textColor = ybd_Color(@"#999999");
        placeholderLabel.text = self.message.length > 0 ? self.message : @"";
        [self.contentView addSubview:placeholderLabel];
        self.placeholderLabel = placeholderLabel;
        
        UITextView *textField = [[UITextView alloc] init];
        textField.font = [UIFont systemFontOfSize:alMessageFont];
        textField.backgroundColor = [UIColor clearColor];
        textField.delegate = self;
        [self.contentView addSubview:textField];
        self.inputTextView = textField;
    }
    
    
    // line
    UILabel *horizontalLine = [[UILabel alloc] init];
    horizontalLine.backgroundColor = ybd_Color(aLineColor);
    [self.contentView addSubview:horizontalLine];
    self.horizontalLine = horizontalLine;
    
    UILabel *verticalLine = [[UILabel alloc] init];
    verticalLine.backgroundColor = ybd_Color(aLineColor);
    [self.contentView addSubview:verticalLine];
    self.verticalLine = verticalLine;
    
    if (self.itemTitles.count > 0) {
        
        // 按钮 限制最多三个按钮
        NSInteger itemCount = self.itemTitles.count > 3 ? 3 : self.itemTitles.count;
        for (NSInteger i = 0; i < itemCount; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = ybd_Color(aWhiteColor);
            button.titleLabel.font = [UIFont systemFontOfSize:alItemFont];
            [button setTitle:self.itemTitles[i] forState:UIControlStateNormal];
            [button setTitleColor:ybd_Color(aLightTextColor) forState:UIControlStateNormal];
            button.tag = i + 100;
            [button addTarget:self action:@selector(alertViewItemClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:button];
            
            // item数组
            [self.items addObject:button];
        }
    }
    
    [self layoutTextView];
}

- (void)layoutTextView {
    // 标题的高
    CGFloat titleHeight = 25;
    
    // 提示消息的高
    CGFloat messageHeight = self.message.length > 0 ? [self getHeightWith:self.message font:12] : 0.0f;
    
    // 重新计算
    if (self.message.length == 0) {
        titleHeight = alHeadMinHeight;
    }else{
        if ((titleHeight + messageHeight) <= alHeadMinHeight) {
            messageHeight = alHeadMinHeight - titleHeight;
        }else if ((titleHeight + messageHeight) > alHeadMaxHeight){
            messageHeight = alHeadMaxHeight - titleHeight;
        }
        
    }
    
    // 约束标题
    self.titleLabel.frame = CGRectMake(0, 20, kAlertViewWidth, titleHeight);
    
    // 约束提示消息
    CGFloat messageY = CGRectGetMaxY(self.titleLabel.frame);
    self.inputTextView.frame = CGRectMake(20, messageY, kAlertViewWidth-40, 60);
    self.placeholderLabel.frame = self.inputTextView.frame;
    
    // 约束line的高
    CGFloat Y = 0.0;
    Y = CGRectGetMaxY(self.inputTextView.frame);
    
    CGFloat lineY = self.message.length > 0 ? Y : CGRectGetMaxY(self.titleLabel.frame);
    
    self.horizontalLine.frame = CGRectMake(0, lineY+10, kAlertViewWidth, 1);
    
    // 约束item的高
    CGFloat itemY = CGRectGetMaxY(self.horizontalLine.frame);
    
    if (self.items.count == 3) {
        UIButton *button0 = self.items[0];
        UIButton *button1 = self.items[1];
        UIButton *button2 = self.items[2];
        
        button0.frame = CGRectMake(0, itemY, kAlertViewWidth/2.0-1, alItemHeight);
        button1.frame = CGRectMake(kAlertViewWidth/2.0+0.5, itemY, kAlertViewWidth/2.0-1, alItemHeight);
        button2.frame = CGRectMake(0, CGRectGetMaxY(button0.frame), kAlertViewWidth, alItemHeight);
        
        self.verticalLine.frame = CGRectMake(CGRectGetMaxX(button0.frame), CGRectGetMinY(button0.frame), 1, alItemHeight);
        
    }else if (self.items.count == 2){
        
        UIButton *button0 = self.items[0];
        UIButton *button1 = self.items[1];
        
        button0.frame = CGRectMake(0, itemY, kAlertViewWidth/2.0-1, alItemHeight);
        button1.frame = CGRectMake(kAlertViewWidth/2.0+0.5, itemY, kAlertViewWidth/2.0-1, alItemHeight);
        
        self.verticalLine.frame = CGRectMake(CGRectGetMaxX(button0.frame), CGRectGetMinY(button0.frame), 1, alItemHeight);
        
    }else if (self.items.count == 1){
        
        UIButton *button0 = self.items[0];
        button0.frame = CGRectMake(0, itemY, kAlertViewWidth, alItemHeight);
    }
    
    // 约束content的高
    UIButton *button = [self.items lastObject];
    CGFloat contentViewHeight = self.items.count > 0 ? CGRectGetMaxY(button.frame) : CGRectGetMaxY(self.messageLabel.frame)+10;
    self.contentView.bounds = (CGRect){CGPointZero,CGSizeMake(kAlertViewWidth, contentViewHeight)};
}

#pragma mark
#pragma mark --- YBDAlertViewTypeControll ---
- (void)setupControll {
    // 标题
    if (self.title.length > 0) {
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:alTitleFont];
        titleLabel.text = self.title.length > 0 ? self.title : @"";;
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
    }
    
    if (self.message.length > 0) {
        
        // 提示语
        UILabel *messageLabel = [[UILabel alloc] init];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.numberOfLines = 0;
        messageLabel.font = [UIFont systemFontOfSize:alMessageFont];
        [self.contentView addSubview:messageLabel];
        self.messageLabel = messageLabel;
        
        NSString *serviceNumber = @"400-091-8080";
        NSRange serviceRange = [self.message rangeOfString:serviceNumber ];
        NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:self.message attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:alMessageFont],NSForegroundColorAttributeName:ybd_Color(aDarkTextColor)}];
        [message addAttribute:NSForegroundColorAttributeName value:ybd_Color(@"#EE376F") range:serviceRange];
        self.messageLabel.attributedText = message;
    }
    
    
    // line
    UILabel *horizontalLine = [[UILabel alloc] init];
    horizontalLine.backgroundColor = ybd_Color(aLineColor);
    [self.contentView addSubview:horizontalLine];
    self.horizontalLine = horizontalLine;
    
    UILabel *verticalLine = [[UILabel alloc] init];
    verticalLine.backgroundColor = ybd_Color(aLineColor);
    [self.contentView addSubview:verticalLine];
    self.verticalLine = verticalLine;
    
    if (self.itemTitles.count > 0) {
        
        // 按钮 限制最多三个按钮
        NSInteger itemCount = self.itemTitles.count > 3 ? 3 : self.itemTitles.count;
        for (NSInteger i = 0; i < itemCount; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = ybd_Color(aWhiteColor);
            button.titleLabel.font = [UIFont systemFontOfSize:alItemFont];
            [button setTitle:self.itemTitles[i] forState:UIControlStateNormal];
            [button setTitleColor:ybd_Color(aLightTextColor) forState:UIControlStateNormal];
            button.tag = i + 100;
            [button addTarget:self action:@selector(alertViewItemClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:button];
            
            // item数组
            [self.items addObject:button];
        }
    }
    
    [self layoutControll];
}

- (void)layoutControll {
    // 约束标题
    CGFloat titleHeight = [self.title boundingRectWithSize:CGSizeMake(kAlertViewWidth, 50) options:0 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:alTitleFont]} context:nil].size.height;
    self.titleLabel.frame = CGRectMake(0, 30, kAlertViewWidth, titleHeight);
    
    // 约束message
    CGFloat messageMaxW = kAlertViewWidth - 60;
    CGSize messageS = [self.messageLabel.attributedText boundingRectWithSize:CGSizeMake(messageMaxW, 100) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    CGFloat messageY = CGRectGetMaxY(self.titleLabel.frame) + 30;
    self.messageLabel.frame = CGRectMake((kAlertViewWidth - messageS.width)/2, messageY, messageS.width, messageS.height);
    
    // 约束按钮
    // 约束item的高
    CGFloat itemY = CGRectGetMaxY(self.messageLabel.frame) + 30;
    
    if (self.items.count == 3) {
        UIButton *button0 = self.items[0];
        UIButton *button1 = self.items[1];
        UIButton *button2 = self.items[2];
        
        CGFloat itemW = kAlertViewWidth / 3;
        CGFloat itemX = (kAlertViewWidth - itemW)/3;
        button0.frame = CGRectMake(itemX, itemY, itemW, alItemHeight);
        button1.frame = CGRectMake(CGRectGetMaxX(button0.frame)+itemX, itemY, itemW, alItemHeight);
        button2.frame = CGRectMake(itemX, CGRectGetMaxY(button0.frame), itemW*2+itemX, alItemHeight);
        
    }else if (self.items.count == 2){
        
        UIButton *button0 = self.items[0];
        UIButton *button1 = self.items[1];
        
        CGFloat itemW = kAlertViewWidth * 0.4;
        CGFloat itemX = (kAlertViewWidth - itemW*2)/3;
        button0.frame = CGRectMake(itemX, itemY, itemW, alItemHeight);
        button1.frame = CGRectMake(CGRectGetMaxX(button0.frame)+itemX, itemY, itemW, alItemHeight);
        
    }else if (self.items.count == 1){
        CGFloat itemW = kAlertViewWidth * 0.65;
        CGFloat itemX = (kAlertViewWidth - itemW)/2;
        
        UIButton *button0 = self.items[0];
        button0.frame = CGRectMake(itemX, itemY, itemW, alItemHeight);
    }
    
    // 切圆角
    [self.items enumerateObjectsUsingBlock:^(UIButton *  _Nonnull button, NSUInteger idx, BOOL * _Nonnull stop) {
        button.layer.cornerRadius = CGRectGetHeight(button.frame)/2;
        button.clipsToBounds = YES;
        CAGradientLayer *layer = [YBDAlertConstant ybd_layerGradualColor];
        layer.frame = button.bounds;
        [button.layer insertSublayer:layer atIndex:0];
        [button setTitleColor:ybd_Color(aWhiteColor) forState:UIControlStateNormal];
    }];
    
    
    // 约束content的高
    UIButton *button = [self.items lastObject];
    CGFloat contentViewHeight = self.items.count > 0 ? CGRectGetMaxY(button.frame) + 30 : CGRectGetMaxY(self.messageLabel.frame)+30;
    self.contentView.bounds = (CGRect){CGPointZero,CGSizeMake(kAlertViewWidth, contentViewHeight)};
}

#pragma mark
#pragma mark --- YBDAlertViewTypeImageNormal ---
- (void)setupImageNormal {
    
    // 顶部图片
    if (self.imageName.length > 0) {
        UIImageView *imageView = [UIImageView new];
        UIImage *image = [UIImage imageNamed:self.imageName];
        imageView.image = image;
        [self.contentView addSubview:imageView];
        self.imageView = imageView;
    }
    
    // 标题
    if (self.title.length > 0) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:20];
        titleLabel.text = self.title;
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
    }
    
    // 提示语
    if (self.message.length > 0) {
        UILabel *messageLabel = [[UILabel alloc] init];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.numberOfLines = 0;
        messageLabel.font = [UIFont systemFontOfSize:alMessageFont];
        messageLabel.textColor = ybd_Color(aDarkTextColor);
        messageLabel.text = self.message;
        [self.contentView addSubview:messageLabel];
        self.messageLabel = messageLabel;
    }
    
    [self layoutImageNormal];
}

- (void)layoutImageNormal {
    // 约束顶部图片
    UIImage *image = [UIImage imageNamed:self.imageName];
    CGFloat Y = -image.size.height/2;
    self.imageView.frame = CGRectMake((kAlertViewWidth-image.size.width)/2, Y, image.size.width, image.size.height);
    
    // 约束title
    CGFloat titleY = CGRectGetMaxY(self.imageView.frame)+30;
    self.titleLabel.frame = CGRectMake(0, titleY, kAlertViewWidth, 20);
    
    // 约束message
    CGFloat messageMaxW = kAlertViewWidth - 60;
    CGSize messageS = [self.messageLabel.text boundingRectWithSize:CGSizeMake(messageMaxW, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:alMessageFont]} context:nil].size;
    CGFloat messageY = CGRectGetMaxY(self.titleLabel.frame) + 20;
    self.messageLabel.frame = CGRectMake((kAlertViewWidth - messageS.width)/2, messageY, messageS.width, messageS.height);
    
    // 约束contentView
    CGFloat contentViewHeight = self.message.length > 0 ? CGRectGetMaxY(self.messageLabel.frame)+40 : CGRectGetMaxY(self.titleLabel.frame)+40;
    self.contentView.bounds = (CGRect){CGPointZero,CGSizeMake(kAlertViewWidth, contentViewHeight)};
}

#pragma mark
#pragma mark --- YBDAlertViewTypeImageClose ---
- (void)setupImageClose {
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
    [closeBtn setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateHighlighted];
    [closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:closeBtn];
    self.closeButton = closeBtn;
    
    // 顶部图片
    if (self.imageName.length > 0) {
        UIImageView *imageView = [UIImageView new];
        UIImage *image = [UIImage imageNamed:self.imageName];
        imageView.image = image;
        [self.contentView addSubview:imageView];
        self.imageView = imageView;
    }
    
    // 标题
    if (self.title.length > 0) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:20];
        titleLabel.text = self.title;
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
    }
    
    // 提示语
    if (self.message.length > 0) {
        UILabel *messageLabel = [[UILabel alloc] init];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.numberOfLines = 0;
        [self.contentView addSubview:messageLabel];
        self.messageLabel = messageLabel;
        
        NSRange range = [self.message rangeOfString:@"￥"];
        NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:@"[0-9,.￥]" options:0 error:nil];
        NSString *result = [regular stringByReplacingMatchesInString:self.message options:0 range:NSMakeRange(0, self.message.length) withTemplate:@""];
        NSInteger length = self.message.length - result.length;
        NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:self.message];
        
        if (length > 0) {
            [message addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:alTitleFont],NSForegroundColorAttributeName:ybd_Color(aDarkTextColor)} range:NSMakeRange(0, self.message.length)];
            [message addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:alItemFont],NSForegroundColorAttributeName:ybd_Color(@"#FD0033")} range:NSMakeRange(range.location, length)];
        }else {
            [message addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:alMessageFont],NSForegroundColorAttributeName:ybd_Color(aLightTextColor)} range:NSMakeRange(0, self.message.length)];
        }
        
        self.messageLabel.attributedText = message;
    }
    
    // 按钮 限制最多两个按钮
    if (self.itemTitles.count > 0) {
        NSInteger itemCount = self.itemTitles.count > 2 ? 2 : self.itemTitles.count;
        for (NSInteger i = 0; i < itemCount; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:self.itemTitles[i] forState:UIControlStateNormal];
            button.tag = i + 100;
            [button addTarget:self action:@selector(alertViewItemClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:button];
            
            // item数组
            [self.items addObject:button];
        }
    }
    
    // 约束视图
    [self layoutImageClose];
}

- (void)layoutImageClose {
    // 约束close
    CGFloat closeW = 40;
    self.closeButton.frame = CGRectMake(kAlertViewWidth-40, 0, closeW, closeW);
    
    // 约束顶部图片
    CGFloat Y = 20.0f;
    UIImage *image = [UIImage imageNamed:self.imageName];
    self.imageView.frame = CGRectMake((kAlertViewWidth-image.size.width)/2, Y, image.size.width, image.size.height);
    
    // 约束title
    CGFloat titleY = CGRectGetMaxY(self.imageView.frame)+20;
    self.titleLabel.frame = CGRectMake(0, titleY, kAlertViewWidth, 20);
    
    // 约束message
    CGFloat messageMaxW = kAlertViewWidth - 60;
    CGSize messageS = [self.messageLabel.attributedText boundingRectWithSize:CGSizeMake(messageMaxW, 100) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    CGFloat messageY = CGRectGetMaxY(self.titleLabel.frame) + 30;
    self.messageLabel.frame = CGRectMake((kAlertViewWidth - messageS.width)/2, messageY, messageS.width, messageS.height);
    
    // 约束按钮
    CGFloat itemY = CGRectGetMaxY(self.messageLabel.frame) + 30;
    if (self.items.count == 2){
        
        UIButton *button0 = self.items[0];
        UIButton *button1 = self.items[1];
        
        CGFloat itemW = kAlertViewWidth * 0.65;
        CGFloat itemX = (kAlertViewWidth - itemW)/2;
        button0.frame = CGRectMake(itemX, itemY, itemW, alItemHeight);
        [button0 setTitleColor:ybd_Color(aWhiteColor) forState:UIControlStateNormal];
        button0.titleLabel.font = [UIFont systemFontOfSize:alItemFont];
        
        CGSize sizeB = [button1.currentTitle boundingRectWithSize:CGSizeMake(kAlertViewWidth, 60) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:alMessageFont]} context:nil].size;
        button1.frame = CGRectMake((kAlertViewWidth-sizeB.width)/2, CGRectGetMaxY(button0.frame)+20, sizeB.width, sizeB.height);
        [button1 setTitleColor:ybd_Color(@"#6367f2") forState:UIControlStateNormal];
        button1.titleLabel.font = [UIFont systemFontOfSize:alMessageFont];
        
    }else if (self.items.count == 1){
        CGFloat itemW = kAlertViewWidth * 0.65;
        CGFloat itemX = (kAlertViewWidth - itemW)/2;
        
        UIButton *button0 = self.items[0];
        button0.frame = CGRectMake(itemX, itemY, itemW, alItemHeight);
        [button0 setTitleColor:ybd_Color(aWhiteColor) forState:UIControlStateNormal];
        button0.titleLabel.font = [UIFont systemFontOfSize:alItemFont];
    }
    
    // 切圆角
    [self.items enumerateObjectsUsingBlock:^(UIButton *  _Nonnull button, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            button.layer.cornerRadius = CGRectGetHeight(button.frame)/2;
            button.clipsToBounds = YES;
            CAGradientLayer *layer = [YBDAlertConstant ybd_layerGradualColor];
            layer.frame = button.bounds;
            [button.layer insertSublayer:layer atIndex:0];
            
            *stop = YES;
        }
    }];
    
    // 约束content的高
    UIButton *button = [self.items lastObject];
    CGFloat contentViewHeight = self.items.count > 0 ? CGRectGetMaxY(button.frame)+20 : CGRectGetMaxY(self.messageLabel.frame)+20;
    self.contentView.bounds = (CGRect){CGPointZero,CGSizeMake(kAlertViewWidth, contentViewHeight)};

}

#pragma mark
#pragma mark --- 计算size ---
- (CGFloat)getHeightWith:(NSString *)string font:(CGFloat)font{
    
    CGFloat height = 0.0;
    
    CGSize size = [string boundingRectWithSize:CGSizeMake(kAlertViewWidth-40, 300) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
    
    height = size.height;
    
    return height;
}

#pragma mark
#pragma mark --- show or dismiss ---
- (void)show{
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    // 如果alertView存在，就return出去
    if ([keyWindow viewWithTag:alTag]) return;
    
    self.backgroundView.alpha = 0.0f;
    self.contentView.alpha = 0.0f;
    [keyWindow addSubview:self];
    self.tag = alTag;
    
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
        [self removeFromSuperview];
    }];
}

#pragma mark
#pragma mark --- textView delegate ---
- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.placeholderLabel.text = @"";
}

#pragma mark
#pragma mark --- 设置回调 ---
- (void)setupAlertViewItemClickHandel:(YBDCustomAlertViewItemClickHandle)itemClickHandle{
    _clickHandle = itemClickHandle;
}

- (void)alertViewItemClick:(UIButton *)button{
    
    // 输入框消失、赋值
    if (self.type == YBDAlertViewTypeTextView) {
        
        [self.inputTextView endEditing:YES];
        self.inputText = self.inputTextView.text;
    }else if (self.type == YBDAlertViewTypeTextField) {
        
        [self.inputTextField endEditing:YES];
        self.inputText = self.inputTextField.text;
    }
    
    _clickHandle(self, button.tag, button.currentTitle);
    
    [self dismiss];
    
    YBDLog(@"title = %@",button.currentTitle);
}

- (void)closeBtnClick:(UIButton *)closeBtn {
    [self dismiss];
}

#pragma mark
#pragma mark --- lazy ---
- (UIView *)backgroundView{
    if (!_backgroundView) {
        UIView *view = [[UIView alloc] initWithFrame:(CGRect){CGPointZero,CGSizeMake(ybd_mainWidth, ybd_mainHeight)}];
        view.backgroundColor = ybd_AlphaColor(aBlackColor, 0.3f);
        [self addSubview:view];
        _backgroundView = view;
        
        UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [view addGestureRecognizer:tapG];
    }
    
    return _backgroundView;
}

- (UIView *)contentView{
    if (!_contentView) {
        UIView *view = [[UIView alloc] initWithFrame:(CGRect){CGPointZero,CGSizeMake(kAlertViewWidth, 200)}];
        view.center = self.center;
        view.backgroundColor = ybd_Color(aWhiteColor);
        view.layer.cornerRadius = aDefaultRadios;
//        [view setClipsToBounds:YES];
        [self addSubview:view];
        _contentView = view;
    }
    
    return _contentView;
}

- (NSMutableArray *)itemTitles{
    if (!_itemTitles) {
        _itemTitles = [NSMutableArray array];
    }
    return _itemTitles;
}

- (NSMutableArray *)items{
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}



@end
