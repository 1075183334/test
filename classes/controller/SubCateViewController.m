//
//  SubCateViewController.m
//  ExpansionTableViewByZQ
//
//  Created by 郑 琪 on 13-2-27.
//  Copyright (c) 2013年 郑 琪. All rights reserved.
//

#import "SubCateViewController.h"

@interface SubCateViewController ()

@end

@implementation SubCateViewController




#pragma ViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    
    UIDatePicker* data = [[UIDatePicker alloc]initWithFrame:CGRectMake(10, 0, 300, 160)];
    [self.view setFrame:CGRectMake(0, 0, 320,160)];
    [self.view addSubview:data];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
