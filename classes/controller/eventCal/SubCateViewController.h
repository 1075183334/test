//
//  SubCateViewController.h
//  calendar
//
//  Created by 晓东 on 15/7/9.
//  Copyright (c) 2015年 APPXY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol subCateViewDelegate <NSObject>

-(void)subCateViewReturnDate:(NSDate*)date withindex:(int)index;

@end
@interface SubCateViewController : UIViewController
@property(nonatomic, weak)id<subCateViewDelegate> delegate;
@property(nonatomic, assign)int index;
@property(nonatomic, strong)NSString* dateString;
@end
