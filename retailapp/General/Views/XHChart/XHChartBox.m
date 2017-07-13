//
//  XHChartBox.m
//  月营业额柱状图的控件.
//
//  Created by zxh on 14-8-14.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "XHChartBox.h"
#import "ChartItem.h"
#import "BusinessDayVO.h"
#import "UIView+Sizes.h"

@implementation XHChartBox

-(void) awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"XHChartBox" owner:self options:nil];
    [self addSubview:self.view];
}

- (void)initDelegate:(id<XHChartDelegate>)delegate
{
    self.delegate=delegate;
}

- (void)loadBusinessData:(NSMutableDictionary*)dateDic
{
    self.dateDic=dateDic;
    double max=[self getMax];
    int height=self.bounds.size.height-63;
    self.perHeight=max==0?0:height/max;
}

- (double) getMax
{
    if (!self.dateDic || self.dateDic.allValues.count==0) {
        return 0;
    }
    double max=0;
    for (id obj in self.dateDic.allValues) {
        BusinessDayVO *businessDayVo = nil;
        if ([obj isKindOfClass:[NSArray class]]) {
            //营业汇总
            businessDayVo = [obj objectAtIndex:0];
            if ([businessDayVo.showValue doubleValue]>max) {
                max=[businessDayVo.showValue doubleValue];
            }
        } else if ([obj isKindOfClass:[BusinessDayVO class]]){
            //分账那边
            businessDayVo = (BusinessDayVO *)obj;
            if (businessDayVo.totalAmount>max) {
                max=businessDayVo.totalAmount;
            }
        }
        
        
        
    }
    return max;
}

- (void)initChartView:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    for (UIView *view in [self.view subviews]) {
        [view removeFromSuperview];
    }
    self.itemDic=[NSMutableDictionary dictionary];
    self.currYear=year;
    self.currMonth=month;
    self.currDay=day;
    chartView = [[XHChart alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height-30)];
    
    [chartView setCurrentSelectPage:self.currDay-16];
    chartView.delegate = self;
    chartView.datasource = self;
    [chartView reloadData];
    
    [self setAfterScrollShowView:chartView andCurrentPage:1];
    [self.view addSubview:chartView];
    
    UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectMake(0,self.bounds.size.height-35,self.bounds.size.width,10)];
    lbl.text=@"▴";
    lbl.font = [UIFont systemFontOfSize:14];
    lbl.textColor=RGBA(250, 0, 0, 1);
    lbl.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lbl];
    
    self.lblDate=[[UILabel alloc] initWithFrame:CGRectMake(0,self.bounds.size.height-30,310,30)];
    self.lblDate.text=@"";
    self.lblDate.font = [UIFont systemFontOfSize:13];
    self.lblDate.textColor=RGBA(250, 255, 255, 1);
    self.lblDate.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.lblDate];
    
    [self selectSetBroadcastTime];
}

- (void)setAfterScrollShowView:(XHChart*)scrollview  andCurrentPage:(NSInteger)pageNumber
{
    ChartItem* item=nil;
    NSInteger midVal= (chartView.itemCount % 2==0?(chartView.itemCount-1)/2:chartView.itemCount/2);
    for (int i=0;i<chartView.itemCount;i++) {
        item = [[(ChartItem*)[[scrollview subviews] objectAtIndex:0] subviews] objectAtIndex:pageNumber+i];
        item.backgroundColor = [UIColor clearColor];
        
        if (i==midVal) {
            item.lbl.textColor=RGBA(250, 0, 0, 1);
            [item.view setBackgroundColor:RGBA(255, 255, 255, 1)];
        }else{
            if (item.week==1) {
                item.lbl.textColor=RGBA(255, 255, 255, 1);
            }else{
                item.lbl.textColor=RGBA(255, 255, 255, 0.3);
            }
            [item.view setBackgroundColor:RGBA(255, 255, 255, 0.3)];
        }
    }
}
#pragma mark mxccyclescrollview delegate
#pragma mark mxccyclescrollview databasesource
- (NSInteger)numberOfPages:(XHChart*)scrollView
{
    NSDate* day=[self convertDate:1];
    self.totalPages=[self getDaysOfMonth:day];
    return self.totalPages;
}

- (UIView *)pageAtIndex:(NSInteger)index andScrollView:(XHChart *)scrollView
{
    ChartItem* item=[self.itemDic objectForKey:[NSString stringWithFormat:@"%ld", (long)index]];
    if (!item) {
        item = [[ChartItem alloc] initWithFrame:CGRectMake(0, 0, scrollView.bounds.size.width/chartView.itemCount, scrollView.bounds.size.height)];
        item.lbl.text = @"•";
        item.lbl.font = [UIFont systemFontOfSize:18];
        if (index<0 || index>self.totalPages-1) {
            item.lbl.text = @"";
        }else{
            NSInteger week=[self convertWeek:(index+1)];
            item.week=week;
            if (week==1) {
                item.lbl.textColor=RGBA(255, 255, 255, 1);
            } else {
                item.lbl.textColor=RGBA(255, 255, 255, 0.3);
            }
        }
        
        item.lbl.textAlignment = NSTextAlignmentCenter;
        item.lbl.backgroundColor = [UIColor clearColor];
        item.day=(index+1);
        if (index>-1 && index<self.totalPages) {
            NSString* dateKey=[NSString stringWithFormat:@"%ld-%02ld-%02ld", (long)self.currYear, (long)self.currMonth, (long)index+1];
            BusinessDayVO *vo = nil;
            id obj =[self.dateDic objectForKey:dateKey];
            double viewHeight = 0;
            if ([obj isKindOfClass:[NSArray class]]) {//营业汇总面板
                vo = [obj objectAtIndex:0];
                viewHeight=(!vo)?0:[vo.showValue doubleValue]*self.perHeight;
                if (viewHeight<3 && vo && [vo.showValue doubleValue]>0) {     //保证最低高度为3px.
                    viewHeight=3;
                }
                
            } else if ([obj isKindOfClass:[BusinessDayVO class]]){//分账面板
                vo = (BusinessDayVO *)obj;
                viewHeight=(!vo)?0:vo.totalAmount*self.perHeight;
                if (viewHeight<3 && vo && vo.totalAmount>0) {     //保证最低高度为3px.
                    viewHeight=3;
                }
                
            }
            
            [item.view setLs_height:viewHeight];
            [item.view setLs_top:(item.ls_height-20-viewHeight)];
        } else {
            [item.view setLs_height:0];
            [item.view setLs_top:(item.ls_height-20)];
        }
        [self.itemDic setValue:item forKey:[NSString stringWithFormat:@"%ld", (long)index]];
    }
    [item setLs_left:0];
    [item setLs_width:scrollView.bounds.size.width/chartView.itemCount];
    return item;
}

//选择某一天显示.
- (void)selectSetBroadcastTime
{
    NSInteger midVal= (chartView.itemCount % 2==0?chartView.itemCount/2:(chartView.itemCount+1)/2);
    UIView* view=[[chartView subviews] objectAtIndex:0];
    ChartItem *item = [[(ChartItem*)view subviews] objectAtIndex:midVal];
    self.currDay=item.day;
    self.lblDate.text=[NSString stringWithFormat:@"%ld月%ld日 %@", (long)self.currMonth, (long)item.day, [self getWeeKName:[self convertWeek:self.currDay]]];
    [self.delegate scrollviewDidChangeNumber];
}

//滚动时上下标签显示(当前时间变动事件)
- (void)scrollviewDidChangeNumber
{
    NSInteger midVal= (chartView.itemCount % 2==0?chartView.itemCount/2:(chartView.itemCount+1)/2);
    UIView* view=[[chartView subviews] objectAtIndex:0];
    ChartItem *item = [[(ChartItem*)view subviews] objectAtIndex:midVal];
    self.currDay=item.day;
    self.lblDate.text=[NSString stringWithFormat:@"%ld月%ld日 %@", (long)self.currMonth, (long)item.day, [self getWeeKName:[self convertWeek:self.currDay]]];
    [self.delegate scrollviewDidChangeNumber];
}

- (NSString*) getWeeKName:(NSInteger)week
{
    if (week==1) {
        return @"星期日";
    } else if (week==2) {
        return @"星期一";
    } else if (week==3) {
        return @"星期二";
    } else if (week==4) {
        return @"星期三";
    } else if (week==5) {
        return @"星期四";
    } else if (week==6) {
        return @"星期五";
    } else {
        return @"星期六";
    }
}

- (NSInteger)convertWeek:(NSInteger)day
{
    NSCalendar* calendar=[NSCalendar currentCalendar];
    NSDateComponents* comps=[calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday) fromDate:[self convertDate:day]];
    return [comps weekday];
}

- (NSDate*)convertDate:(NSInteger)day
{
    NSDateComponents *comps = [[NSDateComponents alloc]init];
    [comps setMonth:self.currMonth];
    [comps setDay:day];
    [comps setYear:self.currYear];
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [calendar dateFromComponents:comps];
}

- (NSInteger)getDaysOfMonth:(NSDate*)date_
{
    NSCalendar* calender=[NSCalendar currentCalendar];
    NSRange range=[calender rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date_];
    return range.length;
}

@end
