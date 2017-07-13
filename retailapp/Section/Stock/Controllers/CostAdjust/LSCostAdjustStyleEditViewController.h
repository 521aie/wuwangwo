//
//  LSCostAdjustStyleEditViewController.h
//  retailapp
//
//  Created by guozhi on 2017/4/11.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
typedef void(^StyleDetailCallBlock)();
@class SearchBar2, LSCostAdjustVo, LSCostAdjustDetailVo;
@interface LSCostAdjustStyleEditViewController : LSRootViewController<UITextFieldDelegate,UIActionSheetDelegate>
@property (nonatomic, strong) SearchBar2 *searchBar;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) long long adjustTime;

//备注
@property (nonatomic, copy) NSString *memo;
//页面模式
@property (nonatomic, assign) NSInteger action;
//页面是否可编辑
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, assign) double price;
/**  */
@property (nonatomic, strong) NSNumber *shopType;
//调整单状态
@property (nonatomic, assign) short billStatus;

- (instancetype)initWithShopId:(NSString *)shopId obj:(LSCostAdjustVo *)obj  costAdjustDetailVo:(LSCostAdjustDetailVo *)costAdjustDetailVo action:(int)action isEdit:(BOOL)isEdit callBlock:(StyleDetailCallBlock)callBlock;

@end
