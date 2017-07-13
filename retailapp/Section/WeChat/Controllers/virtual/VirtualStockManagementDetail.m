//
//  StockQueryView.m
//  retailapp
//
//  Created by guozhi on 15/9/8.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//
#define LST_VIRTUAL_NUMBER 1
#import "VirtualStockManagementDetail.h"
#import "NavigateTitle2.h"
#import "XHAnimalUtil.h"
#import "EditItemList.h"
#import "EditItemView.h"
#import "UIHelper.h"
#import "SymbolNumberInputBox.h"
#import "UIHelper.h"
#import "StockInfoVo.h"
#import "AlertBox.h"
#import "ServiceFactory.h"
#import "VirtualStockManagementView.h"
#import "GoodsVo.h"
#import "NSNumber+Extension.h"
#import "UIImageView+SDAdd.h"

@interface VirtualStockManagementDetail ()

@property (weak, nonatomic) IBOutlet UIImageView *goodIcon;
@property (weak, nonatomic) IBOutlet UIImageView *goodTypeIcon; /*<商品类型图标>*/
@property (weak, nonatomic) IBOutlet UILabel *goodName;
@property (weak, nonatomic) IBOutlet UILabel *goodCode;
@property (weak, nonatomic) IBOutlet UILabel *goodPrice;
@end

@implementation VirtualStockManagementDetail
- (instancetype)initWithShopId:(NSString *)shopId goodsId:(NSString *)goodsId action:(int)action edit:(BOOL)isEdit {
    self = [super init];
    if (self) {
        service = [ServiceFactory shareInstance].stockService;
        self.goodsId = goodsId;
        self.shopId = shopId;
        self.action = action;
        self.isEdit = isEdit;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initNotification];
    [self configSubviews];
    [self loadData];
    [self configHelpButton:HELP_WECHAT_SALE_COUNT];
}

- (void)configSubviews {
    
    [_goodIcon ls_addCornerWithRadii:4 roundRect:CGRectMake(0, 0, 68, 68)];
    
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"微店商品详情" backImg:Head_ICON_BACK moreImg:nil];
    [self.titleDiv addSubview:self.titleBox];
    
    [self.lstVirtualnumber initLabel:@"可销售数量" withHit:@"建议不要超过实库存数" delegate:self];
    [self.vewAmount initLabel:@"实库存数" withHit:nil];
    self.lstVirtualnumber.tag = LST_VIRTUAL_NUMBER;
    if (!self.isEdit) {
        [self.lstVirtualnumber editEnable:NO];
    }
//    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}


- (void)onNavigateEvent:(Direct_Flag)event {
    if (event == 1) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    } else {
        if (self.action == ACTION_CONSTANTS_ADD && [[self.lstVirtualnumber getDataLabel] doubleValue] == 0) {
            [LSAlertHelper showAlert:@"商品数量必须大于0！"];
            return;
        }
        __weak typeof(self) weakself = self;
        [service saveVirtualStore:self.paramSave CompletionHandler:^(id json) {
            for (UIViewController *vc in weakself.navigationController.viewControllers) {
                if ([vc isKindOfClass:[VirtualStockManagementView class]]) {
                    VirtualStockManagementView *controller = (VirtualStockManagementView *)vc;
                    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
                    [controller loadVirtualListAndVirtualCount];
                    [weakself.navigationController popToViewController:controller animated:NO];
                }
            }
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }
}


- (void)initData {
    
    if (self.action ==ACTION_CONSTANTS_ADD) {
        if ([self.stockInfoVo.virtualStoreStatus intValue] != 1) {//判断有没有设置过虚拟库存
            self.action = ACTION_CONSTANTS_EDIT;
            [self.titleBox editTitle:NO act:ACTION_CONSTANTS_EDIT];
        }
    } if (self.action == ACTION_CONSTANTS_ADD) {
        [self.titleBox editTitle:YES act:ACTION_CONSTANTS_ADD];
    } else {
        [self.titleBox editTitle:NO act:ACTION_CONSTANTS_EDIT];
    }

    // 商品简介信息
    {
        NSString *name = nil;
        NSString *code = nil;
        NSString *price = nil;
        BOOL isCloth = [[[Platform Instance] getkey:SHOP_MODE] integerValue] == 101;
        
        // 商超：商品类型图片
        _goodTypeIcon.hidden = YES;
        if (!isCloth) {
            NSString *goodTypeName = [_stockInfoVo goodTypeImageString];
            if ([NSString isNotBlank:goodTypeName]) {
                _goodTypeIcon.hidden = NO;
                _goodTypeIcon.image = [UIImage imageNamed:goodTypeName];
            }
        }
        
        name = _stockInfoVo.goodsName?:@"";
        code = isCloth?_stockInfoVo.styleCode:_stockInfoVo.barCode;
        code = [NSString isNotBlank:code]?code:@"";
        price = [NSString stringWithFormat:@"微店售价: ￥%@",[_stockInfoVo.weixinPrice convertToStringWithFormat:@"###,##0.00"]];
        [_goodIcon ls_setImageWithPath:_iconPath placeholderImage:[UIImage imageNamed:@"img_default"]];
        self.goodName.text = name;
        self.goodCode.text = code;
        self.goodPrice.text = price;
    }
    

    [self.vewAmount initData:[NSString stringWithFormat:@"%d",[self.stockInfoVo.nowStore intValue]] withVal:[NSString stringWithFormat:@"%df",[self.stockInfoVo.nowStore intValue]]];
    [self.lstVirtualnumber initData:[NSString stringWithFormat:@"%d",[self.stockInfoVo.virtualStore intValue]] withVal:[NSString stringWithFormat:@"%d",[self.stockInfoVo.virtualStore intValue]]];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (NSMutableDictionary *)param {
    if (_param == nil) {
        _param = [[NSMutableDictionary alloc] init];
    }
    [_param removeAllObjects];
    [_param setValue:self.goodsId forKey:@"goodsId"];
    [_param setValue:self.shopId forKey:@"shopId"];
    return _param;
}

- (NSMutableDictionary *)paramSave {
    if (_paramSave == nil) {
        _paramSave = [[NSMutableDictionary alloc] init];
    }
    [_paramSave removeAllObjects];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:self.goodsId forKey:@"goodsId"];
    [dict setValue:[NSNumber numberWithFloat:[self.lstVirtualnumber.lblVal.text doubleValue]] forKey:@"virtualStore"];
    [arr addObject:dict];
    [_paramSave setValue:arr forKey:@"goodsList"];
    [_paramSave setValue:@"0" forKey:@"batchMode"];
    [_paramSave setValue:self.shopId forKey:@"shopId"];
    return _paramSave;
}

- (void)initNotification {
    [UIHelper initNotification:self.container event:Notification_UI_VirtualStockManagement_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_VirtualStockManagement_Change object:nil];
}

- (void)loadData {
    
    __weak VirtualStockManagementDetail *weakSelf = self;
    [service storeDetail:self.param CompletionHandler:^(id json) {
        NSDictionary *map = json[@"virtualStoreInfo"];
        if ([ObjectUtil isNotNull:map]) {
            weakSelf.stockInfoVo = [[StockInfoVo alloc] initWithDictionary:json[@"virtualStoreInfo"]];
            [weakSelf initData];
        }
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

- (void)dataChange:(NSNotification *)notification {
    if (self.action == ACTION_CONSTANTS_EDIT) {
        [self.titleBox editTitle:[UIHelper currChange:self.container] act:ACTION_CONSTANTS_EDIT];
    }
}

- (void)onItemListClick:(EditItemList *)obj {
    if (obj == self.lstVirtualnumber) {
        [SymbolNumberInputBox initData:[self.lstVirtualnumber getDataLabel]];
        if ([self.stockInfoVo.goodsType intValue] == 4) {//商超散称库存保留3位小数
            [SymbolNumberInputBox show:self.lstVirtualnumber.lblName.text client:self isFloat:YES isSymbol:NO event:obj.tag];
            [SymbolNumberInputBox limitInputNumber:6 digitLimit:3];

        } else {
            [SymbolNumberInputBox show:self.lstVirtualnumber.lblName.text client:self isFloat:NO isSymbol:NO event:obj.tag];
            [SymbolNumberInputBox limitInputNumber:6 digitLimit:3];
        }
    }
}

- (IBAction)onDelBtnClick:(UIButton *)sender {
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"是否确认删除" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确认" otherButtonTitles:nil, nil];
    [action showInView:self.view];
}

- (void)numberClientInput:(NSString *)val event:(NSInteger)eventType {
    if (eventType == LST_VIRTUAL_NUMBER) {
        if ([val doubleValue]>[self.stockInfoVo.nowStore doubleValue]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"设置的可销售数量大于商品实际库存数，确认要设置吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            [alert show];
            self.val = val;
        } else {
            [self.lstVirtualnumber changeData:val withVal:val];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self.lstVirtualnumber changeData:self.val withVal:self.val];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        [arr addObject:self.goodsId];
        [param setValue:arr forKey:@"goodsIdList"];
        [param setValue:self.shopId forKey:@"shopId"];
        __weak VirtualStockManagementDetail *weakSelf = self;
        [service deleteVirtualStore:param CompletionHandler:^(id json) {
            VirtualStockManagementView *vc = nil;
            for (UIViewController *controller in weakSelf.navigationController.viewControllers) {
                if ([controller isKindOfClass:[VirtualStockManagementView class]]) {
                    vc = (VirtualStockManagementView *)controller;
                }
            }
            [vc loadVirtualListAndVirtualCount];
            [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [weakSelf.navigationController popToViewController:vc animated:NO];
            
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }
}

@end
