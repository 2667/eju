//
//  ViewController.m
//  miniProject
//
//  Created by zhoujingjin on 2017/5/7.
//  Copyright © 2017年 zhoujingjin. All rights reserved.
//

#import "ViewController.h"
#import "FirstViewController.h"
#import "Path.h"
#import "PersonModel.h"
#import "AFNetworking.h"

#define DEGBU  1

NSString *uId = @"9";
PersonModel *my;

#if TESTPORT

NSString *const loginPrefix = @"http://122.152.200.61:9002/user-info-add";

#else

NSString *const loginPrefix = @"http://122.152.200.88:12521/user-info-add";


#endif



@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *rtxLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneLabel;
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) NSMutableDictionary *dict4query;
@end

@implementation ViewController

- (void)viewDidLoad {
    
//    Path *pathView = [[Path alloc] initWithFrame:CGRectMake(78, 418, 280, 10)];
//    [self.view addSubview:pathView];
    
    [super viewDidLoad];
    my = [[PersonModel alloc] init];
    
    self.rtxLabel.placeholder = @"Your RTX Name";
    self.phoneLabel.placeholder = @"Phone Number";
    
    //afnetworking
    //afnetworking
    _manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    _dict4query = [[NSMutableDictionary alloc] init];
#if DEGBU
    my.rtx = @"1582";
    my.mobile = @"15921988152";
    [self login];
#endif

    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (IBAction)setRTX:(id)sender {
    my.rtx = [self.rtxLabel text];
}

- (IBAction)setMobile:(id)sender {
    my.mobile = [self.phoneLabel text];
}

- (IBAction)login:(id)sender {
    
    [self login];
}
- (void) login
{
    NSLog(@"login");
    if(my.rtx && my.mobile)
    {
        self.dict4query[@"rtx"] = my.rtx;
        self.dict4query[@"mobile"] = my.mobile;
        [self.manager POST:loginPrefix parameters:self.dict4query progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSHTTPURLResponse *response = (NSHTTPURLResponse *) task.response;
            NSLog(@"---Current heads:%@---Response:%@----", task.currentRequest.allHTTPHeaderFields, response.allHeaderFields[@"Set-Cookie"]);
            my.token = response.allHeaderFields[@"Set-Cookie"];
            
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            NSLog(@"body JSON: %@", json);
            NSArray *retData = [json objectForKey:@"retData"];
            NSDictionary *tmp = retData[0];
            my.uId = [tmp objectForKey:@"uId"];
            //跳转页面
            UITabBarController* vc=[self.storyboard instantiateViewControllerWithIdentifier:@"tabBarVC"];
            
            UIApplication.sharedApplication.delegate.window.rootViewController = vc;
            
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error:%@", error);
        }];
        
        
    }
}



@end
