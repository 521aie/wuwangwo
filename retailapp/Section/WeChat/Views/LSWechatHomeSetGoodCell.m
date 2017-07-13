//
//  LSWechatHomeSetGoodCell.m
//  retailapp
//
//  Created by guozhi on 16/9/25.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSWechatHomeSetGoodCell.h"
#import "LSViewUtil.h"
#import "ColorHelper.h"
#import "Wechat_StyleVo.h"
#import "MicroWechatGoodsVo.h"
#define kLeftMargin 10
#define kHeight 88
#define kTopMargin 15

@interface LSWechatHomeSetGoodCell()
/**
 *  商品名字
 */
@property (nonatomic, weak) UILabel *lblName;
/**
 *  款号
 */
@property (nonatomic, weak) UILabel *lblCode;

@end
@implementation LSWechatHomeSetGoodCell

+ (instancetype)wechatGoodCellAtTableView:(UITableView *)tableView {
    static NSString *cellIdentifier = @"cell";
    LSWechatHomeSetGoodCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[LSWechatHomeSetGoodCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.frame = CGRectMake(0, 0, tableView.frame.size.width, kHeight);
        //添加分割线
        [LSViewUtil addLine:cell margin:10 y:(kHeight -1)];
        cell.lblName = [LSViewUtil addLable:cell font:[UIFont boldSystemFontOfSize:15] color:[UIColor blackColor]];
        cell.lblCode = [LSViewUtil addLable:cell font:[UIFont systemFontOfSize:13] color:[ColorHelper getTipColor6]];
       
    }
    return cell;    
}


#pragma mark - 微店商品列表页面单元格
- (void)setGoodsVo:(MicroWechatGoodsVo *)goodsVo {
    _goodsVo = goodsVo;
    CGFloat x = kLeftMargin;
    CGFloat y = kTopMargin;
    CGFloat w = SCREEN_W - x - 50;
    CGSize styleNameSize = [LSViewUtil sizeWithText:goodsVo.goodsName maxSize:CGSizeMake(w , MAXFLOAT) font:[UIFont boldSystemFontOfSize:15]];
    styleNameSize.height = styleNameSize.height > 40 ? 40 : styleNameSize.height;
    self.lblName.frame = CGRectMake(x, y, styleNameSize.width, styleNameSize.height);
    self.lblName.text = goodsVo.goodsName;
    
    //商品款号
    NSString *codeStr = [NSString stringWithFormat:@"条形码：%@", _goodsVo.barCode];
    CGSize codeSize = [LSViewUtil sizeWithText:codeStr maxSize:CGSizeMake(w, MAXFLOAT) font:[UIFont systemFontOfSize:13]];
    y = self.frame.size.height - kTopMargin - codeSize.height;
    self.lblCode.frame = CGRectMake(x, y, codeSize.width, codeSize.height);
    self.lblCode.text = codeStr;
    
}
@end
