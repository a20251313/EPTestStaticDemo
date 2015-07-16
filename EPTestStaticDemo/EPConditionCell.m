//
//  EPConditionCell.m
//  BizfocusOC
//
//  Created by jingfuran on 15/7/13.
//  Copyright (c) 2015年 郑东尧. All rights reserved.
//

#import "EPConditionCell.h"

@implementation EPConditionCell

- (void)awakeFromNib {
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    // Initialization code
}

@end
