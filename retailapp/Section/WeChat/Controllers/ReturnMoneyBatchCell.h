//
//  ReturnMoneyBatchCell.h
//  retailapp
//
//  Created by diwangxie on 16/4/21.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RetailSellReturnVo.h"

@interface ReturnMoneyBatchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblNo;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblMoney;
// 选中图标
@property (nonatomic, weak) IBOutlet UIImageView* imgCheck;
// 未选中图标
@property (nonatomic, weak) IBOutlet UIImageView* imgUnCheck;

- (void)initWithData:(RetailSellReturnVo *)sellReturnVo;
@end
