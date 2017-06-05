//
//  PackBoxBatchListView.h
//  retailapp
//
//  Created by hm on 15/10/26.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
#import "LSFooterView.h"
typedef NS_ENUM(NSInteger, OP_TYPE){
    EXPORT,       //导出
    DELETE        //删除
};

typedef void(^BatchHandler)(void);

@interface PackBoxBatchListView : LSRootViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>

@property (nonatomic, strong) UITableView *mainGrid;

@property (nonatomic, strong) LSFooterView *footView;


//传入装箱单列表和状态列表
- (void)loadDataWithList:(NSMutableArray *)dataList withType:(OP_TYPE)opType withReturnGoodsId:(NSString *)returnGoodsId;
- (void)batchCallBack:(BatchHandler)handler;
- (void)initConditionByStatus:(NSString *)statusName withStatusVal:(NSString *)statusVal withDate:(NSString *)date;
@end
