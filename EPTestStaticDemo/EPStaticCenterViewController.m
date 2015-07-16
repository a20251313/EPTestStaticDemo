//
//  EPStaticCenterViewController.m
//  BizfocusOC
//
//  Created by jingfuran on 15/6/8.
//  Copyright (c) 2015年 郑东尧. All rights reserved.
//

#import "EPStaticCenterViewController.h"
#import "CorePlot-CocoaTouch.h"
#import "BAColorHelper.h"
#import "BAAnimationHelper.h"
#import "BFUtils.h"

#import "EPConditionView.h"
#import "EPAllEnum.h"
#import "EPTopFunctionView.h"
#import "EPBottomListView.h"
#import "EPDefineNumber.h"
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define kFirstItem  @"firstItem"
#define kSecondItem  @"secondItem"


typedef enum
{
    EPCenterBarTypeDefault,
    EPCenterBarTypeSelectBar,
    EPCenterBarTypeNumber,
    EPCenterBarTypeSelectNumber,
}EPCenterBarType;

@interface EPStaticCenterViewController ()<CPTBarPlotDataSource,CPTAxisDelegate,CPTPlotSpaceDelegate,EPConditionViewDelegate,EPBottomListViewDelegate>
{
    

    
    NSMutableDictionary   *m_dicData;  //总的数值

    
    NSMutableArray          *m_arrayTitle;
    
    UIScrollView            *m_topScrollView;//维度数据展示
    
    EPStaticType     m_centerType;
    EPStaticType     m_bottomType;
    CGFloat          m_hostViewHeight;
    
    EPTopFunctionView       *m_topInfoView;
    
    NSMutableArray          *m_arrayDimones;    //存贮当前页面显示的维度类型
    NSInteger               m_currentIndex;     //当前数据在m_arrayDimones的index
    
    EPCenterBarType         m_barType;
    
    NSInteger       m_currentCount;
    
    NSMutableDictionary            *m_dicReuseLabel;
    

    BOOL                    m_bShowZero;    //是否显示木有金额的数据
    NSMutableArray          *m_arrayData;   //需要显示的数据Description 和ID
    
    EPConditionView         *m_conditionView;
    EPBottomListView        *m_bottomView;
    CGFloat                 CPDBarWidth;
    CGFloat                 CPDBarOffset;
    CGFloat                 CPDBarInitialX;
    
    UISlider                *m_slider;
}


//  CGFloat                 CPDBarWidth = 26;
//CGFloat                 CPDBarOffset = 10;
//CGFloat                 CPDBarInitialX = 15;

@property (nonatomic, strong) CPTGraphHostingView *hostView;
@property (nonatomic, strong) CPTBarPlot *plot;

@property(nonatomic,strong)CPTXYPlotSpace *plotSpace;
@property(nonatomic,strong)NSString   *changeItem;
@property(nonatomic,strong)NSDictionary *dicFilter;

@property(nonatomic)NSDictionary       *selectItemDic;//当前点击选中的X选项
@end

@implementation EPStaticCenterViewController

@synthesize plotSpace;
@synthesize hostView;
@synthesize plot;
@synthesize changeItem;
@synthesize dicFilter;
@synthesize selectItemDic;
@synthesize middleType;





- (void)viewDidLoad {
    [super viewDidLoad];
    
    m_barType = EPCenterBarTypeDefault;
    if (!m_arrayDimones)
    {
        m_arrayDimones = [[NSMutableArray alloc] init];
        [m_arrayDimones addObject:@(EPStaticTypePerson)];
    }
    
    m_centerType = EPStaticTypeTime;
    m_bottomType = EPStaticTypeSubject;
    
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.title = @"统计中心";
    [BFUtils setMainThemeColor:[UIColor colorWithRed:55/255.0 green:153/255.0 blue:40/255.0 alpha:1]];
    [self.navigationController.navigationBar setBarTintColor:[BFUtils mainThemeColor]];
    
    
    
    //UIColor  *defaultColor = [UIColor colorWithRed:130/255.0 green:138/255.0 blue:26/255.0 alpha:1];
    //self.navigationController.navigationBar.barTintColor = defaultColor;
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (m_dicData == nil)
    {
        m_dicData = [[NSMutableDictionary alloc] init];
    }
    if (m_arrayTitle == nil)
    {
        m_arrayTitle = [[NSMutableArray alloc] init];
    }  if (!m_arrayData)
    {
        m_arrayData = [[NSMutableArray alloc] init];
    }

    
    

    self.selectItemDic = nil;
  
    [self reloadData];
    // Do any additional setup after loading the view.
}



-(void)reloadData
{
    //[m_arrayTitle removeAllObjects];
    // NSArray *arrayTitle = [NSArray arrayWithObjects:@"2015年07月",@"2015年06月",@"2015年05月",@"2015年04月",@"2015年03月",@"2015年02月",@"2015年01月",@"2014年12月",@"2014年11月",@"2014年10月",@"2014年9月",@"2014年8月",nil];
    
    if (m_arrayTitle.count == 0)
    {
        NSArray *arrayTitle = [NSArray arrayWithObjects:@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",nil];
        [m_arrayTitle addObjectsFromArray:arrayTitle];
    }

    [self initSubView];
    [self reloadWithData:nil arrayTitle:m_arrayTitle];
    [m_topInfoView refreshWithdicData:[self getTopInfoForShow]];
    
}



-(void)viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
}


-(void)initMiddleView
{
    if (!m_conditionView)
    {
        CGSize size = [UIScreen mainScreen].bounds.size;
        m_conditionView = [[EPConditionView alloc] initWithFrame:CGRectMake(0, m_topScrollView.frame.origin.y+m_topScrollView.frame.size.height, size.width, 115) staticType:self.middleType];
        [self.view addSubview:m_conditionView];
        m_conditionView.delegate = self;
    }
}

-(void)initBottomView
{
    if (!m_bottomView)
    {
        CGSize  size = [UIScreen mainScreen].bounds.size;
        m_bottomView = [[[NSBundle mainBundle] loadNibNamed:@"EPBottomListView" owner:self options:nil] lastObject];
        m_bottomView.delegate = self;
        [m_bottomView setFrame:CGRectMake(0, size.height-180, size.width, 180)];
        [self.view addSubview:m_bottomView];
        
    }
}




-(void)initSubView
{
    if (self.hostView == nil)
    {
        [self initPlot];
    }
    
    CGSize  size = [UIScreen mainScreen].bounds.size;
    CGFloat fYpoint = 64;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (!m_topInfoView)
    {
        m_topInfoView = [[[NSBundle mainBundle] loadNibNamed:@"EPTopFunctionView" owner:self options:nil] lastObject];
        
        [self.view addSubview:m_topInfoView];
        
        [m_topInfoView setFrame:CGRectMake(0, fYpoint, size.width, 30)];
        
        // fYpoint += 30;
        UIView  *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 29, size.width, 1)];
        [lineView setBackgroundColor:[UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1]];
        [m_topInfoView addSubview:lineView];
  
    }
      [self initMiddleView];
    [self initBottomView];
}









- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    //Dispose of any resources that can be recreated.
}





#pragma mark - Chart behavior
-(void)initPlot {
    self.hostView.allowPinchScaling = NO;
    [self configureHost];
    [self configureGraph];
    [self configurePlots];
    [self configureAxes];
}

-(void)reloadWithData:(NSDictionary*)TemData arrayTitle:(NSArray*)titleArray
{
    
   
    if (m_dicData)
    {
        [m_dicData removeAllObjects];
    }
    if (m_arrayTitle != titleArray)
    {
        [m_arrayTitle removeAllObjects];
        [m_arrayTitle addObjectsFromArray:titleArray];
    }
    [m_dicData addEntriesFromDictionary:TemData];
    [self renderHostView:nil];
}

-(void)renderHostView:(NSArray*)oldData
{
    
    [m_arrayData removeAllObjects];
    if (1)
    {
        for (int i = 0;i < m_arrayTitle.count;i++)
        {
            srandom(time(NULL)+i);
            long  value = random()%10000;
            [m_arrayData addObject:[NSDictionary dictionaryWithObjectsAndKeys:m_arrayTitle[i],[@(value) description], nil]];
        }
        
    }
    

    //  [m_topScrollView setContentSize:CGSizeMake(m_topScrollView.frame.size.width, fheight)];
    
    
//    if (m_arrayData.count > 1)
//    {
//        
//        self.plot.barWidth = CPTDecimalFromInteger(26);
//    }else
//    {
//        CGFloat  fheight = (CPDBarWidth+CPDBarOffset)*m_arrayData.count+5;
//        
//        if (fheight != m_hostViewHeight)
//        {
//            m_hostViewHeight = fheight;
//            [self.hostView setFrame:CGRectMake(3, 0, SCREEN_WIDTH-17, fheight)];
//            [m_topScrollView setContentSize:CGSizeMake(m_topScrollView.frame.size.width, fheight)];
//        }
//        
//        self.plot.barWidth = CPTDecimalFromInteger(32);
//    }
  
    
    //  CPTGraph *graph = self.hostView.hostedGraph;
   
    CGFloat xMin = 0.0f;
    CGFloat xMax = self.hostView.frame.size.width;
    CGFloat yMin = 0.0f;
    CGFloat yMax = [self getMaxValueFromArray:m_arrayData];
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(xMin) length:CPTDecimalFromFloat(xMax)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(yMin) length:CPTDecimalFromFloat(yMax)];
    // [plotSpace scaleToFitPlots:[NSArray arrayWithObjects:self.plot, nil]];

    
     [self refreshWithSortType];
    
}

-(void)configureHost
{
    
    CGFloat  fwidth = [UIScreen mainScreen].bounds.size.width-20;
    CGFloat  fsep = 5;
    CPDBarWidth = (fwidth-11*fsep)/12;
    CPDBarOffset = fsep;
    CPDBarInitialX = CPDBarWidth/2;
    CGFloat  fYpoint = 64+30+1;
    CGFloat  fheight = [UIScreen mainScreen].bounds.size.height-fYpoint-115-180;
    
    if (m_topScrollView == nil)
    {
        m_topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, fYpoint, SCREEN_WIDTH, fheight)];
        m_topScrollView.showsHorizontalScrollIndicator = NO;
        m_topScrollView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:m_topScrollView];
        
        
        if (m_slider == nil)
        {
            m_slider = [[UISlider alloc] initWithFrame:CGRectMake(13, fheight-35, SCREEN_WIDTH-26, 23)];
            [m_slider setThumbImage:[UIImage imageNamed:@"slide_thuma.png"] forState:UIControlStateNormal];
            [m_slider setMinimumTrackTintColor:[UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1]];
            [m_slider setMaximumTrackTintColor:[UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1]];
            [m_slider setMinimumValue:0];
            [m_slider setMaximumValue:12];
            [m_slider addTarget:self action:@selector(slideValueChange:) forControlEvents:UIControlEventValueChanged];
            [m_topScrollView addSubview:m_slider];
        }
    }
    
    CGRect rect = CGRectMake(10,0, SCREEN_WIDTH-20, fheight-40);
    m_hostViewHeight = fheight;
    self.hostView = [(CPTGraphHostingView *) [CPTGraphHostingView alloc] initWithFrame:rect];
    self.hostView.allowPinchScaling = NO;
    self.hostView.layer.borderColor = [UIColor clearColor].CGColor;
    [m_topScrollView addSubview:self.hostView];

    
    
}


-(void)setSliderIndex:(CGFloat)index
{
    // CGFloat  fmax = m_slider.maximumValue;
    //  CGFloat fsep = 0.5;
    
    CGFloat fwidth =  CPDBarInitialX+(CPDBarWidth+CPDBarOffset)*index-CPDBarWidth/2;
    CGFloat  fvalue =  fwidth/m_slider.frame.size.width*12;
    
    [m_slider setValue:fvalue animated:YES];
}

-(void)slideValueChange:(UISlider*)myslider
{
    CGFloat  fvalue = myslider.value;
    NSInteger  index = fvalue;
    CGFloat fsep = 0.5;
    if (index < 6)
    {
        fsep = 0.25;
    }
    if (index == 0)
    {
        [self barWasSelectedAtRecordIndex:0 isSlider:YES];
    }else
    {
        [self barWasSelectedAtRecordIndex:index isSlider:YES];
    }
    
    // [self barWasSelectedAtRecordIndex:fvalue];
    
#if DEBUG
    NSLog(@"slideValueChange:%f",fvalue);
#endif
}

-(CGFloat)getMaxValueFromArray:(NSArray*)array
{
 
    CGFloat fmax = 0;
    for (id info in array)
    {
        if ([info isKindOfClass:[NSDictionary class]])
        {
            double  temp = [[[info allKeys] firstObject] doubleValue];
            if (fmax < temp)
            {
                fmax = temp;
            }
           
        }
    }
    return fmax;
}


-(void)configureGraph {
    // 1 - Create the graph
    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
    graph.plotAreaFrame.masksToBorder = NO;
    
    //graph.fill = [CPTFill fillWithColor:[CPTColor redColor]];
    self.plotSpace = (CPTXYPlotSpace*)graph.defaultPlotSpace;
    self.hostView.hostedGraph = graph;
    
    self.hostView.backgroundColor = [UIColor clearColor];

    // graph.plotAreaFrame.borderColor = [UIColor clearColor].CGColor;
  
    //graph.plotAreaFrame.plotArea.fill = [CPTFill fillWithColor:[CPTColor redColor]];
    // 2 - Configure the graph
    
    
    //[graph applyTheme:[CPTTheme themeNamed:kCPTPlainWhiteTheme]];
    graph.paddingBottom = 20;
    graph.paddingLeft  = 10;
    graph.paddingTop    = 10.0f;
    graph.paddingRight  = 10.0f;
    
    

    graph.fill = [CPTFill fillWithColor:[CPTColor clearColor]];
    graph.plotAreaFrame.fill = [CPTFill fillWithColor:[CPTColor clearColor]];
    graph.plotAreaFrame.plotArea.fill = [CPTFill fillWithColor:[CPTColor clearColor]];

    
    // 5 - Set up plot space
    CGFloat xMin = 0.0f;
    CGFloat xMax =  self.hostView.frame.size.width;
    CGFloat yMin = 0.0f;
    CGFloat yMax = 10000;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(xMin) length:CPTDecimalFromFloat(xMax)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(yMin) length:CPTDecimalFromFloat(yMax)];
}

-(void)configurePlots {
    // 1 - Set up the three plots
    self.plot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor redColor] horizontalBars:YES];
    self.plot.identifier = @"aaplPlot";

    // 2 - Set up line style
    CPTMutableLineStyle *barLineStyle = [[CPTMutableLineStyle alloc] init];
    barLineStyle.lineColor = [CPTColor clearColor];
    barLineStyle.lineWidth = 0.5;
    // 3 - Add plots to graph
    CPTGraph *graph = self.hostView.hostedGraph;
    NSArray *plots = [NSArray arrayWithObjects:self.plot,nil];
    for (CPTBarPlot *barplot in plots) {
        barplot.dataSource = self;
        barplot.delegate = self;
        barplot.barWidth = CPTDecimalFromDouble(CPDBarWidth);
        barplot.barOffset = CPTDecimalFromDouble(2);
        barplot.lineStyle = barLineStyle;
        barplot.barsAreHorizontal = NO;
        [graph addPlot:barplot toPlotSpace:plotSpace];
    }
    [plotSpace scaleToFitPlots:plots];
    
}

-(void)configureAxes {
    // 1 - Configure styles
    
    CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
    axisLineStyle.lineWidth = 2.0f;
    axisLineStyle.lineColor = [BAColorHelper stringRGBToCPTColor:@"006090136" alpha:@"1"];
    
    CPTMutableTextStyle *axisTitleStyle = [CPTMutableTextStyle textStyle];
    axisTitleStyle.color = [CPTColor lightGrayColor];
    axisTitleStyle.fontName = @"Helvetica-Bold";
    axisTitleStyle.fontSize = 13.0f;

    // 2 - Get the graph's axis set
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) self.hostView.hostedGraph.axisSet;
    // 3 - Configure the x-axis
    axisSet.xAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
    axisSet.xAxis.title = nil;
    axisSet.xAxis.titleTextStyle = axisTitleStyle;
    axisSet.xAxis.titleOffset = 10.0f;
    axisSet.xAxis.axisLineStyle = axisLineStyle;
   
    plotSpace.delegate = self;
    // 4 - Configure the y-axi
    CPTAxisTitle  *labelTitle = [[CPTAxisTitle alloc] initWithText:@"单位:W" textStyle:axisTitleStyle];
    axisSet.yAxis.axisTitle = labelTitle;
    axisSet.yAxis.titleOffset = -self.hostView.frame.size.width-0;
    axisSet.yAxis.titleRotation = M_PI+M_PI_2;
    axisSet.yAxis.titleLocation = CPTDecimalFromFloat(5000);
    axisSet.yAxis.axisLineStyle = axisLineStyle;
    
    

}



-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}


#pragma mark - CPTPlotDataSource methods

-(double)getMoneyAccordIndx:(NSUInteger)index
{    
    return [[[m_arrayData[index] allKeys] firstObject] doubleValue];
}
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return m_arrayData.count;
}


-(double)doubleForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    
    if (fieldEnum == CPTBarPlotFieldBarTip) {
        if (m_barType == EPCenterBarTypeNumber || m_barType == EPCenterBarTypeSelectNumber)
        {
            return 0;
        }
        return [self getMoneyAccordIndx:index];
    }else if (fieldEnum == CPTBarPlotFieldBarLocation)
    {
        
        if (m_arrayData.count == 1)
        {
            return CPDBarInitialX+(CPDBarWidth+CPDBarOffset)*index+4;
        }
        if (m_barType == EPCenterBarTypeSelectNumber || m_barType == EPCenterBarTypeNumber)
        {
          return  CPDBarInitialX+(CPDBarWidth+CPDBarOffset)*index-1.5;
        }
        return CPDBarInitialX+(CPDBarWidth+CPDBarOffset)*index;
    }
    return index;
    
}


-(CPTTextLayer*)getLayisHight:(BOOL)isHighted index:(NSInteger)index
{
    if (!m_dicReuseLabel)
    {
        m_dicReuseLabel = [[NSMutableDictionary alloc] init];
    }
    
    CPTTextLayer  *layer = [m_dicReuseLabel objectForKey:@(index)];
    if (layer == nil)
    {
        layer = [[CPTTextLayer alloc] initWithText:@""];
        [m_dicReuseLabel setObject:layer forKey:@(index)];
    }
    static CPTMutableTextStyle  *textStyleH = nil;
    if (textStyleH == nil)
    {
        textStyleH = [layer.textStyle mutableCopy];
        textStyleH.fontSize = 16;
        textStyleH.color = [BAColorHelper stringRGBToCPTColor:@"006090136" alpha:@"1"];
    }
    
    static CPTMutableTextStyle  *textStyleN = nil;
    if (textStyleN == nil)
    {
        textStyleN = [layer.textStyle mutableCopy];
        textStyleN.fontSize = 16;
        textStyleN.color = [BAColorHelper stringRGBToCPTColor:@"186209248" alpha:@"1"];
    }
    
    if (isHighted)
    {
        layer.textStyle = textStyleH;
    }else
    {
        layer.textStyle = textStyleN;
    }

    return layer;
    
}

- (CPTLayer *)dataLabelForPlot:(CPTPlot *) plot recordIndex: (NSUInteger) index{
    
    if (m_barType == EPCenterBarTypeSelectBar || m_barType == EPCenterBarTypeDefault)
    {
        return nil;
    }
    
    NSString  *strCurreentItem = nil;
    if (index < m_arrayData.count)
    {
        strCurreentItem = [[m_arrayData[index] allKeys] firstObject];
    }
    
    double price = [self getMoneyAccordIndx:index];
    
    UIColor *color = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
    CPTTextLayer *label = nil;
    if (m_barType == EPCenterBarTypeSelectNumber)
    {
        if ([strCurreentItem isEqualToString:[[self.selectItemDic allKeys] firstObject]])
        {
            label = [self getLayisHight:YES index:index];
        }else
        {
           label = [self getLayisHight:NO index:index];
        }
    }else
    {
        label = [self getLayisHight:YES index:index];
    }
  
    label.text = [BFUtils formatDouble:price];
    [label setFrame:CGRectMake(0, 0, 200, CPDBarWidth)];
    [label setBackgroundColor:color.CGColor];
    label.paddingTop = 10;
    return label;
    
}



#pragma mark - CPTBarPlotDelegate methods
-(void) barWasSelectedAtRecordIndex:(NSUInteger)index isSlider:(BOOL)isSlider {
    
    NSDictionary  *curreentItem = nil;
    if (index < m_arrayData.count)
    {
        curreentItem = m_arrayData[index];
    }
    CGFloat  fscale = 1.15;
    NSString  *currentKey = [[curreentItem allKeys] firstObject];
    
    NSString  *selectKey = [[self.selectItemDic allKeys] firstObject];
    if (isSlider)
    {
        m_barType = EPCenterBarTypeSelectBar;
        self.selectItemDic = curreentItem;
    }else
    {
        switch (m_barType)
        {
            case EPCenterBarTypeDefault:
                m_barType = EPCenterBarTypeSelectBar;
                self.selectItemDic = curreentItem;
                [m_topInfoView animationWithScale:fscale durtion:0.35];
                if (!isSlider) {
                    
                    [self setSliderIndex:index];
                }
                
                break;
            case EPCenterBarTypeSelectBar:
                if (![currentKey isEqualToString:selectKey])
                {
                    self.selectItemDic = curreentItem;
                    [m_topInfoView animationWithScale:fscale durtion:0.35];
                    if (!isSlider) {
                        
                        [self setSliderIndex:index];
                    }
                }else
                {
                    m_barType = EPCenterBarTypeDefault;
                    [self setSliderIndex:0];
                    self.selectItemDic = nil;
                }
                
                break;
            case EPCenterBarTypeNumber:
                m_barType = EPCenterBarTypeSelectNumber;
                self.selectItemDic = curreentItem;
                [m_topInfoView animationWithScale:fscale durtion:0.35];
                break;
            case EPCenterBarTypeSelectNumber:
                if (![currentKey isEqualToString:selectKey])
                {
                    self.selectItemDic = curreentItem;
                    [m_topInfoView animationWithScale:fscale durtion:0.35];
                }else
                {
                    m_barType = EPCenterBarTypeNumber;
                    self.selectItemDic = nil;
                }
                break;
                
            default:
                break;
        }
        
    }
  
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) self.hostView.hostedGraph.axisSet;
    axisSet.xAxis.axisLabels = [self buildLabelTitle];
    // axisSet.yAxis.axisLabels = [self buildyLabelTitle];
    [m_topInfoView refreshWithdicData:[self getTopInfoForShow]];
    [self.hostView.hostedGraph reloadData];
    [self.plot reloadData];
    
}


-(NSString *)legendTitleForBarPlot:(CPTBarPlot *)barPlot recordIndex:(NSUInteger)index
{
    return @"231454";
}
-(void)barPlot:(CPTBarPlot *)plot barWasSelectedAtRecordIndex:(NSUInteger)index
{
    [self barWasSelectedAtRecordIndex:index isSlider:NO];
}

-(CPTFill *)barFillForBarPlot:(CPTBarPlot *)barPlot recordIndex:(NSUInteger)index
{
    // return [CPTFill fillWithColor:[CPTColor greenColor]];
    NSString  *strCurreentItem = nil;
    if (index < m_arrayData.count)
    {
        strCurreentItem = [[m_arrayData[index] allKeys] firstObject];
    }
    
    NSString  *selectKey = [[self.selectItemDic allKeys] firstObject];
    if (m_barType == EPCenterBarTypeDefault)
    {
        
        return [CPTFill fillWithGradient:[CPTGradient gradientWithBeginningColor:[BAColorHelper stringRGBToCPTColor:@"157202058" alpha:@"1"] endingColor:[BAColorHelper stringRGBToCPTColor:@"179228031" alpha:@"1"]]];
    }else if (m_barType == EPCenterBarTypeSelectBar)
    {
        if ([strCurreentItem isEqualToString:selectKey])
        {
//            return [CPTFill fillWithColor:[BAColorHelper stringRGBToCPTColor:@"006090136" alpha:@"1"]];
//            /*
             return [CPTFill fillWithGradient:[CPTGradient gradientWithBeginningColor:[BAColorHelper stringRGBToCPTColor:@"047168225" alpha:@"1"] endingColor:[BAColorHelper stringRGBToCPTColor:@"103193236" alpha:@"1"]]];
        }else
        {
            return [CPTFill fillWithGradient:[CPTGradient gradientWithBeginningColor:[BAColorHelper stringRGBToCPTColor:@"157202058" alpha:@"1"] endingColor:[BAColorHelper stringRGBToCPTColor:@"179228031" alpha:@"1"]]];
        }
     
    }
    
    return [CPTFill fillWithColor:[CPTColor clearColor]];
    
}

/*
-(BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceUpEvent:(id)event atPoint:(CGPoint)point
{
    
    // NSLog(@"event:%@ point:%@",event,[NSValue valueWithCGPoint:point]);
   
    
    UIEvent *uievent = (UIEvent*)event;

    UITouch  *touch = [[uievent allTouches] anyObject];

    m_currentCount = touch.tapCount;
    if (m_currentCount == 1)
    {
     [self performSelector:@selector(singleTap:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSValue valueWithCGPoint:point],@"point", nil] afterDelay:0.25];
    }
    
    
    return YES;
}*/

-(void)singleTap:(NSDictionary*)dicInfo
{
    if (m_currentCount > 2)
    {
        return;
    }
    
    //单击
    if (m_currentCount == 1)
    {
        CGPoint point = [[dicInfo valueForKey:@"point"] CGPointValue];
        NSInteger  index = point.y/(m_hostViewHeight/m_arrayData.count);
        [self barWasSelectedAtRecordIndex:index isSlider:NO];
    }
    return;
    /*
    //双击
    if (m_currentCount == 2)
    {
         
        switch (m_barType)
        {
            case EPCenterBarTypeSelectBar:
                m_barType = EPCenterBarTypeSelectNumber;
                break;
            case EPCenterBarTypeSelectNumber:
                m_barType = EPCenterBarTypeSelectBar;
                break;
            case EPCenterBarTypeDefault:
                m_barType = EPCenterBarTypeNumber;
                break;
            case EPCenterBarTypeNumber:
                m_barType = EPCenterBarTypeDefault;
                break;
                
            default:
                break;
        }

        CPTXYAxisSet *axisSet = (CPTXYAxisSet *) self.hostView.hostedGraph.axisSet;
        axisSet.xAxis.axisLabels = [self buildLabelTitle];
        [axisSet.xAxis setNeedsRelabel];
        [m_topInfoView refreshWithdicData:[self getTopInfoForShow]];
        [self.hostView.hostedGraph reloadData];
        [self.plot reloadData];
        ///NSLog(@"singleTap:2");
    }
 */
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/




#pragma mark buildLabel
-(NSString*)getSusString:(NSString*)allString lengthSave:(NSInteger)length
{
    if ([allString length] < length/2)
    {
        return allString;
    }
    
    int totalLenth = 0;
    NSString  *strTemp = @"";
    NSString *regex = @"^[\u4e00-\u9fa5]";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    for (int i = 0;i < allString.length;i++)
    {
        if (totalLenth > length)
        {
            strTemp = [NSString stringWithFormat:@"%@%@",strTemp,@"..."];
            return strTemp;
        }
        
        
        NSString  *subStr= [allString substringWithRange:NSMakeRange(i, 1)];
        if ([test evaluateWithObject:subStr] ||
            [subStr isEqualToString:@"（"] ||
            [subStr isEqualToString:@"）"])
        {
            totalLenth+=2;
        }else
        {
            totalLenth += 1;
        }
        strTemp = [NSString stringWithFormat:@"%@%@",strTemp,subStr];
    }
    
    return strTemp;
}



-(CPTAxisLabel*)getLabelisHight:(BOOL)isHighted key:(NSNumber*)key text:(NSString*)text
{
    if (!m_dicReuseLabel)
    {
        m_dicReuseLabel = [[NSMutableDictionary alloc] init];
    }
    
    CPTAxisLabel  *label = [m_dicReuseLabel objectForKey:key];
    static CPTMutableTextStyle *textStyleNormal = nil;
    if (textStyleNormal == nil)
    {
        textStyleNormal = [CPTMutableTextStyle textStyle];
        textStyleNormal.color = [BAColorHelper stringRGBToCPTColor:@"179228031" alpha:@"1"];
        textStyleNormal.fontSize = 16;
    }
    
    
    
    static  CPTMutableTextStyle *textStyleHight = nil;
    if (textStyleHight == nil)
    {
        textStyleHight =  [CPTMutableTextStyle textStyle];
        textStyleHight.fontSize = 16;
        textStyleHight.color = [BAColorHelper stringRGBToCPTColor:@"103193236" alpha:@"1"];
    }
    
    
    if (label == nil)
    {
        label = [[CPTAxisLabel alloc] initWithText:@"" textStyle:nil];
        [m_dicReuseLabel setObject:label forKey:key];
        
        label.contentLayer.masksToBounds = YES;
        label.alignment = CPTAlignmentRight;
       
        label.offset = 5;
        
    }
    
    CPTTextLayer  *layer = (CPTTextLayer*)label.contentLayer;
    if (isHighted)
    {
        layer.textStyle = textStyleHight;
    }else
    {
        layer.textStyle = textStyleNormal;
    }
    layer.text = text;
    return label;
    
}

- (NSMutableSet*)buildLabelTitle
{
    NSMutableSet *newAxisLabels = [NSMutableSet set];
    NSString *selectKey  = nil;
    if (self.selectItemDic)
    {
        selectKey = [[self.selectItemDic allKeys] firstObject];
    }
    for ( NSInteger i = m_arrayData.count; i > 0; i--)
    {
        
        NSString   *tempValue = [[m_arrayData[i-1] allValues] firstObject];
        NSString  *strText =  tempValue;//[self getSusString:tempValue lengthSave:8];
        
        CPTAxisLabel *newLabel = [self getLabelisHight:NO key:@(i-1+2000) text:strText];
        newLabel.rotation = M_PI_4;
        if (m_barType == EPCenterBarTypeSelectBar || m_barType == EPCenterBarTypeSelectNumber)
        {
            if ([selectKey isEqualToString:[[m_arrayData[i-1] allKeys] firstObject]])
            {
                newLabel =   [self getLabelisHight:YES key:@(i-1+2000) text:strText];
            }
        }
       
        if (i == m_arrayData.count)
        {
            newLabel.tickLocation = CPTDecimalFromInteger(CPDBarInitialX+(CPDBarWidth+CPDBarOffset)*(i-1)+11);
        }else
        {
            newLabel.tickLocation = CPTDecimalFromInteger(CPDBarInitialX+(CPDBarWidth+CPDBarOffset)*(i-1)+15);
        }
        
        [newAxisLabels addObject:newLabel];
        newLabel.offset = -2;
    }
    
    return newAxisLabels;
}


- (NSMutableSet*)buildyLabelTitle
{
    
    NSMutableSet *newAxisLabels = [NSMutableSet set];

    double max = [self getMaxValueFromArray:m_arrayData];
    NSArray *arrayYValues = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4", nil];
    

    for ( NSInteger i = 0; i < arrayYValues.count; i++)
    {
        
       
        NSString  *strText =  arrayYValues[i];
        
    
        CPTAxisLabel *newLabel = [self getLabelisHight:NO key:@(i-1+3000) text:strText];
    
        
        newLabel.tickLocation = CPTDecimalFromInteger(max/4*(i+1));
        
        [newAxisLabels addObject:newLabel];
    }
    
    return newAxisLabels;
}


#pragma mark getDataAccordCondition

-(NSString*)getTotalDataByCondition:(NSDictionary*)dicInfo mainType:(EPStaticType)maintype bottomType:(EPStaticType)bottomType mainKeyID:(id)mainKeyID bottomID:(id)bottomKeyID
{
    

    NSNumber  *number = @(100);
    //  NSLog(@"selectSQL:%@ number:%@",selectSQL,number);
    //[m_topInfoView refreshType:EPTopFunctionTypeDefault dicData:[self getTopInfoForShow]];
    return [number description];
    
    
}

#pragma mark EPReportDataChoiceViewDelegate
-(void)needChangeData:(NSDictionary*)dicInfo staticType:(EPStaticType)type
{
    
    m_bottomType = type;
    self.dicFilter = dicInfo;
    NSDictionary  *dicTemp = [self getAllDataByCondition:dicInfo mainType:m_centerType bottomType:type];
    [self reloadWithData:dicTemp arrayTitle:m_arrayTitle];
    [m_topInfoView refreshWithdicData:[self getTopInfoForShow]];

}
-(NSDictionary*)getAllDataByCondition:(NSDictionary*)dicInfo mainType:(EPStaticType)maintype bottomType:(EPStaticType)bottomType
{
    

    self.changeItem = nil;
    NSDictionary  *dicTemp = nil;
#if DEBUG
     NSLog(@"getAllDataByCondition:%@",dicTemp);
#endif
    [m_topInfoView refreshWithdicData:[self getTopInfoForShow]];
    return dicTemp;
    
    
}
-(void)selectData:(NSDictionary*)dicInfo staticType:(EPStaticType)type otherInfo:(id)infokey
{
    
 
    m_barType = EPCenterBarTypeDefault;
    self.selectItemDic = nil;
    self.changeItem = [infokey description];
    [self renderHostView:nil];
    [m_topInfoView refreshWithdicData:[self getTopInfoForShow]];
    
    // NSTimeInterval  timeI = [[NSDate date] timeIntervalSinceDate:date];
    // NSLog(@"timeI:%f",timeI);
}



-(NSDictionary*)getTopInfoForShow
{

    NSString  *strItem = [[self.selectItemDic allValues] firstObject];
    NSString  *strMainId = [[[self.selectItemDic allKeys] firstObject] description];
    if (strItem == nil)
    {
        strItem = @"全部";
    }else
    {
        strItem = [NSString stringWithFormat:@"2015年%@月",strItem];
    }
    NSString *money =  strMainId;/*[self getTotalDataByCondition:self.dicFilter
                                           mainType:m_centerType
                                         bottomType:m_bottomType
                                          mainKeyID:strMainId
                                           bottomID:self.changeItem];*/
    if (money == nil)
    {
        double sum = 0;
        for (NSDictionary  *dic in m_arrayData)
        {
            double tem = [[[dic allKeys] firstObject] floatValue];
            sum += tem;
        }
        money = [@(sum) description];
    }
    // NSString  *strKey = [EPStaticCenterViewController getValueAccordType:m_centerType];
    NSString  *strTitle = [NSString stringWithFormat:@"%@",@"报销金额"];
    NSDictionary  *dicInfo = [NSDictionary dictionaryWithObjectsAndKeys:strTitle,@"title",@(m_centerType),@"type",strItem,@"item",[BFUtils formatNumber:money],@"money",nil];
    
    return dicInfo;
}



-(void)setGirdLine
{
    
    CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
    axisLineStyle.lineWidth = 1.0f;
    axisLineStyle.lineColor = [BAColorHelper stringRGBToCPTColor:@"243243243" alpha:@"1"];
    
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) self.hostView.hostedGraph.axisSet;
    CPTXYAxis *yAxis = axisSet.yAxis;
    CGFloat yMin = 0.0f;
    CGFloat yMax = [self getMaxValueFromArray:m_arrayData];
    yAxis.gridLinesRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(yMin) length:CPTDecimalFromFloat(yMax)];
    
    CPTMutableLineStyle *gridLineStyle = [[CPTMutableLineStyle alloc] init];
    gridLineStyle.lineColor = [BAColorHelper stringRGBToCPTColor:@"243243243" alpha:@"1"];
    gridLineStyle.lineWidth = 1;
    yAxis.axisLineStyle = axisLineStyle;
    // axisSet.xAxis.axisLineStyle = axisLineStyle;
    yAxis.majorGridLineStyle = gridLineStyle;
    
    EPDefineNumber  *format = [[EPDefineNumber alloc] init];
    [format setPositiveFormat:@"###,###,###"];
    yAxis.labelFormatter = nil;
    
    //y 轴：线型设置
    yAxis.majorTickLineStyle = gridLineStyle;
    
    //y 轴：不显示小刻度线
    yAxis. minorTickLineStyle = nil ;
    yAxis. majorIntervalLength = CPTDecimalFromFloat(yMax/4);
    
    
    
//    CPTTextLayer  *label = nil;
//    CPTMutableTextStyle *textStyle = nil;
//    if (textStyle == nil)
//    {
//        textStyle = [CPTMutableTextStyle textStyle];
//        textStyle.color = [BAColorHelper stringRGBToCPTColor:@"193193193" alpha:@"1"];
//        textStyle.fontSize = 16;
//    }
//    
//    
//    if (label == nil)
//    {
//        label = [[CPTTextLayer alloc] initWithText:@"2" style:textStyle];
//        [label setFrame:CGRectMake(0, 40, 20, 21)];
//    }
//    [self.hostView.hostedGraph addSublayer:label];
//    self.hostView.hostedGraph.masksToBorder = NO;
    
    CGFloat  fsep = (m_topScrollView.frame.size.height-30)/5;
    CGFloat  fypoint = 0;
    for (int i = 4; i > 0; i--)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, fypoint-5, 15, 21)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor colorWithRed:193/255.0 green:193/255.0  blue:193/255.0  alpha:1]];
        [label setText:[NSString stringWithFormat:@"%d",i]];
        [label setTextAlignment:NSTextAlignmentRight];
        [m_topScrollView addSubview:label];
        fypoint += fsep;
    }
  
    
    
}

#pragma mark JFDimensionSortControllerDelegate
-(void)refreshWithSortType
{
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) self.hostView.hostedGraph.axisSet;
    axisSet.xAxis.axisLabels = [self buildLabelTitle];
    [self setGirdLine];
    axisSet.xAxis.labelingPolicy  = CPTAxisLabelingPolicyNone;
    //axisSet.yAxis.labelingPolicy  = CPTAxisLabelingPolicyNone;
    // axisSet.yAxis.axisLabels = [self buildyLabelTitle];
    
    BAAnimationHelper *animation=[[BAAnimationHelper alloc]init];
    [animation plotStartAnimation:nil sourceData:nil plot:self.plot graph:self.hostView.hostedGraph];
    [self.hostView.hostedGraph reloadDataIfNeeded];
}



#pragma mark EPConditionViewDelegate
-(void)userDidChooseCondition:(NSDictionary*)dicInfo type:(EPStaticType)conditionType
{
    self.selectItemDic = nil;
    [self renderHostView:nil];
#if DEBUG
    NSLog(@"userDidChooseCondition:%@ type:%d",dicInfo,conditionType);
#endif
}

#pragma mark EPBottomListViewDelegate
-(void)scrollToBottomDic:(NSDictionary*)dicInfo
{
    self.selectItemDic = nil;
    [self renderHostView:nil];
}


@end
