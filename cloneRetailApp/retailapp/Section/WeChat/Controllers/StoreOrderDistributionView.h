//
//  StoreOrderDistributionView.h
//  retailapp
//
//  Created by Jianyong Duan on 15/12/11.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditItemList.h"
#import "EditItemText.h"
#import "EditItemText2.h"
#import "NavigateTitle2.h"

typedef void(^ConfirmOrderBack)(NSDictionary *expansion);

@interface StoreOrderDistributionView : BaseViewController

@property (nonatomic, strong) ConfirmOrderBack confirmOrderBack;

@property (nonatomic, retain) IBOutlet UIView *titleDiv;
@property (nonatomic) NavigateTitle2 *titleBox;

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *mainContainer;
@property (nonatomic, strong) IBOutlet NSMutableDictionary*expansionDic;

//配送类型
@property (nonatomic, weak) IBOutlet EditItemList *lsMode;
//配送员
@property (nonatomic, weak) IBOutlet EditItemList *txtMember;
//快递公司
@property (nonatomic, weak) IBOutlet EditItemList *lsExpress;
//快递公司（其他）
@property (nonatomic, weak) IBOutlet EditItemText *txtOther;
//快递单号
@property (nonatomic, weak) IBOutlet EditItemText2 *txtNumber;
//扫一扫
//配送费(元)
@property (weak, nonatomic) IBOutlet EditItemList *lstOutFee;
/**积分兑换管理详情需要 防止扩展字段expression里面的值被冲掉*/
@property (nonatomic, copy) NSString *consume_points;

@end
