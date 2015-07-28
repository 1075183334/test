//
//  ViewController.m
//  ExpansionTableViewByZQ
//
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "Event.h"
#import "Calendar.h"
#import "timeViewController.h"
#import "calendarViewController.h"
#import "colorTableViewCell.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,UIFolderTableViewDelegate,UITextViewDelegate,UITextFieldDelegate,calendarDelegate,timeViewDelegate>
{
    NSMutableArray *_dataList;
    UITextField* _nameText;
    UITextField* _localText;
    NSString* _nameString;
    NSString* _localString;
    UITextView * _noteTextView;
    AppDelegate* myappdelegate;
    calendarViewController* _calendarVc;
    timeViewController* _timeVc;
    NSString* _title;
    NSString* _newColor;
    UILabel* _lable;
    Calendar* _cal;
    Calendar* _colorAndName;
    UISwitch* _sw;
    NSString* _colorNameString;
    
    NSString* _timeVCforTime;
    NSDate* _startTimeDate;
    NSDate* _endTimeDate;
    
    BOOL showStartTime;
    BOOL showEndTime;
    
    UIDatePicker                *startDatePicker;
    UIDatePicker                *endDatePicker;
    IBOutlet UITableViewCell *cellStartTime;
    IBOutlet UILabel          *lblStartTime;
    IBOutlet UITableViewCell *cellEndTime;
    IBOutlet UILabel        *lblEndTime;
    
    NSMutableArray* _colorAndNameMutableArr;
    UIButton* saveBtn;
    UIView* line;
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
    self.title = @"New Event";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(CancelVic)];
    line = [[UIView alloc]initWithFrame:CGRectMake(80, 11, 160, 1)];
    line.backgroundColor = [UIColor redColor];
    _colorAndNameMutableArr = [[NSMutableArray alloc]init];
    self.tableView.separatorStyle               = YES;
    self.tableView.showsVerticalScrollIndicator = NO;
    _calendarVc                                 = [[calendarViewController alloc]init];
    _lable                                      = [[UILabel alloc]initWithFrame:CGRectMake(305, 15, 10, 10)];
    
    saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(0, 0, 40, 30);
    [saveBtn setTitle:@"Save" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(DataSave) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem      = [[UIBarButtonItem alloc]initWithCustomView:saveBtn];
    _nameString                                 = _eventName.eventName;
    _localString                                = _eventName.eventLocal;
    [lblEndTime addSubview:line];
    line.hidden = YES;
    _calendarVc.delegate = self;
    myappdelegate        = [UIApplication sharedApplication].delegate;
    _timeVc = [[timeViewController alloc]init];
    _timeVc.delegate = self;
    [self createLocalText];
    [self createNameText];
    [self createTextView];
    [self currentDateString];
    [self createSwitchAndAlertView];
    if (!_eventName)
    {
    [self showCalendarColorAndName];
    }

}

-(void)CancelVic
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createSwitchAndAlertView
{
    _sw  = [[UISwitch alloc]initWithFrame:CGRectMake(260, 5, 0, 0)];
    if ([_eventName.date isEqualToDate:_eventName.startTime] && [[NSDate dateWithTimeInterval:(24*60*60) sinceDate:_eventName.date] isEqualToDate:_eventName.endTime]) {
        [_sw setOn:YES];
    }
    else
    {
        [_sw setOn:NO];
    }
    [_sw addTarget:self action:@selector(swClick:) forControlEvents:UIControlEventValueChanged];
    [_sw setOn:_eventName.eventAllday];
}

-(NSDate*)currentDateString
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDate *strDate = [user objectForKey:@"selectedDate"];
    return strDate;
}

-(void)DataSave
{
    
        [self saveData];
        [self.navigationController popToRootViewControllerAnimated:YES];
   
}

-(void)swClick:(UISwitch*)sw
{
    if (sw.isOn) {
    
        [_sw setOn:YES];
        startDatePicker.datePickerMode = UIDatePickerModeDate;
        endDatePicker.datePickerMode = UIDatePickerModeDate;
        lblStartTime.text = [self changeDateToString:startDatePicker.date?startDatePicker.date:_eventName.startTime];
        if (lblStartTime.text.length == 0) {
            lblStartTime.text = [self changeDateToString:[self currentDateString]];
        }
        lblEndTime.text = [self changeDateToString:endDatePicker.date?endDatePicker.date:_eventName.endTime];
        if (lblEndTime.text.length == 0) {
            lblEndTime.text = [self changeDateToString:[self currentDateString]];
        }
    }
    else
    {
        [_sw setOn:NO];
        startDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
        endDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
        lblStartTime.text = [self changeDateDayToString:startDatePicker.date?startDatePicker.date:_eventName.startTime];
        if (lblStartTime.text.length == 0) {
            lblStartTime.text = [self changeDateDayToString:[self currentDateString]];
        }
        lblEndTime.text = [self changeDateDayToString:endDatePicker.date?endDatePicker.date:_eventName.endTime];
        if (lblEndTime.text.length == 0) {
            lblEndTime.text = [self changeDateDayToString:[self currentDateString]];
        }
    }
    
    if ([[self changeStringToDateDay:lblStartTime.text] compare:[self changeStringToDateDay:lblEndTime.text]] == NSOrderedDescending || [[self changeStringToDate:lblStartTime.text] compare:[self changeStringToDate:lblEndTime.text]] == NSOrderedDescending)   {
        [self showLine];
    }
    else
    {
        [self hideLine];
    }
    [_tableView beginUpdates];
    [_tableView endUpdates];
    
}

-(void)createTextView
{
    _noteTextView                = [[UITextView alloc]initWithFrame:CGRectMake(10, 0, self.tableView.bounds.size.width-20, 120)];
    _noteTextView.delegate       = self;
    _noteTextView.scrollEnabled  = YES;
    _noteTextView.returnKeyType  = UIReturnKeyDone;
    _noteTextView.font           = [UIFont systemFontOfSize:14];
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
    _nameText               = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, self.tableView.bounds.size.width-20, 40)];
    _nameText.placeholder   = @"Event Name";
    _nameText.delegate      = self;
    _nameText.keyboardType  = UIKeyboardTypeNamePhonePad;//键盘显示类型
    _nameText.returnKeyType = UIReturnKeyDone;
}

-(void)createLocalText
{
    _localText =[[UITextField alloc]initWithFrame:CGRectMake(15, 0, self.tableView.bounds.size.width-20, 40)];
    _localText.placeholder   = @"Location";
    _localText.leftViewMode = UITextFieldViewModeAlways;
    _localText.delegate      = self;
    _localText.keyboardType  = UIKeyboardTypeNamePhonePad;
    _localText.returnKeyType = UIReturnKeyDone;
}

-(void)createStartDatePicker
{
    startDatePicker = [[UIDatePicker alloc] init];
    _eventName==nil?(startDatePicker.date = [self currentDateString]):(startDatePicker.date = _eventName.startTime);
    _startTimeDate = [self currentDateString];
    startDatePicker.frame = CGRectMake(0, 44, self.view.frame.size.width, 216);
    [startDatePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    [cellStartTime addSubview:startDatePicker];
  
    
}
-(void)createEndDatePicker
{
    endDatePicker = [[UIDatePicker alloc] init];
    _eventName==nil?(endDatePicker.date = [self currentDateString]):(endDatePicker.date = _eventName.endTime);
    _endTimeDate = [self currentDateString];
    endDatePicker.frame = CGRectMake(0, 44, self.view.frame.size.width, 216);
    [endDatePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    [cellEndTime addSubview:endDatePicker];
}

#pragma mark - timeViewDelegate
-(void)returnTime:(NSString *)timeString
{
    _timeVCforTime = timeString;
    [self.tableView reloadData];
}

#pragma mark - uitableViewdelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return showStartTime?(44+216):44;
        }
        if (indexPath.row == 1) {
            return showEndTime?(44+216):44;
        }
    }
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            return 40;
        }
        else
            return 120;
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
    AppDelegate * appDleegate = [[UIApplication sharedApplication] delegate];
    
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
            _nameString>0?(_nameText.text = _nameString):(_nameText.placeholder = @"New Event");
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
            
            cellStartTime.clipsToBounds = YES;
            
            if(_eventName == nil)
            {
                _sw.isOn?(lblStartTime.text = [self changeDateToString:startDatePicker.date?startDatePicker.date:[self currentDateString]]):(lblStartTime.text = [self changeDateDayToString:startDatePicker.date?startDatePicker.date:[self currentDateString]]);
            }
            else
            {
                _sw.isOn?(lblStartTime.text = [self changeDateToString:_eventName.startTime]):(lblStartTime.text = [self changeDateDayToString:_eventName.startTime]);
            }
            
            cellStartTime.selectionStyle = UITableViewCellSelectionStyleNone;
            return cellStartTime;
            
        }else if(indexPath.row == 1)
        {
            if(_eventName == nil)
            {
                _sw.isOn?(lblEndTime.text = [self changeDateToString:endDatePicker.date?endDatePicker.date:[self currentDateString]]):(lblEndTime.text = [self changeDateDayToString:endDatePicker.date?endDatePicker.date:[self currentDateString]]);
            }
            else
            {
                 _sw.isOn?(lblEndTime.text = [self changeDateToString:_eventName.endTime]):(lblEndTime.text = [self changeDateDayToString:_eventName.endTime]);
            }
            cellEndTime.selectionStyle = UITableViewCellSelectionStyleNone;

            cellEndTime.clipsToBounds = YES;
            return cellEndTime;
            
        }else{
            
        cell.textLabel.text = @"All-day";
            cell.detailTextLabel.text = nil;
            [cell addSubview:_sw];

        }}
    if (indexPath.section == 2) {

        cell.textLabel.text       = @"Notification";
        cell.detailTextLabel.text = _timeVCforTime?_timeVCforTime:_eventName.eventNotif;
    }
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            
            colorTableViewCell* cell = [[[NSBundle mainBundle]loadNibNamed:@"colorTableViewCell" owner:nil options:nil]lastObject];
            
            cell.calCellColorNameView.text = _colorAndName.calName;
            cell.calCellColorView.backgroundColor = [appDleegate returnColorWithTag:[_colorAndName.calColor intValue]];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.calCellNameView.text  = @"Calendar";
   
            if (_title.length == 0) {
                if (_eventName.eventCalendar.calName.length > 0)
                {
        cell.calCellColorNameView.text = _eventName.eventCalendar.calName;
                    _colorNameString = _eventName.eventCalendar.calName;
                }
            }else
            {
        cell.calCellColorNameView.text = _title;
                
            }
            if (_newColor.length == 0) {
                if (_eventName.eventCalendar.calColor.length > 0) {
                    
                    cell.calCellColorView.backgroundColor = [appDleegate returnColorWithTag:[_eventName.eventCalendar.calColor intValue]];
                 
                }
            }else
            {
               cell.calCellColorView.backgroundColor = [appDleegate returnColorWithTag:[_newColor intValue]];
                
            }
            
            return cell;
        }else{
            
            _noteTextView.text = _eventName.eventNote?_eventName.eventNote:_noteTextView.text;
            _noteTextView.font = [UIFont systemFontOfSize:17];
            [cell addSubview:_noteTextView];
            
        }}
    return cell;
}



#pragma mark - textfiled delegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _nameText) {
        _nameString = textField.text;
    }else
        _localString = textField.text;
    
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
            if (indexPath.row == 0) {
                [self dissmissKeyboard];
                showStartTime = !showStartTime;
                if (showStartTime) {
                    if (!startDatePicker) {
                        [self createStartDatePicker];
                        _sw.isOn?(startDatePicker.datePickerMode = UIDatePickerModeDate):(startDatePicker.datePickerMode = UIDatePickerModeDateAndTime);
                    }
                }
                if ([[self changeStringToDateDay:lblStartTime.text] compare:[self changeStringToDateDay:lblEndTime.text]] == NSOrderedDescending || [[self changeStringToDate:lblStartTime.text] compare:[self changeStringToDate:lblEndTime.text]] == NSOrderedDescending)   {
                    [self showLine];
                }
                else
                {
                    [self hideLine];
                }
               
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                [tableView beginUpdates];
                [tableView endUpdates];
                
            }
            if (indexPath.row == 1) {
                [self dissmissKeyboard];
                showEndTime = !showEndTime;
                if (showEndTime) {
                    if (!endDatePicker) {
                        [self createEndDatePicker];
                        _sw.isOn?(endDatePicker.datePickerMode = UIDatePickerModeDate):(endDatePicker.datePickerMode = UIDatePickerModeDateAndTime);
                    }
                }
                
                if ([[self changeStringToDateDay:lblStartTime.text] compare:[self changeStringToDateDay:lblEndTime.text]] == NSOrderedDescending || [[self changeStringToDate:lblStartTime.text] compare:[self changeStringToDate:lblEndTime.text]] == NSOrderedDescending)
                {
                    [self showLine];
                }
                else
                {
                    [self hideLine];
                }
              
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                [tableView beginUpdates];
                [tableView endUpdates];
        }
       
    }
    if (indexPath.section == 2)
    {
        _timeVc.timeString = _eventName.eventNotif;
        [self.navigationController pushViewController:_timeVc animated:YES];
    }
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            _calendarVc.colorString =_title?_title:_eventName.eventCalendar.calName;
        [self.navigationController pushViewController:_calendarVc animated:YES];
        }
    }
    
}

-(void)showLine
{
    line.hidden = NO;
    saveBtn.userInteractionEnabled = NO;
    [saveBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];

}

-(void)hideLine
{
    line.hidden = YES;
    saveBtn.userInteractionEnabled = YES;
    [saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}
-(void)datePickerValueChanged:(id) sender{
    if (sender == startDatePicker) {
        
        _sw.isOn?(lblStartTime.text = [self changeDateToString:startDatePicker.date]):(lblStartTime.text = [self changeDateDayToString:startDatePicker.date]);
        _startTimeDate = startDatePicker.date;
        
    }
    if (sender == endDatePicker) {
         _sw.isOn?(lblEndTime.text = [self changeDateToString:endDatePicker.date]):(lblEndTime.text = [self changeDateDayToString:endDatePicker.date]);
        _endTimeDate = endDatePicker.date;
    }
    
    if ([[self changeStringToDateDay:lblStartTime.text] compare:[self changeStringToDateDay:lblEndTime.text]] == NSOrderedDescending || [[self changeStringToDate:lblStartTime.text] compare:[self changeStringToDate:lblEndTime.text]] == NSOrderedDescending)   {
        [self showLine];
    }
    else
    {
        [self hideLine];
    }
    [_tableView beginUpdates];
    [_tableView endUpdates];
}


-(NSString*)changeDateDayToString:(NSDate*)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter stringFromDate:date];
}

-(NSDate*)changeStringToDateDay:(NSString*)string
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter dateFromString:string];
}

-(NSString*)changeDateToString:(NSDate*)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter stringFromDate:date];
}

-(NSDate*)changeStringToDate:(NSString*)string
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter dateFromString:string];
}

-(void)saveData
{
    if(_eventName == nil)
    {
        Event *object=[NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:myappdelegate.managedObjectContext];
        object.endTime       = endDatePicker.date?endDatePicker.date:[self currentDateString];
        object.startTime     = startDatePicker.date?startDatePicker.date:[self currentDateString];
        object.eventName     = _nameText.text.length>0?_nameText.text:@"New Event";
        object.eventLocal    = _localText.text;
        object.eventNote     = _noteTextView.text;
        object.date          = [self currentDateString];
        object.eventAllday   = _sw.isOn?YES:NO;
        object.eventNotif    = _timeVCforTime;
        object.eventCalendar = _cal?_cal:_colorAndName;
    }
    else
    {
        _eventName.endTime       = endDatePicker.date?endDatePicker.date:_eventName.endTime;
        _eventName.startTime     = startDatePicker.date?startDatePicker.date:_eventName.startTime;
        _eventName.eventName     = _nameString;
        _eventName.eventLocal    = _localString.length>0?_localString:_localText.text;
        _eventName.eventNote     = _noteTextView.text?_noteTextView.text:_eventName.eventNote;
        _eventName.date          = [self currentDateString];
        _eventName.eventAllday   = _sw.isOn?YES:NO;
        _eventName.eventCalendar = _cal?_cal:_eventName.eventCalendar;
        _eventName.eventNotif    = _timeVCforTime?_timeVCforTime:_eventName.eventNotif;
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

    if (result.count > 0) {
        return result[0];
    }
    return nil;
 
}

-(void)showCalendarColorAndName
{
    NSFetchRequest* request = [[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:@"Calendar" inManagedObjectContext:myappdelegate.managedObjectContext]];
    
    NSError *error           = nil;
    NSArray *result          = [myappdelegate.managedObjectContext executeFetchRequest:request error:&error];//这里获取到的是一个数组，你需要取出你要更新的那个obj
    
    for (Calendar* cal in result) {
        [_colorAndNameMutableArr addObject:cal];
    }
    _colorAndName = [_colorAndNameMutableArr objectAtIndex:0];
    _title = _colorAndName.calName;
}

#pragma mark - calendarDelegate
-(void)calendarViewWithColor:(NSString *)color withTitle:(NSString *)string
{
   _newColor = color;
   _title    = string;
    [self.tableView reloadData];
   _cal      = [self updateData:_title];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self dissmissKeyboard];
}

-(void)dissmissKeyboard
{
    [_nameText resignFirstResponder];
    [_localText resignFirstResponder];
}

@end
