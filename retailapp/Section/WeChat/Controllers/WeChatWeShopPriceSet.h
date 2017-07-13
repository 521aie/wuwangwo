//
//  WeChatWeShopPriceSet.h
//  retailapp
//
//  Created by diwangxie on 16/5/6.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigateTitle2.h"
#import "EditItemList.h"
#import "SymbolNumberInputBox.h"
#import "OptionPickerBox.h"

@interface WeChatWeShopPriceSet : BaseViewController<INavigateEvent,IEditItemListEvent,SymbolNumberInputClient,OptionPickerClient>
@property (weak, nonatomic) IBOutlet UIView *titleDiv;
@property (nonatomic, strong) NavigateTitle2 *titleBox;
@property (weak, nonatomic) IBOutlet EditItemList *lstStrategyType;
@property (weak, nonatomic) IBOutlet EditItemList *lstDiscountRate;
@property (weak, nonatomic) IBOutlet UIView *container;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic,strong) NSMutableArray * styleList;
/**
 *  商超版批量设置微店价格goodsId列表
 */
@property (nonatomic,strong) NSMutableArray * goodsIdList;


-(void)loadDate:(NSMutableArray *) styleList;
@end
