//
//  LSShopCollectionListCell.m
//  retailapp
//
//  Created by guozhi on 2016/11/28.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSShopCollectionListCell.h"

@interface LSShopCollectionListCell ()

/** 支付类型名称 */
@property (nonatomic, strong) UILabel *lblPayTypeName;
/** 支付金额 */
@property (nonatomic, strong) UILabel *lblPayAmount;
/** 下一个图标 */
@property (nonatomic, strong) UIImageView *imgNext;
/** 分割线 */
@property (nonatomic, strong) UIView *viewLine;
@end

@implementation LSShopCollectionListCell
+ (instancetype)shopCollectionListCellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"cell";
    LSShopCollectionListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[LSShopCollectionListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configViews];
        [cell configConstraints];
    }
    return cell;
}

- (void)configViews {
    //支付类型名称
    self.lblPayTypeName = [[UILabel alloc] init];
    self.lblPayTypeName.font = [UIFont systemFontOfSize:15];
    self.lblPayTypeName.textColor = [ColorHelper getTipColor3];
    [self.contentView addSubview:self.lblPayTypeName];
    //支付金额
    self.lblPayAmount = [[UILabel alloc] init];
    self.lblPayAmount.font = [UIFont systemFontOfSize:15];
    self.lblPayAmount.textColor = [ColorHelper getRedColor];
    self.lblPayAmount.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.lblPayAmount];
    //下一个图标
    self.imgNext = [[UIImageView alloc] init];
    self.imgNext.image = [UIImage imageNamed:@"ico_next"];
    [self.contentView addSubview:self.imgNext];
    //分割线
    self.viewLine = [[UIView alloc] init];
    self.viewLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [self.contentView addSubview:self.viewLine];
}

- (void)configConstraints {
    CGFloat margin = 10;
    __weak typeof(self) wself = self;
    //员工名称工号
    [self.lblPayTypeName makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.contentView.left).offset(margin);
        make.centerY.equalTo(wself.contentView.centerY);
    }];

    //实收金额
    [self.lblPayAmount makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(wself.lblPayTypeName);
        make.right.equalTo(wself.imgNext.left);
    }];
    //下一个图标
    [self.imgNext makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wself.contentView.right).offset(-10);
        make.centerY.equalTo(wself.contentView.centerY);
        make.size.equalTo(22);
    }];
    //分割线
    [self.viewLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself.contentView);
        make.height.equalTo(1);
    }];
    
}


- (void)setHandoverPayTypeVo:(LSHandoverPayTypeVo *)handoverPayTypeVo showNextimg:(BOOL)show
{
    _handoverPayTypeVo = handoverPayTypeVo;
    self.lblPayAmount.textColor = [handoverPayTypeVo.salesAmount doubleValue]<0?[ColorHelper getGreenColor]:[ColorHelper getRedColor];
    self.lblPayTypeName.text = handoverPayTypeVo.payMode;
    if (handoverPayTypeVo.salesAmount.doubleValue >= 0) {
        self.lblPayAmount.text = [NSString stringWithFormat:@"￥%.2f", [handoverPayTypeVo.salesAmount doubleValue]];
    } else {
        self.lblPayAmount.text = [NSString stringWithFormat:@"-￥%.2f", -[handoverPayTypeVo.salesAmount doubleValue]];
    }
    
     __weak typeof(self) wself = self;
    if (show) {
        self.imgNext.hidden = NO;
        //实收金额
        [self.lblPayAmount remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(wself.lblPayTypeName);
            make.right.equalTo(wself.imgNext.left);
        }];
    } else {
        self.imgNext.hidden = YES;
        [self.lblPayAmount remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(wself.lblPayTypeName);
            make.right.equalTo(wself.contentView.right).offset(-10);
        }];
    }
}



@end
