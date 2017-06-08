//
//  PersonalInfoSetViewController.m
//  miniProject
//
//  Created by zhoujingjin on 2017/5/4.
//  Copyright © 2017年 zhoujingjin. All rights reserved.
//

#import "PersonalInfoSetViewController.h"
#import "ZFDropDown.h"
#import "PersonModel.h"
#import "AFNetworking.h"


NSString *const personInfoUpdatePrefix = @"http://122.152.200.88:12521/user-info-update";
NSString *const imageUpdatePrefix = @"http://122.152.200.88:12521/upload-file/image";

@interface PersonalInfoSetViewController ()<ZFDropDownDelegate>
{
    NSArray *sex;
    NSArray *sexPref;

    PersonModel* personalInfo;
}
@property (nonatomic, strong) ZFDropDown *sexDropDown;
@property (nonatomic, strong) ZFDropDown *sexPrefDropDown;

@property (nonatomic) NSInteger uid;
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *rtxText;
@property (weak, nonatomic) IBOutlet UITextField *mobileText;
@property (weak, nonatomic) IBOutlet UITextField *bgText;
@property (weak, nonatomic) IBOutlet UITextField *despText;
@property (weak, nonatomic) IBOutlet UITextField *commentText;
@property (weak, nonatomic) IBOutlet UIButton *changHeadButton;
@property (weak, nonatomic) IBOutlet UIButton *changeVCRButton;

@end



@implementation PersonalInfoSetViewController
@synthesize actionSheet = _actionSheet;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息设置";
    //dropdown初始化
    sex = @[@"男", @"女"];
    sexPref = @[@"男", @"女", @"不限"];

    _sexDropDown = [[ZFDropDown alloc] initWithFrame:CGRectMake(190, 150, 90, 30) pattern:kDropDownPatternDefault];
    _sexPrefDropDown = [[ZFDropDown alloc] initWithFrame:CGRectMake(190, 430, 90, 30) pattern:kDropDownPatternDefault];

    self.sexDropDown.delegate = self;
    self.sexPrefDropDown.delegate = self;

    [self.sexDropDown.topicButton setTitle:@"男" forState:UIControlStateNormal];
    [self.sexPrefDropDown.topicButton setTitle:@"男" forState:UIControlStateNormal];

    [self.view addSubview:self.sexDropDown];
    [self.view addSubview:self.sexPrefDropDown];

    
    //afnetworking 初始化
    //afnetworking
    _manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    personalInfo = [[PersonModel alloc] init];
    //TODO
    personalInfo.uId = @"9";
    
    //相机

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) postData
{
    NSDictionary *parameters = @{
                                 @"uId":personalInfo.uId,
                                 @"gender":personalInfo.gender == nil ? @"":personalInfo.gender,
                                 @"name":personalInfo.name == nil ? @"":personalInfo.name,
                                 @"rtx":personalInfo.rtx == nil ? @"":personalInfo.rtx,
                                 @"head":personalInfo.head == nil ? @"":personalInfo.head,
                                 @"gender":personalInfo.gender == nil ? @"":personalInfo.gender,
                                 @"department":personalInfo.department == nil ? @"":personalInfo.department,
                                 @"description":personalInfo.desp == nil ? @"":personalInfo.desp,
                                 @"mobile":personalInfo.mobile == nil ? @"":personalInfo.mobile,
                                 @"comment":personalInfo.comment == nil ? @"":personalInfo.comment,
                                 @"video":personalInfo.video == nil ? @"":personalInfo.video,
                                 @"videoImage":personalInfo.videoImage == nil ? @"":personalInfo.videoImage,
                                 @"prefGender":personalInfo.prefGender == nil ? @"":personalInfo.prefGender,
                                 };

    [self.manager POST:personInfoUpdatePrefix parameters:parameters
               success:^(NSURLSessionTask *operation, id responseObject) {
                   NSLog(@"post success!!!");
                   // 解析服务器返回来的json数据（AFNetworking默认解析json数据）
                   if (responseObject != nil) {
                       NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                       NSLog(@"JSON: %@", json);
                   }
               } failure:^(NSURLSessionTask *operation, NSError *error) {
                   NSLog(@"err:%@", error);
               }];

}

#pragma mark modify textfield
- (IBAction)changeName:(id)sender {
    personalInfo.name = [self.nameText text];
}
- (IBAction)changeRTX:(id)sender {
    personalInfo.rtx = [self.rtxText text];
}

- (IBAction)changeMobile:(id)sender {
    personalInfo.mobile = [self.mobileText text];
}
- (IBAction)changeBG:(id)sender {
    personalInfo.department = [self.bgText text];
}
- (IBAction)changeDes:(id)sender {
    personalInfo.desp = [self.despText text];
}
- (IBAction)changeComment:(id)sender {
    personalInfo.comment = [self.commentText text];
}


#pragma mark dropDown delegate
- (NSArray *)itemArrayInDropDown:(ZFDropDown *)dropDown
{
    NSArray *ret;
    if (dropDown == self.sexDropDown)
    {
        ret = sex;
    } else if (dropDown == self.sexPrefDropDown)
    {
        ret = sexPref;
    }
    return ret;
}

- (NSUInteger)numberOfRowsToDisplayIndropDown:(ZFDropDown *)dropDown itemArrayCount:(NSUInteger)count
{
    NSUInteger ret = 6;
    if(dropDown == self.sexDropDown)
    {
        ret = [sex count];
    } else if (dropDown == self.sexPrefDropDown)
    {
        ret = [sexPref count];
    }
    return ret;
}

- (void)dropDown:(ZFDropDown *)dropDown didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(dropDown == self.sexDropDown)
    {
        personalInfo.gender = [NSString stringWithFormat:@"%ld", indexPath.row];
    } else if (dropDown == self.sexPrefDropDown)
    {
        personalInfo.prefGender = [NSString stringWithFormat:@"%ld", indexPath.row];
    }
        
}


- (IBAction)comfirm:(id)sender {
    [self postData];
}

#pragma mark Camera
- (void)callActionSheetFunc{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
    }else{
        self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:@"取消"destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
    }
    
    self.actionSheet.tag = 1000;
    [self.actionSheet showInView:self.view];
}

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 1000) {
        NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    //来源:相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 1:
                    //来源:相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                case 2:
                    return;
            }
        }
        else {
            if (buttonIndex == 2) {
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:^{
            
        }];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    //TODO
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.manager POST:imageUpdatePrefix parameters:nil
constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    NSData *imageData = UIImagePNGRepresentation(image);
    [formData appendPartWithFileData:imageData name:@"file" fileName:@"image.png" mimeType:@"image/png"];
    } success:^(NSURLSessionTask *operation, id responseObject) {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSLog(@"上传成功:%@", json);
    } failure:^(NSURLSessionTask * operation, NSError * error) {
        NSLog(@"上传失败:%@", error);
    }];
    
}
- (IBAction)chooseIm:(id)sender {
    [self callActionSheetFunc];
}
- (IBAction)chooseVideo:(id)sender {
    [self callActionSheetFunc];
}




@end
