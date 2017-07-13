//
//  ReSplitOrderView.m
//  retailapp
//
//  Created by Jianyong Duan on 16/1/8.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "ReSplitOrderView.h"
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
#import "WechatOrderListView.h"

@interface ReSplitOrderView ()<INavigateEvent, IEditItemListEvent, OptionPickerClient>

@property (nonatomic, strong) WechatService *wechatService;

//整单配送
@property (nonatomic, strong) EditItemList *lsShop;

//拆单配送
@property (nonatomic, strong) NSMutableArray *arrShop;
// 库存
@property (nonatomic, strong) NSMutableArray *arrStock;

@property (nonatomic ,strong) NSMutableArray *instanceAllList;

@end

@implementation ReSplitOrderView

- (NSMutableArray *)arrShop {
    if (!_arrShop) {
        _arrShop = [NSMutableArray array];
    }
    return _arrShop;
}

- (NSMutableArray *)arrStock {
    if (!_arrStock) {
        _arrStock = [NSMutableArray array];
    }
    return _arrStock;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.wechatService = [ServiceFactory shareInstance].wechatService;
    
    // 商品列表
    self.instanceAllList = [NSMutableArray array];
    for (OrderDivideVo *orderDivideVo in self.orderDivideVoList) {
        [self.instanceAllList addObjectsFromArray:orderDivideVo.instanceVoList];
    }

    self.titleBox=[NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"确认接单" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
    [self.titleDiv addSubview:self.titleBox];
    
    [self.lsMode initLabel:@"分单方式" withHit:nil delegate:self];
    [self.lsMode initData:@"拆单配送" withVal:@"拆单配送"];
    self.lsMode.tag = 0;
    
    [self initMainView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initMainView {
    
    //清空
    for (UIView *view in self.scrollView.subviews) {
        if (view == self.lsMode) {
        } else {
            [view removeFromSuperview];
        }
    }
    self.lsShop = nil;
    [self.arrShop removeAllObjects];
    [self.arrStock removeAllObjects];
    
    if ([self.lsMode.currentVal isEqualToString:@"整单配送"]) {
        
        self.lsShop = [[EditItemList alloc] initWithFrame:CGRectMake(0, 48, 320, 48)];
        [self.lsShop initLabel:@"处理门店/仓库" withHit:nil isrequest:YES delegate:self];
        self.lsShop.tag = 1;
        [self.scrollView addSubview:self.lsShop];
        
        
        CGFloat _h = 96;
        
        // 商品列表
        for (int i = 0; i < self.instanceAllList.count; i++) {
            InstanceVo *instanceVo = [self.instanceAllList objectAtIndex:i];
            
            UIView *goodsView = [self viewForGoods:instanceVo];
            CGRect rect = goodsView.frame;
            rect.origin.y = _h;
            goodsView.frame = rect;
            [self.scrollView addSubview:goodsView];
            _h = _h + rect.size.height;
        }
    
        [self.scrollView setContentSize:CGSizeMake(320, _h + 10)];
    } else {
        
        CGFloat _h = 68;
        
        // 商品列表
        for (int i = 0; i < self.instanceAllList.count; i++) {
            InstanceVo *instanceVo = [self.instanceAllList objectAtIndex:i];
            
            SRTitleView *titleView = [SRTitleView loadFromNibWithTitle:[NSString stringWithFormat:@"拆单商品%02d", i + 1]];
            [self.scrollView addSubview:titleView];
            [self setViewFrame:titleView Y:_h];
            _h = _h + 44;
            
            UIView *goodsView = [self viewForGoods:instanceVo];
            CGRect rect = goodsView.frame;
            rect.origin.y = _h;
            goodsView.frame = rect;
            [self.scrollView addSubview:goodsView];
            _h = _h + rect.size.height;
            
            EditItemList *lsShop = [[EditItemList alloc] initWithFrame:CGRectMake(0, _h, 320, 48)];
            [lsShop initLabel:@"处理门店/仓库" withHit:nil isrequest:YES  delegate:self];
            lsShop.tag = i + 1;
            [self.scrollView addSubview:lsShop];
            [self.arrShop addObject:lsShop];
            
            _h += 48;
            
            SRItemView *itemView = [SRItemView loadFromNib];
            [itemView setTitle:@"库存数" value:@"－"];
            [self setViewFrame:itemView Y:_h];
            [self.scrollView addSubview:itemView];
            _h = _h + 44;
            
            [self.arrStock addObject:[itemView getValueLabel]];
        }
        
        [self.scrollView setContentSize:CGSizeMake(320, _h + 10)];
    }
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
    
    if ([self.lsMode.currentVal isEqualToString:@"整单配送"]) {
        UILabel *labelNum = [[UILabel alloc] initWithFrame:CGRectMake(210, label.frame.origin.y, 100, label.frame.size.height)];
        labelNum.textColor = RGB(102, 102, 102);
        labelNum.font = [UIFont systemFontOfSize:15];
        labelNum.text = [NSString stringWithFormat:@"×%.0f", instanceVo.accountNum];
        labelNum.textAlignment = NSTextAlignmentRight;
        [view addSubview:labelNum];
    }
    
    _h += label.frame.size.height + 12;
    
    //颜色 尺码 服鞋版时表示
    if ([[[Platform Instance] getkey:SHOP_MODE] integerValue]==101) {
        UILabel *labelSku = [[UILabel alloc] initWithFrame:CGRectMake(10, _h, 300, 20)];
        labelSku.textColor = RGB(102, 102, 102);
        labelSku.font = [UIFont systemFontOfSize:15];
        labelSku.text = instanceVo.sku;
        [labelSku sizeToFit];
        [view addSubview:labelSku];
    }
    
    if ([self.lsMode.currentVal isEqualToString:@"整单配送"]) {
        
        //库存
        UILabel *labelStock = [[UILabel alloc] initWithFrame:CGRectMake(210, _h, 100, label.frame.size.height)];
        labelStock.textColor = RGB(102, 102, 102);
        labelStock.font = [UIFont systemFontOfSize:15];
        labelStock.text = @"库存数：－";
        labelStock.textAlignment = NSTextAlignmentRight;
        [view addSubview:labelStock];
        
        [self.arrStock addObject:labelStock];
    } else {
        UILabel *labelNum = [[UILabel alloc] initWithFrame:CGRectMake(210, _h, 100, label.frame.size.height)];
        labelNum.textColor = RGB(102, 102, 102);
        labelNum.font = [UIFont systemFontOfSize:15];
        labelNum.text = [NSString stringWithFormat:@"×%.0f", instanceVo.accountNum];
        labelNum.textAlignment = NSTextAlignmentRight;
        [view addSubview:labelNum];
    }
    
    _h += label.frame.size.height + 12;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, _h, 300, 1)];
    line.backgroundColor = RGBA(0, 0, 0, 0.1);
    [view addSubview:line];
    
    view.frame = CGRectMake(0, 0, 320, _h + 1);
    return view;
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
-(void) onNavigateEvent:(Direct_Flag)event {
    if (event == 1) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    } else {
        //保存
        NSMutableArray *array = [NSMutableArray array];
        
        NSMutableArray *goodsIdList = [NSMutableArray array];
        NSMutableArray *divideIdList = [NSMutableArray array];
        for (OrderDivideVo *orderDivideVo in self.orderDivideVoList) {
            [divideIdList addObject:orderDivideVo.orderDivideId];
        }
        
        //分单明细
        if ([self.lsMode.currentVal isEqualToString:@"整单配送"]) {
            
            NSString *shopId = self.lsShop.currentVal;
            if ([NSString isBlank:shopId]) {
                [AlertBox show:@"请选择处理门店/仓库！"];
                return;
            }
            
            OrderDivideVo *orderDivide = [[OrderDivideVo alloc] init];
            
            //供货门店仓库ID
            if (self.orderDivideVoList.count > 0) {
                OrderDivideVo *orderDivideVoOne = [self.orderDivideVoList objectAtIndex:0];
                orderDivide.entityId = orderDivideVoOne.entityId;
                orderDivide.orderId = orderDivideVoOne.orderId;
            }

            orderDivide.shopId = shopId;
            orderDivide.shopType = self.lsShop.additionalData;
            orderDivide.shopName = [self.lsShop getDataLabel];
            orderDivide.createTime = [[NSDate date] timeIntervalSince1970] * 1000;
            orderDivide.opTime = [[NSDate date] timeIntervalSince1970] * 1000;
            orderDivide.opUserId = [[Platform Instance] getkey:USER_ID];
            orderDivide.lastVer = 1;
            orderDivide.divideStatus = 1;
            
            double accountNum = 0;
            //分单详情
            NSMutableArray *orderDivideDetailVoList = [NSMutableArray array];
            for (int i = 0; i < self.instanceAllList.count; i++) {
                
                InstanceVo *instance = [self.instanceAllList objectAtIndex:i];
                
                [goodsIdList addObject:instance.goodsId];
                    
                OrderDivideDetailVo *divideDetail = [[OrderDivideDetailVo alloc] init];
                
                //订单明细ID
                divideDetail.instanceId = instance.instanceId;
                //分单信息ID 1门店、2仓库
                divideDetail.orderDivideId = self.lsShop.additionalData;
                //配送数量
                divideDetail.distributionCount = instance.accountNum;
                //创建时间
                divideDetail.createTime = [[NSDate date] timeIntervalSince1970] * 1000;
                //操作时间
                divideDetail.opTime = [[NSDate date] timeIntervalSince1970] * 1000;
                //版本号
                divideDetail.lastVer = 1;
                //操作人
                divideDetail.opUserId = [[Platform Instance] getkey:USER_ID];
                //商品Id
                divideDetail.goodsId = instance.goodsId;
                
                [orderDivideDetailVoList addObject:divideDetail];
                
                //销售数量
                accountNum += instance.accountNum;
            }
            
            orderDivide.supplyNum = accountNum;
            orderDivide.orderDivideDetailVoList = orderDivideDetailVoList;
            
            [array addObject:orderDivide];
            
        } else {
            
            for (int i = 0; i < self.arrShop.count && i < self.instanceAllList.count; i++) {
                
                InstanceVo *instance = [self.instanceAllList objectAtIndex:i];
                
                [goodsIdList addObject:instance.goodsId];
                
                EditItemList *lsDivideShop = [self.arrShop objectAtIndex:i];
                
                NSString *shopId = lsDivideShop.currentVal;
                if ([NSString isBlank:shopId]) {
                    [AlertBox show:@"请选择处理门店/仓库！"];
                    return;
                }
                
                OrderDivideVo *orderDivide = [[OrderDivideVo alloc] init];
                
                //供货门店仓库ID
                if (self.orderDivideVoList.count > 0) {
                    OrderDivideVo *orderDivideVoOne = [self.orderDivideVoList objectAtIndex:0];
                    orderDivide.entityId = orderDivideVoOne.entityId;
                    orderDivide.orderId = orderDivideVoOne.orderId;
                }
                
                orderDivide.shopId = shopId;
                orderDivide.shopType = lsDivideShop.additionalData;
                orderDivide.shopName = [lsDivideShop getDataLabel];
                orderDivide.createTime = [[NSDate date] timeIntervalSince1970] * 1000;
                orderDivide.opTime = [[NSDate date] timeIntervalSince1970] * 1000;
                orderDivide.opUserId = [[Platform Instance] getkey:USER_ID];
                orderDivide.lastVer = 1;
                orderDivide.supplyNum = instance.accountNum;
                orderDivide.divideStatus = 1;
                
                //分单详情
                NSMutableArray *orderDivideDetailVoList = [NSMutableArray array];
                
                OrderDivideDetailVo *divideDetail = [[OrderDivideDetailVo alloc] init];
                
                //订单明细ID
                divideDetail.instanceId = instance.instanceId;
                //分单信息ID 1门店、2仓库
                divideDetail.orderDivideId = lsDivideShop.additionalData;
                //配送数量
                divideDetail.distributionCount = instance.accountNum;
                //创建时间
                divideDetail.createTime = [[NSDate date] timeIntervalSince1970] * 1000;
                //操作时间
                divideDetail.opTime = [[NSDate date] timeIntervalSince1970] * 1000;
                //版本号
                divideDetail.lastVer = 1;
                //操作人
                divideDetail.opUserId = [[Platform Instance] getkey:USER_ID];
                //商品Id
                divideDetail.goodsId = instance.goodsId;
                
                [orderDivideDetailVoList addObject:divideDetail];
                
                orderDivide.orderDivideDetailVoList = orderDivideDetailVoList;
                
                [array addObject:orderDivide];
            }
        }
        
        //重新分单
        [self.wechatService reSplitOrder:self.orderId showTypeVoList:array goodsIdList:goodsIdList divideIdList:divideIdList completionHandler:^(id json) {
            //保存成功后，页面跳转到销售/供货订单列表页面。
            
            UIViewController *viewController = nil;
            
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[WechatOrderListView class]]) {
                    viewController = controller;
                    break;
                }
            }
            if (viewController) {
                [self.navigationController popToViewController:viewController animated:YES];
            } else {
                [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
                [self.navigationController popViewControllerAnimated:NO];
            }
            
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }
}

- (void)onItemListClick:(EditItemList*)obj {
    if (obj == self.lsMode) {
        NSMutableArray *nameItems = [[NSMutableArray alloc] init];
        NameItemVO *nameItemVo = [[NameItemVO alloc] initWithVal:@"整单配送" andId:@"整单配送"];
        [nameItems addObject:nameItemVo];
        nameItemVo = [[NameItemVO alloc] initWithVal:@"拆单配送" andId:@"拆单配送"];
        [nameItems addObject:nameItemVo];
        [OptionPickerBox initData:nameItems itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    } else {
        NSString *goodsId = nil;
        
        //商品
        if ([self.lsMode.currentVal isEqualToString:@"整单配送"]) {
            //取库存
            if (self.instanceAllList.count == 1) {
                InstanceVo *instanceVo = [self.instanceAllList objectAtIndex:0];
                goodsId = instanceVo.goodsId;
            }
        } else {
            InstanceVo *instanceVo = [self.instanceAllList objectAtIndex:obj.tag - 1];
            goodsId = instanceVo.goodsId;
        }
        EditItemList *lstShop = nil;
//        UILabel *labelStock = nil;
        if ([self.lsMode.currentVal isEqualToString:@"整单配送"]) {
            lstShop = self.lsShop;
            if (self.instanceAllList.count == 1) {
//                labelStock = [self.arrStock objectAtIndex:0];
            }
        } else {
            if (obj.tag <= self.arrShop.count) {
                lstShop  = [self.arrShop objectAtIndex:obj.tag - 1];
//                labelStock = [self.arrStock objectAtIndex:obj.tag - 1];
            }
        }

        SelectOpOrderShopView *vc= [[SelectOpOrderShopView alloc] init];
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        [vc loadData:[lstShop getStrVal] goodsId:goodsId isPush:YES callBack:^(OpOrderShopWare *item) {
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [self.navigationController popViewControllerAnimated:NO];
            
            if (item == nil) {
                return;
            }
            
            EditItemList *lstShop = nil;
            UILabel *labelStock = nil;
            if ([self.lsMode.currentVal isEqualToString:@"整单配送"]) {
                lstShop = self.lsShop;
                if (self.instanceAllList.count == 1) {
                    labelStock = [self.arrStock objectAtIndex:0];
                }
            } else {
                if (obj.tag <= self.arrShop.count) {
                    lstShop  = [self.arrShop objectAtIndex:obj.tag - 1];
                    labelStock = [self.arrStock objectAtIndex:obj.tag - 1];
                }
            }
            
            //店铺设置
            [lstShop initData:item.name withVal:item.opOrderShopId];
            lstShop.additionalData = item.shopType;
            
            //获取商品库存
            if ([self.lsMode.currentVal isEqualToString:@"整单配送"]) {
                if ([NSString isBlank:self.lsShop.currentVal]) {
                    
                    for (int i = 0; i < self.arrStock.count; i++) {
                        UILabel *label = [self.arrStock objectAtIndex:i];
                        label.text = @"库存数：－";
                        label.textColor = RGB(102, 102, 102);
                    }
                } else {
                    //取库存
                    
                    if (self.instanceAllList.count == 1 && self.arrStock.count == 1) {
                        labelStock.text = [NSString stringWithFormat:@"%@", item.number];
                        if (item.number > 0) {
                            labelStock.textColor = RGB(102, 102, 102);
                        } else {
                            labelStock.textColor = RGB(204, 0, 0);
                        }
                    } else {
                        
                        //微店整单订单库存信息
                        [self getStockInfoList];
                    }
                }
            } else {
                if ([NSString isBlank:self.lsShop.currentVal]) {
                    labelStock.text = @"－";
                    labelStock.textColor = RGB(102, 102, 102);
                } else {
                    //库存
                    labelStock.text = [NSString stringWithFormat:@"%@", item.number];
                    if (item.number > 0) {
                        labelStock.textColor = RGB(102, 102, 102);
                    } else {
                        labelStock.textColor = RGB(204, 0, 0);
                    }
                }
            }
            
        }];
    }
}

//微店整单订单库存信息
- (void)getStockInfoList {
    NSMutableArray *goodsIdList = [NSMutableArray arrayWithCapacity:self.instanceAllList.count];
    
    for (InstanceVo *instanceVo in self.instanceAllList) {
        [goodsIdList addObject:instanceVo.goodsId];
    }
    
    __weak typeof(self) weakSelf = self;
    [self.wechatService getStockInfoList:self.lsShop.currentVal goodsIdList:goodsIdList  completionHandler:^(id json) {
        if (!weakSelf) {
            return;
        }
        
        NSArray *stockInfoList = [StockInfoVo converToArr:json[@"stockInfoList"]];
        BOOL virtualStock = NO;
        if ([ObjectUtil isNotNull:json[@"virtualStock"]]) {
            virtualStock = [json[@"virtualStock"] boolValue];
        }
        
        if ([ObjectUtil isNotEmpty:stockInfoList] && weakSelf.arrStock.count > 0) {
            
            for (StockInfoVo *stockInfo in stockInfoList) {
                
                //库存
                NSString *stock = nil;
                if (virtualStock && [stockInfo.virtualStoreStatus intValue] == 2) {
                    stock = [stockInfo.virtualStore stringValue];
                } else {
                    stock = [stockInfo.nowStore stringValue];
                }
                
                for (int i = 0; i< weakSelf.arrStock.count && i< weakSelf.instanceAllList.count; i++) {
                    InstanceVo *instanceVo = [weakSelf.instanceAllList objectAtIndex:i];
                    
                    if ([stockInfo.goodsId isEqualToString:instanceVo.goodsId]) {
                        
                        UILabel *labelStock = [weakSelf.arrStock objectAtIndex:i];
                        
                        labelStock.text = stock;
                        if ([stock integerValue] > 0) {
                            labelStock.textColor = RGB(102, 102, 102);
                        } else {
                            labelStock.textColor = RGB(204, 0, 0);
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

- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType {
    id<INameItem> item = (id<INameItem>)selectObj;
    if (eventType == 0) {
        //分单方式
        if (![[item obtainItemName] isEqualToString:self.lsMode.currentVal]) {
            [self.lsMode initData:[item obtainItemName] withVal:[item obtainItemId]];
            [self initMainView];
        }
    }
    return YES;
}

#pragma mark - private
- (void)setViewFrame:(UIView *)view Y:(CGFloat)y {
    CGRect rect = view.frame;
    rect.origin.y = y;
    view.frame = rect;
}

@end
