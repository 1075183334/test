//
//  SecondCarlendarViewController.m
//  calendar
//
//  Created by 晓东 on 15/7/6.
//  Copyright (c) 2015年 APPXY. All rights reserved.
//

#import "SecondCarlendarViewController.h"
#import "AddCalendarsViewController.h"
#import "AppDelegate.h"
#import "Calendar.h"
#import "PublicClass.h"
@interface SecondCarlendarViewController ()<UITableViewDataSource,UITableViewDelegate,AddCalendarDelegate>
{
    NSMutableArray* allCalendarsArray;
    UITableView * table;
    NSString* _currentName;
    UIColor* _currentColor;
    AppDelegate* appdelegate;
    int _currentBtnTag;
}
@property(nonatomic, strong)AddCalendarsViewController *addCalendarController;
@end



@implementation SecondCarlendarViewController
@synthesize colorsArray;
-(void)viewWillAppear:(BOOL)animated
{
    [allCalendarsArray removeAllObjects];
    [self showDataFromCoreData];
    [table reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Calendars";
    self.view.backgroundColor = [UIColor whiteColor];
    appdelegate = [UIApplication sharedApplication].delegate;
    allCalendarsArray = [[NSMutableArray alloc]init];
    colorsArray = [[NSMutableArray alloc] init];
 
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(CancelVic)];
    self.addCalendarController = [[AddCalendarsViewController alloc]init];
    self.addCalendarController.delegate = self;
    [self createTable];
}


-(void)CancelVic
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    [btn setTitle:@"Add Calendar" forState:UIControlStateNormal];
    [btn  addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    return btn;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section NS_AVAILABLE_IOS(7_0)
{
    return 50;
}


-(void)addClick
{
    [self.navigationController pushViewController:self.addCalendarController animated:YES];
}

-(void)createTable
{
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
   
    [self.view addSubview:table];
}
#pragma mark - UItableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

#pragma mark - UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.addCalendarController.editedCalendar = [allCalendarsArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:self.addCalendarController animated:YES];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [allCalendarsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell  =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.textColor = [UIColor blackColor];
    Calendar * cellCalendar = [allCalendarsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = cellCalendar.calName;

    UILabel* lable = [[UILabel alloc]initWithFrame:CGRectMake(305, 15, 10, 10)];
    lable.backgroundColor = [appDelegate returnColorWithTag:[cellCalendar.calColor integerValue]];
    [cell addSubview:lable];
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self deleteData:[allCalendarsArray objectAtIndex:indexPath.row]];

        [allCalendarsArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    
}

/**
 *  删除记录
 */
-(void)deleteData:(Calendar*)calendarObj
{
    NSError * error = nil;
    [appdelegate.managedObjectContext deleteObject:calendarObj];
    
    if (![appdelegate.managedObjectContext save:&error])
    {
        NSLog(@"error:%@",error);
    }
}

#pragma mark - AddCalendarDelegate
-(void)updatedCalendarObj:(Calendar *)calendarEdited
{
    [table reloadData];
}

-(void)showDataFromCoreData
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Calendar" inManagedObjectContext:appdelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError* error;
    NSArray *fetchedObjects = [appdelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    allCalendarsArray = [NSMutableArray arrayWithArray:fetchedObjects];
 
}


@end
