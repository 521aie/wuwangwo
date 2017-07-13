//
//  LSGoodsPurchaseListCell.m
//  retailapp
//
//  Created by guozhi on 2017/1/13.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSGoodsPurchaseListCell.h"
#import "LSGoodsPurchaseVo.h"

@interface LSGoodsPurchaseListCell()
/** 商品名字 */
@property (nonatomic, strong) UILabel *lblName;
/** 条形码店内码 */
@property (nonatomic, strong) UILabel *lblCode;
/** 总进货量 */
@property (nonatomic, strong) UILabel *lblTotalStockNum;
/** 进货金额 */
@property (nonatomic, strong) UILabel *lblTotalStockPrice;
/** 下一个图片 */
@property (nonatomic, strong) UIImageView *imgViewNext;
/** 分割线 */
@property (nonatomic, strong) UIView *viewLine;
@end

@implementation LSGoodsPurchaseListCell
+ (instancetype)goodsPurchaseListCellWithTableView:(UITableView *)tableView {
    static NSString *cellIdentifier = @"cell";
    LSGoodsPurchaseListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[LSGoodsPurchaseListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        [cell configViews];
        [cell configConstraints];
    }
    return cell;
}

- (void)configViews {
    //商品名称
    self.lblName = [[UILabel alloc] init];
    self.lblName.font = [UIFont systemFontOfSize:15];
    self.lblName.textColor = [ColorHelper getTipColor3];
    [self.contentView addSubview:self.lblName];
    
    //条形码店内码
    self.lblCode = [[UILabel alloc] init];
    self.lblCode.font = [UIFont systemFontOfSize:13];
    self.lblCode.textColor = [ColorHelper getTipColor6];
    [self.contentView addSubview:self.lblCode];
    
    //总进货量
    self.lblTotalStockNum = [[UILabel alloc] init];
    self.lblTotalStockNum.font = [UIFont systemFontOfSize:13];
    self.lblTotalStockNum.textColor = [ColorHelper getTipColor6];
    [self.contentView addSubview:self.lblTotalStockNum];
    
    //进货金额
    self.lblTotalStockPrice = [[UILabel alloc] init];
    self.lblTotalStockPrice.font = [UIFont systemFontOfSize:13];
    self.lblTotalStockPrice.textColor = [ColorHelper getTipColor6];
    [self.contentView addSubview:self.lblTotalStockPrice];
    
    //下一个图片
    self.imgViewNext = [[UIImageView alloc] init];
    self.imgViewNext.image = [UIImage imageNamed:@"ico_next"];
    [self.contentView addSubview:self.imgViewNext];
    
    //分割线
    self.viewLine = [[UIView alloc] init];
    self.viewLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [self.contentView addSubview:self.viewLine];
}

- (void)configConstraints {
    __weak typeof(self) wself = self;
    CGFloat margin = 10;
    CGFloat top = 20;
    //商品名称
    [self.lblName makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.contentView).offset(margin);
        make.right.lessThanOrEqualTo(wself.lblTotalStockNum.left).offset(-margin);
        make.top.equalTo(wself.contentView).offset(top);
    }];
    
    //条形码店内码
    [self.lblCode makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.lblName);
        make.bottom.equalTo(wself.contentView).offset(-top);
    }];
    
    //总进货量
    [self.lblTotalStockNum makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wself.imgViewNext.left);
        make.top.equalTo(wself.lblName);
    }];
    [self.lblTotalStockNum setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    //总进货金额
    [self.lblTotalStockPrice makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(wself.lblCode);
        make.right.equalTo(wself.imgViewNext.left);
    }];
    
    //下一个图片
    [self.imgViewNext makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(22);
        make.right.equalTo(wself.contentView).offset(-margin);
        make.centerY.equalTo(wself.contentView);
    }];
    
    //分割线
    [self.viewLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself.contentView);
        make.height.equalTo(1);
    }];
}

- (void)setObj:(LSGoodsPurchaseVo *)obj {
    _obj = obj;
    //商品名字
    NSString *goodsName = [[[Platform Instance] getkey:SHOP_MODE] intValue] == 101 ? obj.styleName : obj.goodsName;
    self.lblName.text = goodsName;
    
    //条形码店内码
    NSString *styleCode = [NSString stringWithFormat:@"款号：%@",obj.styleCode];
    NSString *code = [[[Platform Instance] getkey:SHOP_MODE] intValue] == 101 ? styleCode : obj.barCode;
    self.lblCode.text = code;
    
    //总进货量
    if ([ObjectUtil isNotNull:obj.stockNum] && [ObjectUtil isNotNull:obj.returnNum]) {
        if ([obj.stockNum.stringValue containsString:@"."] || [obj.returnNum.stringValue containsString:@"."]) {
            self.lblTotalStockNum.text = [NSString stringWithFormat:@"总进货量：%.3f", obj.stockNum.doubleValue - obj.returnNum.doubleValue];
            
        } else {
            self.lblTotalStockNum.text = [NSString stringWithFormat:@"总进货量：%.f", obj.stockNum.doubleValue - obj.returnNum.doubleValue];
        }
    }else{
        self.lblTotalStockNum.text = @"总进货量：0";
    }
    
    //总进货金额
    if ([ObjectUtil isNotNull:obj.stockAmount] && [ObjectUtil isNotNull:obj.returnAmount]) {
        if ((obj.stockAmount.doubleValue - obj.returnAmount.doubleValue) >= 0) {
            self.lblTotalStockPrice.text = [NSString stringWithFormat:@"¥%.2f", obj.stockAmount.doubleValue - obj.returnAmount.doubleValue];
        } else {
            self.lblTotalStockPrice.text = [NSString stringWithFormat:@"-¥%.2f", -(obj.stockAmount.doubleValue - obj.returnAmount.doubleValue)];
        }
    }else{
        self.lblTotalStockPrice.text = @"￥0.00";
    }
}

@end
