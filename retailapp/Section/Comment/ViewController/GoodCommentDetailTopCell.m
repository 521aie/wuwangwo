//
//  GoodCommentDetailTopTableViewCell.m
//  retailapp
//
//  Created by 小龙虾 on 2017/4/20.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "GoodCommentDetailTopCell.h"
#import "GoodsCommentReportVo.h"

@implementation GoodCommentDetailTopCell

-(void)upDataWithModel:(GoodsCommentReportVo *)model
{
    [self.imgPic sd_setImageWithURL:[NSURL URLWithString:model.picPath] placeholderImage:[UIImage imageNamed:@"img_default"]];
    self.lblGoodsName.text = model.goodsName;
    self.lblStyle.text = [NSString stringWithFormat:@"%@",model.goodsCode];
    self.lblGoodComment.text = model.feedbackRate;
    self.lblTotal.text = [NSString stringWithFormat:@"（%ld个评价）", model.totalCount];
    self.lblFeedback.text= [NSString stringWithFormat:@"%.2f%%",(double) model.goodCount/(double)( model.goodCount+ model.mediumCount+ model.badCount)*100.00];
    // 好评
    self.lblGoodComment.text = [NSString stringWithFormat:@"%ld个好评，",  model.goodCount];
    
    // 中评
    self.lblMediumComment.text = [NSString stringWithFormat:@"%ld个中评，",  model.mediumCount];
    
    
    // 差评
    self.lblBadComment.text = [NSString stringWithFormat:@"%ld个差评",  model.badCount];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
