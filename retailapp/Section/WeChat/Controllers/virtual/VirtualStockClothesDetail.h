//
//  StockQueryView.h
//  retailapp
//
//  Created by guozhi on 15/9/8.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IEditItemListEvent.h"
#import "SymbolNumberInputBox.h"
#import "FooterListEvent.h"
#import "ISearchBarEvent.h"
#import "SkcStyleVo.h"
#import "NavigateTitle2.h"

@class NavigateTitle2,StockModule,EditItemView,EditItemList,StockService,SearchBar2,StockInfoVo,FooterListView4;
@interface VirtualStockClothesDetail : BaseViewController <INavigateEvent,SymbolNumberInputClient,FooterListEvent,ISearchBarEvent,UITextFieldDelegate,UIAlertViewDelegate> {
    StockService *service;
}
@property (nonatomic, weak) IBOutlet UIView* titleDiv;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NavigateTitle2* titleBox;
@property (nonatomic, strong) NSMutableDictionary *param;
@property (weak, nonatomic) IBOutlet SearchBar2 *searchBar;
@property (nonatomic, strong) StockInfoVo *stockInfoVo;
@property (nonatomic, copy) NSString *styleCode;
@property (weak, nonatomic) IBOutlet FooterListView4 *footView;
/**款式vo*/
@property (nonatomic, strong) SkcStyleVo *skcStyleVo;
/**款色vo列表*/
@property (nonatomic, strong) NSArray *skcList;
/**尺码名称列表*/
@property (nonatomic, strong) NSArray *sizeNameList;
/**款色尺码列表*/
@property (nonatomic, strong) NSArray *skcSizeList;
/**是否编辑标识位*/
@property (nonatomic, assign) BOOL isChange;
/**判断是添加模式还是编辑模式*/
@property (nonatomic, assign) int action;
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, assign) int actionInit;
/**临时 UITextField*/
@property (nonatomic, strong) UITextField *txtField;
/**是否保存并继续添加*/
@property (nonatomic, assign) BOOL isContinue;
/**是否删除*/
@property (nonatomic, assign) BOOL isDel;
@property (nonatomic, copy) NSString *shopId;
@property (nonatomic, copy) NSString *val;
/**选择全部供货价 总金额不显示*/
@property (nonatomic, assign) BOOL isSelectAll;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil param:(NSMutableDictionary *)param stockInfoVo:(StockInfoVo *)stockInfoVo shopId:(NSString *)shopId action:(int)action edit:(BOOL)isEdit;
- (void)loadDataWithStyleId:(NSString *)styleId;
@end
