//
//  LSWechatGoodCell.m
//  retailapp
//
//  Created by guozhi on 16/8/24.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSWechatGoodCell.h"
#import "LSViewUtil.h"
#import "ColorHelper.h"
#import "Wechat_StyleVo.h"
#import "MicroWechatGoodsVo.h"
#define kLeftMargin 90
#define kHeight 88
#define kTopMargin 15

@interface LSWechatGoodCell()
/**
 *  商品图片
 */
@property (nonatomic, weak) UIImageView *imgView;
/**
 *  上下架图片
 */
//@property (nonatomic, weak) UIImageView *imgUpDown;
/**
 *  商品名字
 */
@property (nonatomic, weak) UILabel *lblName;
/**
 *  款号
 */
@property (nonatomic, weak) UILabel *lblCode;

@end
@implementation LSWechatGoodCell

+ (instancetype)wechatGoodCellAtTableView:(UITableView *)tableView {
    static NSString *cellIdentifier = @"cell";
    LSWechatGoodCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[LSWechatGoodCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.frame = CGRectMake(0, 0, tableView.frame.size.width, kHeight);
        
        //添加分割线
        [LSViewUtil addLine:cell margin:0 y:(kHeight -1)];
        
        //添加下一个图片
        [LSViewUtil addNextImageView:cell];
        
        //添加商品图片
        cell.imgView = [LSViewUtil addGoodImageView:cell];
//        cell.imgUpDown = [LSViewUtil addImageView:cell];
        cell.lblName = [LSViewUtil addLable:cell font:[UIFont boldSystemFontOfSize:15] color:[UIColor blackColor]];
        cell.lblCode = [LSViewUtil addLable:cell font:[UIFont systemFontOfSize:13] color:[ColorHelper getTipColor6]];
       
    }
    return cell;    
}

#pragma mark - 微店款式列表页面单元格
- (void)setStyleVo:(Wechat_StyleVo *)styleVo {
    _styleVo = styleVo;
    CGFloat x = kLeftMargin;
    CGFloat y = kTopMargin;
    CGFloat w = SCREEN_W - x - 50;

    //上下架图片
//    self.imgUpDown.frame = CGRectMake(x, y + 2, 40, 15);
//    if ([styleVo.microShelveStatus isEqualToString:@"2"]) {//已下架的标志显示出来
//        self.imgUpDown.image =  [UIImage imageNamed:@"ico_wechat_down"];
//        styleNameStr = [NSString stringWithFormat:@"            %@", styleVo.styleName];
//        self.imgUpDown.hidden = NO;
//    } else {
//        self.imgUpDown.hidden = YES;
    //商品名称
    NSString *styleNameStr = [NSString stringWithFormat:@"%@", styleVo.styleName];
//    }
    CGSize styleNameSize = [LSViewUtil sizeWithText:styleNameStr maxSize:CGSizeMake(w , MAXFLOAT) font:[UIFont boldSystemFontOfSize:15]];
    styleNameSize.height = styleNameSize.height > 40 ? 40 : styleNameSize.height;
    self.lblName.frame = CGRectMake(x, y, styleNameSize.width, styleNameSize.height);
    self.lblName.text = styleNameStr;
    
    //商品款号
    NSString *codeStr = [NSString stringWithFormat:@"款号：%@", _styleVo.styleCode];
    CGSize codeSize = [LSViewUtil sizeWithText:codeStr maxSize:CGSizeMake(w, MAXFLOAT) font:[UIFont systemFontOfSize:13]];
    y = self.frame.size.height - kTopMargin - codeSize.height;
    self.lblCode.frame = CGRectMake(x, y, codeSize.width, codeSize.height);
    self.lblCode.text = codeStr;
    
   
    
    //设置商品图文
    NSURL *url = [NSURL URLWithString:styleVo.filePath];
    UIImage *placeholder = [UIImage imageNamed:@"img_default.png"];
    [self.imgView sd_setImageWithURL:url placeholderImage:placeholder];

}

#pragma mark - 微店商品列表页面单元格
- (void)setGoodsVo:(MicroWechatGoodsVo *)goodsVo {
    _goodsVo = goodsVo;
    CGFloat x = kLeftMargin;
    CGFloat y = kTopMargin;
    CGFloat w = SCREEN_W - x - 50;
    
    //上下架图片
//    self.imgUpDown.frame = CGRectMake(x, y + 2, 40, 15);
//    if ([_goodsVo.microShelveStatus isEqualToString:@"2"]) {//已下架的标志显示出来
//        self.imgUpDown.image =  [UIImage imageNamed:@"ico_wechat_down"];
//        goodsNameStr = [@"            " stringByAppendingString:goodsVo.goodsName];
//        self.imgUpDown.hidden = NO;
//    } else {
//        self.imgUpDown.hidden = YES;
    //商品名称
    NSString *goodsNameStr= [NSString stringWithFormat:@"%@", goodsVo.goodsName];
    CGSize styleNameSize = [LSViewUtil sizeWithText:goodsNameStr maxSize:CGSizeMake(w , MAXFLOAT) font:[UIFont boldSystemFontOfSize:15]];
    styleNameSize.height = styleNameSize.height > 40 ? 40 : styleNameSize.height;
    self.lblName.frame = CGRectMake(x, y, styleNameSize.width, styleNameSize.height);
    self.lblName.text = goodsNameStr;
    
    //商品款号
    NSString *codeStr = [NSString stringWithFormat:@"条形码：%@", _goodsVo.barCode];
    CGSize codeSize = [LSViewUtil sizeWithText:codeStr maxSize:CGSizeMake(w, MAXFLOAT) font:[UIFont systemFontOfSize:13]];
    y = self.frame.size.height - kTopMargin - codeSize.height;
    self.lblCode.frame = CGRectMake(x, y, codeSize.width, codeSize.height);
    self.lblCode.text = codeStr;
    
    //设置商品图文
    NSURL *url = [NSURL URLWithString:goodsVo.filePath];
    UIImage *placeholder = [UIImage imageNamed:@"img_default.png"];
    [self.imgView sd_setImageWithURL:url placeholderImage:placeholder];
    
}
@end
