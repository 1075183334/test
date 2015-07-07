//
//  AddCalendarsViewController.m
//  calendar
//
//  Created by 晓东 on 15/7/6.
//  Copyright (c) 2015年 APPXY. All rights reserved.
//

#define marginColor 8

#import "AddCalendarsViewController.h"
#import "CalendarsViewController.h"
#import "Calendar.h"
#import "AppDelegate.h"
@interface AddCalendarsViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UIColor* _currentColor;
    NSArray* _arrColor;
    NSMutableArray* _dataArray;
    NSString* _judgeString;
}
@property(nonatomic, strong)UITextField* text;
@property(nonatomic, strong)UITableView* tableView;
@property(nonatomic, strong)AppDelegate* appdelegate;
@property(nonatomic, strong)NSMutableArray* BtnArray;
@end

@implementation AddCalendarsViewController

-(void)setMethodString:(NSString *)methodString
{
    if ([_methodString isEqualToString:methodString]) {
        return;
    }
    _methodString = methodString;
    _text.placeholder = @"Calendar Name";
}

-(void)setNameSring:(NSString *)nameSring
{
    if ([_nameSring isEqualToString:nameSring]) {
        return;
    }
    _nameSring = nameSring;
    _text.placeholder = _nameSring;
}

-(void)setMethodIndex:(int)methodIndex
{
    if (_methodIndex == methodIndex) {
        return;
    }
    _methodIndex = methodIndex;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Add Calendar";
    self.view.backgroundColor  = [UIColor whiteColor];
//    for (UIViewController *subVC in self.navigationController.viewControllers) {
//        if ([subVC isKindOfClass:[CalendarsViewController class]]) {
//            self.delegate = subVC;
//        }
//    }
    self.appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    _BtnArray = [[NSMutableArray alloc]init];
    [self createTwobtn];
    [self createTable];
}
-(void)createTwobtn
{
    _arrColor = [NSArray arrayWithObjects:[UIColor darkGrayColor],[UIColor lightGrayColor],[UIColor grayColor],[UIColor redColor],[UIColor greenColor],[UIColor blueColor],[UIColor cyanColor],[UIColor yellowColor],[UIColor magentaColor],[UIColor orangeColor],[UIColor purpleColor],[UIColor brownColor], nil];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(CancelVic)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(SaveBtn)];
    
    _text = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    
    _text.keyboardType = UIKeyboardTypeNamePhonePad;//键盘显示类型
    _text.returnKeyType = UIReturnKeyDone;
    _text.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    _text.text = nil;
}
-(void)createTable
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

-(void)CancelVic
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)SaveBtn
{
   
    if ([self.delegate respondsToSelector:@selector(AddcalendarName:withColor:withMethod:withIndex:)])
    {
       
        [self.delegate AddcalendarName:self.text.text  withColor:_currentColor withMethod:_methodString withIndex:_methodIndex];
       
    }
    if ([_methodString isEqualToString:@"change"]) {
        [self updateData:_nameSring withName:_text.text];
    }
    else{
        
        [self saveData];
        
    }


    
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
        return 30;
    
    else
        
        return 242;
}







#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return 1;
    
    else
        
        return 1;
    
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
      
        [cell addSubview:_text];
    }
    if (indexPath.section == 1) {
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
        [cell addSubview:view];
        [self createViewColor:view];
    }
    
    return cell;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [_dataArray addObject:textField.text];
}
/**
 * 
 + (UIColor *)blackColor;      // 0.0 white
 + (UIColor *)darkGrayColor;   // 0.333 white
 + (UIColor *)lightGrayColor;  // 0.667 white
 + (UIColor *)whiteColor;      // 1.0 white
 + (UIColor *)grayColor;       // 0.5 white
 + (UIColor *)redColor;        // 1.0, 0.0, 0.0 RGB
 + (UIColor *)greenColor;      // 0.0, 1.0, 0.0 RGB
 + (UIColor *)blueColor;       // 0.0, 0.0, 1.0 RGB
 + (UIColor *)cyanColor;       // 0.0, 1.0, 1.0 RGB
 + (UIColor *)yellowColor;     // 1.0, 1.0, 0.0 RGB
 + (UIColor *)magentaColor;    // 1.0, 0.0, 1.0 RGB
 + (UIColor *)orangeColor;     // 1.0, 0.5, 0.0 RGB
 + (UIColor *)purpleColor;     // 0.5, 0.0, 0.5 RGB
 + (UIColor *)brownColor;      // 0.6, 0.4, 0.2 RGB
 
 */

-(void)createViewColor:(UIView *)view
{
    
    for (int i= 0; i<12; i++) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat colorW = 70;
        CGFloat colorH = 70;
        btn.backgroundColor = [_arrColor objectAtIndex:i];
        [btn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
        btn.frame = CGRectMake(marginColor+(marginColor+colorH)*(i%4), marginColor+(marginColor+colorH)*(i/4), colorW, colorH);
        btn.tag = i;
        [self.BtnArray addObject:btn];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
       
    }
}

-(void)saveData
{
    Calendar *object=[NSEntityDescription insertNewObjectForEntityForName:@"Calendar" inManagedObjectContext:self.appdelegate.managedObjectContext];
    
//    [object setValue:_text.text forKey:@"calName"];
//    [object setValue:[NSString stringWithFormat:@"%@",_currentColor] forKey:@"calColor"];
    object.calName = _text.text;
    object.calColor = [NSString stringWithFormat:@"%@",_currentColor];
    
    [self.appdelegate saveContext];
   
}

- (void)updateData:(NSString*)newsId withName:(NSString*)newName
{
    
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"calName like[cd] %@",newsId];
    
    //首先你需要建立一个request
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Calendar" inManagedObjectContext:self.appdelegate.managedObjectContext]];
    [request setPredicate:predicate];//这里相当于sqlite中的查询条件，具体格式参考苹果文档
    
    NSError *error = nil;
    NSArray *result = [self.appdelegate.managedObjectContext executeFetchRequest:request error:&error];//这里获取到的是一个数组，你需要取出你要更新的那个obj
    for (Calendar *info in result) {
        info.calName = newName;
        info.calColor = [NSString stringWithFormat:@"%@",_currentColor];
    }
    
    //保存
    if ([self.appdelegate.managedObjectContext save:&error]) {
        //更新成功
        NSLog(@"更新成功");
    }
}

- (void)judgeData:(NSString*)oldName
{
    
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"calName like[cd] %@",oldName];
    
    //首先你需要建立一个request
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Calendar" inManagedObjectContext:self.appdelegate.managedObjectContext]];
    [request setPredicate:predicate];//这里相当于sqlite中的查询条件，具体格式参考苹果文档
    
    NSError *error = nil;
    NSArray *result = [self.appdelegate.managedObjectContext executeFetchRequest:request error:&error];//这里获取到的是一个数组，你需要取出你要更新的那个obj
    for (Calendar *info in result) {
        _judgeString = [NSString stringWithString:info.calName];
    }
    
    //保存
    if ([self.appdelegate.managedObjectContext save:&error]) {
        //更新成功
        NSLog(@"更新成功");
    }
}


-(void)btnClick:(UIButton*)btn
{
    
    NSLog(@"%d",btn.tag);
    
  
    for (UIButton* btn in _BtnArray) {
        [btn setSelected:NO];
    }
    [btn setSelected:YES];
    _currentColor = [_arrColor objectAtIndex:btn.tag];
}

@end
