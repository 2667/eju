//
//  WebViewController.m
//  miniProject
//
//  Created by zhoujingjin on 2017/4/27.
//  Copyright © 2017年 zhoujingjin. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@property  (nonatomic, strong) UIActivityIndicatorView* waitingView;


@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //网页
    CGFloat topSpace = 0;
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, topSpace, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.webView.delegate = self;
    
    self.waitingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.waitingView.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    self.waitingView.color = [UIColor blackColor];
    
    
    [self.view addSubview:self.webView];
    [self.view addSubview:self.waitingView];
    //返回按钮
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self UIUpdate];
}

- (void) UIUpdate
{
    if(self.URL){
        NSURL *url = [[NSURL alloc] initWithString:self.URL];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    }
}

- (void) setURL:(NSString *)URL
{
    _URL = URL;
    if(self.view.window){ //只当在屏幕上时更新
        [self UIUpdate];
    }
}

- (void )webViewDidStartLoad:(UIWebView  *)webView
{
    [self.waitingView startAnimating];
}

- (void )webViewDidFinishLoad:(UIWebView  *)webView
{
    [self.waitingView stopAnimating];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
