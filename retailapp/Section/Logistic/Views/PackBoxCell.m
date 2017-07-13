//
//  PackBoxCell.m
//  retailapp
//
//  Created by hm on 15/10/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "PackBoxCell.h"
#import "DateUtils.h"
#import "ExportListProtocol.h"

@implementation PackBoxCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.checkPic.hidden = !selected;
    self.uncheckPic.hidden = selected;
}

//- (void)fillPackBox:(id<ExportListProtocol>)obj {
//    
//    id<ExportListProtocol> item = obj;
//    self.lblDate.text = [NSString stringWithFormat:@"调拨日期:%@" ,[DateUtils formateTime2:[item getBillDate]]];
//    self.lblDetail.text = [NSString stringWithFormat:@"单号:%@" ,[item getBillNum]];
//    self.lblPaperNo.text = [item getName];
//    self.lblStatus.text = [item getStatus];
//}

@end
