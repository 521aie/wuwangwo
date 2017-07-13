//
//  GoodsCommentDetialCell.m
//  retailapp
//
//  Created by Jianyong Duan on 15/11/19.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GoodsCommentDetialCell.h"
#import "NSString+Estimate.h"

@implementation GoodsCommentDetialCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [UIColor colorWithRed:198.0/255.0 green:194.0/255.0 blue:191.0/255.0 alpha:1.0].CGColor;
}

- (void)dataWithGoodsComment:(GoodsCommentVo *)commentVo {
    
    self.lblTime.text = commentVo.commentTime;
    
    NSInteger level = [commentVo.commentLevel integerValue];
    if (level == 1) {
        self.imageViewType.image = [UIImage imageNamed:@"ico_comment_good"];
    } else if (level == 2) {
        self.imageViewType.image = [UIImage imageNamed:@"ico_comment_medium"];
    } else {
        self.imageViewType.image = [UIImage imageNamed:@"ico_comment_bad"];
    }
    self.lblName.text = [NSString stringWithFormat:@"%@(%@)", commentVo.customerName, commentVo.customerTel];
    // 颜色： 尺码：
    self.lblColorSize.text = commentVo.skuInfo;
    
    //评论内容
    if ([commentVo.comment respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:commentVo.comment];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        [paragraphStyle setLineSpacing:5];
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [commentVo.comment length])];
        self.lblContent.attributedText = attributedString;
        
    } else {
        self.lblContent.text = commentVo.comment;
    }
}

+ (CGFloat)heightForContent:(NSString *)content {
    CGFloat _h = 0;
    if ([content respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        [paragraphStyle setLineSpacing:5];
        //        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12], NSParagraphStyleAttributeName:paragraphStyle.copy};
        
        CGRect rect = [content boundingRectWithSize:CGSizeMake(274, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        _h = MAX(rect.size.height + 26, 44);
    } else {
        CGSize size = [NSString getTextSizeWithText:content font:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(274, MAXFLOAT)];
        _h = MAX(size.height + 26, 44);
    }
    
    return _h + 100;
}

@end
