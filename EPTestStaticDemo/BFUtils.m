//
//  BFUtils.m
//  Test
//
//  Created by xsh on 14-4-21.
//  Copyright (c) 2014年 xsh. All rights reserved.
//

#ifndef IS_IOS7
#define IS_IOS7 [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f
#endif
#import "BFUtils.h"



 NSString* const BNRNeedRefreshData = @"BNRNeedRefreshData";

static BFUtils  *mainUtils = nil;

#import <CoreText/CoreText.h>


@interface BFUtils ()

@property(nonatomic,strong)UIColor  *mainThemeColor;
@end

@implementation BFUtils
@synthesize mainThemeColor;

+(id)shareInstance
{
    if (mainUtils == nil)
    {
        mainUtils = [[BFUtils alloc] init];
    }
    return mainUtils;
}
+(void)setMainThemeColor:(UIColor*)color
{
    BFUtils *utils = [BFUtils shareInstance];
    [utils setMainThemeColor:color];
}
+(UIColor*)mainThemeColor
{
    BFUtils *utils = [BFUtils shareInstance];
    return [utils mainThemeColor];
}

//判断是否为浮点形：
+ (BOOL)isPureFloat:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    float val;
    
    return[scan scanFloat:&val] && [scan isAtEnd];
    
}


//判断当前单据是否查看过  type = 1 表示审批列表的单据 0表示我的报销的单据
+(BOOL)isReadThisBill:(NSString*)billId type:(int)type
{
    NSString *key = [NSString stringWithFormat:@"%@%d",billId,type];
    BOOL readed = [[[NSUserDefaults standardUserDefaults] valueForKey:key] boolValue];
    return readed;
}

//设置当前单据为查看  type = 1 表示审批列表的单据 0表示我的报销的单据
+(BOOL)setReadBill:(NSString*)billID type:(int)type
{
     NSString *key = [NSString stringWithFormat:@"%@%d",billID,type];
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:key];
    BOOL suc = [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"setReadBill:%@ type:%d suc:%d",billID,type,suc);
    return suc;
}



+(NSString*)getStatusString:(NSString*)billStatus
{
    if ([billStatus isEqualToString:@"processing"])
    {
        return @"审核中";
    }else if([billStatus isEqualToString:@"refused"])
    {
        return @"已退回";
    }else if ([billStatus isEqualToString:@"approved"])
    {
        return @"已通过";
    }else if ([billStatus isEqualToString:@"draft"])
    {
        return @"草稿";
    }else if ([billStatus isEqualToString:@"finished"])
    {
        return @"已完成";
    }
    return @"";
}





+(NSMutableAttributedString*)getAttributedString:(NSString*)strInfo
{
    //UIFont  *font = [UIFont fontWithName:@"Helvetica Light" size:15];
    //  UIFont *font = [UIFont fontWithName:@"Palatino-Roman" size:14.0];
    
    UIColor *color = [UIColor colorWithRed:1 green:91.0/255.0 blue:0 alpha:1];
    NSMutableAttributedString  *att = [[NSMutableAttributedString alloc] initWithString:strInfo];
    [att addAttribute:(NSString *)kCTForegroundColorAttributeName  value:(id)color.CGColor range:NSMakeRange(0, [strInfo length])];
    
//    [att addAttribute:(NSString *)kCTFontAttributeName value:(id)CFBridgingRelease(CTFontCreateWithName((CFStringRef)@"Helvetica Light",17,NULL))   range:NSMakeRange(0, [strInfo length])];
//    [att addAttribute:(NSString *)kCTFontAttributeName value:(id)CFBridgingRelease(CTFontCreateWithName((CFStringRef)@"Helvetica Light",9,NULL))   range:NSMakeRange(0,1)];
    
    [att addAttribute:(NSString *)kCTFontAttributeName value:(id)CFBridgingRelease(CTFontCreateWithName((CFStringRef)@"Helvetica-Light",17,NULL))   range:NSMakeRange(0, [strInfo length])];
    [att addAttribute:(NSString *)kCTFontAttributeName value:(id)CFBridgingRelease(CTFontCreateWithName((CFStringRef)@"Helvetica-Light",9,NULL))   range:NSMakeRange(0,1)];
    
    return att;
}

+(NSMutableAttributedString*)getAttributedString:(NSString*)moneyInfo countInfo:(NSString*)countInfo
{
    //UIFont  *font = [UIFont fontWithName:@"Helvetica Light" size:15];
    //  UIFont *font = [UIFont fontWithName:@"Palatino-Roman" size:14.0];
    
    NSString *strInfo = [NSString stringWithFormat:@"%@%@",moneyInfo,countInfo];
    UIColor *moneycolor = [UIColor colorWithRed:1 green:91.0/255.0 blue:0 alpha:1];
    UIColor *countColor = [UIColor blackColor];
    NSMutableAttributedString  *att = [[NSMutableAttributedString alloc] initWithString:strInfo];
   
    if ([UIScreen mainScreen].bounds.size.width == 414)
    {
        [att addAttribute:(NSString *)kCTFontAttributeName value:(id)CFBridgingRelease(CTFontCreateWithName((CFStringRef)@"Helvetica-Light",20,NULL))   range:NSMakeRange(0, [moneyInfo length])];
        [att addAttribute:NSForegroundColorAttributeName  value:(id)countColor range:NSMakeRange([moneyInfo length],[countInfo length])];
        [att addAttribute:(NSString *)kCTFontAttributeName value:(id)CFBridgingRelease(CTFontCreateWithName((CFStringRef)@"Helvetica-Light",10,NULL))   range:NSMakeRange(0,1)];
        [att addAttribute:(NSString *)kCTFontAttributeName value:(id)CFBridgingRelease(CTFontCreateWithName((CFStringRef)@"Helvetica-Light",15,NULL))   range:NSMakeRange([moneyInfo length], [countInfo length])];
        
        [att addAttribute:NSForegroundColorAttributeName  value:(id)moneycolor range:NSMakeRange(0, [moneyInfo length])];
        [att addAttribute:NSForegroundColorAttributeName  value:(id)countColor range:NSMakeRange([moneyInfo length],[countInfo length])];
        
    }else
    {
        [att addAttribute:(NSString *)kCTFontAttributeName value:(id)CFBridgingRelease(CTFontCreateWithName((CFStringRef)@"Helvetica-Light",17,NULL))   range:NSMakeRange(0, [moneyInfo length])];
        [att addAttribute:NSForegroundColorAttributeName  value:(id)countColor range:NSMakeRange([moneyInfo length],[countInfo length])];
        [att addAttribute:(NSString *)kCTFontAttributeName value:(id)CFBridgingRelease(CTFontCreateWithName((CFStringRef)@"Helvetica-Light",9,NULL))   range:NSMakeRange(0,1)];
        [att addAttribute:(NSString *)kCTFontAttributeName value:(id)CFBridgingRelease(CTFontCreateWithName((CFStringRef)@"Helvetica-Light",12,NULL))   range:NSMakeRange([moneyInfo length], [countInfo length])];
        
        [att addAttribute:NSForegroundColorAttributeName  value:(id)moneycolor range:NSMakeRange(0, [moneyInfo length])];
        [att addAttribute:NSForegroundColorAttributeName  value:(id)countColor range:NSMakeRange([moneyInfo length],[countInfo length])];
    }
  
    return att;
}


//把NSNULL 以及其余的不是NSString的类转化为NSString 类型，如果值为NULL和nil 则返回@""
+(NSString*)ridObject:(id)object
{
    if ([object isKindOfClass:[NSString class]])
    {
        return object;
    }
    
    if ([object isKindOfClass:[NSNull class]] || object == nil)
    {
        return @"";
    }
    
    return [object description];
}

+ (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
}




//+ (BOOL)isIOS7
//{
//    return ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f);
//}



+ (NSString *)getTimeFromNow
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:date];
}

+(NSDate*)getDateFromString:(NSString*)strDate forFormat:(NSString*)format
{
    static NSDateFormatter  *dateFormatter2 = nil;
    if (dateFormatter2 == nil)
    {
        dateFormatter2 = [[NSDateFormatter alloc] init];
        [dateFormatter2 setLocale:[NSLocale currentLocale]];
        [dateFormatter2 setTimeZone:[NSTimeZone defaultTimeZone]];
    }
  
    // example: 2009-11-04T19:46:20.192723
    if (format != nil)
    {
        [dateFormatter2 setDateFormat:format];
    }else
    {
         [dateFormatter2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
   
    
    NSDate   *date = [dateFormatter2 dateFromString:strDate];
    return date;
}

+(NSDate*)getMonthStartDayFromString:(NSString*)strDate forFormat:(NSString*)format
{
    static NSDateFormatter  *dateFormatter = nil;
    if (dateFormatter == nil)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
    }
    
    // example: 2009-11-04T19:46:20.192723
    if (format != nil)
    {
        [dateFormatter setDateFormat:format];
    }else
    {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    
    
    NSDate   *date = [dateFormatter dateFromString:strDate];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    [cal setLocale:[NSLocale currentLocale]];
    [cal setTimeZone:[NSTimeZone defaultTimeZone]];
    NSDateComponents *comps = [cal
                               components:NSYearCalendarUnit | NSMonthCalendarUnit
                               fromDate:date];
    comps.day = 1;
    NSDate *beginDate = [cal dateFromComponents:comps];
    
    
    
    return beginDate;
}


+ (NSString *)getCurrentHours
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    [formatter setDateFormat:@"HH"];
    return [formatter stringFromDate:date];
}


//图片存到cache目录下
+ (NSString *)imagePath:(UIImage *)aImg
{
    
    NSString *str = [NSString stringWithFormat:@"%@.png", [self getTimeFromNow]];
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [arr objectAtIndex:0];
    
    NSString *pngPath = [cachePath stringByAppendingPathComponent:str];
    
    [UIImagePNGRepresentation(aImg) writeToFile:pngPath atomically:YES];
    
    return pngPath;
}

//图片存到cache目录下
+ (BOOL)saveImage:(UIImage *)aImg path:(NSString*)strPath
{
    
    // NSString *str = strPath;
    //NSArray *arr = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    //NSString *cachePath = [arr objectAtIndex:0];
    
    //NSString *pngPath = [cachePath stringByAppendingPathComponent:str];
    
    
    NSData *data = UIImageJPEGRepresentation(aImg, 1);
    BOOL suc = [data writeToFile:strPath atomically:YES];
    NSLog(@"saveImage:%@ suc:%d",strPath,suc);
    return suc;
}

+(NSString*)getCacheImageID:(NSString*)imageID type:(NSString*)type isThumbail:(BOOL)isThumbail
{
    
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [arr objectAtIndex:0];
    
    NSString *pngPath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@%d.jpg",imageID,type,isThumbail]];
    
    return pngPath;
}
+(void)deleteCacheFiles
{
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [arr objectAtIndex:0];
    NSArray  *files = [[NSFileManager defaultManager] subpathsAtPath:cachePath];
    for (NSString  *file in files)
    {
        if ([file hasSuffix:@"jpg"])
        {
            NSString  *strPath = [cachePath stringByAppendingPathComponent:file];
            BOOL suc = [[NSFileManager defaultManager] removeItemAtPath:strPath error:nil];
            if (suc)
            {
                NSLog(@"deleteCacheFiles %@ suc",strPath);
            }else
            {
               NSLog(@"deleteCacheFiles %@ fail",strPath);
            }
        }
    }
    
}

+ (float)nextHeight:(id)sender
{
    return ((UIView *)sender).frame.origin.y + ((UIView *)sender).frame.size.height;
    
}

+ (float)rightWidth:(id)sender
{
    return ((UIView *)sender).frame.origin.x + ((UIView *)sender).frame.size.width;
}
+ (CGFloat)getHeightWithString:(NSString *)aStr WithSize:(CGSize)aSize WithFont:(UIFont *)aFont
{
    
    if (![aStr isKindOfClass:[NSString class]])
    {
        return aSize.height;
    }
    CGRect rect;
    
    if (IS_IOS7)//IOS 7.0 以上
        
    {
        
        NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:aFont, NSFontAttributeName,nil];
        
        rect = [aStr boundingRectWithSize:aSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:tdic context:nil];
        
        
    }
    
    else
        
    {
        
      //  rect.size = [aStr sizeWithFont:aFont constrainedToSize:aSize lineBreakMode:NSLineBreakByCharWrapping];
        
    }
    
    
    
    return rect.size.height;
    

}

+ (CGSize)getWidthWithString:(NSString *)aStr WithFont:(UIFont *)aFont
{
    CGSize size;
    if (IS_IOS7) {
        size = [aStr sizeWithAttributes:@{NSFontAttributeName: aFont}];
    }
    else
    {
       // size = [aStr sizeWithFont:aFont];
    }
    return size;
}

//设置默认的lab
+ (void)setDefaultLable:(UILabel *)aLab
{
    [aLab setFont:[UIFont systemFontOfSize:15.0f]];
    [aLab setBackgroundColor:[UIColor clearColor]];
    [aLab setLineBreakMode:NSLineBreakByCharWrapping];
    [aLab setNumberOfLines:0];
}

+ (void)setDefaultLable:(UILabel *)aLab WithSize:(float)aSize WithFont:(NSString *)aFontName
{
    [aLab setBackgroundColor:[UIColor clearColor]];
    [aLab setFont:[UIFont fontWithName:aFontName size:aSize]];
    [aLab setFont:[UIFont systemFontOfSize:aSize]];

}
//获取判断之后的字符串
+ (NSString *)getString:(NSString *)aStr
{
    if (!aStr||[aStr isKindOfClass:[NSNull class]]||[aStr isEqual:@"(null)"]){
        
        aStr = @"0";

    }
  
    return aStr;
    
}
#pragma mark 获取中文字符串转码utf8
+ (NSString*) getEncodingWithUTF8:(NSString *)_str
{
    return [_str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}




+(BOOL)storeValue:(id)object forKey:(NSString*)key
{
    if (object == nil || key == nil)
    {
        NSLog(@"storeValue:%@ forKey:%@",object,key);
        return NO;
    }
    
    
    [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    return YES;
}

+(id)getstoreValueByKey:(NSString*)key
{
    if (key == nil)
    {
        NSLog(@"getstoreValueByKey:%@",key);
        return nil;
    }
    
    
    id object = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return object;
}


+(NSDictionary*)getTimeFormatForString:(NSString*)durationTime
{
    NSString    *strbeginFormat = nil;
    NSString    *strendFormat = nil;
    
    static NSDateFormatter  *formatter = nil;
    if (formatter == nil)
    {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[NSLocale currentLocale]];
        [formatter setTimeZone:[NSTimeZone defaultTimeZone]];
    }

    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate  *date = [NSDate date];
    NSDate  *beginDate = nil;
    
    strendFormat = [formatter stringFromDate:date];
    
    if ([durationTime isEqualToString:@"最近一天"])
    {
        beginDate = [NSDate date];
    }else if ([durationTime isEqualToString:@"最近三天"])
    {
        beginDate = [NSDate dateWithTimeIntervalSinceNow:-60*24*60*3];
    }else if ([durationTime isEqualToString:@"最近一周"])
    {
        beginDate = [NSDate dateWithTimeIntervalSinceNow:-60*24*60*7];
    }else if ([durationTime isEqualToString:@"最近两周"])
    {
        beginDate = [NSDate dateWithTimeIntervalSinceNow:-60*24*60*14];
    }else if ([durationTime isEqualToString:@"最近一个月"])
    {
        beginDate = [NSDate dateWithTimeIntervalSinceNow:-60*24*60*30];
    }else if ([durationTime isEqualToString:@"最近三个月"])
    {
        beginDate = [NSDate dateWithTimeIntervalSinceNow:-60*24*60*30*3];
    }
    else if ([durationTime isEqualToString:@"最近半年"])
    {
        beginDate = [NSDate dateWithTimeIntervalSinceNow:-60*24*60*30*6];
    }else if ([durationTime isEqualToString:@"最近一年"])
    {
        beginDate = [NSDate dateWithTimeIntervalSinceNow:-60*24*60*30*12];
    }else if ([durationTime isEqualToString:@"月初到现在"])
    {
      
        NSCalendar *cal = [NSCalendar currentCalendar];
        [cal setLocale:[NSLocale currentLocale]];
        [cal setTimeZone:[NSTimeZone defaultTimeZone]];
        NSDateComponents *comps = [cal
                                   components:NSYearCalendarUnit | NSMonthCalendarUnit
                                   fromDate:date];
        comps.day = 1;
        beginDate = [cal dateFromComponents:comps];
        
    
        
        //beginDate = [NSDate dateWithTimeIntervalSinceNow:-60*24*60*30*12];
    }else if ([durationTime isEqualToString:@"年初到现在"])
    {
        NSCalendar *cal = [NSCalendar currentCalendar];
        [cal setLocale:[NSLocale currentLocale]];
        [cal setTimeZone:[NSTimeZone defaultTimeZone]];
        NSDateComponents *comps = [cal
                                   components:NSYearCalendarUnit | NSMonthCalendarUnit
                                   fromDate:date];
        comps.day = 1;
        comps.month = 1;
        beginDate = [cal dateFromComponents:comps];
        
    }else if ([durationTime rangeOfString:@"\n"].location != NSNotFound)
    {
        //2014-05-06-2014-05-10
        NSArray  *arrayCom = [durationTime componentsSeparatedByString:@"\n"];
        if (arrayCom.count == 2)
        {
            NSArray  *beginArray = [arrayCom subarrayWithRange:NSMakeRange(0, 1)];
            NSArray  *endArray = [arrayCom subarrayWithRange:NSMakeRange(1, 1)];
            
            strbeginFormat = [beginArray firstObject];
            strendFormat = [endArray firstObject];
        }
    }
    if (beginDate)
    {
        strbeginFormat = [formatter stringFromDate:beginDate];
    }
    

    NSDictionary  *dicInfo = [NSDictionary dictionaryWithObjectsAndKeys:strbeginFormat,kBeginTime,strendFormat,kEndTime,nil];
    
    NSLog(@"getTimeFormatForString:%@ result:%@",durationTime,dicInfo);
    return dicInfo;
    
}


/**
 *  获取筛选条件名称对应的type
 *
 *  @param strMainValue 筛选名称
 *
 *  @return 筛选条件名称对应的type
 */

+(EPStaticType)getStaticTypeAccordValue:(NSString*)strMainValue
{
    
    
    EPStaticType  type = EPStaticTypePerson;
    
    if ([strMainValue isEqualToString:@"报销人"])
    {
        type = EPStaticTypePerson;
        
    }else if ([strMainValue isEqualToString:@"部门"])
    {
        type = EPStaticTypeDepartment;
    }else if([strMainValue isEqualToString:@"项目"])
    {
        type = EPStaticTypeProject;
    }else if ([strMainValue isEqualToString:@"客户"])
    {
        type = EPStaticTypeClient;
    }else if ([strMainValue isEqualToString:@"科目"])
    {
        type = EPStaticTypeSubject;
    }else if ([strMainValue isEqualToString:@"时间"])
    {
        type = EPStaticTypeTime;
    }else if ([strMainValue isEqualToString:@"事业部"])
    {
        type = EPStaticTypeBusiness;
    }
    
    return type;
}


+(NSString*)formatNumber:(id)strNumber
{
    
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"￥###,###,###"];
    
    NSNumber  *num = nil;
    if ([strNumber isKindOfClass:[NSNumber class]])
    {
        num = strNumber;
    }else if ([strNumber isKindOfClass:[NSString class]])
    {
        num = [NSNumber numberWithFloat:[strNumber doubleValue]];
    }else
    {
        return @"";
    }
    
    NSString *formattedNumberString = [numberFormatter
                                       stringFromNumber:num];
    //   formatNumber(@"strNumber:%@ result: %@",strNumber,formattedNumberString);
    
    return formattedNumberString;
    
}
+(NSString*)formatDouble:(double)number
{
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"￥###,###,###"];
    
    NSNumber  *num = [NSNumber numberWithDouble:number];;
    
    
    NSString *formattedNumberString = [numberFormatter
                                       stringFromNumber:num];
    // formatNumber(@"formatDouble:%f result: %@",number,formattedNumberString);
    
    return formattedNumberString;
}

@end
