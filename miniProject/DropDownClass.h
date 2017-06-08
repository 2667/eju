//
//  DropDownClass.h
//  DropDownMenuDome
//
//  Created by Bc_Ltf on 15/1/19.
//  Copyright (c) 2015年 Bc_Ltf. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DropDownClassProtocol <NSObject>

- (void) send: (NSMutableArray *) threeIndex;

@end

@interface DropDownClass : UIView<UITableViewDataSource,UITableViewDelegate>



// 绘制下啦栏 题头  ：原点+高度
- (instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height andDataArray:(NSMutableArray *)data;
-(NSMutableArray*)getData;


@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *rightTableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
// 当前左栏展示数据
@property (nonatomic,assign)NSArray *CurrentArray;
@property (nonatomic, weak) id<DropDownClassProtocol> delegate;

@end
