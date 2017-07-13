//
//  GoodsBatchSaleSettingView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/7/29.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
#import "IEditItemListEvent.h"
#import "IEditItemRadioEvent.h"
#import "SymbolNumberInputBox.h"


@class  LSEditItemRadio, LSEditItemList;
typedef void(^goodsBatchSaleSettingBack) (BOOL flg);
@interface GoodsBatchSaleSettingView : LSRootViewController<SymbolNumberInputClient, IEditItemListEvent>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *container;

//销售提成比例
@property (nonatomic, strong) LSEditItemList *lsSaleRoyaltyRatio;
//参与积分
@property (nonatomic, strong) LSEditItemRadio *rdoIsJoinPoint;
//参与任何优惠活动
@property (nonatomic, strong) LSEditItemRadio *rdoIsJoinActivity;

@property (nonatomic, strong) goodsBatchSaleSettingBack goodsBatchSaleSettingBack;

- (id)initWithIdList:(NSMutableArray*) idList fromView:(int) fromView;

-(void) loaddatas:(goodsBatchSaleSettingBack) callBack;

@end
