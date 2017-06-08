//
//  HouseModel.h
//  miniProject
//
//  Created by zhoujingjin on 2017/4/27.
//  Copyright © 2017年 zhoujingjin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HouseModel : NSObject

@property (nonatomic, strong) NSString *imagePath; //surfaceImage
@property (nonatomic, strong) NSString *houseTitle; //name
@property (nonatomic, strong) NSString *houseInfo; //自己生成的
@property (nonatomic, strong) NSString *detailURL; //详情页rul
@property (nonatomic, strong) NSString *roomType; //rentType 合租0 整租1
@property (nonatomic, strong) NSString *subway; //地铁线
@property (nonatomic, strong) NSString *station;

@property (nonatomic, strong) NSString *hId;
@property (nonatomic, strong) NSString *ownerId;
@property (nonatomic, strong) NSString *bedNum; // 室
@property (nonatomic, strong) NSString *liveNum; // 厅
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) NSString *floor;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *district;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *payType;
@property (nonatomic, strong) NSString *orientation; //0东
@property (nonatomic, strong) NSString *lon;
@property (nonatomic, strong) NSString *lat;
@property (nonatomic, strong) NSString *wifi;
@property (nonatomic, strong) NSString *refrig;
@property (nonatomic, strong) NSString *wash;
@property (nonatomic, strong) NSString *air;
@property (nonatomic, strong) NSString *oven;
@property (nonatomic, strong) NSString *descp;
@property (nonatomic, strong) NSString *video;
@property (nonatomic, strong) NSString *status; //0-active 1-inactive
@property (nonatomic, strong) NSString *images;




@end
