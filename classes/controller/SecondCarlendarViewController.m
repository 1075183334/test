//
//  SecondCarlendarViewController.m
//  calendar
//
//  Created by 晓东 on 15/7/6.
//  Copyright (c) 2015年 APPXY. All rights reserved.
//

#import "SecondCarlendarViewController.h"
#import "AddCalendarsViewController.h"


@interface SecondCarlendarViewController ()<UITableViewDataSource,UITableViewDelegate,AddCalendarDelegate>
{
    NSMutableArray* _nameSecondMutableArr;
    UITableView * table;
    NSString* _currentName;
    UIColor* _currentColor;
}
@property(nonatomic, strong)AddCalendarsViewController *addCalendarController;
@end



@implementation SecondCarlendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Calendars";
    self.view.backgroundColor = [UIColor whiteColor];
    _nameSecondMutableArr = [NSMutableArray arrayWithObjects:@"Add Calendars", nil];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(CancelVic)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(SaveBtn)];
    self.addCalendarController = [[AddCalendarsViewController alloc]init];
    self.addCalendarController.delegate = self;
    [self createTable];
}


-(void)CancelVic
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)SaveBtn
{
    
    if ([self.secondDelegate respondsToSelector:@selector(addSecondCarlendarArray:)]) {
        
        NSMutableArray* mutableArr = [NSMutableArray arrayWithArray:_nameSecondMutableArr];
        [mutableArr removeLastObject];
        NSArray* arr = [NSArray arrayWithArray:mutableArr];
        [self.secondDelegate addSecondCarlendarArray:arr];
    }
    [self.navigationController popViewControllerAnimated:YES];

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
    if (indexPath.row < [_nameSecondMutableArr count]-1) {
        self.addCalendarController.methodIndex = indexPath.row;
        self.addCalendarController.methodString = @"change";
        self.addCalendarController.nameSring = [_nameSecondMutableArr objectAtIndex:indexPath.row];
    }else
    {
        self.addCalendarController.methodString = @"add";
    }
    
    
    [self.navigationController pushViewController:self.addCalendarController animated:YES];
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_nameSecondMutableArr count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell  =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.text = [_nameSecondMutableArr objectAtIndex:indexPath.row];
    if ([indexPath row]==[_nameSecondMutableArr count]-1) {
        cell.textLabel.textColor = [UIColor grayColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_nameSecondMutableArr removeObjectAtIndex:indexPath.row];
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        
    }
    
}

#pragma mark - AddCalendarDelegate
-(void)AddcalendarName:(NSString *)name withColor:(UIColor *)color withMethod:(NSString *)method withIndex:(int)index
{
    if (name.length ==0 ) {
        return;
    }
    if ([method isEqualToString:@"change"]) {
        [_nameSecondMutableArr replaceObjectAtIndex:index withObject:name];
        [table reloadData];
        return;
    }
    if ([method isEqualToString:@"add"]) {
        [_nameSecondMutableArr insertObject:name atIndex:[_nameSecondMutableArr count]-1];
        
        [table reloadData];
    }
    
    _currentName = name;
    _currentColor = color;
   
}


@end
