//
//  AddCalendarsViewController.h
//  calendar
//
//  Created by 晓东 on 15/7/6.
//  Copyright (c) 2015年 APPXY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Calendar;

@protocol AddCalendarDelegate <NSObject>

-(void)updatedCalendarObj:(Calendar *)calendarEdited;

@end

@interface AddCalendarsViewController : UIViewController
@property(nonatomic, strong)id<AddCalendarDelegate> delegate;
@property(nonatomic, strong) Calendar* editedCalendar;
@property(nonatomic, assign)int btnTag;
@property (nonatomic, strong) UIButton  * selectedBtn;
@end
