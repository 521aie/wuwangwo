//
//  StockQueryView.m
//  retailapp
//
//  Created by guozhi on 15/9/8.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//
#define TAG_LST_STOCK 2
#import "VirtualStockBatchView.h"
#import "NavigateTitle2.h"
#import "XHAnimalUtil.h"
#import "UIHelper.h"
#import "EditItemRadio.h"
#import "EditItemList.h"
#import "Platform.h"
#import "SymbolNumberInputBox.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "NSString+Estimate.h"
#import "VirtualStockClothesDetail.h"
#import "VirtualStockSort.h"
#import "GoodsVo.h"
#import "VirtualStockManagementView.h"
#import "VirtualStockSort.h"
#import "StockService.h"

@interface VirtualStockBatchView ()<INavigateEvent,IEditItemListEvent,SymbolNumberInputClient,UIAlertViewDelegate> {
    StockService *service;
}

@property (nonatomic,strong) NavigateTitle2 *titleBox;
@property (nonatomic,weak) IBOutlet UIView *titleDiv;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet EditItemList *lstStocl;
@property (weak, nonatomic) IBOutlet UILabel *labDetail;
@property (nonatomic, strong) NSMutableDictionary *param;
@property (nonatomic, strong) NSMutableDictionary *param1;
@property (nonatomic, copy) NSString *shopId;
@end

@implementation VirtualStockBatchView
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil shopId:(NSString *)shopId goodsVos:(NSMutableArray *)goodsVos action:(int)action {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        service = [ServiceFactory shareInstance].stockService;
        self.shopId = shopId;
        self.goodsVos = goodsVos;
        self.action = action;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSubviews];
    [self loadData];
    [self initNotification];
}

- (void)configSubviews {
    
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"设置可销售数量" backImg:Head_ICON_BACK moreImg:nil];
    if (self.action == ACTION_CONSTANTS_ADD) {
        [self.titleBox editTitle:YES act:ACTION_CONSTANTS_ADD];
    }
    [self.titleDiv addSubview:self.titleBox];
    
    if (self.action == ACTION_CONSTANTS_ADD) {
        [self.lstStocl initLabel:@"可销售数量" withHit:nil isrequest:YES delegate:self];
    } else {
        [self.lstStocl initLabel:@"可销售数量" withHit:nil isrequest:NO delegate:self];
        self.lstStocl.oldVal = @"";
    }
    self.lstStocl.tag = TAG_LST_STOCK;
    [self initData];
//    self.labDetail.text = [NSString stringWithFormat:@"提示：建议设置的可销售数量不要超过已选中的商品最小实库存数%@。",self.maxStore?:@0];
//    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void)initData {
    self.labDetail.text = [NSString stringWithFormat:@"提示：建议设置的可销售数量不要超过已选中的商品最小实库存数%@。",self.maxStore];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void)onNavigateEvent:(Direct_Flag)event {
    if (event == DIRECT_LEFT) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        [self.navigationController popViewControllerAnimated:NO];
    } else {
        if ([self isValid]) {
            __weak typeof(self) wself = self;
            if ([[[_lstStocl getStrVal] convertToNumber] compare:_maxStore] == NSOrderedDescending) {
                [LSAlertHelper showAlert:@"设置的可销售数量大于已选中的商品最小实库存数，是否继续保存？" block:nil block:^{
                    [wself save];
                }];
            }  else {[wself save];}
        }
    }
}



- (void)showVirtualStockList {
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[VirtualStockManagementView class]]) {
            VirtualStockManagementView *viewController = (VirtualStockManagementView *)vc;
            [viewController loadVirtualListAndVirtualCount];
            if (self.action == ACTION_CONSTANTS_ADD) {
                [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
            } else {
                [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            }
            [self.navigationController popToViewController:viewController animated:NO];
        }
    }
}

- (void)initNotification {
    [UIHelper initNotification:self.container event:Notification_UI_VirtualStockManagement_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_VirtualStockManagement_Change object:nil];
}

- (void)dataChange:(NSNotification *)notification {
    if (self.action == ACTION_CONSTANTS_EDIT) {
        [self.titleBox editTitle:[UIHelper currChange:self.container] act:ACTION_CONSTANTS_EDIT];
    }
}

- (NSMutableDictionary *)param1 {
    if (_param1 == nil) {
        _param1 = [[NSMutableDictionary alloc] init];
    }
    [_param1 removeAllObjects];
    [_param1 setValue:@"1" forKey:@"batchMode"];
    if (self.lstStocl.hidden == NO) {
        [_param1 setValue:self.lstStocl.lblVal.text forKey:@"batchVirtualStore"];
    }

    if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 102) {
        
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (GoodsVo *goodsVo in self.goodsVos) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:goodsVo.goodsId forKey:@"goodsId"];
            [arr addObject:dict];
        }
        [_param1 setValue:arr forKey:@"goodsList"];
    }
    if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (NSString *goodsId in self.goodsVos) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:goodsId forKey:@"goodsId"];
            [arr addObject:dict];
        }
        [_param1 setValue:arr forKey:@"goodsList"];
    }
    [_param1 setValue:self.shopId forKey:@"shopId"];

    return _param1;
}

- (NSMutableDictionary *)param {
    if (_param == nil) {
        _param = [[NSMutableDictionary alloc] init];
    }
    [_param removeAllObjects];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 102) {
        for (GoodsVo *goodsVo in self.goodsVos) {
            [arr addObject:goodsVo.goodsId];
        }
        [_param setValue:arr forKey:@"goodsIdList"];
    }
    if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {
        [_param setValue:self.styleId forKey:@"styleId"];
    }
    [_param setValue:self.shopId forKey:@"shopId"];
    return _param;
}



- (void)onItemListClick:(EditItemList *)obj {
    if (obj.tag == TAG_LST_STOCK) {
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:NO isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:6 digitLimit:0];
        [SymbolNumberInputBox initData:obj.lblVal.text];
    }
}

- (void)numberClientInput:(NSString *)val event:(NSInteger)eventType {
    if (eventType == TAG_LST_STOCK) {
//        if ([val doubleValue] > self.maxStore) {
//            self.val = val;
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"设置的虚拟库存数大于所选商品的最小实际库存数，确认要设置吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
//            alert.tag = 1;
//            [alert show];
//           } else {
            [self.lstStocl changeData:val withVal:val];
//        }
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if (alertView.tag == 1) {
            [self.lstStocl changeData:self.val withVal:self.val];
        } else if (alertView.tag == 2) {
            [self save];
        }
    }
}


- (BOOL)isValid {
    if (self.action == ACTION_CONSTANTS_ADD) {
        if (self.lstStocl.hidden == NO) {
            if ([NSString isBlank:self.lstStocl.lblVal.text]) {
                [AlertBox show:@"可销售数量不能为空! "];
                return NO;
            }
//            if ([self.lstStocl.lblVal.text doubleValue] == 0.0) {
//                [AlertBox show:@"可销售数量不能为0! "];
//                 return NO;
//            }
           
        }
    } else {
//        if (self.lstStocl.hidden == NO) {
//            if ([NSString isNotBlank:self.lstStocl.lblVal.text]) {
//                if ([self.lstStocl.lblVal.text doubleValue] == 0.0) {
//                     [AlertBox show:@"可销售数量不能为0! "];
//                    return NO;
//                }
//            }
//        }
    }

    return YES;
}

#pragma mark - 网络请求 -
// 获取选择设置商品中的商品的最小实际库存：所有选中商品中实际库存最小的值
- (void)loadData {
    [service virtualStoreRange:self.param CompletionHandler:^(id json) {
        self.maxStore = json[@"maxValidVirtualStore"];
        [self initData];
        
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

// 保存设置的可销售数量
- (void)save {
    [service saveVirtualStore:self.param1 CompletionHandler:^(id json) {
        [self showVirtualStockList];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

@end
