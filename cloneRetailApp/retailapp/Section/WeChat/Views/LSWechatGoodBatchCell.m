//
//  LSWechatGoodBatchCell.m
//  retailapp
//
//  Created by guozhi on 16/8/25.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSWechatGoodBatchCell.h"
#import "LSViewUtil.h"
#import "MicroWechatGoodsVo.h"
#import "UIView+Sizes.h"
#import "Wechat_StyleVo.h"
@interface LSWechatGoodBatchCell()
/**
 *  选中不选择图片标志
 */
@property (nonatomic, weak) UIImageView *imgStatus;
/**
 *  上下架标志
 */
//@property (nonatomic, weak) UIImageView *imgUpdownType;
/**
 *  商品名字
 */
@property (nonatomic, weak) UILabel *lblName;
/**
 *  款号
 */
@property (nonatomic, weak) UILabel *lblCode;

@end

@implementation LSWechatGoodBatchCell
+ (instancetype)wechatGoodBatchCellAtTableView:(UITableView *)tableView {
    static NSString *cellIdentifier = @"cell";
    LSWechatGoodBatchCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[LSWechatGoodBatchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        CGFloat kHeight = 54;
        CGFloat topMargin = 5;//距离上面距离
        cell.frame = CGRectMake(0, 0, tableView.frame.size.width, kHeight);
        CGFloat x = 0;
        CGFloat y = 0;
        CGFloat w = 0;
        CGFloat h = 0;
        
       
        //添加选择不选中标志图片
        w = h = 22;
        x = x + 10;
        x = x + 10;
        y = (kHeight - h)/2.0;
        cell.imgStatus = [LSViewUtil addImageView:cell imagePath:nil frame:CGRectMake(x, y, w, h)];
        x = x + w;
    
        //添加商品名称
        x = x + 20;
        y = topMargin;
        w = tableView.frame.size.width - x - 20;
        h = 20;
        cell.lblName = [LSViewUtil addLable:cell font:[UIFont systemFontOfSize:15] color:[UIColor blackColor] frame:CGRectMake(x, y, w, h)];
        
        //添加商品条形码
        h = 20;
        y = kHeight - topMargin - h;
        cell.lblCode = [LSViewUtil addLable:cell font:[UIFont systemFontOfSize:13] color:[ColorHelper getTipColor6] frame:CGRectMake(x, y, w, h)];
        
        //添加上下架标志
//        x = tableView.frame.size.width - 60;
//        w = 40;
//        h = 15;
//        cell.imgUpdownType.ls_centerY = cell.lblCode.ls_centerY + cell.lblCode.ls_height/2;
//        cell.imgUpdownType = [LSViewUtil addImageView:cell imagePath:nil frame:CGRectMake(x, y, w, h)];
        //添加分割线
        [LSViewUtil addLine:cell margin:0 y:(kHeight -1)];
        
    }
    return cell;
}

//微店商品批量设置
- (void)setGoodsVo:(MicroWechatGoodsVo *)goodsVo {
    _goodsVo = goodsVo;
    self.lblName.text = _goodsVo.goodsName;
    self.lblCode.text = [NSString stringWithFormat:@"条形码：%@", _goodsVo.barCode];
//    if ([microShelveStatus isEqual:@"1"]) {
//        self.imgUpdownType.hidden = YES;
//    }else{
//        self.imgUpdownType.hidden = NO;
//        self.imgUpdownType.image = [UIImage imageNamed:@"ico_wechat_down"];
//    }
    if ([goodsVo.isCheck isEqualToString:@"0"] || goodsVo.isCheck == nil || [goodsVo.isCheck isEqualToString:@""] ) {
        self.imgStatus.image = [UIImage imageNamed:@"ico_uncheck"];
    }else{
        self.imgStatus.image = [UIImage imageNamed:@"ico_check"];
    }

}

//微店款式批量设置
- (void)setStyleVo:(Wechat_StyleVo *)styleVo {
    _styleVo = styleVo;
    self.lblName.text = _styleVo.styleName;
    self.lblCode.text = [NSString stringWithFormat:@"款号：%@", _styleVo.styleCode];
//    NSString *microShelveStatus = _styleVo.microShelveStatus;
//    if ([microShelveStatus isEqual:@"1"]) {
//        self.imgUpdownType.hidden = YES;
//    }else{
//        self.imgUpdownType.hidden = NO;
//        self.imgUpdownType.image = [UIImage imageNamed:@"ico_wechat_down"];
//    }
    if (_styleVo.isCheck == nil || [_styleVo.isCheck isEqualToString:@""] || [_styleVo.isCheck isEqualToString:@"0"]) {
        self.imgStatus.image = [UIImage imageNamed:@"ico_uncheck"];
    }else{
        self.imgStatus.image = [UIImage imageNamed:@"ico_check"];
    }
}

@end
