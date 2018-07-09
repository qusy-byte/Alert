//
//  YBDSelectView.m
//  YBDAlertController
//
//  Created by Jadyn on 2018/1/17.
//  Copyright © 2018年 Jadyn. All rights reserved.
//

#import "YBDSelectView.h"
#import "YBDAngleView.h"
#import "YBDAlertConstant.h"

@interface YBDSelectView () <UITableViewDelegate, UITableViewDataSource>

/**
 backgroundView
 */
@property (nonatomic,weak) UIView *backgroundView;

/**
 contentView
 */
@property (nonatomic,weak) UIView *contentView;

/**
 tableView
 */
@property (nonatomic,weak) UITableView *selectTable;

/**
 上方三角形
 */
@property (nonatomic,weak) UIView *angleView;

/**
 icons
 */
@property (nonatomic,strong) NSArray *icons;

/**
 titles
 */
@property (nonatomic,strong) NSArray *titles;

/**
 列表行数
 */
@property (nonatomic,assign) NSInteger count;

@end

@implementation YBDSelectView {
    YBDSelectTableViewItemClickHandle _itemClickHandle;
}

#pragma mark
#pragma mark --- QSYSelectTableView方法 ---
+ (instancetype)selectTableViewWithIcon:(NSArray *)icons title:(NSArray *)titles {
    
    YBDSelectView *selectView = [[YBDSelectView alloc] initWithFrame:(CGRect){CGPointZero,CGSizeMake(ybd_mainWidth, ybd_mainHeight)}];
    selectView.icons = icons;
    selectView.titles = titles;
    
    if (!icons && titles) {
        selectView.count = titles.count;
    }else if (icons && !titles) {
        selectView.count = icons.count;
    }else if (icons && titles) {
        selectView.count = icons.count < titles.count ? icons.count : titles.count;
    }
    
    // 添加item
    [selectView contentView];
    [selectView selectTable];
    //    [selectView angleView];
    
    return selectView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self backgroundView];
    }
    
    return self;
}

- (void)show {
    
    // 如果存在，就返回
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if ([keyWindow viewWithTag:asTag]) return;
    
    self.backgroundView.alpha = 0.0f;
    self.contentView.alpha = 0.0f;
    self.contentView.frame = (CGRect){ self.origin, CGSizeMake(asWidth, asItemHeight * self.count + 10)};
    self.contentView.layer.affineTransform = CGAffineTransformMakeScale(0.1, 0.1);
    self.contentView.layer.anchorPoint = CGPointMake(1.0, 0.0);
    self.contentView.layer.position = CGPointMake(self.origin.x+asWidth, self.origin.y);
    [keyWindow addSubview:self];
    self.tag = asTag;
    
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        self.backgroundView.alpha = 1.0f;
        self.contentView.alpha = 1.0f;
        self.contentView.layer.affineTransform = CGAffineTransformMakeScale(1.0, 1.0);
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss {
    
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        self.backgroundView.alpha = 0.0f;
        self.contentView.alpha = 0.0f;
        self.contentView.layer.affineTransform = CGAffineTransformMakeScale(0.1, 0.1);
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

- (void)setSelectTableViewItemClickHandle:(YBDSelectTableViewItemClickHandle)handle {
    _itemClickHandle = handle;
}

#pragma mark
#pragma mark --- tableView delegate && dataSource ---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return asItemHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"QSYSelctViewCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.icons) {
        cell.imageView.image = [UIImage imageNamed:self.icons[indexPath.row]];
    }
    if (self.titles) {
        cell.textLabel.text = self.titles[indexPath.row];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    _itemClickHandle(self, indexPath.row, self.titles[indexPath.row]);
    [self dismiss];
    
    YBDLog(@"title = %@",self.titles[indexPath.row]);
}

#pragma mark
#pragma mark --- lazy ---
- (UIView *)backgroundView{
    
    if (!_backgroundView) {
        UIView *view = [[UIView alloc] initWithFrame:(CGRect){CGPointZero,CGSizeMake(ybd_mainWidth, ybd_mainHeight)}];
        view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3f];
        [self addSubview:view];
        _backgroundView = view;
        
        UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [view addGestureRecognizer:tapG];
    }
    
    return _backgroundView;
}

- (UIView *)contentView{
    
    if (!_contentView) {
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, asWidth, asItemHeight * self.count + 10)];
        contentView.backgroundColor = [UIColor clearColor];
        contentView.clipsToBounds = YES;
        
        [self addSubview:contentView];
        _contentView = contentView;
        
        YBDAngleView *angleView = [[YBDAngleView alloc] initWithFrame:CGRectMake(asWidth-30, 0, 20, 10)];
        [contentView addSubview:angleView];
    }
    
    return _contentView;
}

- (UITableView *)selectTable{
    
    if (!_selectTable) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:(CGRect){CGPointMake(0, 10),CGSizeMake(asWidth, CGRectGetHeight(self.contentView.frame) - 10)} style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.layer.cornerRadius = 5;
        tableView.separatorInset = UIEdgeInsetsZero;
        tableView.scrollEnabled = NO;
        [self.contentView addSubview:tableView];
        _selectTable = tableView;
    }
    
    return _selectTable;
}

@end
