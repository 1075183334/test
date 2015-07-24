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
#import "Calendar.h"
#import "Event.h"
#import "AppDelegate.h"
#import "ViewController.h"

#define tableViewMargin 100

@interface mainViewController ()<CalendarDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIViewController* _currentViewController;
    NSMutableArray* _dataMutableArr;
    EditViewController* _editVc;
    CalendarsViewController * calendarsVic;
    NSDate* _date;
    AppDelegate* myappdelegate;
    NSMutableArray* _allEventArray;
}
@property(nonatomic, strong)CalendarView* myCalendar;
@property(nonatomic, strong)UITableView* table;
@end

@implementation mainViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _dataMutableArr = [self returnNewDateArr:[NSMutableArray arrayWithArray:[self getData:_date]]];
     [self.table reloadData];
     [self.myCalendar reload];
}

-(NSMutableArray*)returnNewDateArr:(NSMutableArray*)oldDateArr
{
    NSMutableArray* newDateArr = [[NSMutableArray alloc]init];
    for (int i = 0; i < [oldDateArr count]; i++) {
        Event* event = [oldDateArr objectAtIndex:i];
        if ([event.eventCalendar.calCheck isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            [newDateArr addObject:event];
        }
    }
    return newDateArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _allEventArray                         = [[NSMutableArray alloc]init];
    self.view.backgroundColor              = [UIColor whiteColor];
    UIButton* btn                          = [UIButton buttonWithType:UIButtonTypeContactAdd];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [btn addTarget:self action:@selector(EditClick) forControlEvents:UIControlEventTouchUpInside];
    _dataMutableArr                        = [[NSMutableArray alloc]init];
    _date                                  = [[NSDate alloc]init];
    myappdelegate                          = [UIApplication sharedApplication].delegate;
    calendarsVic                           = [[CalendarsViewController alloc]init];
    [self createCalendar];
    [self createTableView];
    [self createChildVic];
}

-(void)EditClick
{
    ViewController* viewVc = [[ViewController alloc]init];
    [self.navigationController pushViewController:viewVc animated:YES];
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
    self.myCalendar.calendarDate = _date;
//    _dataMutableArr = [NSMutableArray arrayWithArray:[self getData:_date]];
    [self.table reloadData];
    [self.myCalendar reload];

}

-(void)showCalendars
{
        [self.navigationController pushViewController:calendarsVic animated:YES];

}
-(void)createCalendar
{
    self.myCalendar = [[CalendarView alloc]initWithFrame:CGRectMake(0, 60, self.view.bounds.size.width, 300)];
  
    if (_date) {
        NSCalendar* cale = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSCalendarUnit calunit =  NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit |NSMinuteCalendarUnit | NSSecondCalendarUnit;
        NSDateComponents *components = [cale components:calunit fromDate:[NSDate date]];
        components.hour   = 0;
        components.minute = 0;
        components.second = 0;
        _date = [cale dateFromComponents:components];
        _dataMutableArr = [NSMutableArray arrayWithArray:[self getData:_date]];
        NSUserDefaults* defaults  = [NSUserDefaults standardUserDefaults];
        [defaults setObject:_date forKey:@"selectedDate"];
    }
    self.myCalendar.delegate = self;
//    self.myCalendar.calendarDate = [NSDate date];
    
    [self.view addSubview:self.myCalendar];
    
}

-(void)createTableView
{
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 320, self.view.bounds.size.width, self.view.bounds.size.height-350)];
    [self.view addSubview:self.table];
    
    self.table.delegate = self;
    self.table.dataSource = self;
    
}


#pragma mark - CalendarDelegate protocol conformance

-(void)dayChangedToDate:(NSDate *)selectedDate
{
    _date = selectedDate;
     NSUserDefaults* defaults  = [NSUserDefaults standardUserDefaults];
    [defaults setObject:selectedDate forKey:@"selectedDate"];
    _dataMutableArr = [self returnNewDateArr:[NSMutableArray arrayWithArray:[self getData:_date]]];
//    [self getAllData:selectedDate];
    [self.table reloadData];
}

#pragma mark - uitableViewdelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Event* event = [_dataMutableArr objectAtIndex:indexPath.row];
   
    _editVc                                = [[EditViewController alloc]init];
     _editVc.eventCal = event;
    [self.navigationController pushViewController:_editVc animated:YES];
}

#pragma mark - uitableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataMutableArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell  =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];}
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([_dataMutableArr count]>0) {
        
        Event* event = [_dataMutableArr objectAtIndex:indexPath.row];
        
             cell.textLabel.text =[NSString stringWithFormat:@"%@",event.eventName];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",event.eventCalendar.calName];
            UILabel* lable = [[UILabel alloc]initWithFrame:CGRectMake(305, 15, 10, 10)];
            lable.backgroundColor = [myappdelegate returnColorWithTag:[event.eventCalendar.calColor integerValue]];
            [cell addSubview:lable];
           }
    
     return cell;

}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
      
//        Event* event = [_dataMutableArr objectAtIndex:indexPath.row];
        [myappdelegate.managedObjectContext deleteObject:(Event*)[_dataMutableArr objectAtIndex:indexPath.row]];
        [myappdelegate.managedObjectContext save:nil];
        
     [_dataMutableArr removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [self.myCalendar reload];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        
    }
    
}


- (NSArray*)getData:(NSDate*)date
{
    NSDate* nextDate = [NSDate dateWithTimeInterval:24*60*60 sinceDate:date];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(startTime>=%@ and startTime<%@) or (endTime>=%@ and endTime<%@) or (startTime<%@ and endTime>%@) or (startTime = %@ and endTime = %@) or (startTime < %@ and endTime > %@)",date ,nextDate,date,nextDate,date,nextDate,date,nextDate,date,date];
    
    //首先你需要建立一个request
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Event" inManagedObjectContext:myappdelegate.managedObjectContext]];
    [request setPredicate:predicate];//这里相当于sqlite中的查询条件，具体格式参考苹果文档
    
    NSError *error = nil;
    NSArray *result = [myappdelegate.managedObjectContext executeFetchRequest:request error:&error];//这里获取到的是一个数组，你需要取出你要更新的那个obj
//        for (Event *info in result) {
//        NSLog(@"result == %@ %@",info.date,info.eventName);
//        }
//        NSLog(@"%@",result);
    return result;
}

@end
