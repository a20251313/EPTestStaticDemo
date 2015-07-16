//
//  BAAnimationHelper.m
//  BADemo
//
//  Created by 彦 蔡 on 12-9-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BAAnimationHelper.h"


@implementation BAAnimationHelper{
    int count;
    int times;
}
@synthesize delegate;



-(void)plotStartAnimation:(NSMutableDictionary*)tempData sourceData:(NSMutableDictionary*)sourceData plot:(CPTPlot *)plot graph:(CPTGraph *)graph
{

    //  NSMutableArray *tempDataArray=[NSMutableArray arrayWithArray:[tempData objectForKey:plot.identifier]];
    
    // NSMutableDictionary *userInfo=[NSMutableDictionary dictionaryWithObjectsAndKeys:tempData,@"tempData",sourceData,@"sourceData",plot,@"plot",graph,@"graph", nil];
//    for(int i=0;i<tempDataArray.count;i++){
//        [tempDataArray replaceObjectAtIndex:i withObject:(NSDecimalNumber*)[NSNumber numberWithFloat:0] ];
//    }
//    [tempData setValue:tempDataArray forKey:(NSString*)plot.identifier];
    [plot reloadData];
    
  
//    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//    pathAnimation.duration = 1.0;
//    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
//    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
//    pathAnimation.autoreverses = NO;
//    [plot addAnimation:pathAnimation forKey:nil];

    
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    //transformAnimation.removedOnCompletion = YES;
    animation.duration = 0.55;
    animation.fromValue = [NSNumber numberWithFloat:0.1];
    animation.toValue = [NSNumber numberWithFloat:1];
    animation.delegate = self;
    animation.fillMode=kCAFillModeForwards;
    animation.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    plot.anchorPoint=CGPointMake(0, 0);
    [plot addAnimation:animation forKey:nil];
    // [graph addPlot:plot];
    
    /*
    times=50;
    
    NSTimer *dataTimer = [NSTimer timerWithTimeInterval:0.01
                                                 target:self
                                               selector:@selector(timerAction2:)
                                               userInfo:userInfo
                                                repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:dataTimer forMode:NSDefaultRunLoopMode];*/
}
-(void)timerAction2:(NSTimer *)timer{
    NSMutableDictionary *tempData=[timer.userInfo objectForKey:@"tempData"];
    NSMutableDictionary *sourceData=[timer.userInfo objectForKey:@"sourceData"];
    CPTPlot *plot=[timer.userInfo objectForKey:@"plot"];
    NSMutableArray *tempDataArray=[NSMutableArray arrayWithArray:[tempData objectForKey:@
                                                                  "tempData"]];
    NSMutableArray *sourceDataArray=[sourceData objectForKey:@"sourceData"];
    //CPTGraph *graph=[timer.userInfo objectForKey:@"graph"];
    for(int i=0;i<tempDataArray.count;i++){
        NSDecimalNumber *sourceData=[sourceDataArray objectAtIndex:i];
        [tempDataArray replaceObjectAtIndex:i withObject:(NSDecimalNumber*)[NSNumber numberWithDouble:[sourceData doubleValue]/times*count] ];
    }
    [tempData setValue:tempDataArray forKey:(NSString*)plot.identifier];
    [plot reloadData];
    count++;
    
    if (count>times) {
        [timer invalidate];
    }
}
-(void)plotStartAnimation:(NSMutableArray *)data plot:(CPTPlot *)plot graph:(CPTGraph *)graph
{
    NSMutableArray *sourceArray=[NSMutableArray arrayWithArray:data];

    
    NSMutableDictionary *userInfo=[NSMutableDictionary dictionaryWithObjectsAndKeys:data,@"data",sourceArray,@"sourceData",plot,@"plot",graph,@"graph", nil];
    for(int i=0;i<data.count;i++){
        [data replaceObjectAtIndex:i withObject:(NSDecimalNumber*)[NSNumber numberWithFloat:0] ];
    }
    [plot reloadData];
     [graph addPlot:plot];
    
    //动画执行次数
    times=30;

    NSTimer *dataTimer = [NSTimer timerWithTimeInterval:0.01
                                        target:self
                                      selector:@selector(timerAction:)
                                      userInfo:userInfo
                                       repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:dataTimer forMode:NSDefaultRunLoopMode];
}
-(void)timerAction:(NSTimer *)timer{
    NSMutableArray *data=[NSMutableArray arrayWithArray: [timer.userInfo objectForKey:@"data"]];
    NSMutableArray *dataSource=[timer.userInfo objectForKey:@"sourceData"];
    CPTPlot *plot=[timer.userInfo objectForKey:@"plot"];
    CPTGraph *graph=[timer.userInfo objectForKey:@"graph"];
    for(int i=0;i<data.count;i++){
        NSDecimalNumber *sourceData=[dataSource objectAtIndex:i];
        [data replaceObjectAtIndex:i withObject:(NSDecimalNumber*)[NSNumber numberWithDouble:[sourceData doubleValue]/times*count] ];
    }

    [plot reloadData];
    count++;
    
    if (count>times) {
        CPTLegend *theLegend=[CPTLegend legendWithGraph:graph];
        theLegend.numberOfRows	  = 1;
        theLegend.cornerRadius	  = 10.0;
        theLegend.swatchSize	  = CGSizeMake(20.0, 20.0);
        theLegend.rowMargin		  = 10.0;
        theLegend.paddingLeft	  = 12.0;
        graph.legend=theLegend;
        [timer invalidate];
    }
}
-(void)plotRatationAnimation:(CPTPlot*)plot graph:(CPTGraph*)graph
{
    CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
	rotation.removedOnCompletion = YES;
	rotation.fromValue			 = [NSNumber numberWithFloat:M_PI * 1];
	rotation.toValue			 = [NSNumber numberWithFloat:0.0f];
	rotation.duration			 = 1.0f;
	rotation.timingFunction		 = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	rotation.delegate			 = self;
	[plot addAnimation:rotation forKey:@"rotation"];
    [graph addPlot:plot];
}
+(void)plotRatationAnimation:(CPTPlot*)plot direction:(NSUInteger)direction
{
    CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
	rotation.removedOnCompletion = YES;
    if (direction==0) {
        rotation.fromValue			 = [NSNumber numberWithFloat:0.0];
        rotation.toValue			 = [NSNumber numberWithFloat:-M_PI*2];
    }else {
        rotation.fromValue			 = [NSNumber numberWithFloat:0.0];
        rotation.toValue			 = [NSNumber numberWithFloat:M_PI*2];
    }
	
	rotation.duration			 = 1.0f;
	rotation.timingFunction		 = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	rotation.delegate			 = self;
    [plot addAnimation:rotation forKey:@"rotation"];
}
-(void)plotScaleAnimation:(CPTPlot*)plot
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    //transformAnimation.removedOnCompletion = YES;
    animation.duration = 1;
    animation.fromValue = [NSNumber numberWithFloat:0.1];
    animation.toValue = [NSNumber numberWithFloat:1];
    animation.delegate = self;
    animation.fillMode=kCAFillModeForwards;
    animation.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    plot.anchorPoint=CGPointMake(0, 0);
    [plot addAnimation:animation forKey:nil];
    
}
-(void)plotScaleAnimationWithGraph:(CPTGraph *)graph
{
    /*for(CPTPlot *plot in graph.allPlots)
    {
        [self plotScaleAnimation:plot];
    }*/

    [self plotScaleAnimation:[graph.allPlots objectAtIndex:0]];
    
}
-(CATransition*)showNavigationController
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.8;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionPush;
    transition.delegate = self;
    return transition;
}


- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    if (flag == YES) {
        if (delegate && [delegate respondsToSelector:@selector(onAnimationDone)]) {
            [delegate onAnimationDone];
        }
    }
    
}

@end
