//
//  ThirdViewController.m
//  miniProject
//
//  Created by zhoujingjin on 2017/4/26.
//  Copyright © 2017年 zhoujingjin. All rights reserved.
//

#import "ThirdViewController.h"
#import "PersonalInfoSetViewController.h"

@interface ThirdViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *personalIm;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *bg;
@property (weak, nonatomic) IBOutlet UILabel *info;
@property (weak, nonatomic) IBOutlet UIButton *setButton;
@property (weak, nonatomic) IBOutlet UILabel *rtx;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *numPerson;
@property (weak, nonatomic) IBOutlet UILabel *sexOritation;
@property (weak, nonatomic) IBOutlet UILabel *personState;


@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"houseIm1" ofType:@".png"];
    self.personalIm.image = [UIImage imageWithContentsOfFile:filePath];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)setPersonalInfo:(id)sender {
    PersonalInfoSetViewController *pis = [self.storyboard instantiateViewControllerWithIdentifier:@"personalInfoStoryboard"];
    [self.navigationController pushViewController:pis animated:YES];
    pis = nil;
}



@end
