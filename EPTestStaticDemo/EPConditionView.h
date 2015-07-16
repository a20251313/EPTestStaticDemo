//
//  EPConditionVIew.h
//  BizfocusOC
//
//  Created by jingfuran on 15/7/13.
//  Copyright (c) 2015年 郑东尧. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EPAllEnum.h"

@protocol EPConditionViewDelegate <NSObject>

-(void)userDidChooseCondition:(NSDictionary*)dicInfo type:(EPStaticType)conditionType;

@end

@interface EPConditionView : UIView

@property(nonatomic)EPStaticType  staticType;
@property(nonatomic,weak)id<EPConditionViewDelegate> delegate;

-(id)initWithFrame:(CGRect)frame  staticType:(EPStaticType)type;
-(id)getCurrentCondition;
@end
