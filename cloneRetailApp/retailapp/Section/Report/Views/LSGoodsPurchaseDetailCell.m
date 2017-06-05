//
//  LSGoodsPurchaseDetailCell.m
//  retailapp
//
//  Created by guozhi on 2017/1/14.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSGoodsPurchaseDetailCell.h"
#import "LSGoodsPurchaseVo.h"
#import "DateUtils.h"

@interface LSGoodsPurchaseDetailCell()
/** 供应商 */
@property (nonatomic, strong) UILabel *lblSuppilerName;
/** 单号 */
@property (nonatomic, strong) UILabel *lblNumber;
/** 时间 */
@property (nonatomic, strong) UILabel *lblTime;
/** 进/退货量 */
@property (nonatomic, strong) UILabel *lblPurchaseNum;
/** 进/退货量金额 */
@property (nonatomic, strong) UILabel *lblPurchaseAmount;
/** 下一个图片 */
@property (nonatomic, strong) UIImageView *imgViewNext;
/** 分割线 */
@property (nonatomic, strong) UIView *viewLine;
@end

@implementation LSGoodsPurchaseDetailCell
+ (instancetype)goodsPurchaseDetailCellWithTableView:(UITableView *)tableView {
    static NSString *cellIdentifier = @"cell";
    LSGoodsPurchaseDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[LSGoodsPurchaseDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        [cell configViews];
        [cell configConstraints];
    }
    return cell;
}

- (void)configViews {
    //供应商名称
    self.lblSuppilerName = [[UILabel alloc] init];
    self.lblSuppilerName.font = [UIFont systemFontOfSize:15];
    self.lblSuppilerName.textColor = [ColorHelper getTipColor3];
    [self.contentView addSubview:self.lblSuppilerName];
    
    //单号
    self.lblNumber = [[UILabel alloc] init];
    self.lblNumber.font = [UIFont systemFontOfSize:13];
    self.lblNumber.textColor = [ColorHelper getTipColor6];
    [self.contentView addSubview:self.lblNumber];
    
    //时间
    self.lblTime = [[UILabel alloc] init];
    self.lblTime.font = [UIFont systemFontOfSize:13];
    self.lblTime.textColor = [ColorHelper getTipColor6];
    [self.contentView addSubview:self.lblTime];
    
    //进/退货量
    self.lblPurchaseNum = [[UILabel alloc] init];
    self.lblPurchaseNum.font = [UIFont systemFontOfSize:13];
    self.lblPurchaseNum.textColor = [ColorHelper getTipColor6];
    [self.contentView addSubview:self.lblPurchaseNum];
    
    //进/退货量金额
    self.lblPurchaseAmount = [[UILabel alloc] init];
    self.lblPurchaseAmount.font = [UIFont systemFontOfSize:13];
    self.lblPurchaseAmount.textColor = [ColorHelper getRedColor];
    [self.contentView addSubview:self.lblPurchaseAmount];
    
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
    CGFloat top = 10;
    
    //供应商名称
    [self.lblSuppilerName makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.contentView).offset(margin);
        make.top.equalTo(wself.contentView).offset(top);
        make.width.mas_equalTo(SCREEN_W*2/3);
    }];
    
    //单号
    [self.lblNumber makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.contentView).offset(margin);
        make.centerY.equalTo(wself.contentView);
    }];
    
    //时间
    [self.lblTime makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.contentView).offset(margin);
        make.bottom.equalTo(wself.contentView).offset(-top);
    }];
    
    //进/退货量
    [self.lblPurchaseNum makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(wself.lblSuppilerName.bottom);
        make.right.equalTo(wself.imgViewNext.left);
    }];
    
    //进/退货量金额
    [self.lblPurchaseAmount makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(wself.lblTime.top);
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
    
    //供应商名字
    self.lblSuppilerName.text = obj.supplierName;
    
    //单号
    self.lblNumber.text = [NSString stringWithFormat:@"单号：%@", obj.invoiceCode];
   
    //时间
    self.lblTime.text = [NSString stringWithFormat:@"%@",[DateUtils formateTime:[obj.invoiceTime longLongValue]]];
    
    //进货/退货
    if ([ObjectUtil isNotNull:obj.invoiceFlag]) {
        if (obj.invoiceFlag.intValue == 1) {
            if ([ObjectUtil isNotNull:obj.stockNum]) {
                if ([obj.stockNum.stringValue containsString:@"."]) {
                    self.lblPurchaseNum.text = [NSString stringWithFormat:@"进货量：%.3f", obj.stockNum.doubleValue];
                } else {
                    self.lblPurchaseNum.text = [NSString stringWithFormat:@"进货量：%.f", obj.stockNum.doubleValue];
                }
                self.lblPurchaseAmount.textColor = [ColorHelper getRedColor];
                self.lblPurchaseAmount.text = [NSString stringWithFormat:@"¥%.2f", obj.stockAmount.doubleValue];
            }
        } else {
            if ([ObjectUtil isNotNull:obj.returnNum]) {
                if ([obj.returnNum.stringValue containsString:@"."]) {
                    self.lblPurchaseNum.text = [NSString stringWithFormat:@"退货量：%.3f", obj.returnNum.doubleValue];
                } else {
                    self.lblPurchaseNum.text = [NSString stringWithFormat:@"退货量：%.f", obj.returnNum.doubleValue];
                }
                self.lblPurchaseAmount.textColor = [ColorHelper getGreenColor];
                if (obj.returnAmount.doubleValue == 0) {
                    self.lblPurchaseAmount.text = [NSString stringWithFormat:@"¥%.2f", obj.returnAmount.doubleValue];
                } else {
                    self.lblPurchaseAmount.text = [NSString stringWithFormat:@"-¥%.2f", obj.returnAmount.doubleValue];
                }
            }
        }
    }
}

@end
