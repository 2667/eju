//
//  HouseCell.m
//  miniProject
//
//  Created by zhoujingjin on 2017/4/27.
//  Copyright © 2017年 zhoujingjin. All rights reserved.
//

#import "HouseCell.h"

@interface HouseCell()

@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *roomLive;
@property (nonatomic, strong) UILabel *floor;
@property (nonatomic, strong) UILabel *orientation;
@property (nonatomic, strong) UILabel *subway;
@property (nonatomic, strong) UILabel *price;

@end


@implementation HouseCell

@synthesize imageView = _imageView;

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 100, 80)];
        
        _title = [[UILabel alloc] initWithFrame:CGRectMake(130, 10, 200, 26)];
        
        _roomLive = [[UILabel alloc] initWithFrame:CGRectMake(130, 43, 70, 20)];
        _floor = [[UILabel alloc] initWithFrame:CGRectMake(195, 43, 70, 20)];
        _orientation = [[UILabel alloc] initWithFrame:CGRectMake(260, 43, 50, 20)];
        _subway = [[UILabel alloc] initWithFrame:CGRectMake(130, 70, 170, 20)];
        _price = [[UILabel alloc] initWithFrame:CGRectMake(290, 70, 100, 20)];
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.roomLive];
        [self.contentView addSubview:self.floor];
        [self.contentView addSubview:self.orientation];
        [self.contentView addSubview:self.subway];
        [self.contentView addSubview:self.price];
    }
    return self;
}


-(void) config:(HouseModel *)model
{
    UIImage *urlImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.imagePath]]];
    self.imageView.image = urlImage;
    self.title.text = model.houseTitle;
    self.roomLive.text = [NSString stringWithFormat:@"%@室%@厅", model.liveNum, model.bedNum];
    self.floor.text = [NSString stringWithFormat:@"%@层", model.floor];
    NSArray *orien = @[@"朝东",@"朝南", @"朝西", @"朝北"];
    self.orientation.text = orien[[model.orientation integerValue]];
    self.subway.text = [NSString stringWithFormat:@"近%@地铁站", model.subway];
    self.price.text = [NSString stringWithFormat:@"%@元/月", model.price];
    CGFloat fontSmallSize = 14.0;
    [self.roomLive setFont:[UIFont systemFontOfSize:fontSmallSize]];
    [self.floor setFont:[UIFont systemFontOfSize:fontSmallSize]];
    [self.orientation setFont:[UIFont systemFontOfSize:fontSmallSize]];
    [self.subway setFont:[UIFont systemFontOfSize:fontSmallSize]];
    [self.price setFont:[UIFont systemFontOfSize:fontSmallSize]];
    self.price.textColor = [UIColor colorWithRed:0.953 green:0.647 blue:0.212 alpha:1.0];
    
    self.roomLive.textColor = [UIColor grayColor];
    self.floor.textColor = [UIColor grayColor];
    self.orientation.textColor = [UIColor grayColor];
    self.subway.textColor = [UIColor grayColor];
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
