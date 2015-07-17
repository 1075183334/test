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
@interface SecondCarlendarViewController ()<UITableViewDataSource,UITableViewDelegate,AddCalendarDelegate>
{
    NSMutableArray* _nameSecondMutableArr;
    NSMutableArray* _colorMutableArr;
    UITableView * table;
    NSString* _currentName;
    UIColor* _currentColor;
    AppDelegate* appdelegate;
    NSMutableArray* _dataMutableArr;
    int _currentBtnTag;
}
@property(nonatomic, strong)AddCalendarsViewController *addCalendarController;
@end



@implementation SecondCarlendarViewController

-(void)viewWillAppear:(BOOL)animated
{
    [_nameSecondMutableArr removeAllObjects];
    [_dataMutableArr removeAllObjects];
    [_colorMutableArr removeAllObjects];
    [self showDataFromCoreData];
    [_nameSecondMutableArr addObjectsFromArray:_dataMutableArr];
//    [_nameSecondMutableArr addObject:@"Add Calendar"];
    [table reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Calendars";
    self.view.backgroundColor = [UIColor whiteColor];
    appdelegate = [UIApplication sharedApplication].delegate;
    _dataMutableArr = [[NSMutableArray alloc]init];
    _nameSecondMutableArr = [[NSMutableArray alloc]init];
    _colorMutableArr = [[NSMutableArray alloc]init];
    
//    [self showDataFromCoreData];
//    [_nameSecondMutableArr addObjectsFromArray:_dataMutableArr];
//    [_nameSecondMutableArr addObject:@"Add Calendar"];
    
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
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 60)];
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
    self.addCalendarController.methodString = @"add";
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
//    if (indexPath.row <= [_nameSecondMutableArr count]) {
        self.addCalendarController.methodIndex = indexPath.row;
        self.addCalendarController.methodString = @"change";
        
        self.addCalendarController.nameSring = [_nameSecondMutableArr objectAtIndex:indexPath.row];
    
    
    
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

    UILabel* lable = [[UILabel alloc]initWithFrame:CGRectMake(305, 15, 10, 10)];
    lable.backgroundColor = [self returnColorWithString:[_colorMutableArr objectAtIndex:indexPath.row]];
    [cell addSubview:lable];
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self deleteData:[_nameSecondMutableArr objectAtIndex:indexPath.row]];

        [_nameSecondMutableArr removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        
    }
    
}

/**
 *  删除记录
 */
-(void)deleteData:(NSString*)str
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Calendar" inManagedObjectContext:appdelegate.managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setIncludesPropertyValues:NO];
    [request setEntity:entity];
    NSError *error = nil;
    NSArray *datas = [appdelegate.managedObjectContext executeFetchRequest:request error:&error];
//    NSLog(@"%@",datas);
    if (!error && datas && [datas count])
    {
        for (Calendar *obj in datas)
        {
            if ([obj.calName isEqualToString:str])
            {
//                 NSLog(@"%@== %@",obj.calName,str);
                [appdelegate.managedObjectContext deleteObject:obj];
            }
            
           
        }
        if (![appdelegate.managedObjectContext save:&error])
        {
            NSLog(@"error:%@",error);
        }
    }
}

#pragma mark - AddCalendarDelegate
-(void)AddcalendarName:(NSString *)name withColor:(UIColor *)color withMethod:(NSString *)method withIndex:(int)index withBtnIndex:(int)btnIndex
{
//    NSLog(@"%@=-－=%@",_nameSecondMutableArr,_colorMutableArr);

    if ([method isEqualToString:@"change"]) {
        [_nameSecondMutableArr replaceObjectAtIndex:index withObject:name];
        [_colorMutableArr replaceObjectAtIndex:index withObject:name];
        [table reloadData];
        return;
    }
    if ([method isEqualToString:@"add"]) {
        [_nameSecondMutableArr addObject:name];
        [table reloadData];
    }
    
    _currentName = name;
    _currentColor = color;
    _currentBtnTag = btnIndex;
   
}

-(void)showDataFromCoreData
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Calendar" inManagedObjectContext:appdelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError* error;
    NSArray *fetchedObjects = [appdelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (Calendar *info in fetchedObjects) {
        
//        NSLog(@"Name: %@", info.calName);
        [_dataMutableArr addObject:info.calName];
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
