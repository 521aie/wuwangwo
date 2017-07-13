//
//  LSSuppilerPurchaseDetailCell.m
//  retailapp
//
//  Created by wuwangwo on 2017/2/4.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSSuppilerPurchaseDetailCell.h"
#import "LSSuppilerPurchaseVo.h"
#import "DateUtils.h"

@interface LSSuppilerPurchaseDetailCell ()
/** 单号 */
@property (nonatomic, strong) UILabel *lbIinvoiceCode;
/** 单据时间 */
@property (nonatomic, strong) UILabel *lblInvoiceTime;
/** 进/退货数量 */
@property (nonatomic, strong) UILabel *lblPurchaseNum;
/** 进/退货量金额 */
@property (nonatomic, strong) UILabel *lblPurchaseAmount;
/** 下一个图片 */
@property (nonatomic, strong) UIImageView *imgViewNext;
/** 分割线 */
@property (nonatomic, strong) UIView *viewLine;
@end

@implementation LSSuppilerPurchaseDetailCell
+ (instancetype)suppilerPurchaseDetailCellWithTableView:(UITableView *)tableView{
    static NSString *cellIdentifier = @"cell";
    LSSuppilerPurchaseDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[LSSuppilerPurchaseDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        [cell configViews];
        [cell configConstraints];
    }
    return cell;
}

- (void)configViews {
    //单号
    self.lbIinvoiceCode = [[UILabel alloc] init];
    self.lbIinvoiceCode.font = [UIFont systemFontOfSize:15];
    self.lbIinvoiceCode.textColor = [ColorHelper getTipColor3];
    [self.contentView addSubview:self.lbIinvoiceCode];
   
    //单据时间
    self.lblInvoiceTime = [[UILabel alloc] init];
    self.lblInvoiceTime.font = [UIFont systemFontOfSize:13];
    self.lblInvoiceTime.textColor = [ColorHelper getTipColor6];
    [self.contentView addSubview:self.lblInvoiceTime];
    
    //进/退货量
    self.lblPurchaseNum = [[UILabel alloc] init];
    self.lblPurchaseNum.font = [UIFont systemFontOfSize:13];
    self.lblPurchaseNum.textColor = [ColorHelper getTipColor6];
    self.lblPurchaseNum.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.lblPurchaseNum];
    
    //进/退货量金额
    self.lblPurchaseAmount = [[UILabel alloc] init];
    self.lblPurchaseAmount.font = [UIFont systemFontOfSize:13];
    self.lblPurchaseAmount.textColor = [ColorHelper getTipColor6];
    self.lblPurchaseAmount.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.lblPurchaseAmount];
    
    //下一个图片
    self.imgViewNext = [[UIImageView alloc] init];
    self.imgViewNext.image = [UIImage imageNamed:@"ico_next"];
    [self.contentView addSubview:self.imgViewNext];
    
    //分割线
    self.viewLine = [[UIView alloc] init];
    self.viewLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self.contentView addSubview:self.viewLine];
}

- (void)configConstraints {
    __weak typeof(self) wself = self;
    CGFloat margin = 10;
    CGFloat top = 20;
    
    //单号
    [self.lbIinvoiceCode makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.contentView).offset(margin);
        make.right.equalTo(wself.contentView).offset(-margin);
        make.top.equalTo(wself.contentView).offset(top);
    }];
    
    //时间
    [self.lblInvoiceTime makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.contentView).offset(margin);
        make.bottom.equalTo(wself.contentView).offset(-top);
    }];
    
    //进/退货量
    [self.lblPurchaseNum makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(wself.lbIinvoiceCode);
        make.right.equalTo(wself.imgViewNext.left);
    }];
    
    //进/退货量金额
    [self.lblPurchaseAmount makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(wself.contentView).offset(-top);
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
        make.left.right.bottom.equalTo(self.contentView);
        make.height.equalTo(1);
    }];
}

- (void)setObj:(LSSuppilerPurchaseVo *)obj {
    _obj = obj;
    //单号
    self.lbIinvoiceCode.text = [NSString stringWithFormat:@"单号:%@",obj.invoiceCode];
    
    //单据时间
    self.lblInvoiceTime.text =  [NSString stringWithFormat:@"%@",[DateUtils formateTime:[obj.invoiceTime longLongValue]]];
    
    //进/退货量、进/退货量金额
     if ([ObjectUtil isNotNull:obj.invoiceFlag]) {
         if (obj.invoiceFlag.intValue == 1) {
             //进货
             if ([ObjectUtil isNotNull:obj.stockNum]) {
                 if ([obj.stockNum.stringValue containsString:@"."]) {
                     self.lblPurchaseNum.text = [NSString stringWithFormat:@"进货量:%.3f", obj.stockNum.doubleValue];
                 } else {
                     self.lblPurchaseNum.text = [NSString stringWithFormat:@"进货量:%.f", obj.stockNum.doubleValue];
                 }
                 self.lblPurchaseAmount.textColor = [ColorHelper getRedColor];
                 self.lblPurchaseAmount.text = [NSString stringWithFormat:@"¥%.2f", obj.stockAmount.doubleValue];
                }
         } else {
             if ([ObjectUtil isNotNull:obj.returnNum]) {
                if ([obj.returnNum.stringValue containsString:@"."]) {
                    self.lblPurchaseNum.text = [NSString stringWithFormat:@"退货量:%.3f", obj.returnNum.doubleValue];
                } else {
                    self.lblPurchaseNum.text = [NSString stringWithFormat:@"退货量:%.f", obj.returnNum.doubleValue];
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
