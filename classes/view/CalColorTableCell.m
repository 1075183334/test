//
//  CalColorTableCell.m
//  calendar
//
//  Created by 晓东 on 15/7/27.
//  Copyright (c) 2015年 APPXY. All rights reserved.
//

#import "CalColorTableCell.h"

@implementation CalColorTableCell
- (void)awakeFromNib {
    
    _calColorCellView.layer.cornerRadius =5;
    _calColorCellView.layer.masksToBounds = YES;
    
    
    if (self.checkImage == nil) {
        self.checkImage = [[UIImageView alloc]initWithFrame:CGRectMake(290, 10, 20, 20)];
        self.checkImage.image = [UIImage imageNamed:@"Selected.png"];
        [self addSubview:self.checkImage];
    }
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
       
        
    }
    
    return self;
}

-(void)setChecked:(BOOL)checked{
    if (checked) {
        self.checkImage.image = [UIImage imageNamed:@"Selected.png"];
    }
    else
    {
        self.checkImage.image = [UIImage imageNamed:@"Unselected.png"];
    }
    _checked = checked;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
