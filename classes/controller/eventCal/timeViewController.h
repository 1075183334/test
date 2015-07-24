//
//  timeViewController.h
//  calendar
//
//  Created by 晓东 on 15/7/16.
//  Copyright (c) 2015年 APPXY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol timeViewDelegate <NSObject>

-(void)returnTime:(NSString*)timeString;

@end
@interface timeViewController : UIViewController

@property(nonatomic,strong)id<timeViewDelegate>delegate;

@property(nonatomic,copy)NSString* timeString;

@end
