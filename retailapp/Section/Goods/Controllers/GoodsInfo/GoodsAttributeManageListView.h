//
//  GoodsBrandManageListView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/8/5.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
#import "GoodsBrandLibraryManageCell.h"

typedef void(^goodsAttributeManageListBack) (int fromViewTag);
@interface GoodsAttributeManageListView : LSRootViewController< GoodsBrandLibraryManageCellDelegate, UIActionSheetDelegate>

@property (nonatomic, copy) goodsAttributeManageListBack goodsAttributeManageListBack;

-(void)loadDatas:(int) fromViewTag callBack:(goodsAttributeManageListBack) callBack;

-(void)loadDatasFromEditView;

@end
