//
//  SelectGoodsCell.m
//  retailapp
//
//  Created by zhangzhiliang on 16/3/3.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "CommonGoodsSelectCell.h"
#import "UIImageView+SDAdd.h"
#import "GoodsVo.h"
#import "GoodsOperationVo.h"

@interface CommonGoodsSelectCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLineHeight;
@end

@implementation CommonGoodsSelectCell

+ (instancetype)commonGoodsSelectCellWith:(UITableView *)tableView {
    CommonGoodsSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonGoodsSelectCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"CommonGoodsSelectCell" owner:nil options:nil].lastObject;
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [_lblPrice setTextColor:[ColorHelper getTipColor6]];
    [_img ls_addCornerWithRadii:6 roundRect:_img.bounds];
    [_bottomLineHeight setConstant:(1.0f/[UIScreen mainScreen].scale)];
}


- (void)fillGoodVo:(GoodsVo *)vo {
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    if (vo.upDownStatus == 2) {
        //已下架的标志显示出来
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
        textAttachment.image = [UIImage imageNamed:@"ico_alreadyOffShelf"];
        textAttachment.bounds = CGRectMake(0, 0, 40, 15);
        NSAttributedString *offShelf = [NSAttributedString attributedStringWithAttachment:textAttachment];
        [attributedString appendAttributedString:offShelf];
    }
    
    if (vo.goodsName) {
        NSString *goodName = [NSString stringWithFormat:@" %@" ,vo.goodsName];
        NSAttributedString *goodNameAttributedString = [[NSAttributedString alloc] initWithString:goodName attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName:[ColorHelper getTipColor3]}];
        [attributedString appendAttributedString:goodNameAttributedString];
    }
    
    _lblName.attributedText = attributedString;
    _lblPrice.text = vo.barCode;
    
    // 商品icon
    UIImage *placeholder = [UIImage imageNamed:@"img_default.png"];
    [_img ls_setImageWithPath:vo.filePath placeholderImage:placeholder];
}


- (void)fillGoodsOperationVo:(GoodsOperationVo *)vo {
    
    _lblName.text = vo.goodsName;
    _lblPrice.text = [NSString stringWithFormat:@"￥%.2f", [vo.retailPrice doubleValue]];
    [_lblPrice setTextColor:[ColorHelper getRedColor]];
    UIImage *placeholder = [UIImage imageNamed:@"img_default"];
    [_img ls_setImageWithPath:vo.filePath placeholderImage:placeholder];
}

//{
//    //    GoodsOperationVo *item = [self.datas objectAtIndex:indexPath.row];
//    //    cell.lblName.text = item.goodsName;
//    //    cell.lblPrice.text = [NSString stringWithFormat:@"￥%.2f", [item.retailPrice doubleValue]];
//    //    [cell.lblPrice setTextColor:[ColorHelper getRedColor]];
//    //    [cell.lblName setVerticalAlignment:VerticalAlignmentTop];
//    //    UIImage* placeholder = [UIImage imageNamed:@"img_default.png"];
//    //    if ([NSString isNotBlank:item.filePath]) {
//    //        [cell.img.layer setMasksToBounds:YES];
//    //        [cell.img.layer setCornerRadius:PANEL_OUTTER_CORNER_RADIUS];
//    //        NSURL* url = [NSURL URLWithString:[NSString urlFilterRan:item.filePath]];
//    //        [cell.img sd_setImageWithURL:url placeholderImage:placeholder];
//    //    }
//    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//}

@end
