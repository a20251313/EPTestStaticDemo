//
//  EPTopFunctionView.h
//  BizfocusOC
//
//  Created by jingfuran on 15/6/16.
//  Copyright (c) 2015年 郑东尧. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EPTopBarFunctionViewDelegate <NSObject>

-(void)topNumberChangeClicked:(BOOL)isUp;

@end


@interface EPTopBarFunctionView : UIView
@property(nonatomic,weak)id<EPTopBarFunctionViewDelegate> delegate;

-(void)refreshWithdicData:(NSDictionary*)dicData;
-(void)animationWithScale:(CGFloat)scale durtion:(double)durtion;
@end
