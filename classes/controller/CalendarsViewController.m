//
//  CalendarsViewController.m
//  calendar
//
//  Created by 晓东 on 15/7/6.
//  Copyright (c) 2015年 APPXY. All rights reserved.
//

#import "CalendarsViewController.h"
#import "SecondCarlendarViewController.h"
#import "AppDelegate.h"
#import "Calendar.h"
#import "CalColorTableCell.h"
@interface CalendarsViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSString* _currentTitle;
    AppDelegate *appdelegate;
    NSMutableArray *contacts;
    UIButton *button;
    NSMutableArray* _allDataMutableArr;
}
@property (strong,nonatomic)NSIndexPath *lastpath ;
@property(nonatomic, strong)UITableView* tableView;
@property(nonatomic, strong)SecondCarlendarViewController *secondController;
@end

@implementation CalendarsViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self showDataFromCoreData];
    [self.tableView reloadData];
    [self tableViewCheckImage];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    appdelegate = [UIApplication sharedApplication].delegate;
    self.title = @"Calendars";
    self.view.backgroundColor = [UIColor whiteColor];
    self.secondController = [[SecondCarlendarViewController alloc] init];
    _allDataMutableArr = [[NSMutableArray alloc]init];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(showNextVic)];
    
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneBtn)];
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [button setTitle:@"Cancel" forState:UIControlStateNormal];
    [button setTitle:@"All" forState:UIControlStateSelected];

    button.backgroundColor = [UIColor whiteColor];
    button.frame = CGRectMake(0, 0, self.view.bounds.size.width, 40);

    [self createTable];

}

-(void)tableViewCheckImage
{
    [contacts removeAllObjects];
    contacts = [NSMutableArray array];
    for (int i = 0; i <[_allDataMutableArr count]; i++) {
        Calendar* calendar = [_allDataMutableArr objectAtIndex:i];
        if ([calendar.calCheck boolValue]) {
            [contacts addObject:calendar];
        }
    }
    
    button.selected = (contacts.count != _allDataMutableArr.count);
}

- (void)allSelect:(UIButton*)sender{
    if (contacts.count == _allDataMutableArr.count) {
        [contacts removeAllObjects];
        button.selected = YES;
    }else{
        [contacts removeAllObjects];
        [contacts addObjectsFromArray:_allDataMutableArr];
        button.selected = NO;
    }
    
    [_tableView reloadData];
    
}


-(void)doneBtn
{
    for (Calendar *calendar in _allDataMutableArr) {
        if ([contacts containsObject:calendar]) {
            calendar.calCheck = @(YES);
        }else{
            calendar.calCheck = @(NO);
        }
    }
    [appdelegate saveContext];
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)showNextVic
{
  
    [self.navigationController pushViewController:self.secondController animated:YES];
}

-(void)createTable
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}
#pragma mark - UItableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        
        
    }
    if (indexPath.section == 1) {
       
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        CalColorTableCell *cell = (CalColorTableCell*)[_tableView cellForRowAtIndexPath:indexPath];
        if (cell.checked) {
            cell.checked = NO;
            if ([contacts containsObject:cell.calendar]) {
                [contacts removeObject:cell.calendar];
            }
        }else{
            cell.checked = YES;
            if (![contacts containsObject:cell.calendar]) {
                [contacts addObject:cell.calendar];
            }
        }
        [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        button.selected = (contacts.count != _allDataMutableArr.count);
    }
    
}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return 1;
    
    else
    
        return [_allDataMutableArr count];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"cell";
    CalColorTableCell *cell  =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"CalColorTableCell" owner:nil options:nil] lastObject];
       }
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        
        [button addTarget:self action:@selector(allSelect:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:button];
       
        
    }
    if (indexPath.section == 1) {
        Calendar* calendar = [_allDataMutableArr objectAtIndex:indexPath.row];
        
        BOOL checked = [contacts containsObject:calendar];
        [cell setChecked:checked];
        cell.calendar = calendar;
        cell.calColorNameCellLable.text = calendar.calName;
        cell.calColorCellView.backgroundColor = [appdelegate returnColorWithTag:[calendar.calColor intValue]];
       
    }
    
    return cell;
}


-(void)showDataFromCoreData
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Calendar" inManagedObjectContext:appdelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError* error;
    NSArray *fetchedObjects = [appdelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    _allDataMutableArr = [NSMutableArray arrayWithArray:fetchedObjects];

    
}

@end
