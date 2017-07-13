//
//  LSCostAdjustListCell.m
//  retailapp
//
//  Created by guozhi on 2017/3/22.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSCostAdjustListCell.h"
#import "DateUtils.h"
@interface LSCostAdjustListCell()
/** 操作人 */
@property (weak, nonatomic) IBOutlet UILabel *lblName;
/** 单号 */
@property (weak, nonatomic) IBOutlet UILabel *lblNo;
/** 单据状态 */
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
/** 调整日期 */
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@end
@implementation LSCostAdjustListCell

+ (instancetype)costAdjustListCellWithTableView:(UITableView *)tableView {
    static NSString *cellIdentifier = @"cell";
    LSCostAdjustListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
    }
    return cell;
}

- (void)setObj:(LSCostAdjustVo *)obj {
    _obj = obj;
//    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];
//    NSString *nameStr = [NSString stringWithFormat:@"%@ ",obj.opName];
//    NSMutableAttributedString *attrNameString = [[NSMutableAttributedString alloc] initWithString:nameStr];
//    [attrNameString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,nameStr.length-1)];
//    [attrString appendAttributedString:attrNameString];
//    NSString *staffStr = [NSString stringWithFormat:@"(工号:%@)",obj.opStaffId];
//    NSMutableAttributedString *attrStaffStr = [[NSMutableAttributedString alloc] initWithString:staffStr];
//    [attrStaffStr addAttribute:NSForegroundColorAttributeName value:[ColorHelper getTipColor6] range:NSMakeRange(0,staffStr.length)];
//    [attrStaffStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:13.0] range:NSMakeRange(0,staffStr.length)];
//    [attrString appendAttributedString:attrStaffStr];
//    self.lblName.attributedText = attrString;
    self.lblName.text = [NSString stringWithFormat:@"%@(工号:%@)", obj.opName, obj.opStaffId];
    self.lblNo.text = [NSString stringWithFormat:@"单号:%@", obj.costPriceOpNo];
    self.lblStatus.text = obj.billStatusName;
    self.lblStatus.textColor = obj.billStatusColor;
    
    self.lblDate.text = [NSString stringWithFormat:@"操作日期:%@",[DateUtils formateTime2:obj.createTime.longLongValue]];
   

    
}
@end
