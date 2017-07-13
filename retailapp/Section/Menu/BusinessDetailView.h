//
//  BusinessDetailView.h
//  retailapp
//
//  Created by hm on 15/8/5.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BusinessSummaryBox,XHChartBox;
@class MainModule,LoginService;
@interface BusinessDetailView : BaseViewController {
    LoginService *service;
}

@property (nonatomic,weak) IBOutlet UILabel* lblTitle;

@property (nonatomic,weak) IBOutlet UIView* tabBox;

@property (nonatomic, strong) IBOutlet UIView *tabBg;

@property (nonatomic,weak) IBOutlet UILabel* lblTabLeft;

@property (nonatomic,weak) IBOutlet UILabel* lblTabRight;

/**月营业数据面板*/
@property (nonatomic,weak) IBOutlet UIView* monthPanel;

@property (nonatomic,weak) IBOutlet UIScrollView* monthScroll;
/**上一月图标*/
@property (nonatomic,weak) IBOutlet UIImageView* imgPre;
/**上一月按钮*/
@property (nonatomic,weak) IBOutlet UIButton* btnPre;
/**下一月图标*/
@property (nonatomic,weak) IBOutlet UIImageView* imgNext;
/**下一月按钮*/
@property (nonatomic,weak) IBOutlet UIButton* btnNext;




/**今天营业数据面板*/
@property (nonatomic,weak) IBOutlet UIView* dayPanel;

@property (nonatomic,weak) IBOutlet UIScrollView* dayScroll;

@property (nonatomic,weak) IBOutlet UIView* container;

/**今天标题*/
@property (nonatomic,weak) IBOutlet UILabel* lblTitleDay;

/**上个月图标*/
@property (nonatomic, strong) IBOutlet UIImageView *imgPrePay;
/**上个月按钮*/
@property (nonatomic, strong) IBOutlet UIButton *btnPrePay;
/**下个月图标*/
@property (nonatomic, strong) IBOutlet UIButton *btnNextPay;
/**下个月按钮*/
@property (nonatomic, strong) IBOutlet UIImageView *imgNextPay;
/**今天详细数据信息*/
@property (nonatomic,weak) IBOutlet BusinessSummaryBox* dayDetailBox;
/**本月详细数据信息*/
@property (weak, nonatomic) IBOutlet BusinessSummaryBox *monthDetailBox;
/**月营业数据柱状图详细面板*/
@property (nonatomic, strong) IBOutlet XHChartBox *chartBox;
/**1：按门店，2：按个人*/
@property (nonatomic,assign) int shopFlag;
/** 日数据字典表. */
@property (nonatomic, strong) NSMutableDictionary* dayDic;
/** 显示的功能值 */
@property (nonatomic, strong) NSMutableArray* dayList;
//返回事件.
- (IBAction)btnBackEvent:(id)sender;

//tab月处理.
- (IBAction)btnTabMonthEvent:(id)sender;

//tab今天处理.
- (IBAction)btnTabTodayEvent:(id)sender;

@end
