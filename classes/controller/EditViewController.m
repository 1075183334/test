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
#import "colorTableViewCell.h"
@interface EditViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITextView* _titleTextView;
    UITextView* _noteTextView;
    ViewController* _viewVc;
    UILabel* _lable;
    
    UILabel* _noteLable;
    UILabel* _titleLable;
    
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
    
    self.title =@"Event Details";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(CancelVic)];

    self.view.backgroundColor = [UIColor whiteColor];
    _lable = [[UILabel alloc]initWithFrame:CGRectMake(305, 15, 10, 10)];
    _titleTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width-20, 120)];
    _titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width-20, 30)];
    _noteLable =  [[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width-20, 40)];
    _noteTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 30, self.view.bounds.size.width-20, 70)];
    [self createTableView];
}
-(void)CancelVic
{
    [self.navigationController popViewControllerAnimated:YES];
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
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
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
        return 121;
        
    }
    if (indexPath.row == 1 ||indexPath.row ==2 ) {
        return 40;
    }
    if (indexPath.row == 3)
    {
//            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
//            CGRect textFrame=[[_noteTextView layoutManager]usedRectForTextContainer:[_noteTextView textContainer]];
//            _noteTextView.frame = CGRectMake(10, 30, self.view.bounds.size.width-20, textFrame.size.height+17);
        
                UIFont *font = [UIFont systemFontOfSize:16.0];
                CGSize size = [_noteTextView.text sizeWithFont:font constrainedToSize:CGSizeMake(300, 9999) lineBreakMode:NSLineBreakByWordWrapping];
                 _noteTextView.frame = CGRectMake(10, 30, self.view.bounds.size.width-20, size.height+40);
                
                return  size.height+40;
            }
    return 70;
}

#pragma mark - uitableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
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
//        NSLog(@"%@",cell.textLabel.font);
        
        _titleTextView.userInteractionEnabled = NO;
//         NSLog(@"\n%@,\n%@,\n%@,\n%@",_eventCal.date,_eventCal.startTime,[NSDate dateWithTimeInterval:(24*60*60) sinceDate:_eventCal.date],_eventCal.endTime);
        if (_eventCal.eventName.length>0) {
            
            if(_eventCal.eventAllday == 0)
            {
            _titleTextView.text = [NSString stringWithFormat:@"\n%@\n \n%@\n%@",_eventCal.eventLocal,[self changeDateDayToString:_eventCal.startTime],[self changeDateDayToString:_eventCal.endTime]];
            
            _titleTextView.font = [UIFont systemFontOfSize:16];
        }else
        {
            if ([_eventCal.startTime isEqualToDate:_eventCal.endTime] || [[self changeDateToString:_eventCal.startTime] isEqualToString:[self changeDateToString:_eventCal.endTime]]) {
                _titleTextView.text = [NSString stringWithFormat:@"\n%@\n\nAll Day for %@ ",_eventCal.eventLocal,[self changeDateToString:_eventCal.startTime]];
            }else
            _titleTextView.text = [NSString stringWithFormat:@"\n%@\n\nAll Day for %@\n%@",_eventCal.eventLocal,[self changeDateToString:_eventCal.startTime],[self changeDateToString:_eventCal.endTime]];
            
            _titleTextView.font = [UIFont systemFontOfSize:17];
            
        }
        }
       
        _titleLable.text = [NSString stringWithFormat:@" %@",_eventCal.eventName];
        _titleLable.font = [UIFont boldSystemFontOfSize:17];
        [_titleTextView addSubview:_titleLable];
        _titleTextView.textColor = [UIColor grayColor];
        _titleTextView.autoresizesSubviews = YES;
        [cell addSubview:_titleTextView];
    }
    else if (indexPath.row == 3) {
        _noteTextView.userInteractionEnabled = NO;
    
        if (_eventCal.eventNote.length > 0) {
            _noteTextView.text = [NSString stringWithFormat:@"%@",_eventCal.eventNote?_eventCal.eventNote:_noteTextView.text];
        }else
        {
            _noteTextView.text = @"No Note";

        }
        _noteLable.text = @" Note";
        _noteLable.font = [UIFont boldSystemFontOfSize:17];
        _noteTextView.textColor = [UIColor colorWithRed:69/255.0 green:69/255.0 blue:69/255.0 alpha:1.0];
        [cell addSubview:_noteLable];
        _noteTextView.font = [UIFont systemFontOfSize:16];
        _noteTextView.autoresizesSubviews = YES;
        [cell addSubview:_noteTextView];
    }
    else if (indexPath.row == 1)
    {
        colorTableViewCell* cell = [[[NSBundle mainBundle]loadNibNamed:@"colorTableViewCell" owner:nil options:nil]lastObject];
        
        cell.calCellNameView.text = @"Calendar";
        if (_eventCal.eventCalendar.calName.length > 0) {
            cell.calCellColorNameView.text  = [NSString stringWithFormat:@"%@",_eventCal.eventCalendar.calName];
            cell.calCellColorNameView.textColor = [UIColor grayColor];
            cell.calCellColorView.backgroundColor = [appDelegate returnColorWithTag:[_eventCal.eventCalendar.calColor intValue]];
            [cell addSubview:_lable];
        }else
        {
            cell.calCellColorNameView.text = nil;
            [_lable removeFromSuperview];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.row == 2)
    {
        cell.textLabel.text = @"Notification";
        cell.detailTextLabel.text = _eventCal.eventNotif;
    }
    return cell;
}



-(NSString*)changeDateDayToString:(NSDate*)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter stringFromDate:date];
}

-(NSString*)changeDateToString:(NSDate*)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter stringFromDate:date];
}

@end
