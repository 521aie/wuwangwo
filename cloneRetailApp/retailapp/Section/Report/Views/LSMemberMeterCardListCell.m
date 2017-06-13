//
//  LSMemberMeterCardListCell.m
//  retailapp
//
//  Created by wuwangwo on 2017/4/1.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberMeterCardListCell.h"
#import "LSMemberMeterCardListVo.h"
#import "DateUtils.h"

@interface LSMemberMeterCardListCell ()
/** 会员名（会员卡号） */
@property (nonatomic, strong) UILabel *lblMemberCardName;
/** 计次服务名称 */
@property (nonatomic, strong) UILabel *lblMeterCardName;
/** 销售金额 */
@property (nonatomic, strong) UILabel *lblSalePrice;
/** 充值时间 */
@property (nonatomic, strong) UILabel *lblTransactionTime;
/** 下一个图片 */
@property (nonatomic, strong) UIImageView *imgViewNext;
/** 分割线 */
@property (nonatomic, strong) UIView *viewLine;
@end

@implementation LSMemberMeterCardListCell

+ (instancetype)memberMeterCardListCellWithTableView:(UITableView *)tableView{
    static NSString *cellIdentifier = @"LSMemberMeterCardListCell";
    LSMemberMeterCardListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[LSMemberMeterCardListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        [cell configViews];
        [cell configConstraints];
    }
    return cell;
}

- (void)configViews {
    //会员名称
    self.lblMemberCardName = [[UILabel alloc] init];
    self.lblMemberCardName.font = [UIFont systemFontOfSize:15];
    self.lblMemberCardName.textColor = [ColorHelper getTipColor3];
    self.lblMemberCardName.numberOfLines = 0;
    self.lblMemberCardName.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:self.lblMemberCardName];
    
    //计次服务名称
    self.lblMeterCardName = [[UILabel alloc] init];
    self.lblMeterCardName.font = [UIFont systemFontOfSize:13];
    self.lblMeterCardName.textColor = [ColorHelper getTipColor6];
    self.lblMeterCardName.numberOfLines = 0;
    self.lblMeterCardName.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:self.lblMeterCardName];
    
    //销售价格
    self.lblSalePrice = [[UILabel alloc] init];
    self.lblSalePrice.font = [UIFont systemFontOfSize:13];
    self.lblSalePrice.textAlignment = 2;
    [self.contentView addSubview:self.lblSalePrice];
    
    //充值时间
    self.lblTransactionTime = [[UILabel alloc] init];
    self.lblTransactionTime.font = [UIFont systemFontOfSize:13];
    self.lblTransactionTime.textColor = [ColorHelper getTipColor6];
    self.lblTransactionTime.textAlignment = 2;
    [self.contentView addSubview:self.lblTransactionTime];
    
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
    
    [self.imgViewNext makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.contentView).offset(39);
        make.right.equalTo(wself.contentView).offset(-12);
        make.width.equalTo(8);
        make.height.equalTo(13);
    }];
    
    [self.lblSalePrice makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.contentView).offset(23);
        make.right.equalTo(wself.imgViewNext.left);
        make.width.equalTo(100);
        make.height.equalTo(12);
    }];
    
    [self.lblTransactionTime makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.lblMeterCardName.top);
        make.right.equalTo(wself.lblSalePrice.right);
        make.width.equalTo(SCREEN_W/2-20);
        make.height.equalTo(12);
    }];
    
    [self.lblMemberCardName makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.contentView).offset(top);
        make.left.equalTo(wself.contentView).offset(margin);
        make.right.equalTo(wself.lblSalePrice.left);
        make.bottom.equalTo(wself.lblMeterCardName.top).offset(-margin);
    }];
    
    [self.lblMeterCardName makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.lblMemberCardName.bottom).offset(margin);
        make.left.equalTo(wself.lblMemberCardName.left);
        make.right.equalTo(wself.lblTransactionTime.left);
        make.bottom.equalTo(wself.contentView).offset(-11);
    }];
    
    [self.viewLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself.contentView);
        make.height.equalTo(1);
    }];
}

- (void)setObj:(LSMemberMeterCardListVo *)obj {
    _obj = obj;
    if ([NSString isNotBlank:obj.memberName]) {
        self.lblMemberCardName.text = [NSString stringWithFormat:@"%@ (NO.%@)",obj.memberName,obj.memberNo];
    }
    
    if ([NSString isNotBlank:obj.accountCardName]) {
        self.lblMeterCardName.text = obj.accountCardName;
    }
    
    //operType; //操作类型（充值、退款）
    if (obj.pay.doubleValue >= 0) {
        self.lblSalePrice.textColor = [ColorHelper getRedColor];
        self.lblSalePrice.text =[NSString stringWithFormat:@"￥%.2f", obj.pay.floatValue];
    } else {
        self.lblSalePrice.textColor = [ColorHelper getGreenColor];
        NSMutableString *temp =[NSMutableString stringWithFormat:@"%.2f", obj.pay.floatValue];
        [temp insertString:@"￥" atIndex:1];
        self.lblSalePrice.text= temp;
    }
    
    NSString *time = [DateUtils formateTime:obj.createTime.longLongValue];
    if ([NSString isNotBlank:time]) {
        self.lblTransactionTime.text = time;
    }
}

@end
