//
//  PurchasePaperEditView.h
//  retailapp
//
//  Created by hm on 15/10/31.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
@class PaperVo;

typedef void(^EditPurchasePaperHandler)(PaperVo* item , NSInteger action);

@class LSEditItemList,LSEditItemText,LSEditItemTitle;
@interface PurchasePaperEditView : LSRootViewController

@property (nonatomic,strong) UIView* headerView;
/**历史导入（调拨无）*/
@property (nonatomic,strong) LSEditItemList* lsHistory;
/**基本信息标题*/
@property (nonatomic,strong) LSEditItemTitle* baseTitle;
/**单号*/
@property (nonatomic,strong) LSEditItemText* txtPaperNo;
/**供应商*/
@property (nonatomic,strong) LSEditItemList* lsSupplier;
/**收货仓库*/
@property (nonatomic,strong) LSEditItemList* lsReceiveWarehouse;
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

@property (nonatomic,strong) UITableView* mainGrid;

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
/**唯一性*/
@property (nonatomic,copy) NSString *token;
@property (nonatomic,copy) NSString* recordType;
- (IBAction)addBtnClick:(id)sender;
- (IBAction)typeBtnClick:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
- (void)loadPaperId:(NSString*)paperId status:(short)billStatus paperType:(NSInteger)paperType action:(NSInteger)action recordType:(NSString *)recordType isEdit:(BOOL)isEdit callBack:(EditPurchasePaperHandler)callBack;
@end
