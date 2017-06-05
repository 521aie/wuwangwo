//
//  OrderPayListCell.h
//  RestApp
//
//  Created by 果汁 on 15/9/18.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderPayListData.h"
#import "LSOnlineReceiptVo.h"
#import "CopyFounctionLabel.h"
@interface OrderPayListCell : UITableViewCell <CopyFounctionLabelEvent>
@property (nonatomic, strong) IBOutlet UILabel *innerCode;
@property (nonatomic, strong) IBOutlet UILabel *payTime;
@property (nonatomic, strong) IBOutlet UILabel *payName;
@property (nonatomic, strong) IBOutlet UILabel *orIntoMyCount;
@property (nonatomic, strong) IBOutlet UILabel *intoCountMoney;
@property (weak, nonatomic) IBOutlet UILabel *mobile;
@property (weak, nonatomic) IBOutlet UILabel *orderName;
@property (weak, nonatomic) IBOutlet CopyFounctionLabel *orderId;
@property (weak, nonatomic) IBOutlet UILabel *payMen;
/**
 *  收入类型  充值收入 消费收入
 */
@property (weak, nonatomic) IBOutlet UILabel *lblCharge;
/**
 *
 *
 *  @param receiptVo 
 *  @param payType   是微信 2是支付宝
 */

- (void)initWithData:(LSOnlineReceiptVo *)receiptVo payType:(NSString *)payType;
@end
