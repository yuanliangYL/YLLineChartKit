//
//  YLChartDataView.m
//  Echart_ios
//
//  Created by AlbertYuan on 2019/8/23.
//  Copyright © 2019 Yunaliang. All rights reserved.
//

#import "YLChartDataView.h"

#define ChartWIDTH [UIScreen mainScreen].bounds.size.width

#define ChartHeight 270
#define kEchartViewHeight 220

@interface YLChartDataView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

//背景容器
@property (weak, nonatomic) IBOutlet UIView *chartInfoBackView;

//近几日
@property (weak, nonatomic) IBOutlet UIButton *reccentDayBtn;

//近一年
@property (weak, nonatomic) IBOutlet UIButton *renceentYearBtn;

//标识标签
@property (weak, nonatomic) IBOutlet UILabel *biaoshiLable;

//图表相关数据
@property(nonatomic,strong)PYOption *option;
@property(nonatomic,strong)PYGrid *grid;
@property(nonatomic,strong)PYAxis *xAxis;
@property(nonatomic,strong)PYAxis *yAxis;
@property(nonatomic,strong)PYCartesianSeries *series1;

@end

@implementation YLChartDataView

-(PYEchartsView *)kEchartView{
    if (!_kEchartView) {
        
       _kEchartView = [[PYEchartsView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, kEchartViewHeight)];
        _kEchartView.backgroundColor = [UIColor whiteColor];
       [self.scrollView addSubview:_kEchartView];
        
    }
    
    return  _kEchartView;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.frame = CGRectMake(0, 0,ChartWIDTH, ChartHeight);
    
    [self initUI];
}

//初始化界面
-(void)initUI{
    
    [self.reccentDayBtn setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1] forState:UIControlStateSelected];
    [self.reccentDayBtn setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] forState:UIControlStateNormal];
    self.reccentDayBtn.selected = YES;
    
    
    [self.renceentYearBtn setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1] forState:UIControlStateSelected];
    [self.renceentYearBtn setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] forState:UIControlStateNormal];
    
    
    //初始化图表
    [self creatScrollView];
    
    PYOption *option = [self theLineChartWithYaxis:nil andXaxis:nil withAllDataInfo:nil isRotation:NO];
    
    if (option != nil) {
       [self.kEchartView setOption:option];
       [self.kEchartView loadEcharts];
    }
    
    [self bringSubviewToFront:self.biaoshiLable];
    
    //[self showLineDemo];
    //[self.kEchartView loadEcharts];
}

//初始化滚动视图
- (void)creatScrollView{
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, kEchartViewHeight)];
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width, kEchartViewHeight);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.scrollEnabled = NO;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.bounces  = NO;
    [self.chartInfoBackView addSubview:self.scrollView];
}

//查看最近30天的数据
- (IBAction)receentDayClickAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickTypeWithInfo:)]) {
        
        self.reccentDayBtn.selected = YES;
        self.renceentYearBtn.selected = NO;
        [self.delegate didClickTypeWithInfo:DayType];
        
    }
}

//最近一年的数据
- (IBAction)receebtyearClickAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickTypeWithInfo:)]) {
        
        self.reccentDayBtn.selected = NO;
        self.renceentYearBtn.selected = YES;
        [self.delegate didClickTypeWithInfo:YearType];
    }
}

-(PYOption *)theLineChartWithYaxis:(NSMutableArray *)yaxis andXaxis:(NSMutableArray *)xaxis withAllDataInfo:(NSMutableArray *)data isRotation:(BOOL)rotation{

    //y轴坐标显示
    if (yaxis.count == 0 || yaxis == nil) {
        yaxis = [NSMutableArray arrayWithObjects:@"0", @"500", @"1000", @"1500", @"2000", @"2500", @"3000",nil];;
    }
    NSNumber *rotationNum = 0;
    NSNumber *gridheight = 0;
    if (rotation) {
        rotationNum = @(M_PI * 12.0);
        gridheight = @(kEchartViewHeight-70);
    }else{
        rotationNum = @(0);
        gridheight = @(kEchartViewHeight-50);
    }
 
    
    /** 图表选项 */
    return [PYOption initPYOptionWithBlock:^(PYOption *option) {
        option.calculableEqual(YES) //是否启用拖拽重计算特性，默认关闭
        .colorEqual(@[@"#FFD44C"])//数值系列的颜色列表(折线颜色)
        .backgroundColorEqual([[PYColor alloc] initWithColor:[UIColor whiteColor]]) // 图标背景色
        .animationEqual(YES) // 图标动画效果
        
         /** 直角坐标系内绘图网格, 说明见下图 */
        .gridEqual([PYGrid initPYGridWithBlock:^(PYGrid *grid) {
            grid.xEqual(@45).x2Equal(@10).yEqual(@20).y2Equal(@35)  // 左上角位置  // 右下角位置
            .borderWidthEqual(@0) //竖边距
            .borderColorEqual([PYColor colorWithHexString:@"#FFFFFF"])//边距颜色
            .heightEqual(gridheight);
        }])
        
         /** X轴设置 */
        .addXAxis([PYAxis initPYAxisWithBlock:^(PYAxis *axis) {
            axis.typeEqual(@"category") //横轴默认为类目型(就是坐标自己设置)
            .boundaryGapEqual(@YES) // 起始和结束两端空白
            .splitLineEqual([PYAxisSplitLine initPYAxisSplitLineWithBlock:^(PYAxisSplitLine *splitLine) {
                splitLine.showEqual(NO); // 分隔线
            }])
            .axisLineEqual([PYAxisLine initPYAxisLineWithBlock:^(PYAxisLine *axisLine) {
                axisLine.showEqual(NO);  // 坐标轴线
            }])
            .axisTickEqual([PYAxisTick initPYAxisTickWithBlock:^(PYAxisTick *axisTick) {
                axisTick.showEqual(NO);// X坐标轴小标记
            }])
            .dataEqual(xaxis) // X轴坐标数据
            .axisLabelEqual([PYAxisLabel initPYAxisLabelWithBlock:^(PYAxisLabel *axisLabel) { //x轴标签属性设置
                axisLabel.textStyleEqual([PYTextStyle initPYTextStyleWithBlock:^(PYTextStyle *textStyle) {
                    textStyle.fontSizeEqual(@12);
                    textStyle.colorEqual(@"#666666");
                }])
                .rotateEqual(rotationNum);
            }]);
        }])
        
        /** Y轴设置 */
        .addYAxis([PYAxis initPYAxisWithBlock:^(PYAxis *axis) {
            axis.typeEqual(@"value") //横轴默认为类目型(就是坐标自己设置)
            .splitLineEqual([PYAxisSplitLine initPYAxisSplitLineWithBlock:^(PYAxisSplitLine *splitLine) {
                splitLine.showEqual(YES) // 分隔线
                .lineStyleEqual([PYLineStyle initPYLineStyleWithBlock:^(PYLineStyle *lineStyle) {
                    lineStyle.typeEqual(@"solid")   //'solid' | 'dotted' | 'dashed' 虚线类型)
                    .colorEqual([PYColor colorWithHexString:@"#DFDFDF"]);
                }]);
            }])
            .axisLineEqual([PYAxisLine initPYAxisLineWithBlock:^(PYAxisLine *axisLine) {
                axisLine.showEqual(NO);  // 坐标轴线
            }])
            .axisTickEqual([PYAxisTick initPYAxisTickWithBlock:^(PYAxisTick *axisTick) {
                axisTick.showEqual(NO);// 坐标轴小标记
            }])
            .splitNumberEqual(@(yaxis.count -1))
            .dataEqual(yaxis) // X轴坐标数据
            .axisLabelEqual([PYAxisLabel initPYAxisLabelWithBlock:^(PYAxisLabel *axisLabel) { //x轴标签属性设置
                axisLabel.textStyleEqual([PYTextStyle initPYTextStyleWithBlock:^(PYTextStyle *textStyle) {
                    textStyle.fontSizeEqual(@12);
                    textStyle.colorEqual(@"#666666");
                }]);
            }]);
        }])
        
        /** 第一条折线设置 */
        .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
            series.smoothEqual(YES)
            .symbolSizeEqual(@1.5)
            .nameEqual(@"价格/元")
            .typeEqual(@"line")
            .itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
                itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *itemStyleProp) {
                    itemStyleProp.lineStyleEqual([PYLineStyle initPYLineStyleWithBlock:^(PYLineStyle *lineStyle) {
                        lineStyle.widthEqual(@1);
                    }]);
                }]);
            }])
            .dataEqual(data);
        }]);
    }];
}


/*
// ** 图表选项 */
//self.option = [[PYOption alloc] init];
////是否启用拖拽重计算特性，默认关闭
//self.option.calculable = YES;
////数值系列的颜色列表(折线颜色)
//self.option.color = @[@"#FFD44C"];
//// 图标背景色
//self.option.backgroundColor = [[PYColor alloc] initWithColor:[UIColor whiteColor]];
//self.option.animation = YES;
//
//
///** 直角坐标系内绘图网格, 说明见下图 */
//self.grid = [[PYGrid alloc] init];
//// 左上角位置
//self.grid.x = @(45);
//self.grid.y = @(20);
//// 右下角位置
//self.grid.x2 = @(10);
//self.grid.y2 = @(35);
//self.grid.borderWidth = @(0);  //竖边距
////self.grid.borderColor = [PYColor colorWithHexString:@"#FF0000"];   //边距颜色
//// 添加到图标选择中
//self.option.grid = self.grid;
//
///** X轴设置 */
//self.xAxis = [[PYAxis  alloc] init];
////横轴默认为类目型(就是坐标自己设置)
//self.xAxis.type = @"category";
//// 起始和结束两端空白
//self.xAxis.boundaryGap = @(YES);
//// 分隔线
//self.xAxis.splitLine.show = NO;
//// 坐标轴线
//self.xAxis.axisLine.show = NO;
//// X轴坐标数据
//self.xAxis.data =  [NSMutableArray arrayWithObjects:@"", @"", @"", @"", @"", @"", @"",nil];
//// X坐标轴小标记
//self.xAxis.axisTick = [[PYAxisTick alloc] init];
//self.xAxis.axisTick.show = NO;
//
////    self.xAxis.axisLabel = [[PYAxisLabel alloc] init];
////    self.xAxis.axisLabel.textStyle = [[PYTextStyle alloc] init];
////    self.xAxis.axisLabel.textStyle.fontSize = @25;
////    self.xAxis.axisLabel.textStyle.color = [UIColor redColor];
////    // 添加到图标选择中
//self.option.xAxis = [[NSMutableArray alloc] initWithObjects:self.xAxis, nil];
//
//
///** Y轴设置 */
//self.yAxis = [[PYAxis alloc] init];
//self.yAxis.axisLine.show = NO;
//// 纵轴默认为数值型(就是坐标系统生成), 改为 @"category" 会有问题, 读者可以自行尝试
//self.yAxis.type = @"value";
//NSMutableArray * priceArr =  [NSMutableArray arrayWithObjects:@"0", @"500", @"1000", @"1500", @"2000", @"2500", @"3000",nil];
//self.yAxis.data = priceArr;
//// 分割段数，默认为5
//self.yAxis.splitNumber = @(priceArr.count-1);
//// 分割线类型
//self.yAxis.splitLine.lineStyle.type = @"solid";   //'solid' | 'dotted' | 'dashed' 虚线类型
////self.yAxis.splitLine.lineStyle.color = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1];
////shadowColor
////单位设置,  设置最大值, 最小值
//// yAxis.axisLabel.formatter = @"{value} k";
//// yAxis.max = @9000;
//// yAxis.min = @5000;
//// 添加到图标选择中  ( y轴更多设置, 自行查看官方文档)
//self.option.yAxis = [[NSMutableArray alloc] initWithObjects:self.yAxis, nil];
//
///** 定义坐标点数组 */
//NSMutableArray *seriesArr = [NSMutableArray array];
///** 第一条折线设置 */
//self.series1 = [[PYCartesianSeries alloc] init];
//self.series1.name = @"价格/元";
//// 类型为折线
//self.series1.type = @"line";
//// 曲线平滑
//// series1.smooth = YES;
//// 坐标点大小
//self.series1.symbolSize = @(1.5);
//
//// 坐标点样式, 设置连线的宽度
//self.series1.itemStyle = [[PYItemStyle alloc] init];
//self.series1.itemStyle.normal = [[PYItemStyleProp alloc] init];
//self.series1.itemStyle.normal.lineStyle = [[PYLineStyle alloc] init];
//self.series1.itemStyle.normal.lineStyle.width = @(1);
//self.series1.smooth = YES;
//// 添加坐标点 y 轴数据 ( 如果某一点 无数据, 可以传 @"-" 断开连线 如 : @[@"7566", @"-", @"7571"]  )
//NSMutableArray *xdata = @[].mutableCopy;
//self.series1.data = xdata;
//
//[seriesArr addObject:self.series1];
//[self.option setSeries:seriesArr];
//
//
///** 初始化图表 */
//self.kEchartView = [[PYEchartsView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 220)];
////self.kEchartView.backgroundColor = [UIColor redColor];
//// 添加到 scrollView 上
//[self.scrollView addSubview:self.kEchartView];
//// 图表选项添加到图表上
//[self.kEchartView setOption:self.option];

//    NSLog(@"%f",self.scrollView.contentSize.width);
//    self.scrollView.contentSize = CGSizeMake(self.kEchartView.frame.size.width, 0);
//    NSLog(@"%f======%f",self.kEchartView.frame.size.width,self.scrollView.contentSize.width);
 //   * 提示框 */
//    PYTooltip *tooltip = [[PYTooltip alloc] init];
//    // 触发类型 默认数据触发
//    tooltip.trigger = @"axis";
//    // 竖线宽度
//    tooltip.axisPointer.lineStyle.width = @1;
////    tooltip.axisPointer.lineStyle.color =  [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1];
//    // 提示框 文字样式设置
//    tooltip.textStyle = [[PYTextStyle alloc] init];
//    tooltip.textStyle.fontSize = @12;
//    // 提示框 显示自定义
//    //tooltip.formatter = @"(function(params){ var res = params[0].name; for (var i = 0, l = params.length; i < l; i++) {res += '<br/>' + params[i].seriesName + ' : ' + params[i].value;}; return res})";
//    // 添加到图标选择中
//    option.tooltip = tooltip;


//    /** 图例 */
//    PYLegend *legend = [[PYLegend alloc] init];
//    // 设置数据
//    legend.data = @[@"（价格/元）"];
//    // 添加到图标选择中
//    option.legend = legend;

@end
