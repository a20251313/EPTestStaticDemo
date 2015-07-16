//
//  EPBottomListVIew.h
//  EPTestStaticDemo
//
//  Created by jingfuran on 15/7/14.
//  Copyright (c) 2015年 jingfuran. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EPBottomListViewDelegate <NSObject>

-(void)scrollToBottomDic:(NSDictionary*)dicInfo;

@end

@interface EPBottomListView : UIView

@property(nonatomic,weak)id<EPBottomListViewDelegate> delegate;
@end
