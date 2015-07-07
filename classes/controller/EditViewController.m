//
//  EditViewController.m
//  calendar
//
//  Created by APPXY on 15/7/2.
//  Copyright (c) 2015年 APPXY. All rights reserved.
//

#import "EditViewController.h"
#import "ViewController.h"
@interface EditViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITextView* _textView;
}
@property(nonatomic, strong)UITableView* tableView;

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createTableView];
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
    [self.navigationController pushViewController:[[ViewController alloc]init] animated:YES];
}



#pragma mark - uitableViewdelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 100;
    }
    if (indexPath.row == 1 ||indexPath.row ==2 ||indexPath.row == 4) {
        return 40;
    }
    if (indexPath.row == 3) {
        return 100;
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
    static NSString *CellIdentifier = @"cell1";
    UITableViewCell *cell  =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];}
    if (indexPath.row == 0) {
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 100)];
        [cell addSubview:_textView];
    }
    else if (indexPath.row == 3) {
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 100)];
        [cell addSubview:_textView];
    }
    else if (indexPath.row == 1)
    {
        cell.textLabel.text = @"Calendar";
        cell.detailTextLabel.text = @"work";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (indexPath.row == 2)
    {
        cell.textLabel.text = @"Notification";
        cell.detailTextLabel.text = @"5 min before";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }
    else if (indexPath.row == 4)
    {
        cell.textLabel.text = @"Show all note";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}

@end
