//
//  ViewController.m
//  ExpansionTableViewByZQ
//
//  Created by 郑 琪 on 13-2-26.
//  Copyright (c) 2013年 郑 琪. All rights reserved.
//

#import "ViewController.h"
#import "SubCateViewController.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,UIFolderTableViewDelegate>
{
    NSMutableArray *_dataList;
    UITextField* _nameText;
    UITextField* _localText;
    UITextView * _noteTextView;
}
@property (strong, nonatomic) SubCateViewController *subVc;
@property (strong, nonatomic) NSDictionary *currentCate;
@property (assign)BOOL isOpen;
@property (nonatomic,retain)NSIndexPath *selectIndex;
@end

@implementation ViewController
@synthesize isOpen,selectIndex;
@synthesize subVc=_subVc;
@synthesize currentCate=_currentCate;
@synthesize tableView=_tableView;
- (void)viewDidLoad
{
    [super viewDidLoad];
	self.tableView.separatorStyle = YES;
    self.tableView.showsVerticalScrollIndicator = NO;
    
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
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            _nameText = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 40)];
            _nameText.placeholder = @"  Event Name";
            [cell addSubview:_nameText];
        }else
        {
            _localText =[[UITextField alloc]initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 40)];
            _localText.placeholder = @"  Location";
            [cell addSubview:_localText];
            
        }}
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Start";
        }else if(indexPath.row == 1)
        {
            cell.textLabel.text = @"Ends";
        }else{
            cell.textLabel.text = @"All-day";
        }}
    if (indexPath.section == 2) {
        
        cell.textLabel.text = @"Notification";
    }
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Calendar";
        }else{
            _noteTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 100)];
            [cell addSubview:_noteTextView];
        }}
    return cell;
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 1) {
        if (indexPath.row == 0 || indexPath.row == 1) {
            
            SubCateViewController *subVc = [[SubCateViewController alloc]
                                            initWithNibName:NSStringFromClass([SubCateViewController class])
                                            bundle:nil];
            
            self.tableView.scrollEnabled = NO;
            UIFolderTableView *folderTableView = (UIFolderTableView *)tableView;
            [folderTableView openFolderAtIndexPath:indexPath WithContentView:subVc.view
                                         openBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                             
                                         }
                                        closeBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                          
                                        }
                                   completionBlock:^{
                                       // completed actions
                                       self.tableView.scrollEnabled = YES;
                                      
                                   }];
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

@end
