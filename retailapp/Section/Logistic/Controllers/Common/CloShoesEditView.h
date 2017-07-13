//
//  CloShoesEditView.h
//  retailapp
//
//  Created by hm on 15/10/30.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"

typedef void(^EditHandler)(void);

@class SearchBar2;
@interface CloShoesEditView : LSRootViewController<UITextFieldDelegate,UIActionSheetDelegate>


@property (nonatomic, strong) SearchBar2 *searchBox;

@property (nonatomic, strong) UIScrollView *scrollView;

/**是否启用装箱单*/
@property (nonatomic, assign) BOOL isOpenPackBox;
/**p 收货 o 配送*/
@property (nonatomic, copy) NSString *recordType;
/**门店shopId*/
@property (nonatomic, copy) NSString *shopId;
/**调入门店id*/
@property (nonatomic, copy) NSString *inShopId;
/**供应商id（叫货验证用）*/
@property (nonatomic, copy) NSString *supplyId;
/**是否第三方供应商*/
@property (nonatomic, assign) BOOL isThirdSupply;
/**物流记录必传*/
@property (nonatomic, assign) double goodsPrice;

//设置页面参数及回调block
- (void)loadDataWithCode:(NSString *)styleCode withParam:(NSMutableDictionary *)param withSourceId:(NSString *)sourceId withAction:(NSInteger)action withType:(NSInteger)paperType withEdit:(BOOL)isEdit callBack:(EditHandler)handler;

@end
