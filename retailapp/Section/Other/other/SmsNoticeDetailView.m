//
//  SmsNoticeDetailView.m
//  retailapp
//
//  Created by hm on 15/9/7.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SmsNoticeDetailView.h"
#import "ServiceFactory.h"
#import "XHAnimalUtil.h"
#import "AlertBox.h"
#import "UIHelper.h"
#import "Notice.h"
#import "DateUtils.h"
#import "LSEditItemView.h"
@interface SmsNoticeDetailView ()

@property (nonatomic,strong) UIScrollView* scrollView;
//公告标题
@property (nonatomic,strong) LSEditItemView* txtTitle;
//公告日期
@property (nonatomic,strong) LSEditItemView* txtDate;
//公告内容
@property (nonatomic,strong) LSEditItemView* contentMemo;
@property (nonatomic, strong) SmsService *smsService;
//公告id
@property (nonatomic, copy) NSString *noticeId;

@property (nonatomic, copy) DetailHandler detailBlock;

@end

@implementation SmsNoticeDetailView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.smsService = [ServiceFactory shareInstance].smsService;
    [self initNavigate];
    [self initMainView];
    [UIHelper refreshUI:self.scrollView];
    [self showNoticeDetailById:self.noticeId];
}


- (void)loadDataWithId:(NSString *)noticeId callBack:(DetailHandler)handler
{
    self.noticeId = noticeId;
    self.detailBlock = handler;
}

#pragma mark - 初始化导航
- (void)initNavigate
{
    [self configTitle:@"公告通知" leftPath:Head_ICON_BACK rightPath:nil];
}

#pragma mark - 初始化主视图
- (void)initMainView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    self.scrollView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [self.view addSubview:self.scrollView];
    
    self.txtTitle = [LSEditItemView editItemView];
    [self.txtTitle initLabel:@"公告标题" withHit:nil];
    [self.scrollView addSubview:self.txtTitle];
    
    self.txtDate = [LSEditItemView editItemView];
    [self.txtDate initLabel:@"发布时间" withHit:nil];
    [self.scrollView addSubview:self.txtDate];
    
    self.contentMemo = [LSEditItemView editItemView];
    [self.contentMemo initLabel:@"公告内容" withHit:nil];
    [self.scrollView addSubview:self.contentMemo];
}

#pragma mark - 获取公告详情数据
- (void)showNoticeDetailById:(NSString*)noticeId
{
    __strong typeof(self) strongSelf = self;
    [self.smsService selectNoticeDetail:noticeId completionHandler:^(id json) {
        Notice *notice = [Notice converToNotice:[json objectForKey:@"notice"]];
        [strongSelf.txtTitle initData:notice.noticeTitle];
        [strongSelf.txtDate initData:[DateUtils formateTime:notice.publishTime]];
        [strongSelf.contentMemo initHit:notice.noticeContent];
        strongSelf.contentMemo.lblDetail.textColor = [ColorHelper getTipColor3];
        strongSelf.contentMemo.lblDetail.font = [UIFont systemFontOfSize:15];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

@end
