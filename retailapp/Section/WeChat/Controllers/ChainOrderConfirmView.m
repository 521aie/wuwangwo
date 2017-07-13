//
//  ChainOrderConfirmView.m
//  retailapp
//
//  Created by Jianyong Duan on 15/12/14.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "ChainOrderConfirmView.h"
#import "ServiceFactory.h"
#import "WechatService.h"
#import "OptionPickerBox.h"
#import "NameItemVO.h"
#import "SRGoodsView.h"
#import "SRTitleView.h"
#import "SRItemView.h"
#import "SelectOpOrderShopView.h"
#import "XHAnimalUtil.h"
#import "AlertBox.h"
#import "StockInfoVo.h"
#import "OrderDivideVo.h"
#import "OrderDivideDetailVo.h"
#import "UIHelper.h"
#import "EditItemList.h"
#import "WechatOrderListView.h"

@interface ChainOrderConfirmView ()<INavigateEvent, IEditItemListEvent, UIAlertViewDelegate>

@property (nonatomic, strong) WechatService *wechatService;

//整单配送
@property (nonatomic, strong) EditItemList *lstShop;

// 库存
@property (nonatomic, strong) NSMutableArray *arrStock;


//outlet
@property (nonatomic, retain) IBOutlet UIView *titleDiv;
@property (nonatomic) NavigateTitle2 *titleBox;

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

/**是否开启虚拟库存 YES 开启*/
@property (nonatomic, assign) BOOL isVirtual;
@property (nonatomic, assign) int count;


@end

@implementation ChainOrderConfirmView
- (void)viewDidLoad {
    [super viewDidLoad];
    self.wechatService = [[WechatService alloc] init];
    [self initNavigate];
    [self initMainView];
}

- (BOOL)isContainInstanceVo:(NSMutableArray *)list instanceVo:(InstanceVo *)instanceVo {
    for (InstanceVo *instance in list) {
        if ([instance.goodsId isEqualToString:instanceVo.goodsId]) {
            return YES;
        }
    }
    return NO;
    
}


- (void)initNavigate {
    self.titleBox=[NavigateTitle2 navigateTitle:self];
    if (self.isReset) {
        [self.titleBox initWithName:@"重新分单" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
    } else {
        [self.titleBox initWithName:@"确认接单" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
    }
    [self.titleDiv addSubview:self.titleBox];
}

- (NSMutableArray *)arrStock {
    if (_arrStock == nil) {
        _arrStock = [NSMutableArray array];
    }
    return _arrStock;
}

- (void)initMainView {
    self.lstShop = [[EditItemList alloc] initWithFrame:CGRectMake(0, 0, 320, 48)];
    [self.lstShop initLabel:@"处理门店" withHit:nil isrequest:YES delegate:self];
    [self.lstShop initData:@"请选择" withVal:nil];
    self.lstShop.imgMore.image=[UIImage imageNamed:@"ico_next.png"];
    self.lstShop.tag = 1;
    [self.scrollView addSubview:self.lstShop];
    __block CGFloat _h = 48;
    
    // 商品列表
    
    [self.instanceVoJsonList enumerateObjectsUsingBlock:^(InstanceVo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *goodsView = [self viewForGoods:obj];
        CGRect rect = goodsView.frame;
        rect.origin.y = _h;
        goodsView.frame = rect;
        [self.scrollView addSubview:goodsView];
        _h = _h + rect.size.height;
    }];
    [self.scrollView setContentSize:CGSizeMake(320, _h + 40)];
}

- (UIView *)viewForGoods:(InstanceVo *)instanceVo {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    
    //商品名
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 300, 300)];
    label.numberOfLines = 0;
    label.text = instanceVo.originalGoodsName;
    label.textColor = RGB(51, 51, 51);
    label.font = [UIFont systemFontOfSize:15];
    [label sizeToFit];
    [view addSubview:label];
    
    CGFloat _h = label.frame.origin.y + label.frame.size.height + 12;
    
    //code
    label = [[UILabel alloc] initWithFrame:CGRectMake(10, _h, 300, 20)];
    label.textColor = RGB(102, 102, 102);
    label.font = [UIFont systemFontOfSize:15];
    if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {//服鞋
        label.text = instanceVo.innerCode;
    } else {
        label.text = instanceVo.barCode;
    }
    [label sizeToFit];
    [view addSubview:label];
    
    UILabel *labelNum = [[UILabel alloc] initWithFrame:CGRectMake(210, label.frame.origin.y, 100, 18)];
    labelNum.textColor = RGB(102, 102, 102);
    labelNum.font = [UIFont systemFontOfSize:15];
    labelNum.text = [NSString stringWithFormat:@"×%.0f", instanceVo.accountNum];
    labelNum.textAlignment = NSTextAlignmentRight;
    [view addSubview:labelNum];
    
    _h += 18 + 12;
    
    //颜色 尺码 服鞋版时表示
    if ([[[Platform Instance] getkey:SHOP_MODE] integerValue]==101) {
        UILabel *labelSku = [[UILabel alloc] initWithFrame:CGRectMake(10, _h, 300, 20)];
        labelSku.textColor = RGB(102, 102, 102);
        labelSku.font = [UIFont systemFontOfSize:15];
        labelSku.text = instanceVo.sku;
        [labelSku sizeToFit];
        [view addSubview:labelSku];
    }
    
    //库存
    UILabel *labelStock = [[UILabel alloc] initWithFrame:CGRectMake(150, _h, 160, 18)];
    labelStock.textColor = RGB(102, 102, 102);
    labelStock.font = [UIFont systemFontOfSize:15];
    labelStock.text = @"库存数：－";
    labelStock.textAlignment = NSTextAlignmentRight;
    [view addSubview:labelStock];
    
    [self.arrStock addObject:labelStock];
    _h += 18 + 12;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, _h, 300, 1)];
    line.backgroundColor = RGBA(0, 0, 0, 0.1);
    [view addSubview:line];
    view.frame = CGRectMake(0, 0, 320, _h + 1);
    return view;
}


-(void) onNavigateEvent:(Direct_Flag)event {
    if (event == 1) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    } else {
        if ([NSString isBlank:[self.lstShop getStrVal]]) {
            [AlertBox show:@"请选择处理门店！"];
            return;
        }
        BOOL isVisibal = NO;
        BOOL isAlert = NO;
        int i = 0;
        for (UILabel *lbl in self.arrStock) {
            InstanceVo *instanceVo = [self.instanceVoJsonList objectAtIndex:i];
            i++;
            NSString *text = lbl.text;
            if ([text isEqualToString:@"无"]) {
                isVisibal = YES;
            } else if (![text isEqualToString:@"－"]) {
                int accountNum = 0;
                accountNum = [[text substringFromIndex:4] intValue];
                if (accountNum < instanceVo.accountNum) {
                    isAlert = YES;
                }
            }
        }
        if (!self.isVirtual && isVisibal == NO && isAlert) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"存在实际库存数小于订单数量的商品，确定要分单吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
            return;
        }
        [self save];
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self save];
    }
}

- (void)save {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.orderInfo.orderId forKey:@"orderId"];
    //指定门店Id
    [param setObject:[self.lstShop getStrVal] forKey:@"targetShopId"];
    //手动分单
    NSString *url = nil;
    if (self.isReset) {//重新分单
        [param setObject:self.orderInfo.divideId forKey:@"divideId"];
        url = @"orderManagement/reSplitOrder";
    } else {
        url = @"orderManagement/manualSplit";
    }
    __weak typeof(self) wself = self;
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        [wself.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[WechatOrderListView class]]) {
                //前往订单列表页面
                WechatOrderListView *vc = (WechatOrderListView *)obj;
                [vc.tableView headerBeginRefreshing];
                [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
                [wself.navigationController popToViewController:obj animated:NO];
            }
        }];
        
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

- (void)onItemListClick:(EditItemList*)obj {
    NSString *goodsId = nil;
    SelectOpOrderShopView *vc= [[SelectOpOrderShopView alloc] init];
    vc.dealShopId = self.orderInfo.dealShopId;
    //商品
    if (self.instanceVoJsonList.count == 1) {
        InstanceVo *instanceVo = [self.instanceVoJsonList objectAtIndex:0];
        goodsId = instanceVo.goodsId;
    }
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    [vc loadData:[self.lstShop getStrVal] goodsId:goodsId isPush:YES callBack:^(OpOrderShopWare *item) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
        if (item == nil) {
            return;
        }
        if ([ObjectUtil isNotNull:item.virtualStoreStatus]) {
            self.isVirtual = item.virtualStoreStatus.boolValue;
        }
        
        UILabel *labelStock = nil;
        InstanceVo *instanceVo = nil;
        instanceVo = [self.instanceVoJsonList objectAtIndex:0];
        if (self.instanceVoJsonList.count == 1) {
            labelStock = [self.arrStock objectAtIndex:0];
        }
        
        //店铺设置
        [self.lstShop initData:item.name withVal:item.opOrderShopId];
        self.lstShop.additionalData = item.shopType;
        //获取商品库存
        if (self.instanceVoJsonList.count == 1) {
            if ([ObjectUtil isNull:item.number]) {
                labelStock.text = @"无";
                labelStock.textColor = [ColorHelper getRedColor];
            } else {
                labelStock.textColor = RGB(102, 102, 102);
                int number = [item.number intValue];
                if (self.isVirtual) {
                    NSString *str = [NSString stringWithFormat:@"库存数：%d", number];
                    if (number < instanceVo.accountNum) {
                        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str];
                        [attr addAttribute:NSForegroundColorAttributeName value:[ColorHelper getRedColor] range:NSMakeRange(4, str.length - 4)];
                        labelStock.attributedText = attr;
                    } else {
                        labelStock.text = str;
                    }
                    
                } else {
                    NSString *str = [NSString stringWithFormat:@"库存数：%d", number];
                    if (number < instanceVo.accountNum) {
                        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str];
                        [attr addAttribute:NSForegroundColorAttributeName value:[ColorHelper getRedColor] range:NSMakeRange(4, str.length - 4)];
                        labelStock.attributedText = attr;
                    } else {
                        
                        labelStock.text = str;
                    }
                    
                }
                
                
            }
            
        } else {//微店整单订单库存信息
            [self getStockInfoList];
        }
        
        
    }];
}

//微店整单订单库存信息
- (void)getStockInfoList {
    NSMutableArray *goodsIdList = [NSMutableArray array];
    
    for (InstanceVo *instanceVo in self.instanceVoJsonList) {
        [goodsIdList addObject:instanceVo.goodsId];
    }
    __weak typeof(self) weakSelf = self;
    [self.wechatService getStockInfoList:[self.lstShop getStrVal] goodsIdList:goodsIdList  completionHandler:^(id json) {
        if (!weakSelf) {
            return;
        }
        
        NSArray *stockInfoList = [StockInfoVo converToArr:json[@"stockInfoList"]];
        BOOL virtualStock = NO;
        if ([ObjectUtil isNotNull:json[@"virtualStock"]]) {
            virtualStock = [json[@"virtualStock"] boolValue];
        }
        self.isVirtual = virtualStock;
        for (UILabel *labelStock in self.arrStock) {
            if (virtualStock) {//开启虚拟库存显示-
                labelStock.text = @"－";
                labelStock.textColor = RGB(102, 102, 102);
            } else {//关闭虚拟库存显示无
                labelStock.text = @"无";
                labelStock.textColor = [ColorHelper getRedColor];
            }
            
            
        }
        if ([ObjectUtil isNotEmpty:stockInfoList] && weakSelf.arrStock.count > 0) {
            
            for (StockInfoVo *stockInfo in stockInfoList) {
                
                //库存
                NSString *stock = nil;
                if (virtualStock) {
                    if ([ObjectUtil isNotNull:stockInfo.virtualStore]) {
                        stock = [stockInfo.virtualStore stringValue];
                    }
                    
                } else {
                    if ([ObjectUtil isNotNull:stockInfo.nowStore]) {
                        stock = [stockInfo.nowStore stringValue];
                        
                    }
                    
                }
                
                for (int i = 0; i< weakSelf.arrStock.count; i++) {
                    InstanceVo *instanceVo = [weakSelf.instanceVoJsonList objectAtIndex:i];
                    
                    if ([stockInfo.goodsId isEqualToString:instanceVo.goodsId]) {
                        
                        UILabel *labelStock = [weakSelf.arrStock objectAtIndex:i];
                        
                        //虚拟库存开关开启显示虚拟库存关闭显示实际库存
                        //虚拟库存小于商品数量红色显示
                        //虚拟库存状态不是2（不正常有可能为null）也是红色
                        NSString *str = [NSString stringWithFormat:@"库存数：%@", stock];
                        labelStock.textColor = RGB(102, 102, 102);
                        if (stock == nil || stock == (id)[NSNull null] || [stockInfo.virtualStoreStatus intValue] != 2 || [stock doubleValue] < instanceVo.accountNum) {
                            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str];
                            [attr addAttribute:NSForegroundColorAttributeName value:[ColorHelper getRedColor] range:NSMakeRange(4, str.length - 4)];
                            labelStock.attributedText = attr;
                        } else {
                            labelStock.text = str;
                            
                        }
                        break;
                    }
                }
            }
        }
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

#pragma mark - private
- (void)setViewFrame:(UIView *)view Y:(CGFloat)y {
    CGRect rect = view.frame;
    rect.origin.y = y;
    view.frame = rect;
}

@end
