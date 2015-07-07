//
//  SecondCarlendarViewController.h
//  calendar
//
//  Created by 晓东 on 15/7/6.
//  Copyright (c) 2015年 APPXY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol secondCarlendarDelegate <NSObject>

-(void)addSecondCarlendarArray:(NSArray* )array;

@end

@protocol AddCalendarDelegate;
@interface SecondCarlendarViewController : UIViewController

@property(nonatomic, assign)id<secondCarlendarDelegate> secondDelegate;
@property(nonatomic,assign) id<AddCalendarDelegate>delegate;
@end
