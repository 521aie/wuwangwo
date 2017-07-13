//
//  PackBoxEditView.h
//  retailapp
//
//  Created by hm on 15/10/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
@class PackGoodsVo;
typedef void(^PackBoxHandler)(PackGoodsVo *packGoodsVo, NSInteger action);

@class LSEditItemList,LSEditItemText,LSEditItemTitle;
@interface PackBoxEditView : LSRootViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>

@property (nonatomic,strong) UIView* headerView;
/**基本信息标题*/
@property (nonatomic,strong) LSEditItemTitle* baseTitle;
/**单号*/
@property (nonatomic,strong) LSEditItemText* txtPaperNo;
/**箱号*/
@property (nonatomic,strong) LSEditItemText* txtBoxNo;
/**日期*/
@property (nonatomic,strong) LSEditItemList* lsDate;
/**时间*/
@property (nonatomic,strong) LSEditItemList* lsTime;
/**备注 （收货无）*/
@property (nonatomic,strong) LSEditItemText* txtMemo;
/**商品列表标题*/
@property (nonatomic,strong) LSEditItemTitle* goodsTitle;

@property (nonatomic,weak) UITableView* mainGrid;

@property (nonatomic,weak) UIView* footerView;
@property (nonatomic,weak) UIView* addView;

/**导出*/
@property (nonatomic,weak) UIView* exportView;
@property (nonatomic,weak) UIButton* exportBtn;
/**删除*/
@property (nonatomic,weak) UIView* delView;
@property (nonatomic,weak) UIButton* delBtn;
/**合计*/
@property (nonatomic,weak) UIView* sumView;
/**总项数 价格*/
@property (nonatomic,weak) UILabel* lblAmount;

- (IBAction)onTypeEventClick:(id)sender;

- (void)loadDataById:(NSString *)paperId withAction:(NSInteger)action withEdit:(BOOL)isEidt callBack:(PackBoxHandler)handler;

@end
