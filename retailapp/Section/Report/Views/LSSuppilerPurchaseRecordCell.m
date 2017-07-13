//
//  LSSuppilerPurchaseRecordCell.m
//  retailapp
//
//  Created by wuwangwo on 2017/2/5.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSSuppilerPurchaseRecordCell.h"
#import "LSSuppilerPurchaseVo.h"

@interface LSSuppilerPurchaseRecordCell ()
/** 背景 */
@property (nonatomic, strong) UIView *backView;
/** 进/退货数量 */
@property (nonatomic, strong) UILabel *lblPurchaseNum;
/** 进/退货量金额 */
@property (nonatomic, strong) UILabel *lblPurchaseAmount;
/** 分割线 */
@property (nonatomic, strong) UIView *viewLine;
@end

@implementation LSSuppilerPurchaseRecordCell
+ (instancetype)suppilerPurchaseDetailCellWithTableView:(UITableView *)tableView{
    static NSString *cellIdentifier = @"cell";
    LSSuppilerPurchaseRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[LSSuppilerPurchaseRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        [cell configViews];
        [cell configConstraints];
    }
    return cell;
}

- (void)configViews {
    self.backView = [[UIView alloc] init];
    self.backView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview: self.backView];
    
    //商品名称
    self.lblGoodsName = [[UILabel alloc] init];
    self.lblGoodsName.font = [UIFont systemFontOfSize:13];
    self.lblGoodsName.textColor = [ColorHelper getTipColor3];
    [self.backView addSubview:self.lblGoodsName];
    
    //条码号
    self.lblCode = [[UILabel alloc] init];
    self.lblCode.font = [UIFont systemFontOfSize:13];
    self.lblCode.textColor = [ColorHelper getTipColor6];
    [self.backView addSubview:self.lblCode];
    
    //进/退货量
    self.lblPurchaseNum = [[UILabel alloc] init];
    self.lblPurchaseNum.font = [UIFont systemFontOfSize:13];
    self.lblPurchaseNum.textColor = [ColorHelper getTipColor6];
    self.lblPurchaseNum.textAlignment = NSTextAlignmentCenter;
    [self.backView addSubview:self.lblPurchaseNum];
    
    //进/退货量金额
    self.lblPurchaseAmount = [[UILabel alloc] init];
    self.lblPurchaseAmount.font = [UIFont systemFontOfSize:13];
    self.lblPurchaseAmount.textColor = [ColorHelper getTipColor6];
    self.lblPurchaseAmount.textAlignment = NSTextAlignmentCenter;
    [self.backView addSubview:self.lblPurchaseAmount];
    
    //分割线
    self.viewLine = [[UIView alloc] init];
    self.viewLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self.backView addSubview:self.viewLine];
}

- (void)configConstraints {
    __weak typeof(self) wself = self;
    CGFloat margin = 10;
    CGFloat top = 10;
    
    [self.backView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.contentView.left).offset(margin);
        make.right.equalTo(wself.contentView.right).offset(-margin);
        make.top.bottom.equalTo(wself.contentView);
    }];
    
    //分割线
    [self.viewLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself.backView);
        make.height.equalTo(1);
    }];
    
    //左边分割线
    UIView *viewLeftLine = [[UIView alloc] init];
    viewLeftLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self.backView addSubview:viewLeftLine];
    [viewLeftLine makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(wself.backView);
        make.left.left.equalTo(wself.backView);
        make.width.equalTo(1);
    }];
    
    //右边中心分割线
    UIView *viewRightCenterLine = [[UIView alloc] init];
    viewRightCenterLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self.backView addSubview:viewRightCenterLine];
    [viewRightCenterLine makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(wself.backView);
        make.right.equalTo(wself.backView.right).offset(-80);
        make.width.equalTo(1);
    }];
    
    //左边边中心分割线
    UIView *viewLeftCenterLine = [[UIView alloc] init];
    viewLeftCenterLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self.backView addSubview:viewLeftCenterLine];
    [viewLeftCenterLine makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(wself.backView);
        make.right.equalTo(viewRightCenterLine.right).offset(-60);
        make.width.equalTo(1);
    }];
    
    //右边分割线
    UIView *viewRightLine = [[UIView alloc] init];
    viewRightLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self.backView addSubview:viewRightLine];
    [viewRightLine makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(wself.backView);
        make.right.equalTo(wself.backView);
        make.width.equalTo(1);
    }];
    
    //商品名称
    [self.lblGoodsName makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.backView).offset(margin);
        make.right.equalTo(wself.backView.right).offset(-140);
        make.top.equalTo(wself.backView).offset(top);
    }];
    
    //单号
    [self.lblCode makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(wself.lblGoodsName);
        make.top.equalTo(wself.lblGoodsName.bottom);
        make.bottom.equalTo(wself.backView).offset(-top);
    }];
    
    //进/退货量
    [self.lblPurchaseNum makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewLeftCenterLine.right);
        make.right.equalTo(viewRightCenterLine.left);
        make.top.bottom.equalTo(wself.backView);
    }];
    
    //进/退货量金额
    [self.lblPurchaseAmount makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewRightCenterLine.right);
        make.right.equalTo(viewRightLine.left);
        make.top.bottom.equalTo(wself.backView);
    }];
}

- (void)setObj:(LSSuppilerPurchaseVo *)obj {
    _obj = obj;
    //商品名称
    self.lblGoodsName.text = obj.goodsName;
    [self.lblGoodsName sizeToFit];
    CGFloat height = [[self class] heightForContent:obj.goodsName];
    CGRect tempFrame = self.lblGoodsName.frame;
    tempFrame.size.height = height;
    self.lblGoodsName.frame = tempFrame;
    
    //单号:服鞋显示款号styleCode
    if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {
        self.lblCode.text = [NSString stringWithFormat:@"款号: %@",obj.styleCode];
    } else {
        self.lblCode.text = obj.barCode;
    }
    
    //进/退货量、进/退货量金额
    if ([ObjectUtil isNotNull:obj.invoiceFlag]) {
        if (obj.invoiceFlag.intValue == 1) {
            //进货
            if ([ObjectUtil isNotNull:obj.stockNum]) {
                if ([obj.stockNum.stringValue containsString:@"."]) {
                    self.lblPurchaseNum.text = [NSString stringWithFormat:@"%.3f", obj.stockNum.doubleValue];
                } else {
                    self.lblPurchaseNum.text = [NSString stringWithFormat:@"%.f", obj.stockNum.doubleValue];
                }
                self.lblPurchaseAmount.text = [NSString stringWithFormat:@"¥%.2f", obj.goodsPrice.doubleValue];
            }
        } else {
            if ([ObjectUtil isNotNull:obj.returnNum]) {
                if ([obj.returnNum.stringValue containsString:@"."]) {
                    self.lblPurchaseNum.text = [NSString stringWithFormat:@"%.3f", obj.returnNum.doubleValue];
                } else {
                    self.lblPurchaseNum.text = [NSString stringWithFormat:@"%.f", obj.returnNum.doubleValue];
                }
                self.lblPurchaseAmount.text = [NSString stringWithFormat:@"¥%.2f", obj.goodsPrice.doubleValue];
            }
        }
    }
}

+ (CGFloat)heightForContent:(NSString *)content
{
    CGSize size = CGSizeMake((SCREEN_W-140-21-21), 10000);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15.0], NSFontAttributeName, nil];
    CGRect frame = [content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return frame.size.height;
}

@end
