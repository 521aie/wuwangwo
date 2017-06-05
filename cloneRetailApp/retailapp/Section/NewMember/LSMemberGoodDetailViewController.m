//
//  LSMemberGoodDetailViewController.m
//  retailapp
//
//  Created by taihangju on 16/10/8.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberGoodDetailViewController.h"
#import "NavigateTitle2.h"
#import "EditItemText.h"
#import "EditItemMemo.h"
#import "EditItemList.h"
#import "SymbolNumberInputBox.h"
//#import "StyleGoodsVo.h"
//#import "GoodsVo.h"
#import "GoodsGiftListVo.h"
#import "GoodsSkuVo.h"
#import "ServiceFactory.h"
#import "LSAlertHelper.h"
#import "LSMemberGoodsGiftVo.h"
#import "NSNumber+Extension.h"
#import "LSGoodsSummaryInfoView.h"

@interface LSMemberGoodDetailViewController ()<INavigateEvent ,IEditItemListEvent ,SymbolNumberInputClient>

@property (nonatomic, strong) MemberService* memberService;
@property (nonatomic, strong) NavigateTitle2 *titleBox;/*<>*/
@property (nonatomic, strong) UIScrollView *scrollView;/*<>*/
@property (nonatomic, strong) UIView *container;/**<scrollView的容器view>*/
@property (nonatomic, strong) LSGoodsSummaryInfoView *summaryView;/**<商品简介信息栏>*/
@property (nonatomic, strong) EditItemText *exchangeType;/*<兑换类型>*/
//@property (nonatomic, strong) EditItemText *factStockNum;/**<实库存数>*/
@property (nonatomic, strong) EditItemList *needIntegral;/*<所需积分>*/
@property (nonatomic, strong) EditItemList *entityStockNum;/**<实体门店可兑换数量>*/
@property (nonatomic, strong) EditItemList *wechatStockNum;/**<微店可兑换数量>*/
@property (nonatomic, strong) UIButton *detBtn;/*<删除button>*/
@property (nonatomic, assign) NSInteger actionType;/*<添加或者编辑模式>*/
@property (nonatomic, strong) GoodsGiftListVo *addGiftGoodVo;/*<添加的作为积分商品的GoodVo>*/
@property (nonatomic, strong) LSMemberGoodsGiftVo *editGiftGoodVo;/*<编辑模式下的 商品vo>*/
@property (nonatomic, assign) BOOL isEntity;/**<实体：门店或者单店>*/
@property (nonatomic, assign) BOOL isWechatOpened;/**<单店/门店的微店开启>*/
@property (nonatomic, assign) BOOL isColthModel;/*<是服鞋模式>*/
@end

@implementation LSMemberGoodDetailViewController

- (instancetype)init:(NSInteger)type selectObj:(id)obj {
    
    self = [super init];
    if (self) {

       self.actionType = type;
       self.isColthModel = [[[Platform Instance] getkey:SHOP_MODE] intValue] == 101;
       self.memberService = [ServiceFactory shareInstance].memberService;
        if (type == ACTION_CONSTANTS_ADD) {
            self.addGiftGoodVo = (GoodsGiftListVo *)obj;
        } else if (type == ACTION_CONSTANTS_EDIT) {
            self.editGiftGoodVo = (LSMemberGoodsGiftVo *)obj;
        }
        self.isEntity = [[Platform Instance] getShopMode] != 3;
        self.isWechatOpened = [[Platform Instance] getMicroShopStatus] == 2;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [self configSubViews];
    [self fillData];
    [self configHelpButton:HELP_MEMBER_INTEGRAL_EXCHANGE_SETTING];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - NavigateTitle2 代理

//导航栏点击事件
- (void)onNavigateEvent:(Direct_Flag)event {
    
    __weak typeof(self) wself = self;
    if (event == DIRECT_LEFT) {
        // 添加或者编辑状态有未保存信息时，点击“取消按钮”提示是否放弃更改
        if ([self hasChanged]) {
            [LSAlertHelper showAlert:@"提示" message:@"内容有变更尚未保存，确定要退出吗？" cancle:@"取消" block:nil ensure:@"确定" block:^{
                [wself popToLatestViewController:kCATransitionFromLeft];
            }];
        } else {
            [self popToLatestViewController:kCATransitionFromLeft];
        }
    } else if (event == DIRECT_RIGHT) {
       
        if ([self isValid]) {
            
            // 是否有不限 项: 需满足显示且可编辑，且当前显示内容为“不限”
            BOOL unlimited = (!_wechatStockNum.hidden && !_wechatStockNum.btn.hidden && [[_wechatStockNum getStrVal] isEqualToString:@"不限"]) || (!_entityStockNum.hidden && !_entityStockNum.btn.hidden && [[_entityStockNum getStrVal] isEqualToString:@"不限"]);
            if (unlimited) {
                
                [LSAlertHelper showAlert:@"可兑换数量将设为“不限”，积分兑换时不会判断商品数量，是否继续保存？" block:nil block:^{
                    [wself saveIntegralExchangeGood];
                }];
            } else {
                [wself saveIntegralExchangeGood];
            }
        }
    }
}

- (void)configSubViews {
    
    _titleBox = [NavigateTitle2 navigateTitle:self];
    if (_actionType == ACTION_CONSTANTS_ADD) {
        [_titleBox initWithName:@"添加兑换设置" backImg:Head_ICON_BACK moreImg:Head_ICON_OK];
        [_titleBox editTitle:YES act:ACTION_CONSTANTS_ADD];
    } else {
        [_titleBox initWithName:@"积分商品详情" backImg:Head_ICON_BACK moreImg:nil];
    }
    [self.view addSubview:self.titleBox];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_scrollView];
    
    _container = [[UIView alloc] init];
    [_scrollView addSubview:_container];
    
    _summaryView = [LSGoodsSummaryInfoView goodsSummaryInfoView];
    [_container addSubview:_summaryView];
    
    _exchangeType = [[EditItemText alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48)];
    [_exchangeType initLabel:@"兑换类型" withHit:@"" isrequest:NO type:0];
    [_exchangeType initData:@"积分商品"];
    [_exchangeType editEnabled:NO];
    [_container addSubview:_exchangeType];
    
//    _factStockNum = [[EditItemText alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48)];
//    [_factStockNum initLabel:@"实库存数" withHit:@"" isrequest:NO type:0];
//    [_factStockNum editEnabled:NO];
//    [_container addSubview:_factStockNum];
    
    _needIntegral = [[EditItemList alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48)];
    [_needIntegral initLabel:@"兑换所需积分" withHit:@"" isrequest:YES delegate:self];
    _needIntegral.tag = 11;
    [_container addSubview:_needIntegral];
    
    if (_isEntity) {
        
        BOOL editAble = ![[Platform Instance] lockAct:ACTION_GIFT_GOODS_COUNT_SETTING];
        _entityStockNum = [[EditItemList alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 68)];
        [_entityStockNum initLabel:@"实体门店可兑换数量" withHit:@"未输入时在实体门店兑换将不判断可兑换数量" isrequest:NO delegate:self];
        [_entityStockNum initData:@"不限" withVal:@"不限"];
        [_entityStockNum editEnable:editAble];
        _entityStockNum.tag = 12;
        [_container addSubview:_entityStockNum];
        
       
        _wechatStockNum = [[EditItemList alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 68)];
        [_wechatStockNum initLabel:@"微店可兑换数量" withHit:@"未输入时在微店兑换将不判断可兑换数量" isrequest:NO delegate:self];
        [_wechatStockNum initData:@"不限" withVal:@"不限"];
        [_wechatStockNum editEnable:editAble];
        _wechatStockNum.tag = 13;
        [_container addSubview:_wechatStockNum];
        [_wechatStockNum visibal:_isWechatOpened]; // 微店显示时显示
    }
    
    
    if (!_detBtn && self.actionType == ACTION_CONSTANTS_EDIT) {
        _detBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_detBtn setTitle:@"删除" forState:0];
        [_detBtn setBackgroundColor:[ColorHelper getRedColor]];
        [_detBtn.titleLabel setTextColor:RGB(192, 0, 0)];
        [_detBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        _detBtn.layer.cornerRadius = 4.0;
        [_container addSubview:_detBtn];
    }
    
    // constraints
    __weak typeof(self) wself = self;
    [wself.titleBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.view.mas_left);
        make.top.equalTo(wself.view.mas_top);
        make.right.equalTo(wself.view.mas_right);
        make.height.equalTo(@64.0);
    }];
    
    [wself.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(wself.view).insets(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
    
    [wself.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(wself.scrollView).insets(UIEdgeInsetsZero);
        make.width.equalTo(wself.scrollView.mas_width);
        make.height.equalTo(wself.scrollView.mas_height);
    }];
    
    [wself.summaryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.container.mas_top);
        make.left.equalTo(wself.container.mas_left);
        make.right.equalTo(wself.container.mas_right);
    }];
    
    [wself.exchangeType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.container.mas_left);
        make.top.equalTo(wself.summaryView.mas_bottom);
        make.right.equalTo(wself.container.mas_right);
        make.height.equalTo(@48.0);
    }];
    
//    [wself.factStockNum mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(wself.container.mas_left);
//        make.top.equalTo(wself.exchangeType.mas_bottom);
//        make.right.equalTo(wself.container.mas_right);
//        make.height.equalTo(@48.0);
//    }];
    
    [wself.needIntegral mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.container.mas_left);
        make.top.equalTo(wself.exchangeType.mas_bottom);
        make.right.equalTo(wself.container.mas_right);
        make.height.equalTo(@48.0);
    }];
    
    __weak UIView *view = wself.needIntegral;
    if (wself.isEntity) {
        [wself.entityStockNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wself.container.mas_left);
            make.top.equalTo(wself.needIntegral.mas_bottom);
            make.right.equalTo(wself.container.mas_right);
            make.height.equalTo(@68.0);
        }];
        view = wself.entityStockNum;
        
        if (_isWechatOpened) {
            BOOL isEdit = wself.actionType == ACTION_CONSTANTS_EDIT;
            [wself.wechatStockNum mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(wself.container.mas_left);
                make.top.equalTo(wself.entityStockNum.mas_bottom);
                make.right.equalTo(wself.container.mas_right);
                make.height.equalTo(@68.0);
                if (isEdit == NO) {
                    make.bottom.lessThanOrEqualTo(wself.container.mas_bottom).with.offset(-40).with.priorityMedium();
                }
            }];
            view = wself.wechatStockNum;
        }
    }
    
    if (wself.detBtn) {
        [wself.detBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wself.container.mas_left).offset(12);
            make.top.equalTo(view.mas_bottom).offset(20);
            make.right.equalTo(wself.container.mas_right).offset(-12);
            make.height.equalTo(@44.0);
            make.bottom.lessThanOrEqualTo(wself.container.mas_bottom).with.offset(-30).with.priorityMedium();
        }];
    }
}

// 点击button，删除已有的积分商品，或者添加新的积分商品
- (void)buttonAction:(UIButton *)sender {
    
     __weak typeof(self) wself = self;
    [LSAlertHelper showSheet:[NSString stringWithFormat:@"确认要删除[%@]吗?" ,@""] cancle:@"取消" cancleBlock:nil selectItems:@[@"确认"] selectdblock:^(NSInteger index) {
        [wself deleteIntegralExchangeGood];
    }];
    
}

- (void)fillData {
    
    [self.exchangeType initData:@"积分商品"];
    if (self.actionType == ACTION_CONSTANTS_ADD) {
        // 服鞋
        [_summaryView fillGoodsSummaryInfo:_addGiftGoodVo];
        [self.needIntegral initData:@"" withVal:@""];
        // 实际库存
//        [_factStockNum initData:_addGiftGoodVo.giftGoodsNumber.stringValue?:@"0"];
//        [_entityStockNum initData:[_factStockNum getStrVal] withVal:[_factStockNum getStrVal]];
        
    } else if (self.actionType == ACTION_CONSTANTS_EDIT) {
        [_summaryView fillGoodsSummaryInfo:_editGiftGoodVo];
        [self.needIntegral initData:_editGiftGoodVo.point.stringValue withVal:_editGiftGoodVo.point.stringValue];
//        [_factStockNum initData:_editGiftGoodVo.number.stringValue?:@"0"];
        if (_editGiftGoodVo.limitedGiftStore.boolValue) {
            NSString *entityNum = _editGiftGoodVo.giftStore.stringValue?:@"0";
            [_entityStockNum initData:entityNum withVal:entityNum];
        }
        
        if (_wechatStockNum && _editGiftGoodVo.limitedWXGiftStore.boolValue) {
            NSString *virtualNum = _editGiftGoodVo.weixinGiftStore.stringValue?:@"0";
            [_wechatStockNum initData:virtualNum withVal:virtualNum];
        }
        
        // 角色权限 影响页面的显示
        if ([[Platform Instance] getShopMode] != 3) {
            //积分兑换设置 开，积分商品数量设置 关时
            //积分商品详情页面的实体门店可兑换数量和微店可兑换数量不可修改
            if (![[Platform Instance] lockAct:ACTION_POINT_EXCHANGE_SET] && [[Platform Instance] lockAct:ACTION_GIFT_GOODS_COUNT_SETTING] ) {
                [_entityStockNum editEnable:NO];
                [_wechatStockNum editEnable:NO];
            }
            
            //积分兑换设置 关，积分商品数量设置 开时
            //卡余额详情页面的金额、兑换所需积分不可修改，隐藏删除按钮；积分商品详情页面的兑换所需积分不可修改，隐藏删除按钮
            if ([[Platform Instance] lockAct:ACTION_POINT_EXCHANGE_SET] && ![[Platform Instance] lockAct:ACTION_GIFT_GOODS_COUNT_SETTING] ) {
                [self.needIntegral editEnable:NO];
                [self.detBtn removeFromSuperview];
            }
        }
    }
}

// 更改导航状态
- (void)tryChangeNavigateItemStatus {
    
    if (_needIntegral.baseChangeStatus || _entityStockNum.baseChangeStatus || _wechatStockNum.baseChangeStatus) {
        [self.titleBox editTitle:YES act:ACTION_CONSTANTS_ADD];
    } else {
        [self.titleBox editTitle:NO act:0];
    }
}

#pragma mark - 相关协议方法
// IEditItemListEvent
- (void)onItemListClick:(EditItemList *)obj {
    // 兑换积分：最大8位 实体和微店可兑换数量：最大6位
    NSInteger digit = obj.tag == 11 ? 8 : 6;
    NSString *initString = obj.lblVal.text;
    if ([initString isEqualToString:@"不限"]) {
        initString = @"";
    }
    [SymbolNumberInputBox initData:initString];
    [SymbolNumberInputBox limitInputNumber:digit digitLimit:0];
    [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:NO isSymbol:YES event:obj.tag];
}


// SymbolNumberInputClient
- (void)numberClientInput:(NSString *)val event:(NSInteger)eventType {
    
    if (eventType == _needIntegral.tag) {
        [_needIntegral changeData:val withVal:val];
    } else if (eventType == _entityStockNum.tag) {
       
        if ([NSString isBlank:val]) {
            NSString *stirng = @"不限";
//            if (self.actionType == ACTION_CONSTANTS_EDIT && _editGiftGoodVo.limitedGiftStore.boolValue) {
//                stirng = _editGiftGoodVo.giftStore.stringValue?:@"0";
//            }
            [_entityStockNum changeData:stirng withVal:stirng];
            
        } else {
            [_entityStockNum changeData:val withVal:val];
        }
    } else if (eventType == _wechatStockNum.tag) {
        
        if ([NSString isBlank:val]) {
            NSString *stirng = @"不限";
//            if (self.actionType == ACTION_CONSTANTS_EDIT && _editGiftGoodVo.limitedWXGiftStore.boolValue) {
//                stirng = _editGiftGoodVo.weixinGiftStore.stringValue?:@"0";
//            }
            [_wechatStockNum changeData:stirng withVal:stirng];
        } else {
             [_wechatStockNum changeData:val withVal:val];
        }
    }
    [self tryChangeNavigateItemStatus];
}


#pragma mark - 网络请求
// 删除积分兑换商品, 只有编辑装填才会有，所以一定是giftGoodVo
- (void)deleteIntegralExchangeGood {
   
    __weak typeof(self) weakSelf = self;
    NSString *goodId = weakSelf.editGiftGoodVo.goodsId;
    [_memberService cancelDegreeGoods:goodId completionHandler:^(id json) {
        if ([json[@"returnCode"] isEqualToString:@"success"]) {
            [weakSelf reloadIntegralGoodList];
        }
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json block:nil];
    }];
}

// 添加或者更新积分兑换商品
- (void)saveIntegralExchangeGood {
    
    // 整理传参
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    if (weakSelf.addGiftGoodVo) {
        [param setValue:weakSelf.addGiftGoodVo.goodsId forKey:@"goodsId"];
    } else if (self.editGiftGoodVo) {
        [param setValue:weakSelf.editGiftGoodVo.goodsId forKey:@"goodsId"];
    }
    // 兑换所需积分
    NSNumber *point = [[weakSelf.needIntegral getStrVal] convertToNumber];
    [param setValue:point forKey:@"point"];
    
    if (weakSelf.entityStockNum) {
        if ([[weakSelf.entityStockNum getStrVal] isEqualToString:@"不限"]) {
            [param setValue:@(NO) forKey:@"limitedGiftStore"];
        } else {
            [param setValue:@(YES) forKey:@"limitedGiftStore"];
            NSInteger count = [[weakSelf.entityStockNum getStrVal] integerValue];
            [param setValue:@(count) forKey:@"giftStore"];
        }
    }
    
    /** 编辑状态： @1 微店开通 @2 微店未开通 ，返回wechatStockNum当前值就行
     *  添加状态且微店开通
     */
    if (_actionType == ACTION_CONSTANTS_EDIT || (_actionType == ACTION_CONSTANTS_ADD && _isWechatOpened)) {
        
        if ([[weakSelf.wechatStockNum getStrVal] isEqualToString:@"不限"]) {
            [param setValue:@(NO) forKey:@"limitedWXGiftStore"];
        } else {
            [param setValue:@(YES) forKey:@"limitedWXGiftStore"];
            NSInteger count = [[weakSelf.wechatStockNum getStrVal] integerValue];
            [param setValue:@(count) forKey:@"weixinGiftStore"];
        }
    } else {
        // 添加且微店未开通，默认微店可销售数量有限制，数量为0
        [param setValue:@(YES) forKey:@"limitedWXGiftStore"];
        [param setValue:@(0) forKey:@"weixinGiftStore"];
    }
    
    if (self.actionType == ACTION_CONSTANTS_ADD) {
        
        [param setValue:@"add" forKey:@"operateType"];
        [_memberService saveDegreeGoodsWith:param completionHandler:^(id json) {
        
            if ([json[@"returnCode"] isEqualToString:@"success"]) {
                [weakSelf reloadIntegralGoodList];
            }
        } errorHandler:^(id json) {
            [LSAlertHelper showAlert:json block:nil];
        }];
    }
    else if (self.actionType == ACTION_CONSTANTS_EDIT) {
        
        [param setValue:@"edit" forKey:@"operateType"];
        [_memberService saveDegreeGoodsWith:param completionHandler:^(id json) {
            
            if ([json[@"returnCode"] isEqualToString:@"success"]) {
                [weakSelf reloadIntegralGoodList];
            }
        } errorHandler:^(id json) {
            [LSAlertHelper showAlert:json block:nil];
        }];
    }
}

// 返回更新积分兑换设置页面，并更新商品列表
- (void)reloadIntegralGoodList {
    
    NSArray *array = [self.navigationController viewControllers];
    for (UIViewController *vc in array) {
        if ([vc isKindOfClass:NSClassFromString(@"LSMemberIntegralSetViewController")]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
            [vc performSelector:@selector(getGoodGiftList:) withObject:@"" afterDelay:0.1];
#pragma clang diagnostic pop
            [self popToLatestViewController:kCATransitionFromLeft];
        }
    }
}

#pragma mark - related check
- (BOOL)hasChanged {
    
    if (self.needIntegral.baseChangeStatus || self.entityStockNum.baseChangeStatus || self.wechatStockNum.baseChangeStatus) {
        return YES;
    }
    return NO;
}
// 验证必填项：兑换所需积分
- (BOOL)isValid {
    
    if ([NSString isBlank:self.needIntegral.currentVal]) {
        [LSAlertHelper showAlert:@"兑换所需积分不能为空！" block:nil];
        return NO;
    } else if (self.needIntegral.currentVal.integerValue <= 0) {
        [LSAlertHelper showAlert:@"兑换所需积分不能为0！" block:nil];
        return NO;
    }
    return YES;
}

@end
