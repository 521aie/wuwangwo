//
//  StyleGoodsPriceView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/10/26.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
#import "IEditItemListEvent.h"
#import "SymbolNumberInputBox.h"

typedef void(^styleGoodsPriceBack) (NSString* lastVer);
@class LSEditItemList;
@interface StyleGoodsPriceView : LSRootViewController<IEditItemListEvent, SymbolNumberInputClient>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *container;

//进货价
@property (nonatomic, strong) LSEditItemList *lsPurPrice;
//吊牌价
@property (nonatomic, strong) LSEditItemList *lsHangTagPrice;
//零售价
@property (nonatomic, strong) LSEditItemList *lsRetailPrice;
//会员价
@property (nonatomic, strong) LSEditItemList *lsMemberPrice;
//批发价
@property (nonatomic, strong) LSEditItemList *lsWhoPrice;

@property (nonatomic, copy) styleGoodsPriceBack styleGoodsPriceBack;

-(void) loaddatas:(NSMutableArray*) styleGoodsList type:(int) type lastVer:(NSString*) lastVer styleId:(NSString*) styleId synShopId:(NSString*) synShopId action:(int) action callBack:(styleGoodsPriceBack) callBack;

@end
