//
//  colorTableViewCell.h
//  calendar
//
//  Created by 晓东 on 15/7/27.
//  Copyright (c) 2015年 APPXY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface colorTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *calCellColorView;
@property (weak, nonatomic) IBOutlet UILabel *calCellNameView;
@property (weak, nonatomic) IBOutlet UILabel *calCellColorNameView;

@end
