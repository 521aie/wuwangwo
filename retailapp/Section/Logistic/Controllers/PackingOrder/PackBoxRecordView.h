//
//  PackBoxRecordView.h
//  retailapp
//
//  Created by hm on 15/11/3.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"

typedef void(^CheckRecordHandler)(void);

@interface PackBoxRecordView : LSRootViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
@property (nonatomic, strong) UIView *styleView;
@property (nonatomic, strong) UITableView *mainGrid;
@property (nonatomic,copy) NSString *styleName;
@property (nonatomic,copy) NSString *styleCode;
@property (nonatomic,strong) NSNumber *hangTagPrice;
@property (nonatomic,copy) NSString *filePath;
@property (nonatomic,assign) BOOL changePrice;
@property (nonatomic,copy) NSString *priceName;
@property (nonatomic,assign) double price;
//设置页面参数及回调block
- (void)loadDataWithEdit:(BOOL)isEdit withStyleId:(NSString *)styleId withReturnId:(NSString *)returnId callBack:(CheckRecordHandler)handler;

@end
