//
//  LSMemberCardOperateDetailController.m
//  retailapp
//
//  Created by wuwangwo on 17/1/6.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberCardOperateDetailController.h"
#import "LSEditItemView.h"
#import "UIHelper.h"
#import "XHAnimalUtil.h"
#import "AlertBox.h"
#import "DateUtils.h"

@interface LSMemberCardOperateDetailController ()
@property (nonatomic, strong)  UIScrollView *scrollView;
@property (nonatomic, strong)  UIView *container;
@property (nonatomic, assign) NSInteger currPage;//用来分页
@property (nonatomic, strong) LSEditItemView *cardCode; //会员卡号
@property (nonatomic, strong) LSEditItemView *kindCardName; //会员卡类型
@property (nonatomic, strong) LSEditItemView *customerName; //会员名
@property (nonatomic, strong) LSEditItemView *customerMobile; //手机号码
@property (nonatomic, strong) LSEditItemView *action; //操作类型
@property (nonatomic, strong) LSEditItemView *staffName; //操作人/员工姓名
@property (nonatomic, strong) LSEditItemView *ownerShopName; //所属门店
@property (nonatomic, strong) LSEditItemView *opTime; //操作时间
@property (nonatomic, strong) NSMutableDictionary *dict;//数据源
@end

@implementation LSMemberCardOperateDetailController

- (instancetype)initWith:(LSCardOperateDetailVo *)vo {
    self = [super init];
    if (self) {
        self.detailVo = vo;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currPage = 1;
    [self configSubviews];
    [self loadData];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void)configSubviews {
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [self configTitle:@"会员卡操作记录" leftPath:Head_ICON_BACK rightPath:nil];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    [self.view addSubview:self.scrollView];
    self.container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 100)];
    [self.scrollView addSubview:self.container];
    
    //会员卡号
    self.cardCode = [LSEditItemView editItemView];
    [self.cardCode initLabel:@"会员卡号" withHit:nil];
    [self.container addSubview:self.cardCode];
    
    //会员卡类型
    self.kindCardName = [LSEditItemView editItemView];
    [self.kindCardName initLabel:@"会员卡类型" withHit:nil];
    [self.container addSubview:self.kindCardName];
    
    //会员名
    self.customerName = [LSEditItemView editItemView];
    [self.customerName initLabel:@"会员名" withHit:nil];
    [self.container addSubview:self.customerName];
    
    //手机号码
    self.customerMobile = [LSEditItemView editItemView];
    [self.customerMobile initLabel:@"手机号码" withHit:nil];
    [self.container addSubview:self.customerMobile];
    
    //操作类型
    self.action = [LSEditItemView editItemView];
    [self.action initLabel:@"操作类型" withHit:nil];
    [self.container addSubview:self.action];
    
    //操作人/显示格式：员工姓名（工号：001）
    self.staffName = [LSEditItemView editItemView];
    [self.staffName initLabel:@"操作人" withHit:nil];
    [self.container addSubview:self.staffName];
    
    //所属门店
    if ([[Platform Instance] getShopMode] != 1) {
        self.ownerShopName = [LSEditItemView editItemView];
        [self.ownerShopName initLabel:@"所属门店" withHit:nil];
        [self.container addSubview:self.ownerShopName];
    }
    
    //操作时间
    self.opTime = [LSEditItemView editItemView];
    [self.opTime initLabel:@"操作时间" withHit:nil];
    [self.container addSubview:self.opTime];
}


#pragma mark - 加载数据
- (void)loadData {
    //根据param请求数据，存在module里，放进数据源data，铺cell
    NSString *url = @"customerOperaLog/detail";
    __weak typeof(self) wself = self;
    
    [BaseService getRemoteLSDataWithUrl:url param:self.param withMessage:nil show:YES CompletionHandler:^(id json) {
        if (wself.currPage == 1) {
            [wself.dict removeAllObjects];
        }
        if (!wself.dict) {
            wself.dict = [[NSMutableDictionary alloc] init];
        }
        NSMutableArray *map = json[@"customerOpLogDetail"];
        if ([ObjectUtil isNotNull:json]) {
            wself.detailVo =  [LSCardOperateDetailVo mj_objectWithKeyValues:map];
            [wself initData];
        }
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

- (NSMutableDictionary *)param {
    if (_param == nil) {
        _param = [NSMutableDictionary dictionary];
    }
    [_param setValue:self.id forKey:@"id"];

    return _param;
}

#pragma mark - 加载后页面初始化数据
- (void)initData {
    //会员卡号
    [self.cardCode initData:self.detailVo.cardCode];
    //会员卡类型
    [self.kindCardName initData:self.detailVo.kindCardName];
    //会员名
    [self.customerName initData:self.detailVo.customerName];
    //手机号码
    [self.customerMobile initData:self.detailVo.customerMobile];
    //操作类型（2:挂失，3:解挂，12:退卡，8:换卡）
    if ([self.detailVo.action  isEqual: @(2)]) {
        [self.action initData:@"挂失"];
    }else if ([self.detailVo.action  isEqual: @(3)]) {
        [self.action initData:@"解挂"];
    }else if ([self.detailVo.action  isEqual: @(12)]) {
        [self.action initData:@"退卡"];
    }else if ([self.detailVo.action  isEqual: @(8)]) {
        [self.action initData:@"换卡"];
    }
    //操作人/员工姓名
    if ([NSString isNotBlank:self.detailVo.staffName] && [NSString isNotBlank:self.detailVo.staffId]) {
        [self.staffName initData:[NSString stringWithFormat:@"%@（工号：%@）" ,self.detailVo.staffName,self.detailVo.staffId] ];
    } else {
        [self.staffName initData:@""];
    }
    //所属门店:限连锁模式下显示
    if ([[Platform Instance] getShopMode] != 1) {
         [self.ownerShopName initData:self.detailVo.ownerShopName];
    }
    //操作时间
    NSString *string = [DateUtils getTimeStringFromCreaateTime:self.detailVo.opTime.stringValue format:@"yyyy-MM-dd HH:mm:ss"];
    [self.opTime initData:[NSString stringWithFormat:@"%@" ,string] ];

    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

@end
