//
//  AddCalendarsViewController.h
//  calendar
//
//  Created by 晓东 on 15/7/6.
//  Copyright (c) 2015年 APPXY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddCalendarDelegate <NSObject>

-(void)AddcalendarName:(NSString*)name withColor:(UIColor *)color withMethod:(NSString* )method withIndex:(int)index;

@end

@interface AddCalendarsViewController : UIViewController
@property(nonatomic, strong)id<AddCalendarDelegate> delegate;
@property(nonatomic, copy)NSString* methodString;
@property(nonatomic, assign)int methodIndex;
@end
