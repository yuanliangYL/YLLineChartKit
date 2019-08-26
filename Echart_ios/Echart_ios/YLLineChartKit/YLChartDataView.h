//
//  YLChartDataView.h
//  Echart_ios
//
//  Created by AlbertYuan on 2019/8/23.
//  Copyright © 2019 Yunaliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iOS-Echarts.h"

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    DayType,
    YearType
} ChartViewType;

@protocol ChartViewClickDelegate <NSObject>

//点击类型按钮
-(void)didClickTypeWithInfo:(ChartViewType)type;

@end

@interface YLChartDataView : UIView

@property(nonatomic,weak) id<ChartViewClickDelegate> delegate;

@property(nonatomic,strong)NSMutableArray *ydataArr;
@property(nonatomic,strong)NSMutableArray *xdataArr;
@property (nonatomic, strong) PYEchartsView *kEchartView;

/**
 刷新数据

 @param yaxis Y坐标
 @param xaxis X坐标
 @param data 数据
 @param rotation 倾斜度
 @return 设置参数
 */
-(PYOption *)theLineChartWithYaxis:(nullable NSMutableArray *)yaxis andXaxis:(nullable NSMutableArray *)xaxis withAllDataInfo:( nullable NSMutableArray *)data  isRotation:(BOOL)rotation;

@end

NS_ASSUME_NONNULL_END
