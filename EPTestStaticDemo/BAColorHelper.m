//
//  BAColorHelper.m
//  ReportControl
//
//  Created by 彦 蔡 on 12-8-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BAColorHelper.h"

@implementation BAColorHelper
+(CPTColor *)stringToCPTColor:(NSString *)color alpha:(NSString *)alpha{
    if(alpha==nil||[alpha isEqual:@""]){
        alpha=@"1";
    }
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString]; //去掉前后空格换行符
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];  //扫描16进制到int
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    CGFloat talpha=[alpha floatValue];
    return [CPTColor colorWithComponentRed:((float) r / 255.0f)
                                     green:((float) g / 255.0f)
                                      blue:((float) b / 255.0f)
                                     alpha:talpha];
}

+(UIColor *)stringToUIColor:(NSString *)color alpha:(NSString *)alpha{
    if(alpha==nil||[alpha isEqual:@""]){
        alpha=@"1";
    }
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString]; //去掉前后空格换行符
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];  //扫描16进制到int
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    CGFloat talpha=[alpha floatValue];
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:talpha];
}
+(UIColor *)stringRGBToUIColor:(NSString *)color alpha:(NSString *)alpha{
    if(alpha==nil||[alpha isEqual:@""]){
        alpha=@"1";
    }
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString]; //去掉前后空格换行符
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 3;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 3;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 6;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    int r, g, b;
    [[NSScanner scannerWithString:rString] scanInt:&r];  //扫描16进制到int
    [[NSScanner scannerWithString:gString] scanInt:&g];
    [[NSScanner scannerWithString:bString] scanInt:&b];
    
    CGFloat talpha=[alpha floatValue];
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:talpha];
}

+(CPTColor *)stringRGBToCPTColor:(NSString *)color alpha:(NSString *)alpha{
    if(alpha==nil||[alpha isEqual:@""]){
        alpha=@"1";
    }
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString]; //去掉前后空格换行符
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 3;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 3;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 6;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    int r, g, b;
    [[NSScanner scannerWithString:rString] scanInt:&r];  //扫描16进制到int
    [[NSScanner scannerWithString:gString] scanInt:&g];
    [[NSScanner scannerWithString:bString] scanInt:&b];
    
    CGFloat talpha=[alpha floatValue];
    return [CPTColor colorWithComponentRed:((float) r / 255.0f)
                                     green:((float) g / 255.0f)
                                      blue:((float) b / 255.0f)
                                     alpha:talpha];
}
@end
