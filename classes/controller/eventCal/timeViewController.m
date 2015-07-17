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

- (void)viewDidLoad {
    [super viewDidLoad];
    _timeArr = [NSArray arrayWithObjects:@"At time of event",@"5 minutes before",@"15 minutes before",@"1 hour before",@"1 day before", nil];
    _timeTable.delegate = self;
    _timeTable.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        cell.textLabel.text = @"None";
    }
    if (indexPath.section == 1) {
        cell.textLabel.text = [_timeArr objectAtIndex:indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     if (indexPath.section == 1)
     {
    NSArray *array = [tableView visibleCells];
    for (UITableViewCell *cell in array) {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        
    }
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
     }
}
@end
