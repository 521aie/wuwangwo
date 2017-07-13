//
//  WeChatAccountInfoCell2.m
//  retailapp
//
//  Created by diwangxie on 16/4/25.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "AccountInfoCell.h"

@implementation AccountInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//-(void)initView{
//    CGSize nameSize = [NSString sizeWithText:orderInfo.receiverName maxSize:CGSizeMake(MAXFLOAT, 100) font:[UIFont systemFontOfSize:18]];
//    CGSize mobileSize = [NSString sizeWithText:orderInfo.mobile maxSize:CGSizeMake(MAXFLOAT, 100) font:[UIFont systemFontOfSize:13]];
//    CGFloat w = nameSize.width + mobileSize.width+20;
//}
@end
