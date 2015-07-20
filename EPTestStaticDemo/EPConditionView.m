//
//  EPConditionVIew.m
//  BizfocusOC
//
//  Created by jingfuran on 15/7/13.
//  Copyright (c) 2015年 郑东尧. All rights reserved.
//

#import "EPConditionView.h"
#import "EPConditionCell.h"
#import "BFUtils.h"
@interface EPConditionView ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSMutableArray  *m_arrayData;
    UICollectionView  *m_collectionView;
    NSInteger   m_currentIndex;
}

@end

@implementation EPConditionView
@synthesize delegate;
-(id)initWithFrame:(CGRect)frame
{
    [NSException raise:@"Please use function initWithFrame:staticType:" format:@""];
    return nil;
}

-(id)initWithFrame:(CGRect)frame  staticType:(EPStaticType)type
{
   
    self = [super initWithFrame:frame];
    if (self)
    {
        self.staticType = type;
        [self defaultInit];
    }
    return self;
}

- (void)setUpCollectionView
{
    if (m_collectionView == nil)
    {
        CGSize size = [UIScreen mainScreen].bounds.size;
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(75, 75);
        flowLayout.minimumInteritemSpacing = 5;
        flowLayout.minimumLineSpacing = 5;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        
        m_collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, size.width, self.frame.size.height) collectionViewLayout:flowLayout];
        m_collectionView.backgroundColor = [UIColor colorWithRed:242.0 /255.0 green:242.0 /255.0 blue:242.0 /255.0 alpha:1.0];
        self.backgroundColor = [UIColor colorWithRed:242.0 /255.0 green:242.0 /255.0 blue:242.0 /255.0 alpha:1.0];
        m_collectionView.dataSource = self;
        m_collectionView.delegate = self;
        [m_collectionView registerNib:[UINib nibWithNibName:@"EPConditionCell" bundle:nil] forCellWithReuseIdentifier:@"EPConditionCell"];
        [self addSubview:m_collectionView];
        
        m_collectionView.delegate = self;
        m_collectionView.dataSource = self;
    
        
    }
    
    [m_collectionView reloadData];
    
}


-(void)defaultInit
{
    m_currentIndex = 0;
    if (!m_arrayData)
    {
        m_arrayData = [[NSMutableArray alloc] init];
    }
    [m_arrayData removeAllObjects];
    
    NSArray  *allTitles =  [NSArray arrayWithObjects:@"全部",@"交通费用",@"通讯费",@"餐饮费用",@"出差费",@"业务费",nil];
    for (int i = 0;i < allTitles.count;i++)
    {
        srandom(time(NULL)+i);
        long value = random()%50000;
        NSDictionary  *dicMoney = [NSDictionary dictionaryWithObjectsAndKeys:allTitles[i],@(value),nil];
        [m_arrayData addObject:dicMoney];
    }
   
    
    [self setUpCollectionView];
    
}

#pragma get current select condition
-(id)getCurrentCondition
{
    if (m_currentIndex < m_arrayData.count)
    {
        return m_arrayData[m_currentIndex];
    }
    return [m_arrayData firstObject];
}

#pragma mark - UICollectionView DateSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return m_arrayData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary  *dicInfo = m_arrayData[indexPath.row];
    EPConditionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EPConditionCell" forIndexPath:indexPath];
    cell.labelTitle.text = [[dicInfo allValues] firstObject];
    NSString *strMoney = [NSString stringWithFormat:@"%@",[BFUtils formatNumber:[[[dicInfo allKeys] firstObject] description]]];
    cell.labelContent.text = strMoney;
    NSString  *strName = [NSString stringWithFormat:@"%d.png",indexPath.row%4+1];
    cell.imageIcon.image = [UIImage imageNamed:strName];
    if (indexPath.row == m_currentIndex)
    {
        [cell.labelContent setTextColor:[UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1]];
    }else
    {
         [cell.labelContent setTextColor:[UIColor colorWithRed:179/255.0 green:228/255.0 blue:31/255.0 alpha:1]];
    }
    return cell;
}

#pragma mark - UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    m_currentIndex = indexPath.row;
    NSDictionary  *dicInfo = m_arrayData[indexPath.row];
    if (delegate && [delegate respondsToSelector:@selector(userDidChooseCondition:type:)]) {
        [delegate userDidChooseCondition:dicInfo type:self.staticType];
    }
    [collectionView reloadData];
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
