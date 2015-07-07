//
//  Event.h
//  calendar
//
//  Created by 晓东 on 15/7/7.
//  Copyright (c) 2015年 APPXY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Calendar;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * endTime;
@property (nonatomic, retain) NSString * eventColor;
@property (nonatomic, retain) NSString * eventLocal;
@property (nonatomic, retain) NSString * eventName;
@property (nonatomic, retain) NSString * eventNote;
@property (nonatomic, retain) NSString * startTime;
@property (nonatomic, retain) Calendar *eventCalendar;

@end
