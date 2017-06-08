//
//  PersonCell.h
//  miniProject
//
//  Created by zhoujingjin on 2017/5/1.
//  Copyright © 2017年 zhoujingjin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonModel.h"

@interface PersonCell : UITableViewCell
@property (nonatomic, strong) UIImageView *imageView;
-(void) config:(PersonModel*) model;

@end
