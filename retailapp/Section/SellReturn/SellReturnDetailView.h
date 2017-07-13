//
//  SellReturnDetailView.h
//  retailapp
//
//  Created by Jianyong Duan on 15/11/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigateTitle2.h"
#import "ITreeItem.h"

@class RetailSellReturnVo;
@interface SellReturnDetailView : BaseViewController

typedef void(^SellReturnDetail)(id<ITreeItem> companion);

@property (nonatomic,copy) SellReturnDetail sellReturnDetailViewBlock;

- (void)loadSellReturnDetail:(NSInteger)viewType withIsPush:(BOOL)isPush callBack:(SellReturnDetail)callBack;
// input
//@property (nonatomic, copy) NSString *shopId;
//@property (nonatomic, copy) NSString *code;
//@property (nonatomic, copy) NSString *linkeMan;
//@property (nonatomic, copy) NSString * titleVal;
//@property (nonatomic ,strong) NSString *sellReturnId;/*<退货单id>*/
@property (nonatomic ,strong) NSString *shopSellReturnId;/*<连锁门店退货关联表ID>*/
//退货单一览
@property (nonatomic, strong) RetailSellReturnVo *sellReturn;

// outlet
@property (nonatomic,weak) IBOutlet UIView* titleDiv;
@property (nonatomic,weak) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *viewOper;
@property (weak, nonatomic) IBOutlet UIButton *btnRed;
@property (weak, nonatomic) IBOutlet UIButton *btnGreen;
@property (nonatomic, strong) NavigateTitle2* titleBox;

- (IBAction)sellReturnDealClick:(UIButton *)sender;
@end
