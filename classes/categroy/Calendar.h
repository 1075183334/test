//
//  Calendar.h
//  calendar
//
//  Created by 晓东 on 15/7/23.
//  Copyright (c) 2015年 APPXY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface Calendar : NSManagedObject

@property (nonatomic, retain) NSNumber * calCheck;
@property (nonatomic, retain) NSString * calColor;
@property (nonatomic, retain) NSString * calName;
@property (nonatomic, retain) NSSet *calEvents;
@end

@interface Calendar (CoreDataGeneratedAccessors)

- (void)addCalEventsObject:(Event *)value;
- (void)removeCalEventsObject:(Event *)value;
- (void)addCalEvents:(NSSet *)values;
- (void)removeCalEvents:(NSSet *)values;

@end
