//
//  HousePublishViewController.m
//  miniProject
//
//  Created by zhoujingjin on 2017/5/4.
//  Copyright © 2017年 zhoujingjin. All rights reserved.
//

#import "HousePublishViewController.h"
#import "ZFDropDown.h"
#import "HouseModel.h"

#import "AFNetworking.h"

extern NSString *const imageUpdatePrefix;
NSString *const publishHousePrefix = @"http://122.152.200.88:12521/house-detail-add";

@interface HousePublishViewController ()<ZFDropDownDelegate>
{
    NSArray *city;
    NSArray *district;
    NSArray *subwayLine;
    NSArray *subwayName;
    HouseModel *house;
    NSArray *room;
    NSArray *live;
    NSArray *orientation;
    NSArray *rentMethod;
}
@property (nonatomic, strong) ZFDropDown *cityDropDown;
@property (nonatomic, strong) ZFDropDown *districtDropDown;
@property (nonatomic, strong) ZFDropDown *subwayLineDropDown;
@property (nonatomic, strong) ZFDropDown *subwayNameDropDown;
@property (nonatomic, strong) ZFDropDown *shiDropDown;
@property (nonatomic, strong) ZFDropDown *huDropDown;
@property (nonatomic, strong) ZFDropDown *rentMethodDropDown;
@property (nonatomic, strong) ZFDropDown *orientationDropDown;
@property (weak, nonatomic) IBOutlet UITextField *detailAddress;
@property (weak, nonatomic) IBOutlet UITextField *area;
@property (weak, nonatomic) IBOutlet UITextField *rent;
@property (weak, nonatomic) IBOutlet UITextField *houseTitle;
@property (weak, nonatomic) IBOutlet UITextField *descp;
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) NSMutableArray *postImURLs;
@property (weak, nonatomic) IBOutlet UIButton *frige;
@property (weak, nonatomic) IBOutlet UIButton *wifi;
@property (weak, nonatomic) IBOutlet UIButton *air;
@property (weak, nonatomic) IBOutlet UIButton *wash;
@property (weak, nonatomic) IBOutlet UIButton *oven;


@end

@implementation HousePublishViewController
@synthesize actionSheet = _actionSheet;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"房源信息";
    //afnetworking
    _manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    city = @[@"上海", @"北京", @"广州", @"深圳", @"成都"];
    district = @[@"静安", @"徐汇", @"闵行"];
    subwayLine = @[@"1", @"2"];
    subwayName = @[@"虹漕路", @"漕河泾开发区"];
    room = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7"];
    live = @[@"1", @"2", @"3", @"4"];
    orientation = @[@"东", @"南", @"西", @"北"];
    rentMethod = @[@"合租", @"整租"];
    
    _cityDropDown = [[ZFDropDown alloc] initWithFrame:CGRectMake(150, 150, 70, 30) pattern:kDropDownPatternDefault];
    _districtDropDown = [[ZFDropDown alloc] initWithFrame:CGRectMake(250, 150, 100, 30) pattern:kDropDownPatternDefault];
    _subwayLineDropDown = [[ZFDropDown alloc] initWithFrame:CGRectMake(150, 230, 50, 30) pattern:kDropDownPatternDefault];
    _subwayNameDropDown = [[ZFDropDown alloc] initWithFrame:CGRectMake(250, 230, 70, 30) pattern:kDropDownPatternDefault];
    _shiDropDown = [[ZFDropDown alloc] initWithFrame:CGRectMake(150, 270, 50, 30) pattern:kDropDownPatternDefault];
    _huDropDown = [[ZFDropDown alloc] initWithFrame:CGRectMake(250, 270, 50, 30) pattern:kDropDownPatternDefault];
    _orientationDropDown = [[ZFDropDown alloc] initWithFrame:CGRectMake(150, 430, 50, 30) pattern:kDropDownPatternDefault];
    _rentMethodDropDown = [[ZFDropDown alloc] initWithFrame:CGRectMake(150, 390, 70, 30) pattern:kDropDownPatternDefault];
    
    self.cityDropDown.delegate = self;
    self.districtDropDown.delegate = self;
    self.subwayLineDropDown.delegate = self;
    self.subwayNameDropDown.delegate = self;
    self.shiDropDown.delegate = self;
    self.huDropDown.delegate = self;
    self.orientationDropDown.delegate = self;
    self.rentMethodDropDown.delegate = self;
    [self.cityDropDown.topicButton setTitle:@"市" forState:UIControlStateNormal];
    [self.districtDropDown.topicButton setTitle:@"区" forState:UIControlStateNormal];
    [self.subwayLineDropDown.topicButton setTitle:@"9" forState:UIControlStateNormal];
    [self.subwayNameDropDown.topicButton setTitle:@"漕河泾开发区" forState:UIControlStateNormal];
    [self.shiDropDown.topicButton setTitle:@"1" forState:UIControlStateNormal];
    [self.huDropDown.topicButton setTitle:@"1" forState:UIControlStateNormal];
    [self.rentMethodDropDown.topicButton setTitle:@"合租" forState:UIControlStateNormal];
    [self.orientationDropDown.topicButton setTitle:@"东" forState:UIControlStateNormal];
    
    [self.view addSubview:self.cityDropDown];
    [self.view addSubview:self.districtDropDown];
    [self.view addSubview:self.subwayLineDropDown];
    [self.view addSubview:self.subwayNameDropDown];
    [self.view addSubview:self.orientationDropDown];
    [self.view addSubview:self.rentMethodDropDown];
    [self.view addSubview:self.shiDropDown];
    [self.view addSubview:self.huDropDown];
    
    house = [[HouseModel alloc] init];
    //默认没有
    house.refrig = @"0";
    house.wifi = @"0";
    house.air = @"0";
    house.wash = @"0";
    house.oven = @"0";
    _postImURLs = [[NSMutableArray alloc] init];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Dropdown delegate

- (NSArray *)itemArrayInDropDown:(ZFDropDown *)dropDown
{
    NSArray *ret;
    if (dropDown == self.cityDropDown)
    {
        ret = city;
    } else if (dropDown == self.districtDropDown)
    {
        ret = district;
    } else if(dropDown == self.subwayLineDropDown)
    {
        ret = subwayLine;
    } else if (dropDown == self.subwayNameDropDown)
    {
        ret = subwayName;
    } else if(dropDown == self.orientationDropDown)
    {
        ret = orientation;
    } else if(dropDown == self.rentMethodDropDown)
    {
        ret = rentMethod;
    } else if(dropDown == self.shiDropDown)
    {
        ret = room;
    } else if(dropDown == self.huDropDown)
    {
        ret = live;
    }
    return ret;
}

- (NSUInteger)numberOfRowsToDisplayIndropDown:(ZFDropDown *)dropDown itemArrayCount:(NSUInteger)count
{
    NSUInteger ret = 6;
    if(dropDown == self.cityDropDown)
    {
        ret = [city count];
    } else if (dropDown == self.districtDropDown)
    {
        ret = [district count];
    } else if (dropDown == self.subwayLineDropDown)
    {
        ret = [subwayLine count];
    } else if (dropDown == self.subwayNameDropDown)
    {
        ret = [subwayName count];
    } else if(dropDown == self.orientationDropDown)
    {
        ret = [orientation count];
    } else if(dropDown == self.rentMethodDropDown)
    {
        ret = [rentMethod count];
    } else if(dropDown == self.shiDropDown)
    {
        ret = [room count];
    } else if(dropDown == self.huDropDown)
    {
        ret = [live count];
    }
    return ret;
}

- (void)dropDown:(ZFDropDown *)dropDown didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(dropDown == self.cityDropDown)
    {
        house.city = city[indexPath.row];
    } else if (dropDown == self.districtDropDown)
    {
        house.district = district[indexPath.row];
    } else if (dropDown == self.subwayLineDropDown)
    {
        house.subway = subwayName[indexPath.row];
    } else if (dropDown == self.subwayNameDropDown)
    {
        house.subway = subwayName[indexPath.row];
    } else if(dropDown == self.orientationDropDown)
    {
        house.orientation = [NSString stringWithFormat:@"%ld", indexPath.row];
    } else if(dropDown == self.rentMethodDropDown)
    {
        house.roomType = [NSString stringWithFormat:@"%ld", indexPath.row];
    } else if(dropDown == self.shiDropDown)
    {
        house.bedNum = [NSString stringWithFormat:@"%ld", indexPath.row];
    } else if(dropDown == self.huDropDown)
    {
        house.liveNum = [NSString stringWithFormat:@"%ld", indexPath.row];
    }
}

#pragma mark set text field
- (IBAction)setDetailAddr:(id)sender {
    house.address = [self.detailAddress text];
}
- (IBAction)setArea:(id)sender {
    house.area = [self.area text];
}
- (IBAction)setRent:(id)sender {
    house.price = [self.rent text];
}
- (IBAction)setTitle:(id)sender {
    house.houseTitle = [self.houseTitle text];
}
- (IBAction)setDescp:(id)sender {
    house.descp = [self.descp text];
}

#pragma mark set ims


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
        //选择图片
        // Create the image picker
        if(sourceType == UIImagePickerControllerSourceTypePhotoLibrary)
        {
            ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
            elcPicker.maximumImagesCount = 9; //Set the maximum number of images to select, defaults to 4
            elcPicker.returnsOriginalImage = NO; //Only return the fullScreenImage, not the fullResolutionImage
            elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
            elcPicker.onOrder = YES; //For multiple image selection, display and return selected order of images
            elcPicker.imagePickerDelegate = self;
            [self presentViewController:elcPicker animated:YES completion:nil];
        } else {
            
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = NO;
            imagePickerController.sourceType = sourceType;
            
            [self presentViewController:imagePickerController animated:YES completion:^{
                
            }];
        }
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
    [self.postImURLs addObject:json[@"retData"][@"images"][0]];
    [[[UIAlertView alloc] initWithTitle:@"上传房屋图像成功"
                                message:nil
                               delegate:nil
                      cancelButtonTitle:nil
                      otherButtonTitles:NSLocalizedString(@"确定", nil), nil] show];

} failure:^(NSURLSessionTask * operation, NSError * error) {
    NSLog(@"上传失败:%@", error);
}];
    
}

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];

    [self.manager POST:imageUpdatePrefix parameters:nil
constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    for(int i = 0; i < [info count]; ++i)
    {
        UIImage *image = [info[i] objectForKey:UIImagePickerControllerOriginalImage];
        NSData *imageData = UIImagePNGRepresentation(image);
        [formData appendPartWithFileData:imageData name:@"file" fileName:@"image.png" mimeType:@"image/png"];
    }
} success:^(NSURLSessionTask *operation, id responseObject) {
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
    NSLog(@"上传成功:%@", json);
    //提示上传成功
    [[[UIAlertView alloc] initWithTitle:@"上传房屋图像成功"
                                message:nil
                               delegate:nil
                      cancelButtonTitle:nil
                      otherButtonTitles:NSLocalizedString(@"确定", nil), nil] show];
    //保存上传imageURL
    for (int i = 0; i < [json[@"retData"][@"images"] count]; ++i)
    {
        [self.postImURLs addObject:json[@"retData"][@"images"][i]];
    }
    
} failure:^(NSURLSessionTask * operation, NSError * error) {
    NSLog(@"上传失败:%@", error);
    
}];
     }
- (IBAction)chooseIms:(id)sender {
    [self callActionSheetFunc];
}

//post

- (IBAction)publish:(id)sender {
    NSLog(@"push publish button!");
    [self postData];
}

- (void) postData
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    parameters[@"ownerId"] = @"9"; //TODO
    if(house.houseTitle)
    {
        parameters[@"name"] = house.houseTitle;
    }
    if(house.bedNum)
    {
        parameters[@"bedNum"] = house.bedNum;
    }
    if(house.liveNum)
    {
        parameters[@"liveNum"] = house.liveNum;
    }
    if(house.price)
    {
        parameters[@"price"] = house.price;
    }
    if(house.area)
    {
        parameters[@"floor"] = house.floor;
    }
    if(house.city)
    {
        parameters[@"city"] = house.city;
    }
    if(house.district)
    {
        parameters[@"district"] = house.district;
    }
    if(house.subway)
    {
        parameters[@"subway"] = house.subway;
    }
    if(house.address)
    {
        parameters[@"address"] = house.address;
    }
    if(house.roomType)
    {
        parameters[@"rentType"] = house.roomType;
    }
    if(house.orientation)
    {
        parameters[@"orientation"] = house.orientation;
    }
    if(house.wifi)
    {
        parameters[@"wifi"] = house.wifi;
    }
    if(house.refrig)
    {
        parameters[@"refrig"] = house.refrig;
    }
    if(house.wash)
    {
        parameters[@"wash"] = house.wash;
    }
    if(house.air)
    {
        parameters[@"air"] = house.air;
    }
    if(house.oven)
    {
        parameters[@"oven"] = house.oven;
    }
    if(house.descp)
    {
        parameters[@"description"] = house.descp;
    }
    if(self.postImURLs)
    {
        NSString *tmp = [NSString stringWithFormat:@"[\"%@\"", self.postImURLs[0]];
        for (int i = 1; i < [self.postImURLs count]; ++i)
        {
            tmp = [NSString stringWithFormat:@"%@,\"%@\"", tmp, self.postImURLs[i]];
        }
        tmp = [NSString stringWithFormat:@"%@]", tmp];
        parameters[@"images"] = tmp;
        house.images = tmp;
    }
    if(house.video)
    {
        parameters[@"video"] = house.video;
    }
    
    [self.manager POST:publishHousePrefix parameters:parameters
               success:^(NSURLSessionTask *operation, id responseObject) {
                   NSLog(@"post success!!!");
                   // 解析服务器返回来的json数据（AFNetworking默认解析json数据）
                   if (responseObject != nil) {
                       NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                       NSLog(@"JSON: %@", json);
//                       house.hId = json[@"retData"][@"hId"];
                       //页面跳转
                       [[[UIAlertView alloc] initWithTitle:@"发布房屋成功"
                                                   message:nil
                                                  delegate:nil
                                         cancelButtonTitle:nil
                                         otherButtonTitles:NSLocalizedString(@"确定", nil), nil] show];

                       
                   }
               } failure:^(NSURLSessionTask *operation, NSError *error) {
                   NSLog(@"err:%@", error);
               }];
    
}
- (IBAction)changerefridge:(id)sender {
    self.frige.selected = !self.frige.selected;
    if(self.frige.selected)
    {
        house.refrig = @"1";
        [self.frige setTitle:[self.frige.titleLabel text] forState:UIControlStateHighlighted];
    } else {
        house.refrig = @"0";
        [self.frige setTitle:[self.frige.titleLabel text] forState:UIControlStateNormal];
    }
}
- (IBAction)changeAir:(id)sender {
    self.air.selected = !self.air.selected;
    if(self.air.selected)
    {
        house.air = @"1";
        [self.air setTitle:[self.air.titleLabel text] forState:UIControlStateHighlighted];
    } else {
        house.refrig = @"0";
        [self.air setTitle:[self.air.titleLabel text] forState:UIControlStateNormal];
    }

}
- (IBAction)changeWash:(id)sender {
    self.wash.selected = !self.wash.selected;
    if(self.wash.selected)
    {
        house.wash = @"1";
        [self.wash setTitle:[self.wash.titleLabel text] forState:UIControlStateHighlighted];
    } else {
        
        house.refrig = @"0";
        [self.wash setTitle:[self.wash.titleLabel text] forState:UIControlStateNormal];
    }

}



- (IBAction)changeWIFI:(id)sender {
    self.wifi.selected = !self.wifi.selected;
    if(self.wifi.selected)
    {
        house.wifi = @"1";
        [self.wifi setTitle:[self.wifi.titleLabel text] forState:UIControlStateHighlighted];
    } else {
        house.wifi = @"0";
        [self.wifi setTitle:[self.wifi.titleLabel text] forState:UIControlStateNormal];
    }
}

- (IBAction)changeOven:(id)sender {
    self.oven.selected = !self.oven.selected;
    if(self.oven.selected)
    {
        house.oven = @"1";
        [self.oven setTitle:[self.oven.titleLabel text] forState:UIControlStateHighlighted];
    } else {
        house.oven = @"0";
        [self.oven setTitle:[self.oven.titleLabel text] forState:UIControlStateNormal];
    }

}


@end
