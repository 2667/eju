//
//  PersonModel.h
//  miniProject
//
//  Created by zhoujingjin on 2017/5/1.
//  Copyright © 2017年 zhoujingjin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonModel : NSObject

// ---------列表项-----------
@property (nonatomic, strong)   NSString *desp;
@property (nonatomic, strong)   NSString *name;
@property (nonatomic, strong)   NSString *department;
@property (nonatomic, strong)   NSString *uId; //uint
//-----------详情页----------
@property (nonatomic, strong)   NSString *gender; // 0 man
@property (nonatomic, strong)   NSString *rtx;
@property (nonatomic, strong)   NSString *mobile;
@property (nonatomic, strong)   NSString *comment;
@property (nonatomic, strong)   NSString *video;
@property (nonatomic, strong)   NSString *videoImage;
@property (nonatomic, strong)   NSString *prefGender; // 0 or 1
@property (nonatomic, strong)   NSString *token;
@property (nonatomic, strong)   NSString *avatar;
@property (nonatomic, strong)   NSString *head;



@end
