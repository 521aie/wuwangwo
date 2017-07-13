//
//  GoodsCommentCell.m
//  retailapp
//
//  Created by Jianyong Duan on 15/11/4.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GoodsCommentCell.h"

@implementation GoodsCommentCell


- (void)initWithReport:(GoodsCommentReportVo *)reportVo {
    
    [self.imageViewPic sd_setImageWithURL:[NSURL URLWithString:reportVo.picPath] placeholderImage:[UIImage imageNamed:@"img_default"]];
    self.lblGoodsname.text = reportVo.goodsName;
    self.lblCOde.text = reportVo.goodsCode;
    self.lblFeedback.text = reportVo.feedbackRate;
    self.lblCount.text = [NSString stringWithFormat:@"（%ld个评价）", reportVo.totalCount];
}

@end
