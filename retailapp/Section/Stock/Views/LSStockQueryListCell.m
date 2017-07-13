//
//  LSStockQueryListCell.m
//  retailapp
//
//  Created by guozhi on 2017/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSStockQueryListCell.h"
#import "StockInfoVo.h"
@interface LSStockQueryListCell()
/** 商品名称 */
@property (nonatomic, strong) UILabel *lblName;
/** 条形码 */
@property (nonatomic, strong) UILabel *lblBarCode;
/** 价格 */
@property (nonatomic, strong) UILabel *lblPrice;
/** 库存 */
@property (nonatomic, strong) UILabel *lblNowStore;
/** 总金额 */
@property (nonatomic, strong) UILabel *lblTotalMoney;
/** <#注释#> */
@property (nonatomic, strong) UIImageView *imgView;
/** <#注释#> */
@property (nonatomic, strong) UIView *line;
@end
@implementation LSStockQueryListCell
+ (instancetype)stockQueryListCellWithTableView:(UITableView *)tableView {
    static NSString *cellIdentifier = @"cell";
    LSStockQueryListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[LSStockQueryListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        [cell configViews];
        [cell configConstraints];
    }
    return cell;
}

- (void)configViews {
    self.lblName = [[UILabel alloc] init];
    self.lblName.font = [UIFont systemFontOfSize:15];
    self.lblName.textColor = [ColorHelper getTipColor3];
    [self.contentView addSubview:self.lblName];
    
    self.lblBarCode = [[UILabel alloc] init];
    self.lblBarCode.font = [UIFont systemFontOfSize:13];
    self.lblBarCode.textColor = [ColorHelper getTipColor6];
    [self.contentView addSubview:self.lblBarCode];
    
    self.lblPrice = [[UILabel alloc] init];
    self.lblPrice.font = [UIFont systemFontOfSize:13];
    self.lblPrice.textColor = [ColorHelper getTipColor6];
    [self.contentView addSubview:self.lblPrice];
    
    self.lblNowStore = [[UILabel alloc] init];
    self.lblNowStore.font = [UIFont systemFontOfSize:13];
    self.lblNowStore.textColor = [ColorHelper getTipColor6];
    [self.contentView addSubview:self.lblNowStore];
    
    self.lblTotalMoney = [[UILabel alloc] init];
    self.lblTotalMoney.font = [UIFont systemFontOfSize:13];
    self.lblTotalMoney.textColor = [ColorHelper getTipColor6];
    [self.contentView addSubview:self.lblTotalMoney];
    
    self.imgView = [[UIImageView alloc] init];
    self.imgView.image = [UIImage imageNamed:@"ico_next"];
    [self.contentView addSubview:self.imgView];
    
    self.line = [[UIView alloc] init];
    self.line.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [self.contentView addSubview:self.line];
}

- (void)configConstraints {
    __weak typeof(self) wself = self;
    CGFloat margin = 10;
    [self.lblName makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.contentView).offset(margin);
        make.top.equalTo(wself.contentView).offset(margin);
        make.right.equalTo(wself.contentView).offset(-margin);
    }];
    [self.lblBarCode makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.contentView).offset(margin);
        make.centerY.equalTo(wself.contentView);
        make.right.equalTo(wself.lblNowStore.right).offset(-margin);
    }];

    [self.lblPrice makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.contentView).offset(margin);
        make.bottom.equalTo(wself.contentView).offset(-margin);
        make.right.equalTo(wself.lblTotalMoney.right).offset(-margin);
    }];
   
    [self.lblNowStore makeConstraints:^(MASConstraintMaker *make) {
        if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 102) {
             make.right.equalTo(wself.contentView).offset(-margin);
        } else {
             make.right.equalTo(wself.imgView.left);
        }
       
        make.centerY.equalTo(wself.lblBarCode);
    }];
    [self.lblNowStore setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.lblTotalMoney makeConstraints:^(MASConstraintMaker *make) {
        if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 102) {
            make.right.equalTo(wself.contentView).offset(-margin);
        } else {
            make.right.equalTo(wself.imgView.left);
        }
        make.centerY.equalTo(wself.lblPrice);
    }];
    [self.lblTotalMoney setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.imgView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wself.contentView.right).offset(-margin);
        make.centerY.equalTo(wself.contentView.centerY);
        make.size.equalTo(22);
    }];
    
    [self.line makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(wself.contentView);
        make.height.equalTo(1);
    }];
    
}

- (void)setObj:(StockInfoVo *)obj {
    _obj = obj;
    //有权限显示成本价 没有权限 商超显示零售价 服鞋显示吊牌价
    BOOL isShowCostPrice = ![[Platform Instance] lockAct:ACTION_COST_PRICE_SEARCH];
    BOOL isMarket = [[[Platform Instance] getkey:SHOP_MODE] intValue] == 102;
    self.imgView.hidden = isMarket;
    self.lblNowStore.hidden = !isMarket;
    self.lblBarCode.hidden = !isMarket;
    self.lblName.text = isMarket?obj.goodsName:obj.styleName;
    if (isMarket) {//商超
        self.lblBarCode.text = obj.barCode;
        // 散称商品显示到小数后三位， 非散称(如原散称商品现在关闭非散称则任然可以显示小数，过滤掉无意义的0)
        self.lblNowStore.text = [obj.nowStore.stringValue containsString:@"."]?[NSString stringWithFormat:@"库存数：%.3f",[obj.nowStore doubleValue]]:[NSString stringWithFormat:@"库存数：%@" ,obj.nowStore.stringValue]; // [NSString stringWithFormat:@"库存数：%.0f",[obj.nowStore doubleValue]
        self.lblPrice.text = (isShowCostPrice? [NSString stringWithFormat:@"成本价：￥%.2f",[obj.powerPrice doubleValue]]:[NSString stringWithFormat:@"零售价：￥%.2f",[obj.retailPrice doubleValue]]);
        self.lblTotalMoney.text = [NSString stringWithFormat:@"库存金额：￥%.2f",isShowCostPrice ? [obj.powerSumMoney doubleValue] : [obj.sumMoney doubleValue]];
    }else{
        self.lblPrice.text = [NSString stringWithFormat:@"款号：%@",obj.styleCode];
        self.lblTotalMoney.text = [NSString stringWithFormat:@"库存数：%.0f",[obj.nowStore doubleValue]];
    }

}

@end
