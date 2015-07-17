//
//  ViewController.m
//  ExpansionTableViewByZQ
//
//

#import "ViewController.h"
#import "SubCateViewController.h"
#import "AppDelegate.h"
#import "Event.h"
#import "Calendar.h"
#import "timeViewController.h"
#import "calendarViewController.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,UIFolderTableViewDelegate,UITextViewDelegate,UITextFieldDelegate,subCateViewDelegate,calendarDelegate>
{
    NSMutableArray *_dataList;
    UITextField* _nameText;
    UITextField* _localText;
    NSString* _nameString;
    NSString* _localString;
    UITextView * _noteTextView;
    NSDate* _startDate;
    NSDate* _endDate;
    AppDelegate* myappdelegate;
    calendarViewController* _calendarVc;
    NSString* _title;
    NSString* _newColor;
    UILabel* _lable;
    Calendar* _cal;
    SubCateViewController *_subVc;
    UISwitch* _sw;
    UIAlertView *_alert;
}
@property (strong, nonatomic) NSDictionary *currentCate;
@property (assign           ) BOOL         isOpen;
@property (nonatomic,retain ) NSIndexPath  *selectIndex;
@end

@implementation ViewController
@synthesize isOpen,selectIndex;
@synthesize currentCate = _currentCate;
@synthesize tableView   = _tableView;

-(void)setEventName:(Event *)eventName
{
    if (_eventName == eventName) {
        return;
    }
    _eventName = eventName;
//    NSLog(@"%@",_eventName);
   
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorStyle               = YES;
    self.tableView.showsVerticalScrollIndicator = NO;
    _calendarVc                                 = [[calendarViewController alloc]init];
    _subVc                                      = [[SubCateViewController alloc]init];
    _lable                                      = [[UILabel alloc]initWithFrame:CGRectMake(305, 15, 10, 10)];
    self.navigationItem.rightBarButtonItem      = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(DataSave)];
    _nameString                                 = _eventName.eventName;
    _localString                                = _eventName.eventLocal;
    _sw                                         = [[UISwitch alloc]initWithFrame:CGRectMake(260, 5, 0, 0)];
    if ([_eventName.date isEqualToDate:_eventName.startTime] && [[NSDate dateWithTimeInterval:(24*60*60) sinceDate:_eventName.date] isEqualToDate:_eventName.endTime]) {
        [_sw setOn:YES];
    }
    else
    {
        [_sw setOn:NO];
    }
    [_sw addTarget:self action:@selector(swClick:) forControlEvents:UIControlEventValueChanged];
    _calendarVc.delegate = self;
    _subVc.delegate      = self;
    myappdelegate        = [UIApplication sharedApplication].delegate;
    [self createLocalText];
    [self createNameText];
    [self createTextView];
    [self currentDateString];
    [self returnDateWithString];
    
    _alert = [[UIAlertView alloc] initWithTitle:@"请输入Event"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"确定",nil];
    [self.view addSubview:_alert];

}

-(NSDate*)currentDateString
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDate *strDate = [user objectForKey:@"selectedDate"];
    return strDate;
    
}


-(void)returnDateWithString
{
    NSLog(@"%@",[self currentDateString]);
}


-(void)DataSave
{
    if (_nameText.text.length == 0) {
        [_alert show];
        return;
    }
    [self saveData];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)swClick:(UISwitch*)sw
{
    if (sw.isOn) {
       
        _startDate = [self currentDateString];
        _endDate   = [NSDate dateWithTimeInterval:(24*60*60) sinceDate:[self currentDateString]];
        [_sw setOn:YES];
        [self.tableView reloadData];
//         NSLog(@"start = %@ \n end = %@", _startDate,_endDate);
    }
    else
    {
        [_sw setOn:NO];
        [self.tableView reloadData];
    }
    
}

-(void)createTextView
{
    _noteTextView                = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 100)];
    _noteTextView.delegate       = self;
    _noteTextView.scrollEnabled  = YES;
    _noteTextView.returnKeyType  = UIReturnKeyDone;

    //定义一个toolBar
    UIToolbar * topView          = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];

    //设置style
    [topView setBarStyle:UIBarStyleBlack];

    //定义两个flexibleSpace的button，放在toolBar上，这样完成按钮就会在最右边
    UIBarButtonItem * button1 =[[UIBarButtonItem  alloc]initWithBarButtonSystemItem:                                        UIBarButtonSystemItemFlexibleSpace target:self action:nil];

    UIBarButtonItem * button2    = [[UIBarButtonItem  alloc]initWithBarButtonSystemItem:                                        UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    //定义完成按钮
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone  target:self action:@selector(resignKeyboard)];

    //在toolBar上加上这些按钮
    NSArray * buttonsArray       = [NSArray arrayWithObjects:button1,button2,doneButton,nil];
    [topView setItems:buttonsArray];

    [_noteTextView setInputAccessoryView:topView];
    
    //隐藏键盘
    
}
- (void)resignKeyboard {
    [_noteTextView resignFirstResponder];
}
-(void)createNameText
{
    _nameText               = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 40)];
    _nameText.placeholder   = @"  Event Name";
    _nameText.delegate      = self;
    _nameText.keyboardType  = UIKeyboardTypeNamePhonePad;//键盘显示类型
    _nameText.returnKeyType = UIReturnKeyDone;
}

-(void)createLocalText
{
    _localText =[[UITextField alloc]initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 40)];
    _localText.placeholder   = @"  Location";
    _localText.delegate      = self;
    _localText.keyboardType  = UIKeyboardTypeNamePhonePad;
    _localText.returnKeyType = UIReturnKeyDone;
}



#pragma mark - uitableViewdelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            return 40;
        }
        else
            return 100;
    }
    return 40;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}



#pragma mark - uitableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    if (section == 1)
    {
        return 3;
    }
    if (section == 2)
    {
        return 1;
    }else
        
        return 2;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.clipsToBounds = YES;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if(_nameString.length > 0)
            {
                _nameText.text = _nameString;
                
            }

            [cell addSubview:_nameText];
        }else
        {
            if(_localString.length > 0)
            {
               _localText.text = _localString;
            }
            
            [cell addSubview:_localText];
            
        }}
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text       = @"Start";

            if (_startDate == nil || _sw.isOn == YES) {
            cell.detailTextLabel.text = nil;
            }else{
                cell.detailTextLabel.text = [self changeDateDayToString:_startDate];
            }
            if (_eventName.startTime) {
                if (_sw.isOn == YES) {
                    cell.detailTextLabel.text = nil;
                }else {
                    cell.detailTextLabel.text = [self changeDateDayToString:_eventName.startTime];
                }
            }
           

        }else if(indexPath.row == 1)
        {
            cell.textLabel.text       = @"Ends";
            if (_endDate == nil || _sw.isOn == YES) {
                cell.detailTextLabel.text = nil;
            }else{
                cell.detailTextLabel.text = [self changeDateMinToString:_endDate];
            }
            if(_eventName.endTime){
                if (_sw.isOn == YES) {
                    cell.detailTextLabel.text = nil;
                }else {
                    cell.detailTextLabel.text = [self changeDateDayToString:_eventName.endTime];
                }
            }
           
        }else{
        cell.textLabel.text       = @"All-day";

            [cell addSubview:_sw];
        }}
    if (indexPath.section == 2) {

        cell.textLabel.text       = @"Notification";
    }
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
        cell.textLabel.text       = @"Calendar";
            if (_title.length == 0) {
                if (_eventName.eventCalendar.calName.length > 0) {
        cell.detailTextLabel.text = _eventName.eventCalendar.calName;
                }
            }else
            {
        cell.detailTextLabel.text = _title;
            }
            if (_newColor.length == 0) {
                if (_eventName.eventCalendar.calColor.length > 0) {
                    _lable.backgroundColor = [self returnColorWithString:_eventName.eventCalendar.calColor];
                }
            }else
            {
                _lable.backgroundColor = [self returnColorWithString:_newColor];

            }
            
            [cell addSubview:_lable];
        }else{
            
            [cell addSubview:_noteTextView];
            
        }}
    return cell;
}



#pragma mark - textfiled delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    

}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _nameText) {
        _nameString = textField.text;
    }else
        _localString = textField.text;
    NSLog(@"%@==%@",_nameString,_localString);
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
#pragma mark - textviewdelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self.tableView setContentOffset:CGPointMake(0, 220) animated:YES];
}


- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self.tableView setContentOffset:CGPointMake(0, -65) animated:YES];

}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 1) {
        if (_sw.isOn == NO) {
            if (indexPath.row == 0 || indexPath.row == 1) {
                _subVc.index = indexPath.row;
                //            _subVc.dateString = [self currentDateString];
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                UIFolderTableView *folderTableView = (UIFolderTableView *)tableView;
                [folderTableView openFolderAtIndexPath:indexPath WithContentView:_subVc.view
                                             openBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                                 
                                             }
                                            closeBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                                
                                            }
                                       completionBlock:^{
                                       }];
            }
        }
        
    }
    if (indexPath.section == 2)
    {
        [self.navigationController pushViewController:[[timeViewController alloc]init] animated:YES];
    }
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            [self.navigationController pushViewController:_calendarVc animated:YES];
        }
    }
    
}

-(void)CloseAndOpenACtion:(NSIndexPath *)indexPath
{
    if ([indexPath isEqual:self.selectIndex]) {
        self.isOpen = NO;
        [self didSelectCellRowFirstDo:NO nextDo:NO];
        self.selectIndex = nil;
    }
    else
    {
        if (!self.selectIndex) {
            self.selectIndex = indexPath;
            [self didSelectCellRowFirstDo:YES nextDo:NO];
        }
        else
        {
            [self didSelectCellRowFirstDo:NO nextDo:YES];
        }
    }
}
- (void)didSelectCellRowFirstDo:(BOOL)firstDoInsert nextDo:(BOOL)nextDoInsert
{
    self.isOpen = firstDoInsert;
    if (nextDoInsert) {
        self.isOpen = YES;
        self.selectIndex = [self.tableView indexPathForSelectedRow];
        [self didSelectCellRowFirstDo:YES nextDo:NO];
    }
}

#pragma mark - subCateViewDelegate
-(void)subCateViewReturnDate:(NSDate *)date withindex:(int)index
{
//    
    
   
    if (index == 0) {
        _startDate = date;
        _eventName.startTime = date;
//        NSLog(@"%@",_startDate);
    }if (index == 1) {
        _endDate = date;
        _eventName.endTime = date;
//        NSLog(@"%@",_endDate);
    }
    
    [self.tableView reloadData];
    
}

-(NSString*)changeDateDayToString:(NSDate*)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSLog(@"%@",[dateFormatter stringFromDate:date]);
    return [dateFormatter stringFromDate:date];
}
-(NSString*)changeDateMinToString:(NSDate*)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    //    NSLog(@"%@",[dateFormatter stringFromDate:date]);
    return [dateFormatter stringFromDate:date];
}
-(void)saveData
{
    if(_eventName == nil)
    {
        Event *object=[NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:myappdelegate.managedObjectContext];
       
        object.endTime       = _endDate;
        object.startTime     = _startDate;
        object.eventName     = _nameText.text;
        object.eventLocal    = _localText.text;
        object.eventNote     = _noteTextView.text;
        object.date          = [self currentDateString];
        object.eventCalendar = _cal;

    }
    else
    {
        _eventName.endTime       = _endDate;
        _eventName.startTime     = _startDate;
        _eventName.eventName     = _nameString;
        _eventName.eventLocal    = _localString;
        _eventName.eventNote     = _noteTextView.text;
        _eventName.date          = [self currentDateString];
        _eventName.eventCalendar = _cal;
    }
    [myappdelegate saveContext];
    
}

- (Calendar *)updateData:(NSString*)newsId
{
    NSPredicate *predicate   = [NSPredicate
                              predicateWithFormat:@"calName like[cd] %@",newsId];
    //首先你需要建立一个request
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Calendar" inManagedObjectContext:myappdelegate.managedObjectContext]];
    [request setPredicate:predicate];//这里相当于sqlite中的查询条件，具体格式参考苹果文档

    NSError *error           = nil;
    NSArray *result          = [myappdelegate.managedObjectContext executeFetchRequest:request error:&error];//这里获取到的是一个数组，你需要取出你要更新的那个obj
//    for (Calendar *info in result) {
//    NSLog(@"result==%@  %@",info.calName,info.calColor);
//    }
    if (result.count > 0) {
        return result[0];
    }
    return nil;
 
}


#pragma mark - calendarDelegate
-(void)calendarViewWithColor:(NSString *)color withTitle:(NSString *)string
{
//    NSLog(@"%@ %@",color,string);
   _newColor = color;
   _title    = string;
    [self.tableView reloadData];
   _cal      = [self updateData:_title];
}

-(void)removeData
{
    _nameText.text = nil;
    _localText.text = nil;
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
