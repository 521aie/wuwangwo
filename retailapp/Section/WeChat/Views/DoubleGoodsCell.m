//
//  WeChatDoubleGoodsCell.m
//  retailapp
//
//  Created by diwangxie on 16/5/5.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "DoubleGoodsCell.h"
#import "UIImageView+SDAdd.h"

@implementation DoubleGoodsCell


-(void)initView:(NSString *) filePath  styleName:(NSString *) styleName styleCode:(NSString *) styleCode indexPathRow:(NSInteger) pathRow delegate:(id<DoubleGoodsCellDelegate>)delegate {
    self.delegate=delegate;
    [self.imgBox sd_setImageWithURL_Corner:[NSURL URLWithString:[NSString urlFilterRan:filePath]] placeholderImage:nil];
    self.lblStyleName.text=styleName;
    if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {
         self.lblStyleCode.text=[NSString stringWithFormat:@"款号:%@",styleCode];
    } else {
         self.lblStyleCode.text=[NSString stringWithFormat:@"%@",styleCode];
    }
   
    self.btnDel.tag=pathRow;
}
- (IBAction)deleteCell:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteCell:)]) {
        [self.delegate deleteCell:self];
    }
}


@end
