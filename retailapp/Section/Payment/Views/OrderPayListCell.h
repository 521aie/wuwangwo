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

- (void)initWithData:(LSOnlineReceiptVo *)receiptVo payType:(NSString *)payType;
@property (nonatomic, strong) UILabel *innerCode;
@end
