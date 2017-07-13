//
//  UnitInfoViewController.h
//  retailapp
//
//  Created by guozhi on 16/7/16.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
@class LSGoodsUnitVo;
@protocol UnitInfoViewDelegate;
@interface UnitInfoViewController : LSRootViewController
@property (nonatomic, weak) id<UnitInfoViewDelegate> delegate;
- (void)loadData;
@end

@protocol UnitInfoViewDelegate <NSObject>
- (void)unitInfoViewClickDeleted:(LSGoodsUnitVo *)goodsUnit;
- (void)unitInfoViewClickClosedBtn;
@end

