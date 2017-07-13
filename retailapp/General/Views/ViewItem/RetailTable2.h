//
//  RetailTable2.h
//  retailapp
//
//  Created by zhangzhiliang on 15/8/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISampleListEvent.h"

@interface RetailTable2 : UIView<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,ISampleListEvent,UIActionSheetDelegate>
@property (nonatomic, strong) IBOutlet UIView *view;
@property (nonatomic, strong) IBOutlet UITableView *mainGrid;  //表格
@property (nonatomic, strong) IBOutlet UIView *footView;  //页脚
@property (nonatomic, strong) IBOutlet UILabel* lblName;
@property (nonatomic, strong) IBOutlet UIButton* addBtn;
@property (nonatomic, strong) id<ISampleListEvent> delegate;
@property (nonatomic, strong) id<INameValueItem> currObj;
@property (nonatomic, strong) NSString* kindName;
@property (nonatomic, strong) NSString* addName;
@property (nonatomic, strong) NSMutableArray *dataList;    //商品.
@property (nonatomic, strong) NSString* event;
@property (nonatomic) NSUInteger detailCount;
@property (nonatomic) int viewTag;

@property (nonatomic, strong) NSString* isCanDeal; // 营销可否操作字段

- (void)initDelegate:(id<ISampleListEvent>)delegate event:(NSString*)event kindName:(NSString*)kindName addName:(NSString*)addName;

- (void)loadData:(NSMutableArray*)dataList  detailCount:(NSUInteger)detailCount;

- (IBAction)btnAddClick:(id)sender;

- (void)visibal:(BOOL)show;

@end
