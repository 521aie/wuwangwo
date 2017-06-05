//
//  LSStockAdjustListCell.m
//  retailapp
//
//  Created by guozhi on 2017/3/22.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSStockAdjustListCell.h"
#import "DateUtils.h"
@interface LSStockAdjustListCell()
/** 操作人 */
@property (weak, nonatomic) IBOutlet UILabel *lblName;
/** 单号 */
@property (weak, nonatomic) IBOutlet UILabel *lblNo;
/** 单据状态 */
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
/** 调整日期 */
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@end
@implementation LSStockAdjustListCell

+ (instancetype)stockAdjustListCellWithTableView:(UITableView *)tableView {
    static NSString *cellIdentifier = @"cell";
    LSStockAdjustListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
    }
    return cell;
}

- (void)setObj:(StockAdjustVo *)obj statusList:(NSArray *)statusList {
    _obj = obj;
//    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];
//    NSString *nameStr = [NSString stringWithFormat:@"%@ ",obj.opName];
//    NSMutableAttributedString *attrNameString = [[NSMutableAttributedString alloc] initWithString:nameStr];
//    [attrNameString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,nameStr.length-1)];
//    [attrString appendAttributedString:attrNameString];
//    NSString *staffStr = [NSString stringWithFormat:@"(工号:%@)",obj.opStaffid];
//    NSMutableAttributedString *attrStaffStr = [[NSMutableAttributedString alloc] initWithString:staffStr];
//    [attrStaffStr addAttribute:NSForegroundColorAttributeName value:[ColorHelper getTipColor6] range:NSMakeRange(0,staffStr.length)];
//    [attrStaffStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:13.0] range:NSMakeRange(0,staffStr.length)];
//    [attrString appendAttributedString:attrStaffStr];
//    self.lblName.attributedText = attrString;
//    
    self.lblName.text = [NSString stringWithFormat:@"%@(工号:%@)", obj.opName, obj.opStaffid];
    self.lblNo.text = [NSString stringWithFormat:@"单号:%@", obj.adjustCode];
    self.lblStatus.text = [GlobalRender obtainItem:statusList itemId:[NSString stringWithFormat:@"%ld",obj.billStatus]];
    self.lblDate.text = [NSString stringWithFormat:@"调整日期:%@",[DateUtils formateTime2:obj.createTime]];
    if (obj.billStatus == 1) {
        self.lblStatus.textColor = [ColorHelper getBlueColor];
    } else if (obj.billStatus == 2) {
        self.lblStatus.textColor = [ColorHelper getGreenColor];
    } else if (obj.billStatus == 3) {
        self.lblStatus.textColor = [ColorHelper getTipColor6];
    } else{
        self.lblStatus.textColor = [ColorHelper getRedColor];
    }

}

@end
