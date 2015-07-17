//
//  TodayViewController.m
//  calendar
//
//  Created by 晓东 on 15/7/6.
//  Copyright (c) 2015年 APPXY. All rights reserved.
//

#import "TodayViewController.h"
#import "AppDelegate.h"
#import "Calendar.h"
#import "Event.h"
@interface TodayViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* _tableView;
    NSMutableArray   *eventArray;
}
@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Today";
    self.view.backgroundColor = [UIColor whiteColor];
    eventArray = [NSMutableArray array];
    [self createTableView];
    [self showDataFromCoredata];

}
-(void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UITableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [eventArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
//    Calendar* cal = [_dataArr objectAtIndex:indexPath.row];
    Event *event = eventArray[indexPath.row];
    cell.textLabel.text = event.eventName;
    cell.detailTextLabel.text = [[event.startTime description] substringToIndex:19];
//    NSLog(@"%@",cal);
    
    return cell;
   
}

-(void)showDataFromCoredata
{
    AppDelegate* myappdelegate = [UIApplication sharedApplication].delegate;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"calCheck == 1"];
    
    //首先你需要建立一个request
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Calendar" inManagedObjectContext:myappdelegate.managedObjectContext]];
    [request setPredicate:predicate];//这里相当于sqlite中的查询条件，具体格式参考苹果文档
    
    NSError *error = nil;
    NSArray *result = [myappdelegate.managedObjectContext executeFetchRequest:request error:&error];//这里获取到的是一个数组，你需要取出你要更新的那个obj
    //    for (Event *info in result) {
    //    NSLog(@"result==%@  %@",info.date,info.eventName);
    //    }
//    NSLog(@"%@",result);
    [eventArray removeAllObjects];
    for (Calendar *cal in result) {
        [eventArray addObjectsFromArray:[cal.calEvents allObjects]];
    }
}

@end
