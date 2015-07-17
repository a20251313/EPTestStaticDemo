//
//  EPTopFunctionView.m
//  BizfocusOC
//
//  Created by jingfuran on 15/6/16.
//  Copyright (c) 2015年 郑东尧. All rights reserved.
//

#import "EPTopBarFunctionView.h"



@interface EPTopBarFunctionView ()
{
    __weak  IBOutlet   UILabel  *labelLeft;
    __weak  IBOutlet   UILabel  *labelRight;
    UIView  *m_stepBgView;
}

@property(nonatomic,strong)NSDictionary *dicData;
@end

@implementation EPTopBarFunctionView

@synthesize delegate;
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


-(void)initSteperAndLayoutSubView
{
    //30
    CGFloat fheight = 30;
    CGSize size = [UIScreen mainScreen].bounds.size;
    if (!m_stepBgView)
    {
        m_stepBgView = [[UIView alloc] initWithFrame:CGRectMake(15, 5, 65, fheight-10)];
        [m_stepBgView setBackgroundColor:[UIColor whiteColor]];
        m_stepBgView.layer.masksToBounds = YES;
        m_stepBgView.layer.cornerRadius = 5;
        m_stepBgView.layer.borderWidth =    1;
        m_stepBgView.layer.borderColor = [UIColor colorWithRed:179/255.0 green:228/255.0 blue:31/255.0 alpha:1].CGColor;
        [self addSubview:m_stepBgView];
        
        UIView  *lineView = [[UIView alloc] initWithFrame:CGRectMake(m_stepBgView.frame.size.width/2-1, 0, 1, m_stepBgView.frame.size.height)];
        [lineView setBackgroundColor:[UIColor colorWithRed:179/255.0 green:228/255.0 blue:31/255.0 alpha:1]];
        [m_stepBgView addSubview:lineView];
        
        UIButton  *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, (m_stepBgView.frame.size.height-22)/2, m_stepBgView.frame.size.width/2, 22)];
        [leftButton setImage:[UIImage imageNamed:@"step_down.png"] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(clickDownNumber:) forControlEvents:UIControlEventTouchUpInside];
        leftButton.adjustsImageWhenHighlighted = NO;
        
        [m_stepBgView addSubview:leftButton];
        
        UIButton  *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(m_stepBgView.frame.size.width/2, (m_stepBgView.frame.size.height-22)/2, m_stepBgView.frame.size.width/2, 22)];
        [rightButton setImage:[UIImage imageNamed:@"step_up.png"] forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(clickUpNumber:) forControlEvents:UIControlEventTouchUpInside];
        [m_stepBgView addSubview:rightButton];
        rightButton.adjustsImageWhenHighlighted = NO;
    }
    
    [labelLeft setFrame:CGRectMake(m_stepBgView.frame.size.width+m_stepBgView.frame.origin.x+10, (fheight-labelLeft.frame.size.height)/2,size.width/2-(m_stepBgView.frame.size.width+m_stepBgView.frame.origin.x+10)+10, labelLeft.frame.size.height)];
    [labelRight setFrame:CGRectMake(size.width/2, (fheight-labelRight.frame.size.height)/2,size.width/2, labelRight.frame.size.height)];
}


-(void)clickDownNumber:(id)sender
{
    if (delegate && [delegate respondsToSelector:@selector(topNumberChangeClicked:)])
    {
        [delegate topNumberChangeClicked:NO];
    }
}

-(void)clickUpNumber:(id)sender
{
    if (delegate && [delegate respondsToSelector:@selector(topNumberChangeClicked:)])
    {
        [delegate topNumberChangeClicked:YES];
    }
}



-(void)awakeFromNib
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    [self setBounds:CGRectMake(0, 0, size.width, 30)];
    [self initSteperAndLayoutSubView];
}



@end
