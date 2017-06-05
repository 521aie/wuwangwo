//
//  StockQueryView.h
//  retailapp
//
//  Created by guozhi on 15/9/8.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
#import "IEditItemListEvent.h"
#import "SymbolNumberInputBox.h"
#import "IEditItemRadioEvent.h"

@class LSEditItemList,StockService,LSEditItemRadio,GoodsVo;
@interface AlertSettingBatch : LSRootViewController <IEditItemListEvent,SymbolNumberInputClient,IEditItemRadioEvent> {
    StockService *service;
}
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *container;
@property (nonatomic, strong) NSMutableDictionary *param;
@property (nonatomic, strong) NSMutableDictionary *param1;
@property (strong, nonatomic) LSEditItemRadio *rdoAlertNum;
@property (strong, nonatomic) LSEditItemList *lstAlertNum;
@property (strong, nonatomic) LSEditItemRadio *rdoDay;
@property (strong, nonatomic) LSEditItemList *lstDay;
@property (nonatomic, copy) NSString *shopId;
@property (nonatomic, strong) NSMutableArray *goodsVos;
@end
