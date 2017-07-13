//
//  GoodsSalePackManageEditView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/8/17.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigateTitle2.h"
#import "IEditItemListEvent.h"
#import "OptionPickerClient.h"
#import "DatePickerBox.h"
#import "ISampleListEvent.h"
#import "GoodsSalePackManageEditCell.h"

@class GoodsModule,  SalePackVo;
@class EditItemText, EditItemList, ItemTitle;
@interface WechatSalePackManageEditView : BaseViewController<INavigateEvent, OptionPickerClient, IEditItemListEvent, ISampleListEvent,UIActionSheetDelegate>

@property (nonatomic, retain) IBOutlet UIView *titleDiv;
@property (nonatomic, strong) NavigateTitle2 *titleBox;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *container;

//销售包名称
@property (nonatomic, strong) IBOutlet EditItemText *txtSalePackName;
//销售包编号
@property (nonatomic, strong) IBOutlet EditItemText *txtSalePackCode;
//年度
@property (nonatomic, strong) IBOutlet EditItemList *lsYear;
//款式信息
@property (nonatomic, strong) IBOutlet EditItemList *lsStyleInfo;

@property (nonatomic, strong) IBOutlet UIButton *btnDel;

@property (nonatomic, retain) NSMutableArray *datas;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil action:(int) action salePackId:(NSString*) salePackId;

//-(void) loaddatas:(SalePackVo*) salePackVoTemp action:(int) action ;

-(void) loaddatasFromStyleListView;

@end
