//
//  pickView.m
//  calendar
//
//  Created by APPXY on 15/7/2.
//  Copyright (c) 2015年 APPXY. All rights reserved.
//

#import "pickView.h"

@implementation pickView

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2; //显示两列
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component==0)
    {
        //如果是第一列，显示1个标签
        return 24;
    }
    else
    {
        //否则显示2个标签
        return 60;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component==0)
    {
       
        return [NSString stringWithFormat:@"%ld",(long)row+1];
    }
    else
    {
        return [NSString stringWithFormat:@"%ld",(long)row+1];

    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self updatePickHourData];
    [self updatePickMinData];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    if(component==0)
    {
        //设置第一列的行高
        return 50;
    }
    else
    {
        return 30;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if(component==0)
    {
        //设置第一列的宽度
        return 100;
    }
    else
    {
        return 80;
    }
}

-(NSInteger)updatePickHourData
{
    
    NSInteger hour =[[NSString stringWithFormat:@"%d",[self selectedRowInComponent:0]+1] integerValue];
//    NSLog(@"%d",hour);
    return hour;
}
-(NSInteger)updatePickMinData
{
     NSInteger min =[[NSString stringWithFormat:@"%d",[self selectedRowInComponent:1]+1] integerValue];
//    NSLog(@"%d",min);

    return min;
}


@end
