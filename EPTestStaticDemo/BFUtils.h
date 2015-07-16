//
//  BFUtils.h
//  Test
//
//  Created by ； on 14-4-21.
//  Copyright (c) 2014年 xsh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EPAllEnum.h"




#ifndef kNeedNet

#define kBeginTime       @"kBeginTime"
#define kEndTime        @"kEndTime"
#define kNeedNet        1

#endif




extern  NSString* const BNRNeedRefreshData;

@interface BFUtils : NSObject
//传入strInfo  然后获取到特定的NSMutableAttributedString
+(NSMutableAttributedString*)getAttributedString:(NSString*)strInfo;
+(NSMutableAttributedString*)getAttributedString:(NSString*)moneyInfo countInfo:(NSString*)countInfo;

+(void)setMainThemeColor:(UIColor*)color;   //设置当前主题颜色
+(UIColor*)mainThemeColor;



//把object 变为NSString 类型,如果为nil和NULL，则返回@""
+(NSString*)ridObject:(id)object;
+ (NSString *)getTimeFromNow;

//默认转换format为“yyyy-MM-dd HH:mm:ss”
+(NSDate*)getDateFromString:(NSString*)strDate forFormat:(NSString*)format;

+ (NSString *)imagePath:(UIImage *)aImg;

+ (float)nextHeight:(id)sender;
+ (float)rightWidth:(id)sender;

+ (void)setDefaultLable:(UILabel *)aLab;
+ (void)setDefaultLable:(UILabel *)aLab WithSize:(float)aSize WithFont:(NSString *)aFontName;

+ (NSString *)getString:(NSString *)aStr;
+ (NSString*) getEncodingWithUTF8:(NSString *)_str;

//根据 string 获取 高度
+ (CGFloat)getHeightWithString:(NSString *)aStr WithSize:(CGSize)aSize WithFont:(UIFont *)aFont;
//根据string  获取宽度
+ (CGSize)getWidthWithString:(NSString *)aStr WithFont:(UIFont *)aFont;


+ (void)setExtraCellLineHidden: (UITableView *)tableView;


+(BOOL)storeValue:(id)object forKey:(NSString*)key; //存值
+(id)getstoreValueByKey:(NSString*)key;//取值
+(NSDictionary*)getTimeFormatForString:(NSString*)durationTime;//获取时间

//保存图片到cach里面
+ (BOOL)saveImage:(UIImage *)aImg path:(NSString*)strPath;
+(NSString*)getCacheImageID:(NSString*)imageID type:(NSString*)type isThumbail:(BOOL)isThumbail;
+(void)deleteCacheFiles;
//返回单据当前的审批状态
+(NSString*)getStatusString:(NSString*)billStatus;

//判断当前单据是否查看过  type = 1 表示审批列表的单据 0表示我的报销的单据
+(BOOL)isReadThisBill:(NSString*)billId type:(int)type;
//设置当前单据为查看  type = 1 表示审批列表的单据 0表示我的报销的单据
+(BOOL)setReadBill:(NSString*)billID type:(int)type;

+ (BOOL)isPureFloat:(NSString*)string;

/**
 *  获取某个月第一天的时间
 *
 *  @param strDate date的字符串类型
 *  @param format  时间的格式
 *
 *  @return 时间的月份的第一天
 */
+(NSDate*)getMonthStartDayFromString:(NSString*)strDate forFormat:(NSString*)format;

/**
 *  获取筛选条件名称对应的type
 *
 *  @param strMainValue 筛选名称
 *
 *  @return 筛选条件名称对应的type
 */

+(EPStaticType)getStaticTypeAccordValue:(NSString*)strMainValue;
+(NSString*)formatNumber:(id)strNumber;
+(NSString*)formatDouble:(double)number;
@end
