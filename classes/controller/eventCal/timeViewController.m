//
//  timeViewController.m
//  calendar
//
//  Created by 晓东 on 15/7/16.
//  Copyright (c) 2015年 APPXY. All rights reserved.
//

#import "timeViewController.h"

@interface timeViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray* _timeArr;
}
@property (weak, nonatomic) IBOutlet UITableView *timeTable;


@end

@implementation timeViewController

-(instancetype)init{
    self = [super init];
    
      _timeArr = [NSArray arrayWithObjects:@"None",@"At time of event",@"5 minutes before",@"15 minutes before",@"1 hour before",@"1 day before", nil];
    
    return self;
}

-(void)setTimeString:(NSString *)timeString
{
    if ([timeString isEqualToString:_timeString]) {
        return;
    }
    _timeString = timeString;
//    NSLog(@"%lu",(unsigned long)[_timeArr indexOfObject:_timeString]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
  self.title = @"Notification";
    _timeTable.delegate = self;
    _timeTable.dataSource = self;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(DoneClick)];
}


-(void)DoneClick
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 5;
    }
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        cell.textLabel.text = [_timeArr objectAtIndex:0];
        if ([_timeArr indexOfObject:_timeString] == 0) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    if (indexPath.section == 1) {
        cell.textLabel.text = [_timeArr objectAtIndex:indexPath.row+1];
        if ([_timeArr indexOfObject:_timeString] == indexPath.row+1) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSArray *array = [tableView visibleCells];
        for (UITableViewCell *cell in array) {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            
        }
        UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        if ([_delegate respondsToSelector:@selector(returnTime:)]) {
            [_delegate returnTime:[_timeArr objectAtIndex:0]];
        }
    }
    
    
     if (indexPath.section == 1)
     {
    NSArray *array = [tableView visibleCells];
    for (UITableViewCell *cell in array) {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        
    }
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
     
    if ([_delegate respondsToSelector:@selector(returnTime:)]) {
         [_delegate returnTime:[_timeArr objectAtIndex:indexPath.row+1]];
    }}
}
@end
