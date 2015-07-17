//
//  ViewController.h
//  ExpansionTableViewByZQ
//
//  Created by 郑 琪 on 13-2-26.
//  Copyright (c) 2013年 郑 琪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIFolderTableView.h"
#import "Event.h"
@interface ViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIFolderTableView *tableView;
@property (strong, nonatomic) Event* eventName;
@end
