//
//  AllocatePaperEditView.h
//  retailapp
//
//  Created by hm on 15/10/31.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
@class PaperVo;

typedef void(^EditAllocatePaperHandler)(PaperVo* item , NSInteger action);

@class LSEditItemList,LSEditItemText,LSEditItemTitle;
@interface AllocatePaperEditView : LSRootViewController

@property (nonatomic,strong) UIView* headerView;

/**基本信息标题*/
@property (nonatomic,strong) LSEditItemTitle* baseTitle;
/**单号*/
@property (nonatomic,strong) LSEditItemText* txtPaperNo;
/**调出门店*/
@property (nonatomic,strong) LSEditItemList* lsOutShop;
/**调入门店*/
@property (nonatomic,strong) LSEditItemList* lsInShop;
/**日期*/
@property (nonatomic,strong) LSEditItemList* lsDate;
/**时间*/
@property (nonatomic,strong) LSEditItemList* lsTime;
/**备注*/
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
/**确认收货 拒绝收货*/
@property (nonatomic,weak) IBOutlet UIView* crView;
@property (nonatomic,weak) IBOutlet UIButton* comfirmBtn;
@property (nonatomic,weak) IBOutlet UIButton* refuseBtn;
/**确认调拨 拒绝调拨*/
@property (nonatomic,weak) IBOutlet UIView* alView;
@property (nonatomic,weak) IBOutlet UIButton* comAlBtn;
@property (nonatomic,weak) IBOutlet UIButton* refAlBtn;
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

- (IBAction)addBtnClick:(id)sender;
- (IBAction)typeBtnClick:(id)sender;

- (void)loadPaperId:(NSString*)paperId status:(short)billStatus paperType:(NSInteger)paperType action:(NSInteger)action isEdit:(BOOL)isEdit callBack:(EditAllocatePaperHandler)callBack;
@end
