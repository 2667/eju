//
//  Path.m
//  miniProject
//
//  Created by zhoujingjin on 2017/5/7.
//  Copyright © 2017年 zhoujingjin. All rights reserved.
//

#import "Path.h"

@implementation Path




// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    //    [[UIColor grayColor] setStroke];
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    // 添加路径[1条点(100,100)到点(200,100)的线段]到path
    [path1 moveToPoint:CGPointMake(80 , 421)]; //80,294,430
    [path1 addLineToPoint:CGPointMake(294,421)];
    //    path1.lineWidth = 5.0;
    
    // 将path绘制出来
    [path1 stroke];
     self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
    
    //    UIBezierPath *path2 = [UIBezierPath bezierPath];
    //    // 添加路径[1条点(100,100)到点(200,100)的线段]到path
    //    path2.lineWidth = 5.0;
    //    [path2 moveToPoint:CGPointMake(80 , 481)];
    //    [path2 addLineToPoint:CGPointMake(294,481)];
    //    // 将path绘制出来
    //    [path2 stroke];
}


@end
