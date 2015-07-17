//
//  EPTopFunctionView.m
//  BizfocusOC
//
//  Created by jingfuran on 15/6/16.
//  Copyright (c) 2015年 郑东尧. All rights reserved.
//

#import "EPTopFunctionView.h"



@interface EPTopFunctionView ()
{
    __weak  IBOutlet   UILabel  *labelLeft;
    __weak  IBOutlet   UILabel  *labelRight;
}

@property(nonatomic,strong)NSDictionary *dicData;
@end

@implementation EPTopFunctionView

@synthesize dicData;


-(void)animationWithScale:(CGFloat)scale durtion:(double)durtion
{
    [UIView animateWithDuration:0.1 animations:^{
        //self.layer.anchorPoint = CGPointMake(0, 0);
        self.transform = CGAffineTransformMakeScale(scale, scale);
    } completion:^(BOOL finish){
        
        [UIView animateWithDuration:0.2 animations:^{
            self.transform = CGAffineTransformMakeScale(0.9, 0.9);
        }
                         completion:^(BOOL finish){
                             
                             [UIView animateWithDuration:0.15 animations:^{
                                 self.transform = CGAffineTransformMakeScale(1, 1);
                             }]
                             ;
                         }];
        
    }];
    
}

-(void)refreshWithdicData:(NSDictionary*)dicTemp
{
    if (dicTemp)
    {
        [labelRight setText:[NSString stringWithFormat:@"%@",[dicTemp objectForKey:@"money"]]];
        [labelLeft setText:[dicTemp objectForKey:@"item"]];
    }
    self.dicData = dicTemp;
    
}





-(void)awakeFromNib
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    [self setBounds:CGRectMake(0, 0, size.width, 30)];
    [self layoutIfNeeded];
}



@end
