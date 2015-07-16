//
//  ViewController.m
//  EPTestStaticDemo
//
//  Created by jingfuran on 15/7/13.
//  Copyright (c) 2015年 jingfuran. All rights reserved.
//

#import "ViewController.h"
#import "EPStaticCenterViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    
    UIButton  *button = [[UIButton alloc] initWithFrame:CGRectMake((size.width-100)/2, 100, 100, 50)];
    [button setTitle:@"查看图表" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)clickButton:(id)sender
{
    EPStaticCenterViewController  *center = [[EPStaticCenterViewController alloc] init];
    [self.navigationController pushViewController:center animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
