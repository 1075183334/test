//
//  CalendarsViewController.m
//  calendar
//
//  Created by 晓东 on 15/7/6.
//  Copyright (c) 2015年 APPXY. All rights reserved.
//

#import "CalendarsViewController.h"
#import "SecondCarlendarViewController.h"
@interface CalendarsViewController ()<UITableViewDataSource,UITableViewDelegate,secondCarlendarDelegate>
{
    int _current;
    int _old;
    NSString* _currentTitle;
    NSArray* _nameMutableArr;
}
@property (strong,nonatomic)NSIndexPath *lastpath ;
@property(nonatomic, strong)UITableView* tableView;
@property(nonatomic, strong)SecondCarlendarViewController *secondController;
@property(nonatomic, strong)UITableViewCell* cell;
@end

@implementation CalendarsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Calendars";
    self.view.backgroundColor = [UIColor whiteColor];
    self.secondController = [[SecondCarlendarViewController alloc] init];
    self.secondController.secondDelegate = self;
    _nameMutableArr = [NSArray array];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(showNextVic)];
    
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneBtn)];
    [self createTable];

}

-(void)doneBtn
{
    
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
        
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.text = @"Show all Calendars";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    if (indexPath.section == 1) {
       
       _current = indexPath.row;
        self.cell = [tableView cellForRowAtIndexPath:indexPath];
        if (_current == indexPath.row ) {
            
            self.cell.selected = YES;
            self.cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
        }
        if (_current == _old) {
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            self.cell.accessoryType = UITableViewCellAccessoryNone;
        }
        _old = _current;
      
        
        
        NSLog(@"%d",_current);
        [self.tableView reloadData];
        
 }
    
}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return 1;
    
    else
    
        return [_nameMutableArr count];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell  =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];}
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        cell.textLabel.text = @"Hide all Calendars";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    if (indexPath.section == 1) {

        cell.textLabel.text = [_nameMutableArr objectAtIndex:indexPath.row];
    }
    
    return cell;
}

-(void)addSecondCarlendarArray:(NSArray *)array
{
   
    if ([_nameMutableArr isEqualToArray:array]) {
        return;
    }
    _nameMutableArr = array;
    
    [self.tableView reloadData];
}

@end
