//
//  calendarViewController.m
//  calendar
//
//  Created by APPXY on 15/7/3.
//  Copyright (c) 2015年 APPXY. All rights reserved.
//

#import "calendarViewController.h"
#import "Calendar.h"
#import "AppDelegate.h"
@interface calendarViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* _tableView;
    NSMutableArray* _DataMutableArr;
    NSMutableArray* _ColorMutableArr;
    int _selectedIndex;
}

@end

@implementation calendarViewController
@synthesize colorString;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _DataMutableArr  = [[NSMutableArray alloc]init];
    _ColorMutableArr  = [[NSMutableArray alloc]init];
    [self createTableView];
    [self showDataFromCoreData];
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(SaveBtn)];
}

-(void)viewWillAppear:(BOOL)animated
{
//    NSLog(@"%@",colorString);
}

-(void)SaveBtn
{
    if ([self.delegate respondsToSelector:@selector(calendarViewWithColor:withTitle:)]) {
        [self.delegate calendarViewWithColor:[_ColorMutableArr objectAtIndex:_selectedIndex] withTitle:[_DataMutableArr objectAtIndex:_selectedIndex]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

#pragma mark - UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = [tableView visibleCells];
    for (UITableViewCell *cell in array) {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        cell.textLabel.textColor=[UIColor blackColor];
        
    }
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor=[UIColor blueColor];
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    _selectedIndex = indexPath.row;
//    NSLog(@"%d",_selectedIndex);
  
}

#pragma mark - UITableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_DataMutableArr count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell  =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    cell.textLabel.text = [_DataMutableArr objectAtIndex:indexPath.row];
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    if (colorString) {
        if ([colorString isEqualToString:[_DataMutableArr objectAtIndex:indexPath.row]]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    UILabel* lable = [[UILabel alloc]initWithFrame:CGRectMake(260, 15, 10, 10)];
    AppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
    lable.backgroundColor = [appDelegate returnColorWithTag:[[_ColorMutableArr objectAtIndex:indexPath.row]integerValue]];
    [cell addSubview:lable];
    
    return cell;
}



-(void)showDataFromCoreData
{
    AppDelegate* myappdelegate = [UIApplication sharedApplication].delegate;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Calendar" inManagedObjectContext:myappdelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError* error;
    NSArray *fetchedObjects = [myappdelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (Calendar *info in fetchedObjects) {
        
        //        NSLog(@"Name: %@", info.calName);
        [_DataMutableArr addObject:info.calName];
        [_ColorMutableArr addObject:info.calColor];
    }
//    NSLog(@"%@ %@",_DataMutableArr,_ColorMutableArr);
}



@end
