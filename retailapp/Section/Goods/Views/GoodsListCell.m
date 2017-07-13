//
//  GoodsListCell.m
//  retailapp
//
//  Created by zhangzhiliang on 15/7/28.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GoodsListCell.h"
#import "GoodsVo.h"

@implementation GoodsListCell
+ (instancetype)goodsListCellWithTableView:(UITableView *)tableView {
    static NSString *cellIdentifier = @"cell";
    GoodsListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

- (void)setGoodsVo:(GoodsVo *)goodsVo {
    _goodsVo = goodsVo;

    //创建富文本
    NSString *goodsName = _goodsVo.goodsName;
    if (goodsVo.upDownStatus == 2) {
        goodsName = [NSString stringWithFormat:@"  %@", _goodsVo.goodsName];
    }
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:goodsName];
    if (goodsVo.upDownStatus == 2) {//商品已下架
        //NSTextAttachment可以将要插入的图片作为特殊字符处理
        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
        //定义图片内容及位置和大小
        attch.image = [UIImage imageNamed:@"ico_alreadyOffShelf"];
        attch.bounds = CGRectMake(0, 0, 40, 15);
        //创建带有图片的富文本
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithAttributedString: [NSAttributedString attributedStringWithAttachment:attch]];
        //将图片放在最后一位
        //[attri appendAttributedString:string];
        [string addAttribute:NSBaselineOffsetAttributeName value:@-2 range:NSMakeRange(0, string.length)];
        //将图片放在第一位
        [attri insertAttributedString:string atIndex:0];
        //用label的attributedText属性来使用富文本
    }
    self.lblName.attributedText = attri;
    self.lblCode.text = goodsVo.barCode;
    [self.lblCode setTextColor:[ColorHelper getTipColor6]];
    self.lblPrice.text = [NSString stringWithFormat:@"￥%.2f", goodsVo.retailPrice];
    [self.lblPrice setTextColor:[ColorHelper getRedColor]];
    //暂无图片
    UIImage* placeholder = [UIImage imageNamed:@"img_default.png"];
    if (goodsVo.image) {
        [self.img.layer setMasksToBounds:YES];
        [self.img.layer setCornerRadius:PANEL_OUTTER_CORNER_RADIUS];
        self.img.image = goodsVo.image;
    } else {
        [self.img.layer setMasksToBounds:YES];
        
        [self.img.layer setCornerRadius:PANEL_OUTTER_CORNER_RADIUS];
        
        NSURL* url = [NSURL URLWithString:[NSString urlFilterRan:goodsVo.filePath]];
        
        [self.img sd_setImageWithURL:url placeholderImage:placeholder];
    }
    [self layoutIfNeeded];
    _goodsVo.cellHeight = self.line.ls_bottom;
}
@end

