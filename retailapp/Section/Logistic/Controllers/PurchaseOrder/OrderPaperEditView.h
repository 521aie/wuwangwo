//
//  OrderPaperEditView.h
//  retailapp
//
//  Created by hm on 15/10/30.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"

@class PaperVo;

typedef void(^EditOrderPaperHandler)(PaperVo* item , NSInteger action);

@class LSEditItemList,LSEditItemText,LSEditItemTitle;
@interface OrderPaperEditView : LSRootViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UIView* headerView;
/**历史导入（调拨无）*/
@property (nonatomic,strong) LSEditItemList* lsHistory;
/**基本信息标题*/
@property (nonatomic,strong) LSEditItemTitle* baseTitle;
/**单号*/
@property (nonatomic,strong) LSEditItemText* txtPaperNo;
/**机构/门店*/
@property (nonatomic,strong) LSEditItemList* lsOrgShop;
/**供应商*/
@property (nonatomic,strong) LSEditItemList* lsSupplier;
/**收货仓库*/
@property (nonatomic,strong) LSEditItemList* lsReceiveWarehouse;
/**发货仓库*/
@property (nonatomic,strong) LSEditItemList* lsDeliveWarehouse;
/**日期*/
@property (nonatomic,strong) LSEditItemList* lsDate;
/**时间*/
@property (nonatomic,strong) LSEditItemList* lsTime;
/**备注 （收货无）*/
@property (nonatomic,strong) LSEditItemText* txtMemo;
/**商品列表标题*/
@property (nonatomic,strong) LSEditItemTitle* goodsTitle;
/**显示模式*/
@property (nonatomic,strong) LSEditItemList* lsMode;

@property (nonatomic,weak) IBOutlet UITableView* mainGrid;

@property (nonatomic,weak) IBOutlet UIView* footerView;
@property (nonatomic,weak) IBOutlet UIView* addView;
/**添加名称*/
@property (nonatomic,weak) IBOutlet UILabel* lblName;
/**确认 拒绝*/
@property (nonatomic,weak) IBOutlet UIView* crView;
@property (nonatomic,weak) IBOutlet UIButton* comfirmBtn;
@property (nonatomic,weak) IBOutlet UIButton* refuseBtn;
/**提交*/
@property (nonatomic,weak) IBOutlet UIView* subView;
@property (nonatomic,weak) IBOutlet UIButton* subBtn;
/**删除*/
@property (nonatomic,weak) IBOutlet UIView* delView;
@property (nonatomic,weak) IBOutlet UIButton* delBtn;
/**合计*/
@property (nonatomic,weak) IBOutlet UIView* sumView;
/**总项数 价格*/
@property (nonatomic,weak) IBOutlet UILabel* lblAmount;
@property (nonatomic,copy) NSString* recordType;
- (IBAction)addBtnClick:(id)sender;
- (IBAction)typeBtnClick:(id)sender;

//设置页面参数及回调block
- (void)loadPaperId:(NSString*)paperId status:(short)billStatus paperType:(NSInteger)paperType action:(NSInteger)action isEdit:(BOOL)isEdit callBack:(EditOrderPaperHandler)callBack;
@end
