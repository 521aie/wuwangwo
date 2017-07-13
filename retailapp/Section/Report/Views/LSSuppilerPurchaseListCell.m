//
//  LSSuppilerPurchaseListCell.m
//  retailapp
//
//  Created by wuwangwo on 2017/2/4.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSSuppilerPurchaseListCell.h"
#import "LSSuppilerPurchaseVo.h"

@interface LSSuppilerPurchaseListCell ()
/** 供应商 */
@property (nonatomic, strong) UILabel *lblSuppilerName;
/** 交易笔数 */
@property (nonatomic, strong) UILabel *lblTransactionNum;
/** 总进货量 */
@property (nonatomic, strong) UILabel *lblTotalStockNum;
/** 进货金额 */
@property (nonatomic, strong) UILabel *lblTotalStockPrice;
/** 下一个图片 */
@property (nonatomic, strong) UIImageView *imgViewNext;
/** 分割线 */
@property (nonatomic, strong) UIView *viewLine;
@end

@implementation LSSuppilerPurchaseListCell
+ (instancetype)suppilerPurchaseDetailCellWithTableView:(UITableView *)tableView{
    static NSString *cellIdentifier = @"cell";
    LSSuppilerPurchaseListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[LSSuppilerPurchaseListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
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
    
    //交易笔数
    self.lblTransactionNum = [[UILabel alloc] init];
    self.lblTransactionNum.font = [UIFont systemFontOfSize:13];
    self.lblTransactionNum.textColor = [ColorHelper getTipColor6];
    [self.contentView addSubview:self.lblTransactionNum];
    
    //进/退货量
    self.lblTotalStockNum = [[UILabel alloc] init];
    self.lblTotalStockNum.font = [UIFont systemFontOfSize:13];
    self.lblTotalStockNum.textColor = [ColorHelper getTipColor6];
    [self.contentView addSubview:self.lblTotalStockNum];
    
    //进/退货量金额
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
    
    //供应商名称
    [self.lblSuppilerName makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.contentView).offset(margin);
        make.right.lessThanOrEqualTo(wself.lblTotalStockNum.left).offset(-margin);
        make.top.equalTo(wself.contentView).offset(top);
    }];
    
    //交易笔数
    [self.lblTransactionNum makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.lblSuppilerName);
        make.bottom.equalTo(wself.contentView).offset(-top);
    }];
    
    //进/退货量
    [self.lblTotalStockNum makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wself.imgViewNext.left);
        make.top.equalTo(wself.lblSuppilerName);
    }];
     [self.lblTotalStockNum setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    //进/退货量金额
    [self.lblTotalStockPrice makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(wself.lblTransactionNum);
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

- (void)setObj:(LSSuppilerPurchaseVo *)obj {
    _obj = obj;
    //供应商名字
    self.lblSuppilerName.text = obj.supplierName;
    
    //交易笔数
    self.lblTransactionNum.text = [NSString stringWithFormat:@"交易笔数：%@", obj.transactionNum];

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
