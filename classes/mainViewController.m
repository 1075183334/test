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
@interface mainViewController ()<CalendarDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIViewController* _currentViewController;
    NSMutableArray* _dataMutableArr;
    EditViewController* _editVc;
    CalendarsViewController * calendarsVic;
    NSDate* _date;
    AppDelegate* myappdelegate;

}
@property(nonatomic, strong)CalendarView* myCalendar;
@property(nonatomic, strong)UITableView* table;
@end

@implementation mainViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getData:_date];
   
     [self.table reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
     _editVc = [[EditViewController alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [btn addTarget:self action:@selector(EditClick) forControlEvents:UIControlEventTouchUpInside];
    _dataMutableArr = [[NSMutableArray alloc]init];
    _date = [[NSDate alloc]init];
    myappdelegate = [UIApplication sharedApplication].delegate;
    calendarsVic = [[CalendarsViewController alloc]init];
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
    TodayViewController* today = [[TodayViewController alloc]init];
    [self.navigationController pushViewController:today animated:YES];
    
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

          NSLog(@"%@",_date);
    }
    self.myCalendar.delegate = self;
//    self.myCalendar.calendarDate = [NSDate date];
    
    [self.view addSubview:self.myCalendar];
    
}

-(void)createTableView
{
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 340, self.view.bounds.size.width, self.view.bounds.size.height-340-30)];
    [self.view addSubview:self.table];
    
    self.table.delegate = self;
    self.table.dataSource = self;
    
}


#pragma mark - CalendarDelegate protocol conformance

-(void)dayChangedToDate:(NSDate *)selectedDate
{
    NSLog(@"%@",selectedDate);
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    NSString *strDate = [dateFormatter stringFromDate:selectedDate];
    _date = selectedDate;
     NSUserDefaults* defaults  = [NSUserDefaults standardUserDefaults];
    [defaults setObject:selectedDate forKey:@"selectedDate"];
    
    _dataMutableArr = [NSMutableArray arrayWithArray:[self getData:_date]];
    [self.table reloadData];
}

#pragma mark - uitableViewdelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Event* event = [_dataMutableArr objectAtIndex:indexPath.row];
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
        lable.backgroundColor = [self returnColorWithString:event.eventCalendar.calColor];
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
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        
    }
    
}

- (NSArray*)getData:(NSDate*)newsId
{
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"date == %@",newsId];
    
    //首先你需要建立一个request
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Event" inManagedObjectContext:myappdelegate.managedObjectContext]];
    [request setPredicate:predicate];//这里相当于sqlite中的查询条件，具体格式参考苹果文档
    
    NSError *error = nil;
    NSArray *result = [myappdelegate.managedObjectContext executeFetchRequest:request error:&error];//这里获取到的是一个数组，你需要取出你要更新的那个obj
//    for (Event *info in result) {
//    NSLog(@"result==%@  %@",info.date,info.eventName);
//    }
//    NSLog(@"%@",result);
    return result;
}

/**
 *  删除记录
 */
-(void)deleteData:(NSString*)str
{
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:myappdelegate.managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setIncludesPropertyValues:NO];
    [request setEntity:entity];
    NSError *error = nil;
    NSArray *datas = [myappdelegate.managedObjectContext executeFetchRequest:request error:&error];
    //    NSLog(@"%@",datas);
    if (!error && datas && [datas count])
    {
        for (Event *obj in datas)
        {
            if ([obj.eventName isEqualToString:str])
            {
                NSLog(@"%@",obj.eventName);
                [myappdelegate.managedObjectContext deleteObject:obj];
            }
            
            
        }
        if (![myappdelegate.managedObjectContext save:&error])
        {
            NSLog(@"error:%@",error);
        }
    }
}


-(UIColor*)returnColorWithString:(NSString*)string
{
    if ([string isEqualToString:@"UIDeviceWhiteColorSpace 0.333333 1"]) {
        return [UIColor darkGrayColor];
    }else if([string isEqualToString:@"UIDeviceWhiteColorSpace 0.666667 1"])
    { return [UIColor lightGrayColor];
    } else if([string isEqualToString:@"UIDeviceWhiteColorSpace 0.5 1"])
    { return [UIColor grayColor];
    }else if([string isEqualToString:@"UIDeviceRGBColorSpace 1 0 0 1"])
    { return [UIColor redColor];
    }else if([string isEqualToString:@"UIDeviceRGBColorSpace 0 1 0 1"])
    { return [UIColor greenColor];
    }else if([string isEqualToString:@"UIDeviceRGBColorSpace 0 0 1 1"])
    { return [UIColor blueColor];
    }else if([string isEqualToString:@"UIDeviceRGBColorSpace 0 1 1 1"])
    { return [UIColor cyanColor];
    }else if([string isEqualToString:@"UIDeviceRGBColorSpace 1 1 0 1"])
    { return [UIColor yellowColor];
    }else if([string isEqualToString:@"UIDeviceRGBColorSpace 1 0 1 1"])
    { return [UIColor magentaColor];
    }else if([string isEqualToString:@"UIDeviceRGBColorSpace 1 0.5 0 1"])
    { return [UIColor orangeColor];
    }else if([string isEqualToString:@"UIDeviceRGBColorSpace 0.5 0 0.5 1"])
    {   return [UIColor purpleColor];
    }else if([string isEqualToString:@"UIDeviceRGBColorSpace 0.6 0.4 0.2 1"])
    {   return [UIColor purpleColor];}
    else return [UIColor whiteColor];
    
}
@end
