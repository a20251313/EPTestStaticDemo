//
//  EPBottomListVIew.m
//  EPTestStaticDemo
//
//  Created by jingfuran on 15/7/14.
//  Copyright (c) 2015年 jingfuran. All rights reserved.
//

#import "EPBottomListView.h"
#import "EPBottomCell.h"
#import "BFUtils.h"

@interface EPBottomListView ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    __weak  IBOutlet UITableView     *m_tableView;
    __weak  IBOutlet UIView          *m_headView;
    __weak  IBOutlet UIView          *m_alphaView;
    __weak  IBOutlet UILabel         *m_labelFirstTitle;
    __weak  IBOutlet UILabel         *m_labelSecondTitle;
    __weak  IBOutlet UILabel         *m_labelLevel;
    
    NSMutableArray                  *m_arrayData;
    NSInteger                       m_currentIndex;
    NSInteger                       m_cellHeight;
}
@end
@implementation EPBottomListView
@synthesize delegate;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)addData
{
    NSArray  *arraySubject = [NSArray  arrayWithObjects:@"全部",@"行政部",@"研发部",@"测试部",@"行政部",@"研发部",@"测试部",nil];
    if (!m_arrayData)
    {
        m_arrayData = [[NSMutableArray alloc] init];
    }
    for (long i = 0;i < arraySubject.count;i++)
    {
        srandom(time(NULL)+i);
        long value = random()%50000;
        [m_arrayData addObject:[NSDictionary dictionaryWithObjectsAndKeys:arraySubject[i],@(value), nil]];
    }
    
    [m_tableView reloadData];
    
}
-(void)awakeFromNib
{
    m_currentIndex = 0;
    m_cellHeight = 44;
    m_labelLevel.layer.masksToBounds = YES;
    m_labelLevel.layer.cornerRadius = 5;
    m_labelLevel.layer.borderWidth = 1;
    m_labelLevel.layer.borderColor = [UIColor colorWithRed:179/255.0 green:228/255.0 blue:31/255.0 alpha:1].CGColor;
    [self addData];
    [self initAlphaView];
    [m_tableView reloadData];
}


/**
 *  增加各个不透明度块
 */
-(void)initAlphaView
{
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    m_alphaView.backgroundColor = [UIColor clearColor];
    
    UIView  *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, 5)];
    [topView setBackgroundColor:[UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0 alpha:1]];
    [m_alphaView addSubview:topView];
    
    UIView  *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 39, size.width, 5)];
    [bottomView setBackgroundColor:[UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0 alpha:1]];
    [m_alphaView addSubview:bottomView];
    
    
    
    
    UIView  *left1View = [[UIView alloc] initWithFrame:CGRectMake(0, 0,10, 44)];
    [left1View setBackgroundColor:[UIColor colorWithRed:242.0/255.0 green:243.0/255.0 blue:243.0 alpha:1]];
    [m_alphaView addSubview:left1View];
    
    
    UIView  *left2View = [[UIView alloc] initWithFrame:CGRectMake(10+34,5,10, 44-10)];
    [left2View setBackgroundColor:[UIColor colorWithRed:242.0/255.0 green:243.0/255.0 blue:243.0 alpha:1]];
    [m_alphaView addSubview:left2View];
    
    UIView  *middleView = [[UIView alloc] initWithFrame:CGRectMake(size.width/2, 0,10, 44)];
    [middleView setBackgroundColor:[UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0 alpha:1]];
    [m_alphaView addSubview:middleView];
    
    UIView  *rightView = [[UIView alloc] initWithFrame:CGRectMake(size.width-10,0,10, 44)];
    [rightView setBackgroundColor:[UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0 alpha:1]];
    [m_alphaView addSubview:rightView];
    
}

#pragma mark - TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_arrayData.count+2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return m_cellHeight;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    EPBottomCell    *cell = [tableView dequeueReusableCellWithIdentifier:@"EPBottomCell"];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"EPBottomCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    if (indexPath.row < m_arrayData.count)
    {
        id info  = m_arrayData[indexPath.row];
        cell.labelTitle.text = [[info allValues] firstObject];
        cell.labelContent.text = [BFUtils formatNumber:[[[info allKeys] firstObject] description]];
        cell.labelLevel.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
        cell.labelLevel.hidden = NO;
    }else
    {
        cell.labelTitle.text = @"";
        cell.labelContent.text = @"";
        cell.labelLevel.hidden = YES;
    }
    
    if (indexPath.row == m_currentIndex)
    {
        [cell.labelContent setTextColor:[UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1]];
    }else
    {
        [cell.labelContent setTextColor:[UIColor colorWithRed:179/255.0 green:228/255.0 blue:31/255.0 alpha:1]];
    }
    
        
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    
}

#pragma mark - scrollView Delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        CGFloat  fypoint = scrollView.contentOffset.y;
        int index = [self getIndexOfPointY:fypoint];
        if (m_currentIndex != index)
        {
            m_currentIndex = index;
            [m_tableView reloadData];
             [self callDelegate];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [scrollView setContentOffset:CGPointMake(0, m_currentIndex*m_cellHeight) animated:YES];
        });
    }
    NSLog(@"scrollViewDidEndDragging:%@ willDecelerate:%d",scrollView,decelerate);
}




- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat  fypoint = scrollView.contentOffset.y;
   int index = [self getIndexOfPointY:fypoint];
    if (m_currentIndex != index)
    {
        m_currentIndex = index;
        [self callDelegate];
    }
    [m_tableView reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
       
        [scrollView setContentOffset:CGPointMake(0, m_currentIndex*m_cellHeight) animated:YES];
    });
    
    NSLog(@"scrollViewDidEndDecelerating:%@",scrollView);
 
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;
{
    [m_tableView reloadData];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat  fypoint = scrollView.contentOffset.y;
    int index = [self getIndexOfPointY:fypoint];
    if (m_currentIndex != index)
    {
        m_currentIndex = index;
        //[m_tableView reloadData];
         [self callDelegate];
    }
     NSLog(@"scrollViewDidScroll:%@",scrollView);
}
-(void)callDelegate
{
    if (delegate && [delegate respondsToSelector:@selector(scrollToBottomDic:)])
    {
        [delegate scrollToBottomDic:nil];
    }
    
}

-(NSInteger)getIndexOfPointY:(int)pointY
{
    if (pointY < 0)
    {
        pointY = 0;
    }
    
    NSInteger index = pointY/m_cellHeight;
    if (pointY%m_cellHeight > 10)
    {
        index++;
    }
  
    //int index = pointY/m_cellHeight;
    
    NSLog(@"getIndexOfPointY:%d",index);
    
    return index;
}

@end
