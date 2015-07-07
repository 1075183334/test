//
//  EditViewController.m
//  calendar
//
//  Created by APPXY on 15/7/2.
//  Copyright (c) 2015年 APPXY. All rights reserved.
//

#import "EditViewController.h"
#import "beganEditViewController.h"
@interface EditViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView* tableView;
@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createEditBtn];
    [self createTableView];
}

-(void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
}

-(void)createEditBtn
{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    btn.frame = CGRectMake(10, 20, 20, 20);
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btn];
    
    UIButton* beganBtn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    beganBtn.frame = CGRectMake(290, 20, 20, 20);
    [beganBtn addTarget:self action:@selector(beganbtnClick) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:beganBtn];
}

-(void)beganbtnClick
{
    [self presentViewController:[[beganEditViewController alloc]init] animated:YES completion:^{
        
    }];
}

-(void)btnClick
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - uitableViewdelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

#pragma mark - uitableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell1";
    UITableViewCell *cell  =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];}
    cell.textLabel.text = @"111";
    
    return cell;
    
}

@end
