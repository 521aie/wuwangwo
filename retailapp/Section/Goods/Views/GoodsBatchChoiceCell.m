//
//  GoodsBatchChoiceCell.m
//  retailapp
//
//  Created by zhangzhiliang on 15/10/29.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GoodsBatchChoiceCell.h"
#import "GoodsSkuVo.h"
@implementation GoodsBatchChoiceCell
+ (instancetype)goodsBatchChoiceCellWithTableView:(UITableView *)tableView {
    static NSString *cellIdentifier = @"cellIdentifier";
    GoodsBatchChoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
    }
    return cell;
}

- (void)setGoodsVo:(GoodsVo *)goodsVo {
    _goodsVo = goodsVo;
    self.lblName.text = goodsVo.goodsName;
    self.lblCode.text = goodsVo.barCode;
    self.lblType.hidden = YES;
    if ([goodsVo.isCheck isEqualToString:@"1"]) {
        self.imgCheck.image = [UIImage imageNamed:@"ico_check"];
    } else {
        self.imgCheck.image = [UIImage imageNamed:@"ico_uncheck"];
    }

}


- (void)setSaleGoodVo:(SaleGoodVo *)saleGoodVo {
    _saleGoodVo = saleGoodVo;
    self.lblName.text = saleGoodVo.goodName;
    self.lblCode.text = saleGoodVo.goodCode;
    if ([[[Platform Instance] getkey:SHOP_MODE] integerValue] == 101) {
        self.lblType.hidden = NO;
        NSString* attributeName = @"";
        for (GoodsSkuVo* sku in saleGoodVo.goodsSkuList) {
            if ([sku.attributeName isEqualToString:@"颜色"]) {
                attributeName = sku.attributeVal;
                break;
            }
        }
        
        for (GoodsSkuVo* sku in saleGoodVo.goodsSkuList) {
            if ([sku.attributeName isEqualToString:@"尺码"]) {
                attributeName = [attributeName stringByAppendingString:[NSString stringWithFormat:@" %@", sku.attributeVal]];
                break;
            }
        }
        self.lblType.text = attributeName;
    }else{
        self.lblType.hidden = YES;
    }
    
    if (saleGoodVo.isCheck == nil || [saleGoodVo.isCheck isEqualToString:@""] || [saleGoodVo.isCheck isEqualToString:@"0"]) {
        self.imgCheck.image = [UIImage imageNamed:@"ico_uncheck"];
    }else{
        self.imgCheck.image = [UIImage imageNamed:@"ico_check"];
    }
}

- (void)setStyleGoodsVo:(StyleGoodsVo *)styleGoodsVo {
    _styleGoodsVo = styleGoodsVo;
    self.lblName.text = styleGoodsVo.name;
    self.lblCode.text = styleGoodsVo.innerCode;
    
    NSString* attributeName = @"";
    for (GoodsSkuVo* sku in styleGoodsVo.goodsSkuVoList) {
        if ([sku.attributeName isEqualToString:@"颜色"]) {
            attributeName = sku.attributeVal;
            break;
        }
    }
    
    for (GoodsSkuVo* sku in styleGoodsVo.goodsSkuVoList) {
        if ([sku.attributeName isEqualToString:@"尺码"]) {
            attributeName = [attributeName stringByAppendingString:[NSString stringWithFormat:@" %@", sku.attributeVal]];
            break;
        }
    }
    self.lblType.text = attributeName;
    
    if ([styleGoodsVo.isCheck isEqualToString:@"1"]) {
        self.imgCheck.image = [UIImage imageNamed:@"ico_check"];
    }else{
         self.imgCheck.image = [UIImage imageNamed:@"ico_uncheck"];
    }

}

- (void)setWechatGoodsVo:(MicroWechatGoodsVo *)wechatGoodsVo {
    _wechatGoodsVo = wechatGoodsVo;
    self.lblType.hidden = YES;
    self.lblName.text = wechatGoodsVo.goodsName;
    self.lblCode.text = wechatGoodsVo.barCode;
    if ([wechatGoodsVo.isCheck isEqualToString:@"0"] || wechatGoodsVo.isCheck == nil || [wechatGoodsVo.isCheck isEqualToString:@""] ) {
        self.imgCheck.image = [UIImage imageNamed:@"ico_uncheck"];
    }else{
        self.imgCheck.image = [UIImage imageNamed:@"ico_check"];
    }

}

@end
