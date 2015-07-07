//
//  NSString+File.m
//  project
//
//  Created by apple on 15-4-14.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "NSString+File.h"

@implementation NSString (File)

-(NSString *)fileAppendName:(NSString *)append
{
    
    NSString* fileName = [self stringByDeletingPathExtension];
    
    fileName = [fileName stringByAppendingString:append];
    
    NSString* extension = [self pathExtension];
    
    return  [fileName stringByAppendingPathExtension:extension];
    
}
@end
