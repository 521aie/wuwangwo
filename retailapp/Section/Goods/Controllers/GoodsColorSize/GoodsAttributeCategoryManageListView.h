//
//  GoodsStyleCategoryManageListView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/8/11.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"

@class  AttributeVo;
typedef void(^goodsAttributeCategoryManageListBack) (AttributeVo* attributeVo, int fromViewTag);
@interface GoodsAttributeCategoryManageListView : LSRootViewController

@property (nonatomic, strong) AttributeVo* attributeVo;

@property (nonatomic, copy) goodsAttributeCategoryManageListBack goodsAttributeCategoryManageListBack;

//页面入口
- (void)loadData:(NSMutableArray*) categoryList attributeVo:(AttributeVo*)attributeVo callBack:(goodsAttributeCategoryManageListBack) callBack;

@end
