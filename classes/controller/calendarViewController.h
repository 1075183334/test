//
//  calendarViewController.h
//  calendar
//
//  Created by APPXY on 15/7/3.
//  Copyright (c) 2015年 APPXY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol calendarDelegate <NSObject>

- (void)calendarViewWithColor:(NSString*)color withTitle:(NSString* )string;

@end
@interface calendarViewController : UIViewController
@property(nonatomic, weak)id<calendarDelegate> delegate;
@end
