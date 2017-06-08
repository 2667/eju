//
//  FirstViewController.m
//  miniProject
//
//  Created by zhoujingjin on 2017/4/26.
//  Copyright © 2017年 zhoujingjin. All rights reserved.
//

#import "FirstViewController.h"
#import "WebViewController.h"
#import "HouseCell.h"
#import "HouseModel.h"
#import "AFNetworking.h"
#import "HousePublishViewController.h"
#import "PersonModel.h"

extern PersonModel *my;

#define TESTPORT 0

#if TESTPORT
NSString *const houseListPrefix = @"http://122.152.200.61:9002/house-list";
NSString *const houseDetailPrefix = @"http://122.152.200.61:9002/house-detail?hId=";
NSString *const cityInfo = @"http://122.152.200.61:9002/city-info";

#else

NSString *const houseListPrefix = @"http://122.152.200.88:12521/house-list";
NSString *const houseDetailPrefix = @"http://122.152.200.88:12521/house-detail?hId=";
NSString *const cityInfo = @"http://122.152.200.88:12521/city-info";


#endif

@interface FirstViewController ()
{
    ConditionDoubleTableView *tableView;
    NSArray *_titleArray;
    NSArray *_leftArray;
    NSArray *_rightArray;
    NSArray *money;
    
}

@property (nonatomic, strong) NSMutableArray * houseArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) NSMutableDictionary *dict4query;
@property (nonatomic, strong) TMFloatingButton *floatingModeEditButton;



@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"房源";
    
    
    self.tabBarController.tabBar.tintColor = [UIColor colorWithRed:0.953 green:0.647 blue:0.212 alpha:1.0];
    
    self.houseArray = [[NSMutableArray alloc] init]; //存储的是同一个对象
    
    _dict4query = [[NSMutableDictionary alloc] init];
    
    //afnetworking
    _manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [[AFJSONResponseSerializer alloc] init];
    self.manager.requestSerializer = [[AFJSONRequestSerializer alloc] init];
    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
    //设置cookie
    [self.manager.requestSerializer setValue:@"Cookie" forHTTPHeaderField:my.token];
    
    
    [self getNewDataFromNetwork:nil];
    
    
    //定义tableView
    CGFloat space = 40;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, space, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    //悬浮按钮发布房源
    _floatingModeEditButton = [[TMFloatingButton alloc] initWithSuperView: self.view];
    [TMFloatingButton addModeEditStyleToButton:self.floatingModeEditButton];
    [self.floatingModeEditButton addTarget:self action:@selector(modeEditAction) forControlEvents:UIControlEventTouchUpInside];
    
    //下拉刷新
    [self setupRefresh];
    
    //加载下拉单
    [self initDropDown];
    
    //设置筛选参数
    money = @[@"1, 99999999", @"0,1000", @"1000,1500", @"1500,2000", @"2000,3000", @"3000,5000", @"5000, 9999999"];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.tabBarController.tabBar.hidden=NO;
}

-(void) setHouseArray:(NSMutableArray *)houseArray
{
    _houseArray = houseArray;
    if(self.view.window)
    {
        [self.tableView reloadData]; // 更新table view
    }
}

- (void) getNewDataFromNetwork:(NSDictionary *) dict
{
    //异步方式获得初始数据
    [self.houseArray removeAllObjects];
    [self.manager GET:houseListPrefix parameters:dict progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        for(int i = 0; i < [responseObject[@"retData"] count]; ++i){
            HouseModel *houseTmp = [[HouseModel alloc] init];
            houseTmp.houseTitle = [NSString stringWithFormat:@"%@", responseObject[@"retData"][i][@"name"]];
            houseTmp.bedNum = responseObject[@"retData"][i][@"bedNum"];
            houseTmp.liveNum = responseObject[@"retData"][i][@"liveNum"];
            houseTmp.floor = responseObject[@"retData"][i][@"floor"];
            houseTmp.orientation = responseObject[@"retData"][i][@"orientation"];
            houseTmp.subway = responseObject[@"retData"][i][@"subway"];
            houseTmp.price = responseObject[@"retData"][i][@"price"];
            houseTmp.imagePath = responseObject[@"retData"][i][@"surfaceImage"];
            houseTmp.hId = responseObject[@"retData"][i][@"hId"];
            
            self.houseArray[i] = houseTmp;
        }
        
        [self.tableView reloadData]; //更新UI
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void) initDropDown
{
    //获取城市list
//    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [self.manager GET:cityInfo parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        //一级菜单
        _titleArray = @[@"地区", @"合租/整租", @"租金"];
        
        //二级菜单 -> 左栏为空
        NSArray *One_leftArray = @[@"上海", @"广州", @"北京", @"深圳", @"成都"];
        NSArray *Two_leftArray = @[];
        NSArray *Three_leftArray = @[];
        _leftArray = [[NSArray alloc] initWithObjects:One_leftArray, Two_leftArray, Three_leftArray, nil];
        
        NSMutableArray *F_rightArray = [[NSMutableArray alloc] init];
        
        NSArray *retData = responseObject[@"retData"];
        for(int i = 0; i < [retData count]; ++i)
        {
            NSDictionary *tmpCity = (NSDictionary *) retData[i];
            NSArray *tmpRegion = (NSArray *) tmpCity[@"region"];
            NSMutableArray* tmp = [[NSMutableArray alloc] init];
            for(int j = 0; j < [tmpRegion count]; ++j)
            {
                [tmp addObject:@{@"title":tmpRegion[j]}];
            }
            [F_rightArray addObject:tmp];
        }
        NSArray *S_rightArray = @[
                                  @[
                                      @{@"title":@"不限"},
                                      @{@"title":@"合租"},
                                      @{@"title":@"整租"},
                                      
                                      ] ,
                                  ];
        NSArray *L_rightArray = @[
                                  @[
                                      @{@"title":@"不限"},
                                      @{@"title":@"1000以内"},
                                      @{@"title":@"1000-1500"},
                                      @{@"title":@"1500-2000"},
                                      @{@"title":@"2000-3000"},
                                      @{@"title":@"3000-5000"},
                                      @{@"title":@"5000以上"},
                                      
                                      ] ,
                                  ];
        
        
        _rightArray = [[NSArray alloc] initWithObjects:F_rightArray, S_rightArray, L_rightArray, nil];
        
        DropdownMenu *dropdown = [[DropdownMenu alloc] initDropdownWithButtonTitles:_titleArray andLeftListArray:_leftArray andRightListArray:_rightArray];
        dropdown.delegate = self;   //此句的代理方法可返回选中下标值
        [self.view addSubview:dropdown.view];

        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"Error: %@", error);
    
    }];
    
   
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate And UITableViewDataSource
//行的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.houseArray.count;
}

//行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

//加载表格内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellString_=@"tableCell";
    
    HouseCell *cell=[tableView dequeueReusableCellWithIdentifier:cellString_];
    
    if (cell==nil) {
        cell=[[HouseCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellString_];
    }
    [cell config:self.houseArray[indexPath.row]];
    
    
    return cell;
}


//选择表格某一行，页面进行跳转
//TODO
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WebViewController *webViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"webStoryBoard"];
    HouseModel *tmp = (HouseModel *) self.houseArray[indexPath.row];
    webViewController.URL = [NSString stringWithFormat:@"%@%@", houseDetailPrefix, tmp.hId];
    
//    self.tabBarController.tabBar.hidden=YES;
    
    [self.navigationController pushViewController:webViewController animated:YES];
    webViewController = nil; // ?
    
}
#pragma mark - Floating Button
//按下悬浮按钮发布房源 跳转
-(void) modeEditAction
{
    
    HousePublishViewController *housePublishViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"houseStoryBoard"];
    [self.navigationController pushViewController:housePublishViewController animated:YES];
    housePublishViewController = nil;
    
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
    
    //异步方式获得初始数据
//    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [self.manager GET:houseListPrefix parameters:self.dict4query progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        for(int i = 0; i < [responseObject[@"retData"] count]; ++i){
            HouseModel *houseTmp = [[HouseModel alloc] init];
            houseTmp.houseTitle = [NSString stringWithFormat:@"%@", responseObject[@"retData"][i][@"name"]];
            houseTmp.bedNum = responseObject[@"retData"][i][@"bedNum"];
            houseTmp.liveNum = responseObject[@"retData"][i][@"liveNum"];
            houseTmp.floor = responseObject[@"retData"][i][@"floor"];
            houseTmp.orientation = responseObject[@"retData"][i][@"orientation"];
            houseTmp.subway = responseObject[@"retData"][i][@"subway"];
            houseTmp.price = responseObject[@"retData"][i][@"price"];
            houseTmp.imagePath = responseObject[@"retData"][i][@"surfaceImage"];
            houseTmp.hId = responseObject[@"retData"][i][@"hId"];
            
            self.houseArray[i] = houseTmp;
        }
        
        [self.tableView reloadData]; //更新UI
        [control endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
        [control endRefreshing];
    }];
    
}

//TODO
//实现代理，返回选中的下标，若左边没有列表，则返回0
- (void)dropdownSelectedButtonIndex:(NSString *)index LeftIndex:(NSString *)left RightIndex:(NSString *)right {
    NSLog(@"%s : You choice button %@, left %@ and right %@", __FUNCTION__, index, left, right);
    if([index isEqualToString:@"2"])
    {
        //price
        if([right isEqualToString:@"0"])
        {
            [self.dict4query removeObjectForKey:@"price"];
        } else
        {
            self.dict4query[@"price"] = [money objectAtIndex:[right integerValue]];
        }
    } else if ([index isEqualToString:@"1"])
    {
        //合租整租
        if([right isEqualToString:@"0"])
        {
            [self.dict4query removeObjectForKey:@"rentType"];
        } else {
            self.dict4query[@"rentType"] = [NSString stringWithFormat:@"%ld", [right integerValue] - 1];
        }
    } else if ([index isEqualToString:@"0"])
    {
        NSArray *city = (NSArray *) _leftArray[0];
        self.dict4query[@"city"] = [city objectAtIndex:[left integerValue]];
        NSArray *district = (NSArray *) _rightArray[0];
        district = (NSArray *) district[[left integerValue]];
        NSDictionary *tmp = (NSDictionary *)  [district  objectAtIndex:[right integerValue]];
        self.dict4query[@"district"] = tmp[@"title"];
    }
    
    [self getNewDataFromNetwork:self.dict4query];
}

@end
