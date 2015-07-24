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
#import "calColorTableViewCell.h"
@interface CalendarsViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    int _current;
    int _old;
    NSString* _currentTitle;
    AppDelegate *appdelegate;
    NSMutableArray *contacts;
    UIButton *button;
    NSMutableArray* _allDataMutableArr;
}
@property (strong,nonatomic)NSIndexPath *lastpath ;
@property(nonatomic, strong)UITableView* tableView;
@property(nonatomic, strong)SecondCarlendarViewController *secondController;
@property(nonatomic, strong)UITableViewCell* cell;
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
    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.backgroundColor = [UIColor whiteColor];
    button.frame = CGRectMake(0, 0, self.view.bounds.size.width, 40);

    [self createTable];

}

-(void)tableViewCheckImage
{
    
    int count = 0;
    [contacts removeAllObjects];
    contacts = [NSMutableArray array];
    for (int i = 0; i <[_allDataMutableArr count]; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        Calendar* calendar = [_allDataMutableArr objectAtIndex:i];
        if ([calendar.calCheck isEqualToNumber:[NSNumber numberWithBool:NO]]) {
            [dic setValue:@"NO" forKey:@"checked"];
        }
        else
        {
            [dic setValue:@"YES" forKey:@"checked"];
            count++;

        }
          [contacts addObject:dic];
      
        }
    
    if (count == [_allDataMutableArr count]) {
        [button setTitle:@"取消" forState:UIControlStateSelected];
        [button setSelected:YES];
    }else
    {
        [button setTitle:@"全选" forState:UIControlStateNormal];
        [button setSelected:NO];
    }
}





- (void)allSelect:(UIButton*)sender{
    NSArray *anArrayOfIndexPath = [NSArray arrayWithArray:[_tableView indexPathsForVisibleRows]];
    for (int i = 0; i < [anArrayOfIndexPath count]; i++) {
        NSIndexPath *indexPath= [anArrayOfIndexPath objectAtIndex:i];
        calColorTableViewCell *cell = (calColorTableViewCell*)[_tableView cellForRowAtIndexPath:indexPath];
        NSUInteger row = [indexPath row];
//        NSLog(@"%lu",(unsigned long)row);
        NSMutableDictionary *dic = [contacts objectAtIndex:row];
        if ([[[(UIButton*)sender titleLabel] text] isEqualToString:@"全选"]) {
            [dic setObject:@"YES" forKey:@"checked"];
            [cell setChecked:YES];
        }else {
            [dic setObject:@"NO" forKey:@"checked"];
            [cell setChecked:NO];
        }
    }
    if ([[[(UIButton*)sender titleLabel] text] isEqualToString:@"全选"]){
        for (NSDictionary *dic in contacts) {
            [dic setValue:@"YES" forKey:@"checked"];
        }
        [(UIButton*)sender setTitle:@"取消" forState:UIControlStateSelected];
        [sender setSelected:YES];
    }else{
        for (NSDictionary *dic in contacts) {
            [dic setValue:@"NO" forKey:@"checked"];
        }
        [(UIButton*)sender setTitle:@"全选" forState:UIControlStateNormal];
        [sender setSelected:NO];
    }
    
}


-(void)doneBtn
{
//    NSLog(@"%@",contacts);
    for (int i=0 ;i < [_allDataMutableArr count] ; i++) {
        Calendar* cal = [_allDataMutableArr objectAtIndex:i];
        cal.calCheck = [NSNumber numberWithBool:[self returnBOOLWithCheck:[[contacts objectAtIndex:i] objectForKey:@"checked"]]];
    }
    [appdelegate saveContext];

    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)returnBOOLWithCheck:(NSString*)string
{
    if ([string isEqualToString:@"YES"]) {
        return YES;
    }
    else
        return NO;
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
        
        calColorTableViewCell *cell = (calColorTableViewCell*)[_tableView cellForRowAtIndexPath:indexPath];
        
        NSUInteger row = [indexPath row];
        NSMutableDictionary *dic = [contacts objectAtIndex:row];
        if ([[dic objectForKey:@"checked"] isEqualToString:@"NO"]) {
            [dic setObject:@"YES" forKey:@"checked"];
            [cell setChecked:YES];
        }else {
            [dic setObject:@"NO" forKey:@"checked"];
            [cell setChecked:NO];
        }
        [self.tableView reloadData];
        }
    int YEScount = 0;
    int NOcount = 0;
    for (NSMutableDictionary* dic in contacts) {
        
        if ([[dic objectForKey:@"checked"] isEqualToString:@"NO"]) {
            NOcount++;
        }else
        {
            YEScount++;
        }
        if (NOcount < [contacts count]) {
            [button setTitle:@"全选" forState:UIControlStateNormal];
            [button setSelected:NO];
        }
        if (YEScount == [contacts count]) {
            [button setTitle:@"取消" forState:UIControlStateSelected];
            [button setSelected:YES];
        }
        
        
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
    calColorTableViewCell *cell  =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[calColorTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];}
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        
                [button addTarget:self action:@selector(allSelect:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:button];
       
        
    }
    if (indexPath.section == 1) {
        NSUInteger row = [indexPath row];
        if ([contacts count]>0) {
                NSMutableDictionary *dic = [contacts objectAtIndex:row];
                if ([[dic objectForKey:@"checked"] isEqualToString:@"NO"]) {
                    [dic setObject:@"NO" forKey:@"checked"];
                    [cell setChecked:NO];
                    
                }else {
                    [dic setObject:@"YES" forKey:@"checked"];
                    [cell setChecked:YES];
                }
            Calendar* calendar = [_allDataMutableArr objectAtIndex:indexPath.row];
            cell.textLabel.text = calendar.calName;
            UILabel* lable = [[UILabel alloc]initWithFrame:CGRectMake(305, 15, 10, 10)];
            lable.backgroundColor = [appdelegate returnColorWithTag:[calendar.calColor integerValue]];
            [cell addSubview:lable];

        }
       
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
