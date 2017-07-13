//
//
//  XHChartBox.h
//  月营业额的柱状图.
//
//  Created by zxh on 14-8-14.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHChart.h"

@interface XHChartBox : UIView<XHChartDataSource,XHChartDelegate>
{
    XHChart* chartView;
}
@property (nonatomic, strong) UILabel* lblDate;
@property (nonatomic, strong) IBOutlet UIView *view;
@property (nonatomic, strong) NSMutableDictionary* itemDic;
@property (nonatomic, strong) id<XHChartDelegate> delegate;
@property (nonatomic, strong) NSMutableDictionary* dateDic;
@property (nonatomic) double perHeight;
@property (nonatomic) NSInteger currYear;     //当前年
@property (nonatomic) NSInteger currMonth;
@property (nonatomic) NSInteger currDay;

@property (nonatomic) NSInteger totalPages;   //总页数.

- (void)initDelegate:(id<XHChartDelegate>)delegate;

- (void)loadBusinessData:(NSMutableDictionary*)dateDic;   //加载业务数据.

- (void)initChartView:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
- (NSString*) getWeeKName:(NSInteger)week;
- (NSInteger)convertWeek:(NSInteger)day;

@end
