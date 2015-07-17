//
//  BAColorHelper.h
//  ReportControl
//
//  Created by 彦 蔡 on 12-8-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CorePlot-CocoaTouch.h"
@interface BAColorHelper : NSObject
+(CPTColor *)stringToCPTColor:(NSString *)color alpha:(NSString *)alpha;
+(UIColor *)stringToUIColor:(NSString *)color alpha:(NSString *)alpha;
+(CPTColor *)stringRGBToCPTColor:(NSString *)color alpha:(NSString *)alpha;
+(UIColor *)stringRGBToUIColor:(NSString *)color alpha:(NSString *)alpha;
@end
