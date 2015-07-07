//
//  mainViewController.m
//  calendar
//
//  Created by APPXY on 15/7/2.
//  Copyright (c) 2015年 APPXY. All rights reserved.
//

#import "mainViewController.h"
#import "CalendarView.h"
#import "EditViewController.h"
#import <EventKit/EventKit.h>
#import "TodayViewController.h"
#import "CalendarsViewController.h"
@interface mainViewController ()<CalendarDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIViewController* _currentViewController;
}
@property(nonatomic, strong)CalendarView* myCalendar;
@property(nonatomic, strong)UITableView* table;
@end

@implementation mainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [btn addTarget:self action:@selector(EditClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self createCalendar];
    [self createTableView];
//    [self createEditBtn];
    [self createChildVic];
}

-(void)EditClick
{
    [self.navigationController pushViewController:[[EditViewController alloc]init] animated:YES];
}

-(void)createChildVic
{
    
    UIButton* todayBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-30, self.view.bounds.size.width*0.5, 30)];
    [todayBtn setTitle:@"Today" forState:UIControlStateNormal];
    [todayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    todayBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    todayBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    UIButton* calendarsBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width*0.5, self.view.bounds.size.height-30, self.view.bounds.size.width*0.5, 30)];
    [calendarsBtn setTitle:@"Calendar" forState:UIControlStateNormal];
    [calendarsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    calendarsBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    calendarsBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [todayBtn addTarget:self action:@selector(showToday) forControlEvents:UIControlEventTouchUpInside];
    
    [calendarsBtn addTarget:self action:@selector(showCalendars) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:todayBtn];
    [self.view addSubview:calendarsBtn];
    
    
}

-(void)showToday
{
    TodayViewController* today = [[TodayViewController alloc]init];
    [self.navigationController pushViewController:today animated:YES];
    
}

-(void)showCalendars
{
    CalendarsViewController * calendarsVic = [[CalendarsViewController alloc]init];
    [self.navigationController pushViewController:calendarsVic animated:YES];

}
-(void)createCalendar
{
    self.myCalendar = [[CalendarView alloc]initWithFrame:CGRectMake(0, 60, self.view.bounds.size.width, 200)];
    self.myCalendar.delegate = self;
//    self.myCalendar.calendarDate = [NSDate date];
    
    [self.view addSubview:self.myCalendar];
    
}

-(void)createTableView
{
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 300, self.view.bounds.size.width, self.view.bounds.size.height-330)];
    [self.view addSubview:self.table];
    
    self.table.delegate = self;
    self.table.dataSource = self;
    
}

//-(void)createEditBtn
//{
//    UIButton* btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
//    btn.frame = CGRectMake(290, 20, 20, 20);
//    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
//    [self.view addSubview:btn];
//}
//
//- (void)btnClick:(UIButton* )btn
//{
//    [self presentViewController:[[EditViewController alloc]init] animated:YES completion:^{
//    }];
//}

#pragma mark - CalendarDelegate protocol conformance

-(void)dayChangedToDate:(NSDate *)selectedDate
{
}

#pragma mark - uitableViewdelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

#pragma mark - uitableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell  =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];}
    
    
     return cell;

}

@end
