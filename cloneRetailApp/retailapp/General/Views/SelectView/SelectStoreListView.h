//
//  SelectStoreListView.h
//  retailapp
//
//  Created by hm on 16/1/14.
//  Copyright (c) 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "SelectSampleListView.h"
#import "INameCode.h"
typedef void(^StoreHandler)(id<INameCode> item);
@interface SelectStoreListView : SelectSampleListView
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
- (void)loadData:(NSString*)selectId withOrgId:(NSString *)orgId withIsSelf:(BOOL)isSelf callBack:(StoreHandler)storeHandele;
@end
