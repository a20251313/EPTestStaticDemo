//
//  FPRootViewController.h
//  BizfocusOC
//
//  Created by jingfuran on 15/4/8.
//  Copyright (c) 2015年 郑东尧. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EPRootViewController : UIViewController

-(UIBarButtonItem*)addBackBtn:(UIImage*)image backAction:(SEL)backSelect;


-(UIBarButtonItem*)createBackButtonItem;
@end
