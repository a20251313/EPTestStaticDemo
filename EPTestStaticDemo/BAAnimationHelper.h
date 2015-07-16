//
//  BAAnimationHelper.h
//  BADemo
//
//  Created by 彦 蔡 on 12-9-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CorePlot-CocoaTouch.h"
@protocol BAAnimationDelegate <NSObject>

@optional
-(void)onAnimationDone;

@end

@interface BAAnimationHelper : NSObject
{
    id<BAAnimationDelegate> delegate;
}
@property (nonatomic, retain) id<BAAnimationDelegate> delegate;

-(void)plotStartAnimation:(NSMutableArray*)data plot:(CPTPlot *)plot graph:(CPTGraph*)graph;
-(void)plotStartAnimation:(NSMutableDictionary*)tempData sourceData:(NSMutableDictionary*)sourceData plot:(CPTPlot *)plot graph:(CPTGraph *)graph;
-(void)plotRatationAnimation:(CPTPlot*)plot graph:(CPTGraph*)graph;
+(void)plotRatationAnimation:(CPTPlot*)plot direction:(NSUInteger)direction;
-(void)plotScaleAnimation:(CPTPlot*)plot;
-(void)plotScaleAnimationWithGraph:(CPTGraph *)graph;
-(CATransition*)showNavigationController;
@end
