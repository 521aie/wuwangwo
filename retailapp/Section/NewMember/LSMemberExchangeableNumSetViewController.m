//
//  LSMemberExchangeableNumSetViewController.m
//  retailapp
//
//  Created by taihangju on 2017/3/1.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberExchangeableNumSetViewController.h"
#import "LSMemberConst.h"
#import "NavigateTitle2.h"
#import "EditItemList.h"
#import "SymbolNumberInputBox.h"
#import "Masonry.h"

@interface LSMemberExchangeableNumSetViewController ()<INavigateEvent, SymbolNumberInputClient, IEditItemListEvent>

@property (nonatomic, strong) NavigateTitle2 *titleBox;/**<标题栏>*/
@property (nonatomic, strong) EditItemList *numSetItem;/**<可兑换数量设置>*/
@property (nonatomic, assign) NSInteger type;/**<微店或者实体>*/
@property (nonatomic, strong) NSString *giftsString;/**<批量设置的可兑换商品装换的jsonString>*/

@end

@implementation LSMemberExchangeableNumSetViewController

- (instancetype)initWith:(NSInteger)type gifts:(NSString *)string {
    self = [super init];
    if (self) {
        self.type = type;
        self.giftsString = string;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [self configSubviews];
}


- (void)configSubviews {
 
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"设置可兑换数量" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
    [self.view addSubview:self.titleBox];
    
    NSString *title = self.type == kIsEntity ? @"实体门店可兑换数量" : @"微店可兑换数量";
    self.numSetItem = [[EditItemList alloc] initWithFrame:
                           CGRectMake(0, 0, SCREEN_W, 48.0)];
    [self.numSetItem initLabel:title withHit:nil delegate:self];
    [self.numSetItem initData:@"不限" withVal:@"不限"];
    self.numSetItem.imgMore.image = [UIImage imageNamed:@"ico_next_down"];
    [self.view addSubview:self.numSetItem];
    
    UILabel *notice = [[UILabel alloc] initWithFrame:CGRectZero];
    notice.textColor = [ColorHelper getTipColor6];
    notice.font = [UIFont systemFontOfSize:12.0];
    notice.text = ExchangeableNumSetNoticeString;
    notice.numberOfLines = 0;
    [notice sizeToFit];
    [self.view addSubview:notice];
    
    __weak typeof(self) wself = self;
    [wself.titleBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.view.mas_left);
        make.right.equalTo(wself.view.mas_right);
        make.top.equalTo(wself.view.mas_top);
        make.height.equalTo(@64);
    }];
    
    [wself.numSetItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.titleBox.mas_bottom);
        make.left.equalTo(wself.view.mas_left);
        make.right.equalTo(wself.view.mas_right);
        make.height.equalTo(@48);
    }];
    
    [notice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.numSetItem.mas_bottom).offset(5.0);
        make.left.equalTo(wself.view.mas_left).offset(8.0);
        make.right.equalTo(wself.view.mas_right).offset(-8.0);
    }];
}

#pragma mark - 相关协议方法 -
// IEditItemListEvent
- (void)onItemListClick:(EditItemList *)obj {
    NSString *data = [[obj getStrVal] isEqualToString:@"不限"]?@"":[obj getStrVal];
    [SymbolNumberInputBox initData:data];
    [SymbolNumberInputBox limitInputNumber:6 digitLimit:0];
    [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:NO isSymbol:NO event:11];
}

// INavigateEvent
- (void)onNavigateEvent:(Direct_Flag)event {
    if (event == DIRECT_LEFT) {
        [self popToLatestViewController:kCATransitionFromLeft];
    } else {
        if (self.numSetItem.baseChangeStatus == NO) {
            [LSAlertHelper showAlert:@"已选中商品的可兑换数量将设为“不限”，积分兑换时不会判断商品数量，是否继续保存？"
                               block:nil block:^{
                                   [self batchSetGiftStock];
            }];
            return;
        }
        [self batchSetGiftStock];
    }
}

// SymbolNumberInputClient
- (void)numberClientInput:(NSString *)val event:(NSInteger)eventType {
    
    if ([NSString isBlank:val]) {
        val = @"不限";
        [self.numSetItem changeData:val withVal:val];
    } else {
        NSString *numString = [val convertToNumber].stringValue;
        [self.numSetItem changeData:numString withVal:numString];
    }
}


#pragma mark - 网络请求 -
// 批量设置可兑换积分商品库存
- (void)batchSetGiftStock {
    NSString *stockNum = self.numSetItem.baseChangeStatus?[self.numSetItem getStrVal]:@"";
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:_giftsString forKey:@"goodsGiftList"];
    
    if ([NSString isBlank:stockNum] || [stockNum isEqualToString:@"不限"]) {
        if (self.type == kIsEntity) {
            [param setValue:@(NO) forKey:@"limitedGiftStore"];
        } else {
            [param setValue:@(NO) forKey:@"limitedWXGiftStore"];
        }
    } else {
        if (self.type == kIsEntity) {
            [param setValue:@(stockNum.integerValue) forKey:@"giftStore"];
            [param setValue:@(YES) forKey:@"limitedGiftStore"];
        } else {
            [param setValue:@(stockNum.integerValue) forKey:@"weixinGiftStore"];
            [param setValue:@(YES) forKey:@"limitedWXGiftStore"];
        }
    }
    __weak typeof(self) wself = self;
    [BaseService getRemoteLSDataWithUrl:@"gift/batchSetGiftStock" param:param
                            withMessage:@"" show:YES CompletionHandler:^(id json) {
                                
                                [wself popToLatestViewController:kCATransitionFromLeft];
                                if (wself.callBackBlock) {
                                    wself.callBackBlock();
                                }
                                
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
