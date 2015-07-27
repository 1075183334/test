//
//  colorTableViewCell.m
//  calendar
//
//  Created by 晓东 on 15/7/27.
//  Copyright (c) 2015年 APPXY. All rights reserved.
//

#import "colorTableViewCell.h"

@implementation colorTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
    }
    return self;
}


- (void)awakeFromNib {

    _calCellColorView.layer.cornerRadius =5;
    _calCellColorView.layer.masksToBounds = YES;
//    _calCellNameView.textColor = [UIColor blackColor];
//    _calCellColorNameView.textColor = [UIColor blackColor];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
