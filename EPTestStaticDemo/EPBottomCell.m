//
//  EPBottomCell.m
//  EPTestStaticDemo
//
//  Created by jingfuran on 15/7/14.
//  Copyright (c) 2015年 jingfuran. All rights reserved.
//

#import "EPBottomCell.h"

@implementation EPBottomCell

- (void)awakeFromNib {
    
    CGSize  size = [UIScreen mainScreen].bounds.size;
    CGFloat Xpoint = 10;
    CGFloat fwidth = size.width/2-20;
    [self.labelTitle setFrame:CGRectMake(Xpoint, 10, fwidth, 21)];
    [self.labelContent setFrame:CGRectMake(Xpoint+size.width/2, 10, fwidth, 21)];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
