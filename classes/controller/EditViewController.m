//
//  EditViewController.m
//  calendar
//
//  Created by APPXY on 15/7/2.
//  Copyright (c) 2015年 APPXY. All rights reserved.
//

#import "EditViewController.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "Calendar.h"
@interface EditViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITextView* _textView;
    ViewController* _viewVc;
    UILabel* _lable;
}
@property(nonatomic, strong)UITableView* tableView;

@end

@implementation EditViewController

-(void)setEventCal:(Event *)eventCal
{
    if (_eventCal == eventCal) {
        return;
    }
    if (eventCal == nil) {
        _eventCal = nil;
    }
    _eventCal = eventCal;
//    NSLog(@"\n%@  \n%@  \n%@",_eventCal.date,_eventCal.startTime,_eventCal.endTime);
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _lable = [[UILabel alloc]initWithFrame:CGRectMake(305, 15, 10, 10)];

    [self createTableView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

-(void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(showEditVc)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
}

-(void)showEditVc
{
    ViewController *viewVC = [[ViewController alloc] init];
    viewVC.eventName = _eventCal;
    [self.navigationController pushViewController:viewVC animated:YES];
}



#pragma mark - uitableViewdelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 100;
    }
    if (indexPath.row == 1 ||indexPath.row ==2 ||indexPath.row == 4) {
        return 40;
    }
    if (indexPath.row == 3) {
        return 100;
    }
    return 80;
}

#pragma mark - uitableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell1";
    UITableViewCell *cell  =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];}
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 100)];
        _textView.userInteractionEnabled = NO;
//         NSLog(@"\n%@,\n%@,\n%@,\n%@",_eventCal.date,_eventCal.startTime,[NSDate dateWithTimeInterval:(24*60*60) sinceDate:_eventCal.date],_eventCal.endTime);
        if (_eventCal.eventName.length>0) {
            if ([_eventCal.date isEqualToDate: _eventCal.startTime] && [[NSDate dateWithTimeInterval:(24*60*60) sinceDate:_eventCal.date] isEqualToDate: _eventCal.endTime]) {
                _textView.text = [NSString stringWithFormat:@" %@ \n %@\n \n All Day",_eventCal.eventName,_eventCal.eventLocal];
            }else
            {
            _textView.text = [NSString stringWithFormat:@" %@ \n %@\n \n %@ \n %@",_eventCal.eventName,_eventCal.eventLocal,[self changeDateDayToString:_eventCal.startTime],[self changeDateDayToString:_eventCal.endTime]];
            }
            _textView.font = [UIFont systemFontOfSize:15];
        }

        _textView.autoresizesSubviews = YES;
        [cell addSubview:_textView];
    }
    else if (indexPath.row == 3) {
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 100)];
        _textView.userInteractionEnabled = NO;
        if (_eventCal.eventNote.length > 0) {
            _textView.text = [NSString stringWithFormat:@" %@",_eventCal.eventNote];
            _textView.font = [UIFont systemFontOfSize:15];
        }
        
        _textView.autoresizesSubviews = YES;
        [cell addSubview:_textView];
    }
    else if (indexPath.row == 1)
    {
        cell.textLabel.text = @"Calendar";
        if (_eventCal.eventCalendar.calName.length > 0) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",_eventCal.eventCalendar.calName];
            _lable.backgroundColor = [self returnColorWithString:_eventCal.eventCalendar.calColor];
            [cell addSubview:_lable];
        }else
        {
            cell.detailTextLabel.text = nil;
            [_lable removeFromSuperview];
        }

        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (indexPath.row == 2)
    {
        cell.textLabel.text = @"Notification";
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }
    else if (indexPath.row == 4)
    {
        cell.textLabel.text = @"Show all note";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}

- (NSArray*)getData:(NSString*)newsId
{
    AppDelegate* myappdelegate = [UIApplication sharedApplication].delegate;
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"date like[cd] %@",newsId];
    
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

-(NSString*)changeDateDayToString:(NSDate*)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //    NSLog(@"%@",[dateFormatter stringFromDate:date]);
    return [dateFormatter stringFromDate:date];
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
