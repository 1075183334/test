//
//  Event.h
//  calendar
//
//  Created by 晓东 on 15/7/14.
//  Copyright (c) 2015年 APPXY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Calendar;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSString * eventLocal;
@property (nonatomic, retain) NSString * eventName;
@property (nonatomic, retain) NSString * eventNote;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) Calendar *eventCalendar;

@end
