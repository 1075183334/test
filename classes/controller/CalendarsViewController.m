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
    NSMutableArray* _DataNutableArr;
    AppDelegate *appdelegate;
    NSMutableArray* _colorMutableArr;
    
    NSMutableArray *contacts;
    UIButton *button;
    NSMutableArray* checkMutableArr;
}
@property (strong,nonatomic)NSIndexPath *lastpath ;
@property(nonatomic, strong)UITableView* tableView;
@property(nonatomic, strong)SecondCarlendarViewController *secondController;
@property(nonatomic, strong)UITableViewCell* cell;
@end

@implementation CalendarsViewController

-(void)viewWillAppear:(BOOL)animated
{
    [_DataNutableArr removeAllObjects];
    [_colorMutableArr removeAllObjects];
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
    _DataNutableArr = [[NSMutableArray alloc]init];
    _colorMutableArr = [[NSMutableArray alloc]init];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(showNextVic)];
    
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneBtn)];
   
    [self createTable];

}

-(void)tableViewCheckImage
{
    [contacts removeAllObjects];
    contacts = [NSMutableArray array];
    for (int i = 0; i <[_DataNutableArr count]; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"NO" forKey:@"checked"];
        [contacts addObject:dic];
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
        [(UIButton*)sender setTitle:@"取消" forState:UIControlStateNormal];
    }else{
        for (NSDictionary *dic in contacts) {
            [dic setValue:@"NO" forKey:@"checked"];
        }
        [(UIButton*)sender setTitle:@"全选" forState:UIControlStateNormal];
    }
    
}


-(void)doneBtn
{
//    NSLog(@"%@",contacts);
    for (int i=0 ;i < [_DataNutableArr count] ; i++) {
        Calendar* cal = [checkMutableArr objectAtIndex:i];
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
        [self.tableView reloadData];
        
          
            
        }}
    
}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return 1;
    
    else
    
        return [_DataNutableArr count];
    
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
        button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTitle:@"全选" forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
        button.frame = CGRectMake(0, 0, self.view.bounds.size.width, 40);
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
            
       
           
            cell.textLabel.text = [_DataNutableArr objectAtIndex:indexPath.row];
            UILabel* lable = [[UILabel alloc]initWithFrame:CGRectMake(305, 15, 10, 10)];
            lable.backgroundColor = [self returnColorWithString:[_colorMutableArr objectAtIndex:indexPath.row]];
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
    checkMutableArr = [NSMutableArray arrayWithArray:fetchedObjects];
    for (Calendar *info in fetchedObjects) {
        [_DataNutableArr addObject:info.calName];
        [_colorMutableArr addObject:info.calColor];
        
    }
}

-(UIColor*)returnColorWithString:(NSString*)string
{
    if ([string isEqualToString:@"UIDeviceWhiteColorSpace 0.333333 1"]) {
        return [UIColor darkGrayColor];
    }else if([string isEqualToString:@"UIDeviceWhiteColorSpace 0.666667 1"])
    { return [UIColor lightGrayColor];
    } else if([string isEqualToString:@"UIDeviceWhiteColorSpace 0.5 1"])
    { return [UIColor grayColor];
    }else if([string isEqualToString:@"UIDeviceRGBColorSpace 1 0 0 1"])
    { return [UIColor redColor];
    }else if([string isEqualToString:@"UIDeviceRGBColorSpace 0 1 0 1"])
    { return [UIColor greenColor];
    }else if([string isEqualToString:@"UIDeviceRGBColorSpace 0 0 1 1"])
    { return [UIColor blueColor];
    }else if([string isEqualToString:@"UIDeviceRGBColorSpace 0 1 1 1"])
    { return [UIColor cyanColor];
    }else if([string isEqualToString:@"UIDeviceRGBColorSpace 1 1 0 1"])
    { return [UIColor yellowColor];
    }else if([string isEqualToString:@"UIDeviceRGBColorSpace 1 0 1 1"])
    { return [UIColor magentaColor];
    }else if([string isEqualToString:@"UIDeviceRGBColorSpace 1 0.5 0 1"])
    { return [UIColor orangeColor];
    }else if([string isEqualToString:@"UIDeviceRGBColorSpace 0.5 0 0.5 1"])
    {   return [UIColor purpleColor];
    }else if([string isEqualToString:@"UIDeviceRGBColorSpace 0.6 0.4 0.2 1"])
    {   return [UIColor purpleColor];}
    else return [UIColor whiteColor];
    
}
@end
