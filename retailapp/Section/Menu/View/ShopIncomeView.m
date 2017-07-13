//
//  ShopIncomeView.m
//  retailapp
//
//  Created by taihangju on 16/6/8.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "ShopIncomeView.h"
#import "DateUtils.h"

#define kMarginGap 8.0f               //ShopIncomeView 距离父view两边的距离
#define kInnerItemMarginGap 8.0f      //业绩显示等view距离ShopIncomeView左边界的距离

@interface ShopIncomeView()

@end
@implementation ShopIncomeView

+ (ShopIncomeView *)shopIncomeView:(BOOL)showDetail top:(CGFloat)topY displayItems:(NSArray *)items owner:(id)agent
{
    CGFloat incomeViewHeight = 0;
    // 初始化默认ShopIncomeView 263的高度
    CGFloat incomeViewWidth  = CGRectGetWidth([UIScreen mainScreen].bounds) - 2*kMarginGap;
    ShopIncomeView *incomeView = [[ShopIncomeView alloc] initWithFrame:CGRectMake(kMarginGap, topY, incomeViewWidth, 263)];
    incomeView.delegate=agent;
    
    CGFloat showDetailViewHeight = 0;
    if (showDetail) {
        showDetailViewHeight = 36.f;
        
        UIView *showDetailView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, incomeViewWidth, showDetailViewHeight)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, showDetailViewHeight-2)];
        label.text = @"门店营业汇总";
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:13];
        [showDetailView addSubview:label];
        
        // 向右的箭头
        UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(incomeViewWidth-22.0f, (showDetailViewHeight-22.0)/2, 22, 22)];
        arrowImageView.image = [UIImage imageNamed:@"ico_next_w"];
        [showDetailView addSubview:arrowImageView];
        
        // line
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, showDetailViewHeight-1, incomeViewWidth, 1.0/[UIScreen mainScreen].scale)];
        view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
        [showDetailView addSubview:view];
        
        
        // button 点击进入门店营业详情页
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect frame = showDetailView.bounds;
        frame.size.height -= 2;
        button.frame = frame;
        [button addTarget:incomeView action:@selector(showShopIncomeDetailInfo:) forControlEvents:UIControlEventTouchUpInside];
        [showDetailView addSubview:button];
        
        [incomeView addSubview:showDetailView];
        incomeViewHeight += CGRectGetHeight(showDetailView.bounds);

    }
    
    {
        //  处理日期
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
        NSString *currentTime = [dateFormatter stringFromDate:date];
        NSRange spaceRange = [currentTime rangeOfString:@" "];
        NSString *dayTime = [currentTime substringFromIndex:spaceRange.location+1];//hh:mm
        
        // 中间显示日期，今日收益的view
        CGFloat middleViewHeight = 80.0f;
        UIView *middleView = [[UIView alloc] initWithFrame:CGRectMake(0, showDetailViewHeight, incomeViewWidth, middleViewHeight)];
        
        // 日历小图标
        UIImageView *dateImgV = [[UIImageView alloc] initWithFrame:CGRectMake(7, 2, 38, 38)];
        dateImgV.image = [UIImage imageNamed:@"icon_day"];
        [middleView addSubview:dateImgV];
        
        // 当前*日
        NSString *dateStr = [NSString stringWithFormat:@"%@日",[DateUtils formateDate6:[NSDate date]]];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:dateStr];
        [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, dateStr.length-1)];
        UILabel *dayLabel = [[UILabel alloc] initWithFrame:dateImgV.frame];
        dayLabel.font = [UIFont boldSystemFontOfSize:9];
        dayLabel.textAlignment = NSTextAlignmentCenter;
        dayLabel.attributedText = attr;
        dayLabel.textColor = [UIColor darkGrayColor];
        [middleView addSubview:dayLabel];
        
        // 当前时间
        CGFloat timeLabelWidth = 42;
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(dayLabel.center.x-timeLabelWidth/2, CGRectGetMaxY(dateImgV.frame)-7, timeLabelWidth, 21)];
        timeLabel.font = [UIFont systemFontOfSize:12];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.textColor = [UIColor whiteColor];
        timeLabel.text = dayTime;
        [middleView addSubview:timeLabel];
        
        // 今日收益
        CGFloat todayIncomeLabelOrginX = CGRectGetMaxX(timeLabel.frame);
        CGFloat todayIncomeLabelWidth = incomeViewWidth - 2*todayIncomeLabelOrginX;
        UILabel *todayIncomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(todayIncomeLabelOrginX, 8, todayIncomeLabelWidth, 21)];
        todayIncomeLabel.textAlignment = NSTextAlignmentCenter;
        todayIncomeLabel.font = [UIFont systemFontOfSize:13];
        todayIncomeLabel.textColor = [UIColor whiteColor];
        todayIncomeLabel.text = [NSString stringWithFormat:@"今日%@", [items[0] valueForKey:@"name"]];
        [middleView addSubview:todayIncomeLabel];
        
        //收益数据
        CGFloat incomeNumOrginX = CGRectGetMaxY(dateImgV.frame);
        CGFloat incomeNumWidth = incomeViewWidth - 2*incomeNumOrginX;
        UILabel *incomeNum = [[UILabel alloc] initWithFrame:CGRectMake(incomeNumOrginX, CGRectGetMaxY(todayIncomeLabel.frame)-2, incomeNumWidth, 50)];
        incomeNum.textAlignment = NSTextAlignmentCenter;
        incomeNum.font = [UIFont systemFontOfSize:40.f];
        incomeNum.textColor = [UIColor whiteColor];
        //客单数取整数
        if ([[items[0] valueForKey:@"name"] isEqualToString:@"客单数(单)"]) {
            incomeNum.text = showDetail ? [NSString stringWithFormat:@"%.f",[[items[0] valueForKey:@"value"] doubleValue]] : @"-";
        } else {
            incomeNum.text = showDetail ? [NSString stringWithFormat:@"%.2f",[[items[0] valueForKey:@"value"] doubleValue]] : @"-";
        }
        
        [middleView addSubview:incomeNum];
        [incomeView addSubview:middleView];
        incomeViewHeight += CGRectGetHeight(middleView.bounds);
    }
    
    {
        CGFloat verticalGap1 = 5.0f; // 垂直方向subView子views：两个label之间距离,以及上面label距离最近subView上边界的距离
        CGFloat verticalGap2 = 10.0f; // 垂直方向subView子views：靠下的label距离subView底边的距离
        CGFloat subViewWidth = incomeViewWidth/3;
        CGFloat subViewHeight = 50.0f;
        CGFloat grandsunLabelHeight = (subViewHeight-verticalGap2-2*verticalGap1)/2; // subView 上面显示营业信息的label的高度
        
        // 底部显示收益信息的View
        NSInteger count = items.count - 1; // items中第一组是总收益，这里要减去，剩下的是细分收益项
        CGFloat incomeInfoViewHeight = subViewHeight*(count/3)+MIN(1, count%3)*subViewHeight;
        UIView *incomeInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, incomeViewHeight, incomeViewWidth, incomeInfoViewHeight)];
        [incomeView addSubview:incomeInfoView];
        incomeViewHeight += incomeInfoViewHeight;
        
        // 生成显示收益各方面信息的view
        for (NSInteger i = 1; i < items.count ; i++) {
            NSDictionary *dic = (NSDictionary *)items[i];
            NSInteger index = i - 1;
            UIView *subView = [[UIView alloc] initWithFrame:CGRectMake((index%3)*subViewWidth, (index/3)*subViewHeight, subViewWidth, subViewHeight)];
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kInnerItemMarginGap, verticalGap1, subViewWidth, grandsunLabelHeight)];
            titleLabel.font = [UIFont systemFontOfSize:10];
            titleLabel.textColor = [UIColor whiteColor];
            titleLabel.text = dic[@"name"];
            [subView addSubview:titleLabel];
            
            UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(kInnerItemMarginGap, CGRectGetMaxY(titleLabel.frame)+verticalGap1, subViewWidth, grandsunLabelHeight)];
            numLabel.font = [UIFont systemFontOfSize:grandsunLabelHeight];
            numLabel.textColor = [UIColor whiteColor];
            //客单数取整数
            if ([dic[@"name"] isEqualToString:@"客单数(单)"]) {
                numLabel.text = showDetail ? [NSString stringWithFormat:@"%.f",[dic[@"value"] doubleValue]] : @"-";
            } else {
                numLabel.text = showDetail ? [NSString stringWithFormat:@"%.2f",[dic[@"value"] doubleValue]] : @"-";
            }
            [subView addSubview:numLabel];
            
            CGFloat lineWidth = 1.0f/[UIScreen mainScreen].scale;
            // 最右边的 没有右边界线
            if ((index+1)%3 != 0) {
                UIView *line  = [[UIView alloc] initWithFrame:CGRectMake(subViewWidth - lineWidth, kInnerItemMarginGap, lineWidth, 2*grandsunLabelHeight+verticalGap1)];
                line.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.33];
                [subView addSubview:line];
            }
            
            [incomeInfoView addSubview:subView];
            
        }
        
        incomeView.frame = CGRectMake(kMarginGap, topY, incomeViewWidth, incomeViewHeight);
        incomeView.layer.masksToBounds = YES;
        incomeView.layer.cornerRadius = 4.0;
        incomeView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    }
    return incomeView;
}



// 点击跳转到门店收入详情页面
- (void)showShopIncomeDetailInfo:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(showShopIncomeView)]) {
        [self.delegate showShopIncomeView];
    }
}
@end
