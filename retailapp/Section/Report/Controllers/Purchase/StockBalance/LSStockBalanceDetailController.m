//
//  LSStockBalanceDetailController.m
//  retailapp
//
//  Created by guozhi on 2017/1/11.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSStockBalanceDetailController.h"
#import "XHAnimalUtil.h"
#import "LSEditItemView.h"
#import "UIHelper.h"
#import "LSStockBalanceVo.h"
@interface LSStockBalanceDetailController ()
/** <#注释#> */
@property (nonatomic, strong) UIScrollView *scrollView;
/** <#注释#> */
@property (nonatomic, strong) UIView *container;
/** 时间 */
@property (nonatomic, strong) LSEditItemView *vewTime;
/** 门店/仓库 */
@property (nonatomic, strong) LSEditItemView *vewShop;
/** 商品名称 */
@property (nonatomic, strong) LSEditItemView *vewGoodsName;
/** 条形码/款号 */
@property (nonatomic, strong) LSEditItemView *vewCode;
/** 颜色 */
@property (nonatomic, strong) LSEditItemView *vewColor;
/** 尺码 */
@property (nonatomic, strong) LSEditItemView *vewSize;
/** 期初数量 */
@property (nonatomic, strong) LSEditItemView *vewInitialNum;
/** 期初金额 */
@property (nonatomic, strong) LSEditItemView *vewInitialAmount;
/** 入库数量 */
@property (nonatomic, strong) LSEditItemView *vewStorageNum;
/** 出库数量 */
@property (nonatomic, strong) LSEditItemView *vewRefundNum;
/** 结存数量 */
@property (nonatomic, strong) LSEditItemView *vewStockNum;
/** 结存金额 */
@property (nonatomic, strong) LSEditItemView *vewStockAmount;
/** <#注释#> */
@property (nonatomic, strong) LSStockBalanceVo *stockBalanceVo;

@end

@implementation LSStockBalanceDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    [self configContainerViews];
    [self loadData];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    
}

- (void)configViews {
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    //标题
    [self configTitle:@"商品库存数量" leftPath:Head_ICON_BACK rightPath:nil];
    //scollVIew
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    [self.view addSubview:self.scrollView];
    //container
    self.container = [[UIView alloc] init];
    self.container.ls_width = SCREEN_W;
    self.container.hidden = YES;
    [self.scrollView addSubview:self.container];
}


- (void)configContainerViews {
    //时间
    self.vewTime = [LSEditItemView editItemView];
    [self.vewTime initLabel:@"时间" withHit:nil];
    [self.container addSubview:self.vewTime];
    //仓库/门店
    self.vewShop = [LSEditItemView editItemView];
    [self.vewShop initLabel:@"仓库/门店" withHit:nil];
    if ([[Platform Instance] getShopMode] != 3) {
        [self.vewShop visibal:NO];
    }
    [self.container addSubview:self.vewShop];
    //商品名称
    self.vewGoodsName = [LSEditItemView editItemView];
    NSString *goodsName = @"商品名称";
    [self.vewGoodsName initLabel:goodsName withHit:nil];
    self.vewGoodsName.lblDetail.font = [UIFont systemFontOfSize:15];
    self.vewGoodsName.lblDetail.textColor = [ColorHelper getTipColor3];
    [self.container addSubview:self.vewGoodsName];
    //条形码/款号
    self.vewCode = [LSEditItemView editItemView];
    NSString *code = [[[Platform Instance] getkey:SHOP_MODE] intValue] == 101 ? @"店内码" : @"条形码";
    [self.vewCode initLabel:code withHit:nil];
    [self.container addSubview:self.vewCode];
    if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {
        self.vewColor = [LSEditItemView editItemView];
        [self.vewColor initLabel:@"颜色" withHit:nil];
        [self.container addSubview:self.vewColor];
        
        self.vewSize = [LSEditItemView editItemView];
        [self.vewSize initLabel:@"尺码" withHit:nil];
        [self.container addSubview:self.vewSize];
        
    }
    //期初数量
    self.vewInitialNum = [LSEditItemView editItemView];
    [self.vewInitialNum initLabel:@"期初数量" withHit:nil];
    [self.container addSubview:self.vewInitialNum];
    //期初金额
    self.vewInitialAmount = [LSEditItemView editItemView];
    [self.vewInitialAmount initLabel:@"期初金额" withHit:nil];
    [self.container addSubview:self.vewInitialAmount];
    //入库数量
    self.vewStorageNum = [LSEditItemView editItemView];
    [self.vewStorageNum initLabel:@"入库数量" withHit:nil];
    [self.container addSubview:self.vewStorageNum];
    //出库数量
    self.vewRefundNum = [LSEditItemView editItemView];
    [self.vewRefundNum initLabel:@"出库数量" withHit:nil];
    [self.container addSubview:self.vewRefundNum];
    //结存数量
    self.vewStockNum = [LSEditItemView editItemView];
    [self.vewStockNum initLabel:@"结存数量" withHit:nil];
    [self.container addSubview:self.vewStockNum];
    //结存金额
    self.vewStockAmount = [LSEditItemView editItemView];
    [self.vewStockAmount initLabel:@"结存金额" withHit:nil];
    [self.container addSubview:self.vewStockAmount];
}

- (void)loadData {
    NSString *url = @"warehouseInventory/detail";
    __weak typeof(self) wself = self;
    [BaseService getRemoteLSDataWithUrl:url param:self.param withMessage:nil show:YES CompletionHandler:^(id json) {
        wself.stockBalanceVo = [LSStockBalanceVo mj_objectWithKeyValues:json[@"warehouseInventoryDetail"]];
        [wself fillData];
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json];
    }];
    
}

- (void)fillData {
    self.container.hidden = NO;
    //时间
    [self.vewTime initData:self.time];
    //仓库/门店
    [self.vewShop initData:self.stockBalanceVo.shopName];
    //商品名称
    NSString *goodsName = [[[Platform Instance] getkey:SHOP_MODE] intValue] == 101 ? self.stockBalanceVo.styleName : self.stockBalanceVo.goodsName;
    [self.vewGoodsName initHit:goodsName];
    //条形码/款号
    NSString *code = [[[Platform Instance] getkey:SHOP_MODE] intValue] == 101 ? self.stockBalanceVo.innerCode : self.stockBalanceVo.barCode;
    [self.vewCode initData:code];
    //颜色
    [self.vewColor initData:self.stockBalanceVo.colorName];
    //尺码
    [self.vewSize initData:self.stockBalanceVo.sizeName];
    //期初数量
    if ([ObjectUtil isNotNull:self.stockBalanceVo.initialNum]) {
        if ([self.stockBalanceVo.initialNum.stringValue containsString:@"."]) {
            [self.vewInitialNum initData:[NSString stringWithFormat:@"%.3f", self.stockBalanceVo.initialNum.doubleValue]];
        } else {
            [self.vewInitialNum initData:[NSString stringWithFormat:@"%.f", self.stockBalanceVo.initialNum.doubleValue]];
        }
    }
    //期初金额
    if ([ObjectUtil isNotNull:self.stockBalanceVo.initialAmount]) {
        [self.vewInitialAmount initData:[NSString stringWithFormat:@"%.2f", self.stockBalanceVo.initialAmount.doubleValue]];
    }
    //入库数量
    if ([ObjectUtil isNotNull:self.stockBalanceVo.storageNum]) {
        if ([self.stockBalanceVo.storageNum.stringValue containsString:@"."]) {
            [self.vewStorageNum initData:[NSString stringWithFormat:@"%.3f", self.stockBalanceVo.storageNum.doubleValue]];
        } else {
            [self.vewStorageNum initData:[NSString stringWithFormat:@"%.f", self.stockBalanceVo.storageNum.doubleValue]];
        }
    }
    //出库数量
    if ([ObjectUtil isNotNull:self.stockBalanceVo.refundNum]) {
        if ([self.stockBalanceVo.refundNum.stringValue containsString:@"."]) {
            [self.vewRefundNum initData:[NSString stringWithFormat:@"%.3f", self.stockBalanceVo.refundNum.doubleValue]];
        } else {
            [self.vewRefundNum initData:[NSString stringWithFormat:@"%.f", self.stockBalanceVo.refundNum.doubleValue]];
        }
    }
    
    //结存数量
    if ([ObjectUtil isNotNull:self.stockBalanceVo.stockNum]) {
        if ([self.stockBalanceVo.stockNum.stringValue containsString:@"."]) {
            [self.vewStockNum initData:[NSString stringWithFormat:@"%.3f", self.stockBalanceVo.stockNum.doubleValue]];
        } else {
            [self.vewStockNum initData:[NSString stringWithFormat:@"%.f", self.stockBalanceVo.stockNum.doubleValue]];
        }
    }
    
    //结存金额
    if ([ObjectUtil isNotNull:self.stockBalanceVo.stockAmount]) {
        [self.vewStockAmount initData:[NSString stringWithFormat:@"%.2f", self.stockBalanceVo.stockAmount.doubleValue]];
    }
     [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

@end
