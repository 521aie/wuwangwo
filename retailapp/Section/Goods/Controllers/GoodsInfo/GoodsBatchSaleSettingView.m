//
//  GoodsBatchSaleSettingView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/7/29.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GoodsBatchSaleSettingView.h"
#import "UIHelper.h"
#import "LSEditItemList.h"
#import "LSEditItemRadio.h"
#import "DateUtils.h"
#import "GoodsModuleEvent.h"
#import "DatePickerBox.h"
#import "AlertBox.h"
#import "ServiceFactory.h"
#import "XHAnimalUtil.h"

@interface GoodsBatchSaleSettingView ()

@property (nonatomic, strong) GoodsService* goodsService;

@property (nonatomic, strong) NSMutableArray* idList;

@property (nonatomic) int fromView;

@end

@implementation GoodsBatchSaleSettingView

- (id)initWithIdList:(NSMutableArray *)idList fromView:(int)fromView
{
    self = [super init];
    if (self) {
        _idList = idList;
        _fromView = fromView;
        _goodsService = [ServiceFactory shareInstance].goodsService;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initHead];
    [self configViews];
    [self initMainView];
    [self loaddatas];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
}

- (void)configViews {
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    [self.view addSubview:self.scrollView];
    
    self.container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.ls_width, self.scrollView.ls_height)];
    [self.scrollView addSubview:self.container];
    
    self.lsSaleRoyaltyRatio = [LSEditItemList editItemList];
    [self.container addSubview:self.lsSaleRoyaltyRatio];
    
    self.rdoIsJoinPoint = [LSEditItemRadio editItemRadio];
    [self.container addSubview:self.rdoIsJoinPoint];
    
    self.rdoIsJoinActivity = [LSEditItemRadio editItemRadio];
    [self.container addSubview:self.rdoIsJoinActivity];
}


-(void) loaddatas
{
    [self fillModel];
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

-(void) loaddatas:(goodsBatchSaleSettingBack)callBack
{
    self.goodsBatchSaleSettingBack = callBack;
}

-(void) initHead
{
    [self configTitle:@"销售设置" leftPath:Head_ICON_CANCEL rightPath:Head_ICON_OK];
}

-(void) fillModel
{
    [self.lsSaleRoyaltyRatio initData:nil withVal:nil];
    
    [self.rdoIsJoinPoint initData:@"1"];
    
    [self.rdoIsJoinActivity initData:@"1"];
    
}

-(void) initMainView
{
    [self.lsSaleRoyaltyRatio initLabel:@"销售提成比例(%)" withHit:nil isrequest:NO delegate:self];
    
    [self.rdoIsJoinPoint initLabel:@"参与积分" withHit:nil];
    
    [self.rdoIsJoinActivity initLabel:@"参与任何优惠活动" withHit:nil];
    
    self.lsSaleRoyaltyRatio.tag = GOODS_BATCH_SALE_SETTING_RATIO;
}

-(void) onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event==LSNavigationBarButtonDirectLeft) {
        if (self.fromView == GOODS_BATCH_SELECT_VIEW) {
            self.goodsBatchSaleSettingBack(NO);
        }else if (self.fromView == GOODS_STYLE_BATCH_SELECT_VIEW){
            self.goodsBatchSaleSettingBack(NO);
        }
    }else{
        [self save];
    }
}

-(void) onItemListClick:(LSEditItemList *)obj
{
    if (obj.tag == GOODS_BATCH_SALE_SETTING_RATIO) {
        [SymbolNumberInputBox initData:obj.lblVal.text];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:YES isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:3 digitLimit:2];
    }
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

#pragma mark - SymbolNumberInputClient协议
- (void)numberClientInput:(NSString *)val event:(NSInteger)eventType
{
    if (val.doubleValue>100.00) {
        
        [AlertBox show:@"销售提成比例(%)不能大于100.00.请重新输入!"];
        return ;
    }else{
        if ([NSString isBlank:val]) {
            val = @"";
        } else {
            val = [NSString stringWithFormat:@"%.2f",val.doubleValue];
        }
    }
        
    [self.lsSaleRoyaltyRatio changeData:val withVal:val];

    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

-(void) save
{
    __weak GoodsBatchSaleSettingView* weakSelf = self;
    if (_fromView == GOODS_BATCH_SELECT_VIEW) {
        [_goodsService setGoodsBatchSales:_idList percentage:[self.lsSaleRoyaltyRatio getStrVal] hasDegree:[self.rdoIsJoinPoint getStrVal] isSales:[self.rdoIsJoinActivity getStrVal] completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            weakSelf.goodsBatchSaleSettingBack(YES);
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }else if (_fromView == GOODS_STYLE_BATCH_SELECT_VIEW){
        [_goodsService setStyleBatchSales:_idList percentage:[self.lsSaleRoyaltyRatio getStrVal] hasDegree:[self.rdoIsJoinPoint getStrVal] isSales:[self.rdoIsJoinActivity getStrVal] completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            weakSelf.goodsBatchSaleSettingBack(YES);
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }
    
}

@end
