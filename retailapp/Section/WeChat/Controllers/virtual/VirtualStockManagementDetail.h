//
//  StockQueryView.h
//  retailapp
//
//  Created by guozhi on 15/9/8.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IEditItemListEvent.h"
#import "SymbolNumberInputBox.h"
#import "NavigateTitle2.h"

@class NavigateTitle2,StockService,EditItemView,EditItemList,StockInfoVo;
@interface VirtualStockManagementDetail : BaseViewController <INavigateEvent,IEditItemListEvent,SymbolNumberInputClient,UIActionSheetDelegate,UIAlertViewDelegate> {
    StockService *service;
}
@property (nonatomic,weak) IBOutlet UIView* titleDiv;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *container;
@property (nonatomic,strong) NavigateTitle2* titleBox;
@property (weak, nonatomic) IBOutlet EditItemView *vewAmount;
@property (weak, nonatomic) IBOutlet EditItemList *lstVirtualnumber;
@property (nonatomic, strong) StockInfoVo *stockInfoVo;
@property (nonatomic, strong) NSString *iconPath;/**<图片路径>*/
@property (nonatomic, strong) NSMutableDictionary *param;
@property (nonatomic, strong) NSMutableDictionary *paramSave;
@property (nonatomic, assign) int action;
@property (nonatomic, copy) NSString *shopId;
@property (nonatomic, strong) NSString *goodsId;
@property (nonatomic, copy) NSString *val;
@property (nonatomic,assign) BOOL isEdit;
/*
 *  shopId    门店id
 *  GoodsVo   商品信息
 *  action    判断添加还是编辑
 */
- (instancetype)initWithShopId:(NSString *)shopId goodsId:(NSString *)goodsId action:(int)action edit:(BOOL)isEdit;
@end
