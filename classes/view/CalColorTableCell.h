//
//  CalColorTableCell.h
//  calendar
//
//  Created by 晓东 on 15/7/27.
//  Copyright (c) 2015年 APPXY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Calendar;

@interface CalColorTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *calColorCellView;
@property (weak, nonatomic) IBOutlet UILabel *calColorNameCellLable;
@property(nonatomic, strong)UIImageView* checkImage;
@property(nonatomic, assign)BOOL checked;
@property(nonatomic, strong) Calendar *calendar;
@end
