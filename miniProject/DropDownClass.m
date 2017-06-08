//
//  DropDownClass.m
//  DropDownMenuDome
//
//  Created by Bc_Ltf on 15/1/19.
//  Copyright (c) 2015年 Bc_Ltf. All rights reserved.
//

#import "DropDownClass.h"

//获得屏幕frame
#define ScreenSize  [UIScreen mainScreen].applicationFrame

@interface DropDownClass()<UITableViewDataSource,UITableViewDelegate>

// 到底有几列？
@property (nonatomic,assign)NSInteger numOfMenu;
// 列头高度
@property (nonatomic, assign) CGFloat height;
// 判断是否展开  初始值是 NO 没展开
@property (nonatomic, assign) BOOL show;
// 背景
@property (nonatomic, strong) UIView *backGroundView;
// 判断是否是自己
@property (nonatomic,assign)NSInteger currentSelectedMenudIndex;
// 委托 筛选狂的情况
@property (nonatomic, strong) NSMutableArray* threeIndex;

@end

@implementation DropDownClass

@synthesize numOfMenu;
@synthesize currentSelectedMenudIndex;
@synthesize dataArray;
@synthesize CurrentArray;




#pragma mark- 初始化 ：原点+高
- (instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height andDataArray:(NSMutableArray *)data;
{
    // 位置信息
    _origin = origin;
    _show=NO;
    _height = height;
    
    // 填充数据
    dataArray=data;
    numOfMenu=[dataArray count];
    currentSelectedMenudIndex=-1;
    _threeIndex = [NSMutableArray arrayWithObjects:@(-1), @(-1), @(-1), nil];
        // 绘制栏目头的轮廓
        self=[self initWithFrame:CGRectMake(origin.x, origin.y, ScreenSize.size.width,height)];
        // 每个button的宽度
        CGFloat buttonInertval=self.frame.size.width/numOfMenu;
        // 根据列数创建button
        [self createButton:buttonInertval andHeight:height];
        // 创建tableview
        [self createTableView:origin];
        // 创建背景+添加弹回事件
        [self createBackgroud:origin];
        // 给menu添加底边
        [self createShadow];
    
    self.backgroundColor=[UIColor whiteColor];
    return self;
}

#pragma mark- 创建各种东东
/*------------------------------------------生成button-----------------------------------------*/
-(void)createButton:(CGFloat)buttonInertval andHeight:(CGFloat)height
{
    for (int i=0; i<numOfMenu; i++) {
        // 生了一个button 原点  宽  高
        UIButton *tmpButton = [[UIButton alloc] initWithFrame:CGRectMake(i*buttonInertval,0,buttonInertval,height)];
        // 这个小button 的字体是14
        tmpButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
        // 小button用的是正常状态
        [tmpButton setTitle:[[dataArray objectAtIndex:i] objectAtIndex:0] forState:UIControlStateNormal];
        //         小button 用了一个叫做扩展的 图片作为正常状态的图片
        [tmpButton setImage:[UIImage imageNamed:@"expandableImage"] forState:UIControlStateNormal];
        // 图片插在了这里 edge :边缘 优势
        // 设置button中文字和图片
        tmpButton.titleEdgeInsets=UIEdgeInsetsMake(0,0,0,0);
        tmpButton.imageEdgeInsets = UIEdgeInsetsMake(0, buttonInertval*7/8, 0, 0);
        // 小button 使用黑色的字体做题目
        [tmpButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        // 添加点击事件
        [tmpButton addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        // tag 默认值是0
        tmpButton.tag=i+1;
        [self addSubview:tmpButton];
    }
}

/*----------------------------------------添加tableview-----------------------------------------*/

-(void)createTableView:(CGPoint)origin
{
    //左栏
    _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(origin.x, self.frame.origin.y + self.frame.size.height, ScreenSize.size.width*0.7, 0) style:UITableViewStylePlain];
    _leftTableView.rowHeight = 38;
    _leftTableView.dataSource = self;
    _leftTableView.delegate = self;
    
    
    //右栏
    _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(origin.x+ScreenSize.size.width*0.7, self.frame.origin.y + self.frame.size.height, ScreenSize.size.width*0.3, 0) style:UITableViewStylePlain];
    _rightTableView.rowHeight = 38;
    _rightTableView.dataSource = self;
    _rightTableView.delegate = self;
    _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _rightTableView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.f];
}


/*------------------------------------------背景-----------------------------------------*/
-(void)createBackgroud:(CGPoint)origin
{
    _backGroundView = [[UIView alloc] initWithFrame:CGRectMake(origin.x, origin.y, ScreenSize.size.width, ScreenSize.size.height)];
    
    // 解释一下昂：grayscale ：灰度  specified：规定制定  opacity：不透明的
    // white：The grayscale value of the color object, specified as a value from 0.0 to 1.0.
    // The opacity value of the color object, specified as a value from 0.0 to 1.0.
    _backGroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
    // opaque  不透明
    _backGroundView.opaque = NO;
    // target action 模式
    UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
    [_backGroundView addGestureRecognizer:gesture];
}

/*------------------------------------------给menu划线-----------------------------------------*/
-(void)createShadow
{
    //add bottom shadow  这是一条线
    UIView *bottomShadow = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-0.5, ScreenSize.size.width, 0.5)];
    bottomShadow.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:bottomShadow];
    self.backgroundColor=[UIColor whiteColor];
}


#pragma mark- press

/*------------------------------------------逻辑没搞清-----------------------------------------*/
//点击第一栏
//currentSelectedMenudIndex-1是menu的index
-(void)btnPressed:(id)sender
{
    UIButton *a=sender;
    currentSelectedMenudIndex=a.tag;
    CurrentArray=[[[dataArray objectAtIndex:currentSelectedMenudIndex-1] objectAtIndex:2] objectAtIndex:0];

    if (_show==0) {
        // 关闭所有
        for (NSInteger i=1; i<=numOfMenu;i++) {
            UIButton *tmpbutton=(UIButton*)[self viewWithTag:i];
            tmpbutton.imageView.transform=CGAffineTransformMakeRotation(0);
        }
        // 旋转图片
        a.imageView.transform=CGAffineTransformMakeRotation(M_PI);
        
        // Selects a row in the receiver identified by index path, optionally scrolling the row to a location in the receiver.
        // 以索引路径为标志选中接受者中的一行，可以选择滚动这一行到接受者的一个位置
        
        // animated :YES if you want to animate the selection and any change in position, NO if the change should be immediate.
        // 激活：如果你像激活选中单元，并且选择任意位置，那么可以选择是，不是，就是不激活
        NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.rightTableView selectRowAtIndexPath:selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }else{
        // 全部关上
        for (NSInteger i=1; i<=numOfMenu;i++) {
            UIButton *tmpbutton=(UIButton*)[self viewWithTag:i];
            tmpbutton.imageView.transform=CGAffineTransformMakeRotation(0);
        }
    }
    [self animateBackGroundView:self.backGroundView show:!_show complete:^{
        [self animateTableViewShow:!_show complete:^{
            
            [self tableView:self.rightTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            _show=!_show;
        }];
    }];
    [_rightTableView reloadData];
}

#pragma mark- animation method
/*---------------------------------展示和收回-------------------------------------*/
// 激活背景视图：（某视图） 展示吗：（是否）
- (void)animateBackGroundView:(UIView *)view show:(BOOL)show complete:(void(^)())complete {
    if (show) {
        
        //我——你（背景）——他（原图）
        [self.superview addSubview:view];
        [view.superview addSubview:self];
        
        [UIView animateWithDuration:0.2 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
        }];
    
    } else {
        // 消失动画  干掉背景
        [UIView animateWithDuration:0.2 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }
    complete();
}

- (void)animateTableViewShow:(BOOL)show complete:(void(^)())complete {
    if(show)
    {
        // 左边占了七分天下
        _leftTableView.frame = CGRectMake(self.origin.x, self.frame.origin.y+_height, ScreenSize.size.width*0.7, 0);
        [self.superview addSubview:_leftTableView];
        
        // 右边有三分
        _rightTableView.frame = CGRectMake(self.origin.x+ScreenSize.size.width*0.7, self.frame.origin.y+_height,ScreenSize.size.width*0.3, 0);
        [self.superview addSubview:_rightTableView];
        _leftTableView.alpha = 1.f;
        _rightTableView.alpha = 1.f;
        [UIView animateWithDuration:0.2 animations:^{
            _leftTableView.frame = CGRectMake(self.origin.x, self.frame.origin.y+_height, ScreenSize.size.width*0.7, ScreenSize.size.height/3);
            _rightTableView.frame = CGRectMake(self.origin.x+ScreenSize.size.width*0.7, self.frame.origin.y+_height, ScreenSize.size.width*0.3, ScreenSize.size.height/3);
        } completion:^(BOOL finished) {
        }];
    }else
    {
        [UIView animateWithDuration:0.2 animations:^{
                        _leftTableView.alpha = 0.f;
                        _rightTableView.alpha = 0.f;
                    } completion:^(BOOL finished) {
                        [_leftTableView removeFromSuperview];
                        [_rightTableView removeFromSuperview];
                    }];
        
    }complete();

}

// 点击背景 显示动画
- (void)backgroundTapped:(UITapGestureRecognizer *)paramSender
{
    // 点击背景还能干啥呢？关闭呗
    
    [self animateBackGroundView:_backGroundView show:!_show complete:^{
        [self animateTableViewShow:!_show complete:^{
             _show=!_show;
        }];
    }];
}

#pragma mark - table datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return [self menu:self tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"DropDownMenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }

    cell.textLabel.text = [self menu:self tableView:tableView titleForRowAtIndexPath:indexPath];

    if(tableView == _leftTableView){
        cell.backgroundColor = [UIColor whiteColor];
    }else{
        UIView *sView = [[UIView alloc] init];
        sView.backgroundColor = [UIColor whiteColor];
        cell.selectedBackgroundView = sView;
        
//    setSelected:animated:  设置选中项 ：激活
//        Sets the selected state of the cell, optionally animating the transition between states.
// 设置cell的选择状态，可以选择过度状态之间的动画
        [cell setSelected:YES animated:YES];
        cell.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.f];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.separatorInset = UIEdgeInsetsZero;
    return cell;
}


#pragma mark - tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //一级目录及三级目录
        if (tableView == self.leftTableView) {
            [self animateBackGroundView:_backGroundView show:NO complete:^{
                [self animateTableViewShow:NO complete:^{
            
                    /*-----------------------------更改表头显示------------------------------*/
                    
                    UIButton *changeButton=(UIButton*)[self viewWithTag:currentSelectedMenudIndex];
                    UITableViewCell *tmpcell=[tableView cellForRowAtIndexPath:indexPath];
                    NSString *tmpString=tmpcell.textLabel.text;
                    [changeButton setTitle:tmpString forState:UIControlStateNormal];
                    _show =!_show;
                    //设置委托
                    self.threeIndex[0] = @(currentSelectedMenudIndex-1);
                    self.threeIndex[2] = @(indexPath.row);
                    if([_delegate respondsToSelector:@selector(send:)])
                    {
                        [_delegate send:self.threeIndex];
                    }
                }];
            }];
        }
    
    [self menu:self tableView:tableView didSelectRowAtIndexPath:indexPath andCurrent:currentSelectedMenudIndex-1];
    
}


#pragma mark- 处理数据
- (NSInteger)menu:(DropDownClass *)menu tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section;
{
    if (tableView == menu.rightTableView) {
        return [[[dataArray objectAtIndex:currentSelectedMenudIndex-1] objectAtIndex:1] count];
    }else{
        return [CurrentArray count];
    }
}

- (NSString *)menu:(DropDownClass *)menu tableView:(UITableView*)tableView titleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==menu.rightTableView)
    {
//        return cityArr[indexPath.row];
        return [[[dataArray objectAtIndex:currentSelectedMenudIndex-1]objectAtIndex:1] objectAtIndex:indexPath.row];
    }else{
        return [CurrentArray objectAtIndex:indexPath.row];
    }
}
/*--------------------------------点击右栏展示（刷新）左栏-----------------------------------*/
- (void)menu:(DropDownClass *)menu tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath andCurrent:(NSInteger)culm
{
    if(tableView == menu.rightTableView){
        //二级目录
        menu.CurrentArray=[[[menu.dataArray objectAtIndex:culm] objectAtIndex:2]objectAtIndex:indexPath.row];
        [menu.leftTableView reloadData];
        self.threeIndex[1] = @(indexPath.row);
    }
}

-(NSMutableArray*)getData
{
    NSMutableArray *tmpArray=[NSMutableArray new];
    
    for (int i=1; i<=currentSelectedMenudIndex; i++) {
        UIButton *tmpbutton=(UIButton*)[self viewWithTag:i];
        NSString *tmpString=tmpbutton.titleLabel.text;
        [tmpArray addObject:tmpString];
    }
    return tmpArray;
}

@end
