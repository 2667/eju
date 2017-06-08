//
//  SecondViewController.m
//  miniProject
//
//  Created by zhoujingjin on 2017/4/26.
//  Copyright © 2017年 zhoujingjin. All rights reserved.
//

#import "SecondViewController.h"
#import "WebViewController.h"
#import "AFNetworking.h"
#import "PersonCell.h"
#import "PersonModel.h"


extern PersonModel *my;

#if TESTPORT
NSString *const userListPrefix = @"http://122.152.200.61:9002/user-list";
NSString *const userDetailPreifx = @"http://122.152.200.61:9002/user-info?uId=";
#else
NSString *const userListPrefix = @"http://122.152.200.88:12521/user-list";
NSString *const userDetailPreifx = @"http://122.152.200.88:12521/user-info?uId=";
#endif


@interface SecondViewController ()
{
    ConditionDoubleTableView *tableView;
    NSArray *_titleArray;
    NSArray *_leftArray;
    NSArray *_rightArray;

}

@property (nonatomic, strong) NSMutableArray *personArray;
@property (nonatomic, strong) NSMutableDictionary *dict4query;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"找室友";
    
    //afnetworking
    _manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [[AFJSONResponseSerializer alloc] init];
    self.manager.requestSerializer = [[AFJSONRequestSerializer alloc] init];
    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
    //设置cookie
    [self.manager.requestSerializer setValue:@"Cookie" forHTTPHeaderField:my.token];


    _dict4query = [[NSMutableDictionary alloc] init];
    _personArray = [[NSMutableArray alloc] init];
    //初始化页面，不含筛选项的
    [self getInitData];
    //定义tableView
    CGFloat space = 40;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, space, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self initDropDown];
    
    [self setupRefresh];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) getInitData
{
    [self getQueryData:nil];
}

-(void) getQueryData:(NSDictionary *) dict{
    //异步方式获得初始数据
    [self.personArray removeAllObjects];
    [self.manager.requestSerializer setValue:@"Cookie" forHTTPHeaderField:my.token];
    [self.manager GET:userListPrefix parameters:dict progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        NSArray *data = responseObject[@"retData"];
        for(int i = 0; i < [responseObject[@"retData"] count]; ++i){
            PersonModel *tmp = [[PersonModel alloc] init];
            tmp.uId = data[i][@"uId"];
            tmp.name = data[i][@"name"];
            tmp.department = data[i][@"department"];
            tmp.desp = data[i][@"description"];
            tmp.head = data[i][@"head"];
            //TODO
            tmp.gender = data[i][@"gender"] == nil ? @"0" : data[i][@"gender"];
       
            self.personArray[i] = tmp;
        }
        
        [self.tableView reloadData]; //更新UI
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
    }];

}

-(void) setPersonArray:(NSMutableArray *)personArray
{
    _personArray = personArray;
    if(self.view.window)
    {
        [self.tableView reloadData];
    }
}

#pragma mark - tableView Protocol
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.personArray.count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellString_ = @"tableCell";
    PersonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString_];
    if(cell == nil)
    {
        cell = [[PersonCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellString_];
    }
    cell.imageView.layer.cornerRadius = cell.imageView.frame.size.width * 0.5;
    cell.imageView.clipsToBounds = true;
    cell.imageView.layer.borderWidth = 1.5f;//宽度
    cell.imageView.layer.borderColor = [UIColor grayColor].CGColor;//颜色
    
    [cell config:self.personArray[indexPath.row]];
   
    return cell;
}

//选择表格某一行，页面进行跳转
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

    PersonModel *tmp = (PersonModel *) self.personArray[indexPath.row];
    
    WebViewController *webVC = [[WebViewController alloc] init];
    
    webVC.URL = [NSString stringWithFormat:@"%@%@", userDetailPreifx, tmp.uId];
    
    [self.navigationController pushViewController:webVC animated:YES];

    
}

//行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}


//TODO
- (void) send:(NSMutableArray *)threeIndex
{

}

#pragma mark - pull down refreshing
-(void)setupRefresh
{
    //1.添加刷新控件
    UIRefreshControl *control=[[UIRefreshControl alloc]init];
    [control addTarget:self action:@selector(refreshStateChange:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:control];
    
    //2.马上进入刷新状态，并不会触发UIControlEventValueChanged事件
    [control beginRefreshing];
    
    // 3.加载数据
    [self refreshStateChange:control];
}

/**
 *  UIRefreshControl进入刷新状态：加载最新的数据
 */
-(void)refreshStateChange:(UIRefreshControl *)control
{
    //TODO
    //异步方式获得初始数据
    [self.personArray removeAllObjects];
    [self.manager.requestSerializer setValue:@"Cookie" forHTTPHeaderField:my.token];
    [self.manager GET:userListPrefix parameters:self.dict4query progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        NSArray *data = responseObject[@"retData"];
        for(int i = 0; i < [responseObject[@"retData"] count]; ++i){
            PersonModel *tmp = [[PersonModel alloc] init];
            tmp.uId = data[i][@"uId"];
            tmp.name = data[i][@"name"];
            tmp.department = data[i][@"department"];
            tmp.desp = data[i][@"description"];
            tmp.head = data[i][@"head"];
            //TODO
            tmp.gender = data[i][@"gender"] == nil ? @"0" : data[i][@"gender"];
            
            self.personArray[i] = tmp;
        }
        
        [self.tableView reloadData]; //更新UI
        [control endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
        [control endRefreshing];
    }];

    
}
#pragma DropDown
- (void) initDropDown
{
    //一级菜单
    _titleArray = @[@"性别", @"部门"];
    
    //二级菜单 -> 左栏为空
    NSArray *One_leftArray = @[];
    NSArray *Two_leftArray = @[];
    _leftArray = [[NSArray alloc] initWithObjects:One_leftArray, Two_leftArray, nil];
    
    //三级菜单 -> 右栏
    NSArray *F_rightArray = @[
                              @[
                                  @{@"title":@"不限"},
                                  @{@"title":@"男"},
                                  @{@"title":@"女"},
                                  ] ,
                              ];
    
    NSArray *S_rightArray = @[
                              @[
                                  @{@"title":@"不限"},
                                  @{@"title":@"SNG"},
                                  @{@"title":@"CDG"},
                                  ] ,
                              ];
    _rightArray = [[NSArray alloc] initWithObjects:F_rightArray, S_rightArray, nil];
    
    DropdownMenu *dropdown = [[DropdownMenu alloc] initDropdownWithButtonTitles:_titleArray andLeftListArray:_leftArray andRightListArray:_rightArray];
    dropdown.delegate = self;   //此句的代理方法可返回选中下标值
    [self.view addSubview:dropdown.view];


}

//TODO
//实现代理，返回选中的下标，若左边没有列表，则返回0
- (void)dropdownSelectedButtonIndex:(NSString *)index LeftIndex:(NSString *)left RightIndex:(NSString *)right {
    NSLog(@"%s : You choice button %@, left %@ and right %@", __FUNCTION__, index, left, right);
    if([index isEqualToString:@"0"])
    {
        if([right isEqualToString:@"0"])
            {
                [self.dict4query removeObjectForKey:@"gender"];
            }
        else
        {
            self.dict4query[@"gender"] = [NSString  stringWithFormat:@"%ld", [right integerValue]-1];
        }
        
    } else
    {
        //部门
        if([right isEqualToString:@"0"])
        {
            [self.dict4query removeObjectForKey:@"department"];
            
        } else
        {
            NSArray *tmp = (NSArray *)[_rightArray objectAtIndex:1][0];
            NSDictionary *tmp2 = [tmp objectAtIndex:[right integerValue]];
            self.dict4query[@"department"] = tmp2[@"title"];
            NSLog(@"选择的部门:%@", self.dict4query[@"department"]);
        }
    }
    [self getQueryData:self.dict4query];

}


@end
