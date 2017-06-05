//
//  LSStockBalanceListCell.m
//  retailapp
//
//  Created by guozhi on 2017/1/10.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSStockBalanceListCell.h"
#import "LSStockBalanceVo.h"
@interface LSStockBalanceListCell()
/** 商品名字 */
@property (nonatomic, strong) UILabel *lblName;
/** 条形码店内码 */
@property (nonatomic, strong) UILabel *lblCode;
/** 结存数量 */
@property (nonatomic, strong) UILabel *lblBalanceNum;
/** 结存金额 */
@property (nonatomic, strong) UILabel *lblBalanceAmount;
/** 下一个图片 */
@property (nonatomic, strong) UIImageView *imgViewNext;
/** 分割线 */
@property (nonatomic, strong) UIView *viewLine;
@end

@implementation LSStockBalanceListCell

+ (instancetype)stockBalanceListCellWithTableView:(UITableView *)tableView {
    static NSString *cellIdentifier = @"cell";
    LSStockBalanceListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[LSStockBalanceListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
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
    
    //结存数量
    self.lblBalanceNum = [[UILabel alloc] init];
    self.lblBalanceNum.font = [UIFont systemFontOfSize:13];
    self.lblBalanceNum.textColor = [ColorHelper getTipColor6];
    [self.contentView addSubview:self.lblBalanceNum];
    
    //结存金额
    self.lblBalanceAmount = [[UILabel alloc] init];
    self.lblBalanceAmount.font = [UIFont systemFontOfSize:13];
    self.lblBalanceAmount.textAlignment = NSTextAlignmentRight;
    self.lblBalanceAmount.textColor = [ColorHelper getTipColor6];
    [self.contentView addSubview:self.lblBalanceAmount];
    
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
    //商品名称
    CGFloat margin = 10;
    CGFloat top = 10;
    [self.lblName makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.contentView).offset(margin);
        make.right.equalTo(wself.contentView).offset(-margin);
        make.top.equalTo(wself.contentView).offset(top);
    }];
    
    //条形码店内码
    [self.lblCode makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.lblName);
        make.centerY.equalTo(wself.contentView);
    }];
    
    //结存数量
    [self.lblBalanceNum makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.lblName);
        make.bottom.equalTo(wself.contentView).offset(-top);
        make.width.equalTo(wself.contentView.width).multipliedBy(0.5);
    }];
    
    //结存金额
    [self.lblBalanceAmount makeConstraints:^(MASConstraintMaker *make) {
         make.bottom.equalTo(wself.contentView).offset(-top);
         make.right.equalTo(wself.imgViewNext.left);
         make.width.equalTo(wself.contentView.width).multipliedBy(0.5);
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

- (void)setObj:(LSStockBalanceVo *)obj {
    _obj = obj;
    //商品名字
    NSString *goodsName = [[[Platform Instance] getkey:SHOP_MODE] intValue] == 101 ? obj.styleName : obj.goodsName;
    self.lblName.text = goodsName;
    //条形码店内码
    if ( [[[Platform Instance] getkey:SHOP_MODE] intValue] == 102) {
        self.lblCode.text = obj.barCode;
    } else {
        self.lblCode.text = [NSString stringWithFormat:@"%@  %@ %@", obj.innerCode, obj.colorName, obj.sizeName];
    }
    //结存数量
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"结存数量："];
    if ([ObjectUtil isNotNull:obj.stockNum]) {
        if ([obj.stockNum.stringValue containsString:@"."]) {
            [attr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.3f", obj.stockNum.doubleValue] attributes:@{NSForegroundColorAttributeName : [ColorHelper getRedColor]}]];
        } else {
            [attr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.f", obj.stockNum.doubleValue] attributes:@{NSForegroundColorAttributeName : [ColorHelper getRedColor]}]];
        }
    }
    self.lblBalanceNum.attributedText = attr;
    
    //结存金额
    attr = [[NSMutableAttributedString alloc] initWithString:@"结存金额："];
    if ([ObjectUtil isNotNull:obj.stockAmount]) {
        [attr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f", obj.stockAmount.doubleValue] attributes:@{NSForegroundColorAttributeName : [ColorHelper getRedColor]}]];
    }
    self.lblBalanceAmount.attributedText = attr;

}



@end
