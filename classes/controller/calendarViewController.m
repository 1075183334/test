//
//  calendarViewController.m
//  calendar
//
//  Created by APPXY on 15/7/3.
//  Copyright (c) 2015年 APPXY. All rights reserved.
//

#import "calendarViewController.h"

@interface calendarViewController ()
@property(nonatomic, strong)UIButton* work;
@property(nonatomic, strong)UIButton* life;
@property(nonatomic, strong)UIButton* family;

@end

@implementation calendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    btn.frame = CGRectMake(10, 20, 20, 20);
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    [self createBtn];
    
}

-(void)createBtn
{
    _work = [UIButton buttonWithType:UIButtonTypeCustom];
    _work.frame = CGRectMake(0, 40, self.view.bounds.size.width, 30);
    [_work addTarget:self action:@selector(workClick) forControlEvents:UIControlEventTouchUpInside];
    _work.layer.borderColor = [UIColor grayColor].CGColor;
    _work.layer.borderWidth = 1;
    [_work setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [_work setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_work setTitle:@"work" forState:UIControlStateNormal];
    _work.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_work];
    
    _life = [UIButton buttonWithType:UIButtonTypeCustom];
    _life.frame = CGRectMake(0, 70, self.view.bounds.size.width, 30);
    [_life addTarget:self action:@selector(workClick) forControlEvents:UIControlEventTouchUpInside];
    _life.layer.borderColor = [UIColor grayColor].CGColor;
    [_life setTitleColor:[UIColor purpleColor] forState:UIControlStateSelected];
    [_life setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _life.layer.borderWidth = 1;
    [_life setTitle:@"life" forState:UIControlStateNormal];
    _life.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_life];
    
    _family = [UIButton buttonWithType:UIButtonTypeCustom];
    _family.frame = CGRectMake(0, 100, self.view.bounds.size.width, 30);
    [_family addTarget:self action:@selector(workClick) forControlEvents:UIControlEventTouchUpInside];
    [_family setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    [_family setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _family.layer.borderColor = [UIColor grayColor].CGColor;
    _family.layer.borderWidth = 1;
    [_family setTitle:@"family" forState:UIControlStateNormal];
    _family.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_family];
}

- (void)workClick
{
    if (_work.isTouchInside) {
        [_work setSelected:YES];
        [_life setSelected:NO];
        [_family setSelected:NO];
    }
    else if (_life.isTouchInside)
    {
        [_life setSelected:YES];
        [_work setSelected:NO];
        [_family setSelected:NO];
        
    }
    else if (_family.isTouchInside)
    {
        [_family setSelected:YES];
        [_work setSelected:NO];
        [_life setSelected:NO];
        
    }
    
}

-(void)btnClick
{
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(calendarViewWithColor: withTitle:)]) {
            if (_work.isSelected) {
                 [self.delegate calendarViewWithColor:[UIColor redColor] withTitle:@"work"];
            }else if (_life.isSelected){
                [self.delegate calendarViewWithColor:[UIColor purpleColor] withTitle:@"life"];
            }else if (_family.isSelected){
                [self.delegate calendarViewWithColor:[UIColor blueColor] withTitle:@"family"];
            }
           
        }
    }];
}

@end
