//
//  YBDAngleView.m
//  YBDAlertController
//
//  Created by Jadyn on 2018/1/18.
//  Copyright © 2018年 Jadyn. All rights reserved.
//

#import "YBDAngleView.h"

@implementation YBDAngleView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    [self drawAngle];
}

- (void)drawAngle {
    
    CGFloat angleX = CGRectGetWidth(self.frame);
    CGFloat angleY = CGRectGetHeight(self.frame);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(angleX/2, 0)];
    [path addLineToPoint:CGPointMake(0, angleY)];
    [path addLineToPoint:CGPointMake(angleX, angleY)];
    
    path.lineWidth = 0;
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    
    UIColor *fillColor = [UIColor whiteColor];
    [fillColor set];
    [path fill];
    
    [path stroke];
}

@end
