//
//  SelectShopListView.h
//  retailapp
//
//  Created by hm on 15/9/1.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SelectSampleListView.h"
#import "ITreeItem.h"
typedef NS_ENUM(NSInteger, VIEW_TYPE){
    CONTAIN_ALL,       //包含“全部”
    NOT_CONTAIN_ALL     //不包含“全部”
};

typedef void(^SelectShopList)(id<ITreeItem> shop);

@interface SelectShopListView : SelectSampleListView

//是否开通微店
@property (nonatomic) BOOL isMicroShop;
//是否查询直属下级门店
@property (nonatomic) BOOL isJunior;
@property (nonatomic,copy) SelectShopList selectShopBlock;

- (void)loadShopList:(NSString*)selectId withType:(NSInteger)type withViewType:(NSInteger)viewType withIsPush:(BOOL)isPush callBack:(SelectShopList)callBack;
@end
