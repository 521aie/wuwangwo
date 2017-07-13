//
//  KindPayEditView.h
//  retailapp
//
//  Created by 果汁 on 15/9/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
#import "IEditItemListEvent.h"
#import "OptionPickerClient.h"
#import "FooterListEvent.h"

@class LSEditItemList,LSEditItemRadio,LSEditItemText,LSEditItemView,PaymentVo,SettingService;
@interface KindPayEditView : LSRootViewController<IEditItemListEvent,OptionPickerClient,FooterListEvent,UIActionSheetDelegate,UIAlertViewDelegate>
{
    SettingService *service;//网络请求
}
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *container;
/**支付方式类型添加*/
@property (strong, nonatomic) LSEditItemList *lstKind;
/** 收入计入销售额 */
@property (strong, nonatomic) LSEditItemView *vewSale;
@property (strong, nonatomic) LSEditItemRadio *rdoSale;
@property (strong, nonatomic) UILabel *lblNote;

/**支付方式名称*/
@property (strong, nonatomic) LSEditItemText *txtName;
/**支付完成后自动打开钱箱*/
@property (strong, nonatomic) LSEditItemRadio *rdoCashBox;
/**删除按钮*/
@property (strong, nonatomic) UIView *btnDel;
/**状态 添加还是编辑*/
@property (nonatomic, assign) int action;
/**支付详情页面数据*/
@property (nonatomic, strong) PaymentVo *paymentVo;
/**状态 添加还是编辑*/
@property (nonatomic, strong) NSMutableArray *payList;
/**支付方式最后一个时报提示*/
@property (nonatomic, assign) NSUInteger count;
/**创建支付方式编辑添加页面*/
- (instancetype)initWithAction:(int)action paymentVo:(PaymentVo *)paymentVo payList:(NSMutableArray *)payList;

@end
