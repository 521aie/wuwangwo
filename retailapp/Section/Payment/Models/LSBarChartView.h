//
//  LSBarChartView.h
//  retailapp
//
//  Created by guozhi on 16/8/23.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  NS_ENUM (NSInteger,DateFormatter){
    
    MonthToDay = 0, //YYYY-MM-dd
    YearToMonth = 1, //YYYY—MM
    MonthToDaySample =2 //YYYYMMdd
};

@class LSBarChartView,LSBarChartVo;
@protocol LSBarChartViewEvent <NSObject>
- (void)barChartViewdidScroll:(LSBarChartView *)barChartView chartVo:(LSBarChartVo*)chartVo;
@end
@interface LSBarChartView : UIView
@property (nonatomic, strong) UILabel *tip;
@property (nonatomic, assign) id<LSBarChartViewEvent> delegate;
@property (nonatomic, assign) DateFormatter dateFomatter;
@property (nonatomic, assign) NSInteger currentMonth;
@property (nonatomic, assign) NSInteger currentYear;
@property (nonatomic, assign) NSInteger currentDay;
@property (nonatomic, copy) NSString *week;
/**
 *  用来计数 第一次调用didScrollView时天数不赋值
 */
@property (nonatomic, assign) int count;
- (instancetype)initWithFrame:(CGRect)frame itemSize:(CGSize)itemSize itemSpace:(CGFloat)itemSpace  delegate:(id<LSBarChartViewEvent>)deleagte;
-(void)loadData:(NSDictionary *)dict;
-(void)initChartView:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
@end
