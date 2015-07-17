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
    CGFloat Xpoint = 54;
    CGFloat fwidth = size.width/2-54;
    [self.labelTitle setFrame:CGRectMake(Xpoint, 10, fwidth, 21)];
    [self.labelContent setFrame:CGRectMake(Xpoint+size.width/2, 10, fwidth, 21)];
    
    self.labelLevel.layer.masksToBounds = YES;
    self.labelLevel.layer.cornerRadius =7;


    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
