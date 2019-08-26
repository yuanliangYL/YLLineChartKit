//
//  ViewController.m
//  Echart_ios
//
//  Created by AlbertYuan on 2019/8/23.
//  Copyright © 2019 Yunaliang. All rights reserved.
//

#import "ViewController.h"
#import "YLChartDataView.h"

@interface ViewController ()<ChartViewClickDelegate>
@property(nonatomic,strong)YLChartDataView *chartView;
@property(nonatomic,strong)PYOption *option;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    UIView *c = [[UIView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 270)];
    self.chartView = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([YLChartDataView class]) owner:nil options:nil] lastObject];
    self.chartView.delegate = self;
    self.option = [self.chartView theLineChartWithYaxis:[NSMutableArray array] andXaxis:[NSMutableArray arrayWithObjects:@"7.32", @"7.32", @"7.32", @"7.32", @"7.32", @"7.32", @"7.32",nil] withAllDataInfo:[NSMutableArray arrayWithObjects:@"2566", @"1619", @"1571", @"2670", @"2528", @"2640", @"2472",nil] isRotation:NO];
    [self.chartView.kEchartView setOption:self.option];

    [c addSubview:self.chartView];
    [self.view addSubview:c];

}

-(void)didClickTypeWithInfo:(ChartViewType)type{
    NSLog(@"%ld",type);

    switch (type) {
        case 0:
            
             self.option = [self.chartView theLineChartWithYaxis:[NSMutableArray array] andXaxis:[NSMutableArray arrayWithObjects:@"7.32", @"7.32", @"7.32", @"7.32", @"7.32", @"7.32", @"7.32",nil] withAllDataInfo:[NSMutableArray arrayWithObjects:@"2566", @"1619", @"1571", @"2670", @"2528", @"2640", @"2472",nil] isRotation:NO];
            break;
            
        case 1:
            
              self.option =[self.chartView theLineChartWithYaxis:[NSMutableArray array] andXaxis:[NSMutableArray arrayWithObjects:@"2018-01", @"2018-02", @"2018-03", @"2018-04", @"2018-05", @"2018-06", @"2018-07",@"2018-08",@"2018-09",@"2018-10",@"2018-11",@"2018-12",nil] withAllDataInfo:[NSMutableArray arrayWithObjects:@"2566", @"1619", @"1571", @"2670", @"2528", @"2640", @"2472",@"2566", @"1619", @"1571", @"2670", @"2528",nil] isRotation:YES];
            break;
           
        default:
            break;
    }
    
    if (self.option != nil) {
       [self.chartView.kEchartView setOption:self.option];
       [self.chartView.kEchartView loadEcharts];
    }
}

@end
