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
    UITextView* _titleTextView;
    UITextView* _noteTextView;
    ViewController* _viewVc;
    UILabel* _lable;
    
    BOOL _isShowNoteCell;
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
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _lable = [[UILabel alloc]initWithFrame:CGRectMake(305, 15, 10, 10)];
    _titleTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 100)];
    _noteTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 70)];
    _isShowNoteCell = NO;
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

-(NSString*)changeDateToString:(NSDate*)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter stringFromDate:date];
}


#pragma mark - uitableViewdelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 101;
    }
    if (indexPath.row == 1 ||indexPath.row ==2 ||indexPath.row == 4) {
        return 40;
    }
    if (indexPath.row == 3) {
        if(_isShowNoteCell)
        {
//             _noteTextView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 120);
            
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
                
                CGRect textFrame=[[_noteTextView layoutManager]usedRectForTextContainer:[_noteTextView textContainer]];
             _noteTextView.frame = CGRectMake(5, 0, self.view.bounds.size.width-10, textFrame.size.height+17);

                return  textFrame.size.height+18;
                
            }
//                else {
//                _noteTextView.frame = CGRectMake(5, 0, self.view.bounds.size.width-10, _noteTextView.contentSize.height);
//                return  _noteTextView.contentSize.height+18;
//            }
            
            _isShowNoteCell = NO;
        }
        else
        {
            [UIView animateWithDuration:0.5 animations:^{
                _noteTextView.frame = CGRectMake(5, 0, self.view.bounds.size.width-10, 70);
            }];
              return 71;
            _isShowNoteCell = YES;
        }
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
    AppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
    static NSString *CellIdentifier = @"cell1";
    UITableViewCell *cell  =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];}
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.clipsToBounds = YES;

    if (indexPath.row == 0) {
        
        _titleTextView.userInteractionEnabled = NO;
//         NSLog(@"\n%@,\n%@,\n%@,\n%@",_eventCal.date,_eventCal.startTime,[NSDate dateWithTimeInterval:(24*60*60) sinceDate:_eventCal.date],_eventCal.endTime);
        if (_eventCal.eventName.length>0) {
            
            if(_eventCal.eventAllday == 0)
            {
                
            
            _titleTextView.text = [NSString stringWithFormat:@" %@ \n %@\n \n %@ \n %@",_eventCal.eventName,_eventCal.eventLocal,[self changeDateDayToString:_eventCal.startTime],[self changeDateDayToString:_eventCal.endTime]];
            
            _titleTextView.font = [UIFont systemFontOfSize:15];
        }else
        {
            if ([_eventCal.startTime isEqualToDate:_eventCal.endTime]) {
                _titleTextView.text = [NSString stringWithFormat:@" %@ \n %@\n \n All Day for %@ ",_eventCal.eventName,_eventCal.eventLocal,[self changeDateToString:_eventCal.startTime]];
            }else
            _titleTextView.text = [NSString stringWithFormat:@" %@ \n %@\n \n All Day for %@ \n %@",_eventCal.eventName,_eventCal.eventLocal,[self changeDateToString:_eventCal.startTime],[self changeDateToString:_eventCal.endTime]];
            
            _titleTextView.font = [UIFont systemFontOfSize:15];
            
        }
        }
        _titleTextView.autoresizesSubviews = YES;
        [cell addSubview:_titleTextView];
    }
    else if (indexPath.row == 3) {
        _noteTextView.userInteractionEnabled = NO;
        if (_eventCal.eventNote.length > 0) {
            _noteTextView.text = _eventCal.eventNote?_eventCal.eventNote:_noteTextView.text;
            _noteTextView.font = [UIFont systemFontOfSize:15];
        }else
        {
            _noteTextView.text = @"No Note";
            _noteTextView.font = [UIFont systemFontOfSize:15];

        }
        
        _noteTextView.autoresizesSubviews = YES;
        [cell addSubview:_noteTextView];
    }
    else if (indexPath.row == 1)
    {
        cell.textLabel.text = @"Calendar";
        if (_eventCal.eventCalendar.calName.length > 0) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",_eventCal.eventCalendar.calName];
            _lable.backgroundColor = [appDelegate returnColorWithTag:[_eventCal.eventCalendar.calColor integerValue]];
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
        cell.detailTextLabel.text = _eventCal.eventNotif;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }
    else if (indexPath.row == 4)
    {
        cell.textLabel.text = @"Show all note";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else
    {
        cell.textLabel.text = @"";
    }
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 4) {
        _isShowNoteCell = !_isShowNoteCell;
        [tableView beginUpdates];
        [tableView endUpdates];
    }
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


@end
