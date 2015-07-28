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
//#import "AppDelegate.h"
#import "DataClass.h"
@interface AddCalendarsViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UIAlertView* _alert;
}
@property(nonatomic, strong)UITextField* text;
@property(nonatomic, strong)UITableView* tableView;
//@property(nonatomic, strong)AppDelegate* appdelegate;
@end

@implementation AddCalendarsViewController
@synthesize editedCalendar;
@synthesize selectedBtn;
-(void)setBtnTag:(int)btnTag{
    
    if (_btnTag == btnTag) {
        return;
    }
    _btnTag = btnTag;
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor  = [UIColor whiteColor];
    self.title = @"Add Calendars";
//    for (UIViewController *subVC in self.navigationController.viewControllers) {
//        if ([subVC isKindOfClass:[CalendarsViewController class]]) {
//            self.delegate = subVC;
//        }
//    }
//    self.appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [self createTwobtn];
    [self createTable];
    _alert = [[UIAlertView alloc] initWithTitle:@"请输入calName"
                                        message:nil
                                       delegate:self
                              cancelButtonTitle:nil
                              otherButtonTitles:@"确定",nil];
    [self.view addSubview:_alert];
}


-(void)createTwobtn
{

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(CancelVic)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(SaveBtn)];
    
    _text = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width-20, 30)];
    _text.keyboardType = UIKeyboardTypeNamePhonePad;//键盘显示类型
    _text.returnKeyType = UIReturnKeyDone;
    _text.delegate = self;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [_text becomeFirstResponder];
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
  
    _text.text = @"";
    _text.placeholder = @"Calendar Name";

    if(self.editedCalendar == nil)
    {
        self.title = @"Add Calendar";
        _text.text = @"";
        _btnTag = 0;
    }
    else
    {
        self.title = @"Edit Calendar";
        _text.text = self.editedCalendar.calName;
        _btnTag = [self.editedCalendar.calColor intValue];
    }
    [self.tableView reloadData];
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.editedCalendar = nil;
    self.title = nil;
    _text.text = nil;
    _btnTag = 0;
    
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
    if (_text.text.length == 0) {
        [_alert show];
        return;
    }
    
    BOOL isAdd = NO;
    if(self.editedCalendar == nil)
    {
        isAdd = YES;
        self.editedCalendar = [NSEntityDescription insertNewObjectForEntityForName:@"Calendar" inManagedObjectContext:[DataClass shareDelegate].managedObjectContext];
    }
    self.editedCalendar.calName = _text.text;
    self.editedCalendar.calColor = [NSString stringWithFormat:@"%d",_btnTag];
    [[DataClass shareDelegate] saveContext];

    if(!isAdd)
    {
        if ([self.delegate respondsToSelector:@selector(updatedCalendarObj:)])
        {
            [self.delegate updatedCalendarObj:self.editedCalendar];
        }
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
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_text resignFirstResponder];
}

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
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 300)];
        [cell addSubview:view];
        [self createViewColor:view];
    }
    
    return cell;
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString* string ;
    if (section == 1) {
        string = @"Color";
    }
    return string;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}


-(void)createViewColor:(UIView *)view
{
    AppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
    for (int i= 0; i<[appDelegate.colorsArray count]; i++) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat colorW = 70;
        CGFloat colorH = 70;
        btn.backgroundColor = [appDelegate.colorsArray objectAtIndex:i];
        [btn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
        btn.frame = CGRectMake(marginColor+(marginColor+colorH)*(i%4), marginColor+(marginColor+colorH)*(i/4), colorW, colorH);
        btn.tag = i;
        if(i == _btnTag)
        {
            btn.selected = YES;
            self.selectedBtn = btn;
        }
        else
        {
            btn.selected = NO;
        }
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        
       
    }
}



-(void)btnClick:(UIButton*)btn
{
    selectedBtn.selected = NO;
    [btn setSelected:YES];
    selectedBtn = btn;
    _btnTag = btn.tag;
}



@end
