//
//  FPRootViewController.m
//  BizfocusOC
//
//  Created by jingfuran on 15/4/8.
//  Copyright (c) 2015年 郑东尧. All rights reserved.
//

#import "EPRootViewController.h"
#import "BFUtils.h"

@interface EPRootViewController ()

@end

@implementation EPRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:9.0/255.0 green:61.0/255.0 blue:123.0/255.0 alpha:1];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [self createBackButtonItem];
    // Do any additional setup after loading the view.
}

//监听session 过期消息


-(UIBarButtonItem*)addBackBtn:(UIImage*)image backAction:(SEL)backSelect
{
    
    UIImage  *btnimage =  image;
    if (btnimage == nil)
    {
        btnimage = [UIImage imageNamed:@"btn_goback"];
    }
    SEL  sel = backSelect;
    if (sel == nil)
    {
        sel = @selector(backAction:);
    }
    UIButton    *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, btnimage.size.width/2, btnimage.size.height/2)];
    [btnBack setImage:btnimage forState:UIControlStateNormal];
    [btnBack addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem  *leftitem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    return leftitem;
    
}


-(void)backAction:(id)sender
{
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // [BFUtils hudSuccessHidden];
}

-(UIBarButtonItem*)createBackButtonItem
{
    UIBarButtonItem *button = [self addBackBtn:nil backAction:nil];
    return button;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
