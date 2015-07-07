//
//  beganEditViewController.m
//  calendar
//
//  Created by APPXY on 15/7/2.
//  Copyright (c) 2015年 APPXY. All rights reserved.
//

#import "beganEditViewController.h"
#import "pickView.h"
#import "calendarViewController.h"
#import "Event.h"
#import "CalendarView.h"
#import "AppDelegate.h"
#import "mainViewController.h"

@interface beganEditViewController ()<UITextFieldDelegate,calendarDelegate,UITextViewDelegate>
@property(nonatomic, strong)calendarViewController* calendarContr;
@property(nonatomic, strong)mainViewController* mainVc;
@property(nonatomic, strong)UIView* coverView;
@property(nonatomic, strong)pickView* pick1;
@property(nonatomic, strong)pickView* pick2;
@property(nonatomic, strong)UIButton* starts;
@property(nonatomic, strong)UIButton* ends;
@property(nonatomic, strong)UIButton* calendar;
@property(nonatomic, strong)UITextField* nameText;
@property(nonatomic, strong)UITextField* localText;
@property(nonatomic, strong)UITextView* noteText;
@property(nonatomic, strong)AppDelegate *mydelegate;
@property(nonatomic, strong)NSManagedObject *object;
@property(nonatomic, strong)NSManagedObject *Color;
@end

@implementation beganEditViewController

-(void)setDate:(NSDate *)date
{
    if (_date == date) {
        return;
    }
    _date = date;
    
    NSLog(@"string = %@",[[_date description] substringToIndex:10]);

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.calendarContr = [[calendarViewController alloc]init];
    self.calendarContr.delegate = self;
    self.mainVc = [[mainViewController alloc]init];
    self.mydelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [self createEditBtn];
    [self createTextFiled];
    [self createbtn];
    
}

-(void)createTextFiled
{
    self.nameText = [[UITextField alloc]initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, 30)];
    self.nameText.placeholder = @"  Event Name";
    [self.nameText setBorderStyle:UITextBorderStyleBezel];
    [self.view addSubview:self.nameText];
    
    self.localText = [[UITextField alloc]initWithFrame:CGRectMake(0, 80, self.view.bounds.size.width, 30)];
    self.localText.placeholder = @"  Location";
    [self.localText setBorderStyle:UITextBorderStyleBezel];
    [self.view addSubview:self.localText];
    
    self.noteText = [[UITextView alloc]initWithFrame:CGRectMake(0, 250, self.view.bounds.size.width, 100)];
    self.noteText.layer.borderColor = [UIColor blackColor].CGColor;
    self.noteText.layer.borderWidth = 1;
    self.noteText.text = @"note";
    [self.view addSubview:self.noteText];
    self.noteText.delegate = self;
    
}


#pragma mark - uitextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
    self.view.frame = CGRectMake(0, -120, self.view.bounds.size.width, self.view.bounds.size.height);
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);

}

#pragma mark - button
- (void)createbtn
{
    self.starts = [UIButton buttonWithType:UIButtonTypeCustom];
    self.starts.frame = CGRectMake(0, 120, self.view.bounds.size.width, 30);
    [self.starts addTarget:self action:@selector(startClick) forControlEvents:UIControlEventTouchDown];
    self.starts.layer.borderColor = [UIColor grayColor].CGColor;
    self.starts.layer.borderWidth = 1;
    [self.starts setTitle:@"starts" forState:UIControlStateNormal];
    self.starts.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.starts  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:self.starts];
    
    self.ends = [UIButton buttonWithType:UIButtonTypeCustom];
    self.ends.frame = CGRectMake(0, 150, self.view.bounds.size.width, 30);
    [self.ends addTarget:self action:@selector(endsClick) forControlEvents:UIControlEventTouchDown];
    self.ends.layer.borderColor = [UIColor grayColor].CGColor;
    self.ends.layer.borderWidth = 1;
    [self.ends setTitle:@"ends" forState:UIControlStateNormal];
    self.ends.titleLabel.textAlignment = NSTextAlignmentRight;
    [self.ends  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:self.ends];
    
    self.calendar = [UIButton buttonWithType:UIButtonTypeCustom];
    self.calendar.frame = CGRectMake(0, 200, self.view.bounds.size.width, 30);
    [self.calendar addTarget:self action:@selector(calendarClick) forControlEvents:UIControlEventTouchDown];
    self.calendar.layer.borderColor = [UIColor grayColor].CGColor;
    self.calendar.layer.borderWidth = 1;
    [self.calendar setTitle:@"calendar" forState:UIControlStateNormal];
    self.calendar.titleLabel.textAlignment = NSTextAlignmentRight;
    [self.calendar  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:self.calendar];
    
    
}
-(void)calendarClick
{
    [self presentViewController:self.calendarContr animated:YES completion:^{
    }];
    
}

-(void)startClick
{
    self.coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.coverView.backgroundColor = [UIColor blackColor];
    self.coverView.alpha = 0.5;
    [self.view addSubview:self.coverView];
    
    self.pick1 = [[pickView alloc]init];
    self.pick1.frame = CGRectMake(60, 100, 200, 180);
    self.pick1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.pick1];
    
}

-(void)endsClick
{
    self.coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.coverView.backgroundColor = [UIColor blackColor];
    self.coverView.alpha = 0.5;
    [self.view addSubview:self.coverView];
    
    self.pick2 = [[pickView alloc]init];
    self.pick2.frame = CGRectMake(60, 100, 200, 180);
    self.pick2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.pick2];
}

#pragma mark - calendarDelegate
-(void)calendarViewWithColor:(UIColor *)color withTitle:(NSString *)string
{
    [self.calendar setBackgroundColor:color];
    [self.calendar setTitle:[NSString stringWithFormat:@"calendar        %@",string] forState:UIControlStateNormal];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.nameText resignFirstResponder];
    [self.localText resignFirstResponder];
    [self.noteText resignFirstResponder];
    [self.coverView removeFromSuperview];
    [self.pick1 removeFromSuperview];
    [self.pick2 removeFromSuperview];
    [self.pick1 updatePickHourData];
    [self.pick1 updatePickMinData];
    [self updateStartTimeBtnHour:[self.pick1 updatePickHourData] withMin:[self.pick1 updatePickMinData]];
    [self updateEndTimeBtnHour:[self.pick2 updatePickHourData] withMin:[self.pick2 updatePickMinData]];
}

-(void)updateStartTimeBtnHour:(int)hour withMin:(int)min
{
    if(min<10)
    {
        [self.starts setTitle:[NSString stringWithFormat:@" starts  %d:0%d",hour,min] forState:UIControlStateNormal];
    }
    else
    {
        [self.starts setTitle:[NSString stringWithFormat:@" starts  %d:%d",hour,min] forState:UIControlStateNormal];
    }
    
}

-(void)updateEndTimeBtnHour:(int)hour withMin:(int)min
{
    if(min<10)
    {
        [self.ends setTitle:[NSString stringWithFormat:@" ends  %d:0%d",hour,min] forState:UIControlStateNormal];
    }
    else
    {
        [self.ends setTitle:[NSString stringWithFormat:@" ends  %d:%d",hour,min] forState:UIControlStateNormal];
    }
    
}

-(void)createEditBtn
{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    btn.frame = CGRectMake(10, 20, 20, 20);
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btn];
    
    UIButton* savebtn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    savebtn.frame = CGRectMake(290, 20, 20, 20);
    [savebtn addTarget:self action:@selector(savebtnClick) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:savebtn];
}


-(void)savebtnClick
{
    self.object=[NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:self.mydelegate.managedObjectContext];
//    if (_date) {
//        [self.object setValue:[[_date description] substringToIndex:10] forKey:@"date"];
//    }
   
    [self.object setValue:[[_date description] substringToIndex:10] forKey:@"date"];
    [self.object setValue:self.nameText.text forKey:@"eventName"];
    [self.object setValue:self.localText.text forKey:@"eventLocal"];
    [self.object setValue:[self.starts currentTitle] forKey:@"startTime"];
    [self.object setValue:[self.ends currentTitle] forKey:@"endTime"];
    [self.object setValue:self.noteText.text forKey:@"eventNote"];
    [self.mydelegate saveContext];
    
//     self.Color=[NSEntityDescription insertNewObjectForEntityForName:@"Color" inManagedObjectContext:self.mydelegate.managedObjectContext];
//    [self.Color setValue:self.calendar.backgroundColor forKey:@"color"];
//    
//    [self.object setValue:self.Color forKey:@"Color"];
    
//  [self btnClick];
}

-(void)btnClick
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
