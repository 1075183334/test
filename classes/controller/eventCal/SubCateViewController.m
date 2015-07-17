//
//  SubCateViewController.m
//  calendar
//
//  Created by 晓东 on 15/7/9.
//  Copyright (c) 2015年 APPXY. All rights reserved.
//

#import "SubCateViewController.h"

@interface SubCateViewController ()
{
    UIDatePicker* dataPicker;
}
@end

@implementation SubCateViewController

-(void)setIndex:(int)index
{
    if (_index == index) {
        return;
    }
    _index = index;
}

-(void)setDateString:(NSString *)dateString
{
    if ([_dateString isEqualToString:dateString]) {
        return;
    }
    _dateString = dateString;
    NSLog(@"%@",_dateString);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    dataPicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(10, 0, 300, 160)];
    [self.view setFrame:CGRectMake(0, 0, 320, 160)];
    dataPicker.date = [NSDate date];
    dataPicker.datePickerMode = UIDatePickerModeDateAndTime;
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中
    dataPicker.locale = locale;
//    NSDateFormatter* datefor = [[NSDateFormatter alloc]init];
//    [datefor setDateFormat:@"yyyy-M-dd"];
//    [datefor setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
//    NSDate* currentDat = [datefor dateFromString:_dateString];
//    NSDate *nextDat = [NSDate dateWithTimeInterval:24*60*60 sinceDate:[datefor dateFromString:_dateString]];
    
//    dataPicker.minimumDate = currentDat;
//    dataPicker.maximumDate = nextDat;
    [dataPicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
    [self.view addSubview:dataPicker];
}

-(void)dateChanged:(id)sender{
    UIDatePicker* control = (UIDatePicker*)sender;
    NSDate* _date = control.date;
//    NSLog(@"%@",_date);
    if ([self.delegate respondsToSelector:@selector(subCateViewReturnDate:withindex:)]) {
        [self.delegate subCateViewReturnDate:_date withindex:_index];
    }
//    NSLog(@"%@",_date);
}
@end
