//
//  LSSystemNotificationCell.m
//  retailapp
//
//  Created by guozhi on 16/10/10.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSSystemNotificationCell.h"
#import "DateUtils.h"

@implementation LSSystemNotificationCell
+ (instancetype)systemNotificationCellWithTableView:(UITableView *)tableView {
    static NSString *cellIdentifier = @"cell";
    LSSystemNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)setNoticeVo:(LSNoticeVo *)noticeVo {
    _noticeVo = noticeVo;
    if (_noticeVo.businessType == 1) {//一键上架
        self.imgIcon.image = [UIImage imageNamed:@"icon_one_up"];
    }else if (_noticeVo.businessType == 42){//数据清理通知
        self.imgIcon.image = [UIImage imageNamed:@"icon_data"];
    }
    else {//导出
        self.imgIcon.image = [UIImage imageNamed:@"icon_export"];
    }
    self.lblNotificationName.text = noticeVo.noticeTitle;
    self.lblNotificationTime.text = [DateUtils formateTime4:noticeVo.publishTime];
    CGSize size =  [NSString sizeWithText:noticeVo.noticeContent maxSize:CGSizeMake(220, MAXFLOAT) font:self.lblNotificationContext.font];
    self.lblNotificationContext.text = noticeVo.noticeContent;
    self.lblNotificationContext.ls_size = size;
    if (noticeVo.isJump == 1) {//需要跳转
        self.imgNext.hidden = NO;
    } else {
        self.imgNext.hidden = YES;
    }
}

@end
