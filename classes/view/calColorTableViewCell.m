//
//  calColorTableViewCell.m
//  calendar
//
//  Created by 晓东 on 15/7/13.
//  Copyright (c) 2015年 APPXY. All rights reserved.
//

#import "calColorTableViewCell.h"

@implementation calColorTableViewCell

- (void)awakeFromNib {
    
    
    
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        if (self.checkImage == nil) {
            self.checkImage = [[UIImageView alloc]initWithFrame:CGRectMake(270, 10, 20, 20)];
            self.checkImage.image = [UIImage imageNamed:@"Selected"];
            [self addSubview:self.checkImage];
        }
        
    }
    
    return self;
}

-(void)setChecked:(BOOL)checked{
    if (checked) {
        self.checkImage.image = [UIImage imageNamed:@"Selected"];
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
