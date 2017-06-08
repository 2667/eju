//
//  PersonCell.m
//  miniProject
//
//  Created by zhoujingjin on 2017/5/1.
//  Copyright © 2017年 zhoujingjin. All rights reserved.
//

#import "PersonCell.h"

@interface PersonCell()
{
    NSString *boyImPath;
    NSString *girlImPath;
}



@property (nonatomic, strong) UIImageView *genderView;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *bg;
@property (nonatomic, strong) UILabel *descp;

@end

@implementation PersonCell

@synthesize imageView = _imageView;

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    boyImPath = @"";
    if(self) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 80, 80)];
        
        _name = [[UILabel alloc] initWithFrame:CGRectMake(120, 10, 60, 26)];
        
        _genderView = [[UIImageView alloc] initWithFrame:CGRectMake(180, 11, 24, 24)];
        
        
        _bg = [[UILabel alloc] initWithFrame:CGRectMake(120, 43, 100, 20)];
      
        _descp = [[UILabel alloc] initWithFrame:CGRectMake(120, 70, 150, 20)];
        
        
    
        
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.genderView];

        [self.contentView addSubview:self.name];
        [self.contentView addSubview:self.bg];
        [self.contentView addSubview:self.descp];
        [self.contentView addSubview:self.name];
       

    }
    return self;
}

-(void) config:(PersonModel *)model
{
    UIImage *urlImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.head]]];
    self.imageView.image = urlImage;
    
    if([model.gender  isEqual: @"0"])
    {
        self.genderView.image = [UIImage imageNamed:@"boy.png"];
    } else
    {
        self.genderView.image = [UIImage imageNamed:@"girl.png"];
    }
    
   
    
    CGFloat fontSmallSize = 14.0;
    self.name.text = model.name;
    self.bg.text = model.department;
    self.descp.text = model.desp;
    
    [self.bg setFont:[UIFont systemFontOfSize:fontSmallSize]];
    [self.descp setFont:[UIFont systemFontOfSize:fontSmallSize]];

    
    self.bg.textColor = [UIColor grayColor];
    

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    

    // Configure the view for the selected state
}




@end
