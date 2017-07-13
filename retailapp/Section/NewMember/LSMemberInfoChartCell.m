//
//  LSMemberInfoChartCell.m
//  retailapp
//
//  Created by taihangju on 2016/10/18.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberInfoChartCell.h"

@interface LSMemberInfoChartCell()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight; // 新增会员高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeight; // 老会员高度
@end

@implementation LSMemberInfoChartCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected {
    
    if (selected) {
        self.pointLabel.textColor = [UIColor redColor];
        self.bottomLabel.backgroundColor = [UIColor whiteColor];
    }
    else {
        self.pointLabel.textColor = [UIColor lightTextColor];
        self.bottomLabel.backgroundColor = [UIColor lightTextColor];
    }
}

- (void)fill:(NSNumber *)maxMemberNum oldMemberNum:(NSNumber *)oldNum newMemberNum:(NSNumber *)newNum {
    CGFloat height = CGRectGetHeight(self.bounds) - 23.0; // 23 是除去用于显示统计条高度以外的高度
    if (maxMemberNum.floatValue > 0) {
        [self.bottomHeight setConstant:oldNum.floatValue/maxMemberNum.floatValue*0.5*height];
        [self.topHeight setConstant:newNum.floatValue/maxMemberNum.floatValue*0.5*height];
    }
    else {
        // 最大值为零，说明新增和老会员都为0
        [self.bottomHeight setConstant:0];
        [self.topHeight setConstant:0];
    }
}
@end
