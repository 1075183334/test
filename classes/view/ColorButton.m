//
//  ColorButton.m
//  calendar
//
//  Created by 晓东 on 15/7/23.
//  Copyright (c) 2015年 APPXY. All rights reserved.
//

#import "ColorButton.h"

@implementation ColorButton



- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setBackgroundImage:nil forState:UIControlStateNormal];

    }
    return self;
}

-(void)setCheck:(BOOL)check
{
    if (check == YES) {
        [self setSelected:YES];
        [self setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
    }
    else
    {
        [self setSelected:NO];
        [self setBackgroundImage:nil forState:UIControlStateNormal];

    }
    _check = check;
}


@end
