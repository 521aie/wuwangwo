//
//  GoodsDetailEditView.h
//  retailapp
//
//  Created by hm on 15/7/29.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
@class LSEditItemList,LSEditItemText;
@class PaperDetailVo;
typedef void(^ChangeGoodsDetailHandler)(NSInteger action);

@interface GoodsDetailEditView : LSRootViewController<UIActionSheetDelegate>

@property (nonatomic,strong) UIScrollView* scrollView;
@property (nonatomic,strong) UIView* container;
@property (nonatomic,strong) UILabel* lblName;
@property (nonatomic,strong) LSEditItemText* txtInnerCode;
@property (nonatomic,strong) LSEditItemList* lsPrice;
@property (nonatomic,strong) LSEditItemText* txtStoreCount;
@property (nonatomic,strong) LSEditItemList* lsCount;
@property (nonatomic,strong) LSEditItemList* lsProductionDate;
@property (nonatomic,strong) LSEditItemList* lstAmount;
@property (nonatomic,strong) LSEditItemList* lsReason;
@property (nonatomic,strong) UIView * delBtn;
@property (nonatomic,assign) BOOL isThirdSupplier;

//设置页面参数及回调block
- (void)showGoodsDetail:(PaperDetailVo*)paperDetailVo paperType:(NSInteger)type isEdit:(BOOL)isEdit callBack:(ChangeGoodsDetailHandler)handler;
@end
