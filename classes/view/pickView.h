//
//  pickView.h
//  calendar
//
//  Created by APPXY on 15/7/2.
//  Copyright (c) 2015年 APPXY. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface pickView : UIPickerView<UIPickerViewDelegate,UIPickerViewDataSource>

-(NSInteger)updatePickHourData;
-(NSInteger)updatePickMinData;
@end
