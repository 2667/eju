//
//  HousePublishViewController.h
//  miniProject
//
//  Created by zhoujingjin on 2017/5/4.
//  Copyright © 2017年 zhoujingjin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELCImagePickerController.h"

@interface HousePublishViewController : UIViewController<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>


@property (strong, nonatomic) UIActionSheet *actionSheet;
@end
