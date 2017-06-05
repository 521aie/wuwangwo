//
//  LSMemberMeterListCell.m
//  retailapp
//
//  Created by wuwangwo on 2017/3/28.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberMeterListCell.h"
#import "LSMemberMeterVo.h"

@interface LSMemberMeterListCell ()

@property (nonatomic, strong) UIView *viewWhite;
@property (nonatomic, strong) UIView *viewGray;
@property (nonatomic, strong) UIImageView *viewCircleLine;
//售价
@property (nonatomic, strong) UILabel *price;
//计次卡名称
@property (nonatomic, strong) UILabel *cardName;
//有效期（天）：“不限期”或N天
@property (nonatomic, strong) UILabel *period;
//计次商品（个）：计次商品的种类数量
@property (nonatomic, strong) UILabel *txtMeteringGoods;
@property (nonatomic, strong) UILabel *meteringGoods;
//已销售（张）：收银端充值计次卡之后+1
@property (nonatomic, strong) UILabel *txtCardCount;
@property (nonatomic, strong) UILabel *cardCount;
@property (nonatomic, strong) UIView *viewLine;
@end

@implementation LSMemberMeterListCell

+ (instancetype)memberMeteringListCellWithTableView:(UITableView *)tableView{
    
    static NSString *cellIdentifier = @"cell";
    LSMemberMeterListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        
        cell = [[LSMemberMeterListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configViews];
        [cell configConstraints];
    }
    return cell;
}

- (void)configViews {
    
    self.viewWhite = [[UIView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_W-20, 77)];
    self.viewWhite.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.viewWhite];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.viewWhite.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(6, 6)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.viewWhite.bounds;
    maskLayer.path = maskPath.CGPath;
    self.viewWhite.layer.mask = maskLayer;
    
    self.viewCircleLine = [[UIImageView alloc] init];
    self.viewCircleLine.image = [UIImage imageNamed:@"ico_byTime_line1"];
    [self.contentView addSubview:self.viewCircleLine];
    
    self.viewGray = [[UIView alloc] initWithFrame:CGRectMake(10, 94, SCREEN_W-20, 41)];
    self.viewGray.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.00];
    [self.contentView addSubview:self.viewGray];
    
    UIBezierPath *maskPathG = [UIBezierPath bezierPathWithRoundedRect:self.viewGray.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(6, 6)];
    CAShapeLayer *maskLayerG = [[CAShapeLayer alloc] init];
    maskLayerG.frame = self.viewGray.bounds;
    maskLayerG.path = maskPathG.CGPath;
    self.viewGray.layer.mask = maskLayerG;
    
    self.cardName = [[UILabel alloc] init];
    self.cardName.font = [UIFont systemFontOfSize:15];
    self.cardName.textColor = [ColorHelper getTipColor3];
    self.cardName.numberOfLines = 0;
    self.cardName.lineBreakMode = NSLineBreakByWordWrapping;
    [self.viewWhite addSubview:self.cardName];
    
    self.price = [[UILabel alloc] init];
    self.price.font = [UIFont systemFontOfSize:13];
    self.price.textColor = [ColorHelper getOrangeColor];
    self.price.textAlignment = 1;
    [self.viewWhite addSubview:self.price];
    
    self.period = [[UILabel alloc] init];
    self.period.font = [UIFont systemFontOfSize:12];
    self.period.textColor = [ColorHelper getTipColor9];
    [self.viewWhite addSubview:self.period];
    
    self.txtMeteringGoods = [[UILabel alloc] init];
    self.txtMeteringGoods.font = [UIFont systemFontOfSize:12];
    self.txtMeteringGoods.textColor = [ColorHelper getTipColor6];
    self.txtMeteringGoods.text = @"计次商品（项）";
    self.txtMeteringGoods.textAlignment = 1;
    [self.viewGray addSubview:self.txtMeteringGoods];
    
    self.meteringGoods = [[UILabel alloc] init];
    self.meteringGoods.font = [UIFont systemFontOfSize:15];
    self.meteringGoods.textColor = [ColorHelper getTipColor3];
    self.meteringGoods.textAlignment = 1;
    [self.viewGray addSubview:self.meteringGoods];
    
    self.txtCardCount = [[UILabel alloc] init];
    self.txtCardCount.font = [UIFont systemFontOfSize:12];
    self.txtCardCount.textColor = [ColorHelper getTipColor6];
    self.txtCardCount.text = @"已销售（张)";
    self.txtCardCount.textAlignment = 1;
    [self.viewGray addSubview:self.txtCardCount];
    
    self.cardCount = [[UILabel alloc] init];
    self.cardCount.font = [UIFont systemFontOfSize:15];
    self.cardCount.textColor = [ColorHelper getTipColor3];
    self.cardCount.textAlignment = 1;
    [self.viewGray addSubview:self.cardCount];
    
    self.viewLine = [[UIView alloc] init];
    self.viewLine.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.viewLine];
}

- (void)configConstraints {
    
    [self.cardName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.viewWhite).offset(12);
        make.left.equalTo(self.viewWhite).offset(9);
        make.right.equalTo(self.price.left);
        make.height.equalTo(21);
    }];
    
    [self.price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.viewWhite).offset(27);
        make.right.equalTo(self.viewWhite).offset(19);
        make.width.equalTo(102);
        make.height.equalTo(22);
    }];
    
    [self.period mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cardName.bottom).offset(14);
        make.left.equalTo(self.cardName);
        make.right.equalTo(self.viewWhite);
        make.height.equalTo(17);
    }];
    
    [self.viewCircleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.viewWhite.bottom).offset(-1);
        make.left.right.equalTo(self.viewWhite);
        make.height.equalTo(9);
    }];
    
    [self.viewLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.viewGray).offset(2);
        make.left.equalTo(self.viewGray).offset(SCREEN_W/2-1);
        make.bottom.equalTo(self.viewGray).offset(-5);
        make.width.equalTo(1);
    }];

    [self.txtMeteringGoods mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.viewGray).offset(4);
        make.left.equalTo(self.viewGray.left);
        make.right.equalTo(self.viewLine.left);
        make.height.equalTo(12);
    }];
    
    [self.meteringGoods mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.txtMeteringGoods);
        make.bottom.equalTo(self.viewGray.bottom);
        make.height.equalTo(18);
    }];
    
    [self.txtCardCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.txtMeteringGoods.top);
        make.left.equalTo(self.viewLine.right);
        make.right.equalTo(self.viewGray.right);
        make.height.equalTo(self.txtMeteringGoods);
    }];
    
    [self.cardCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.txtCardCount);
        make.bottom.equalTo(self.viewGray.bottom);
        make.height.equalTo(self.meteringGoods);
    }];
}

- (void)setObj:(LSMemberMeterVo *)obj {
    
    _obj = obj;
    
    self.cardName.text = obj.accountCardName;
    
    //售价
    self.price.text = [NSString stringWithFormat: @"￥%@",obj.price];
    
    //有效期（天）：不限期”或N天
    if (obj.expiryDate.integerValue == -1) {
        
        self.period.text = [NSString stringWithFormat: @"有效期（天）：不限期"];
        
    } else {
        
        self.period.text = [NSString stringWithFormat: @"有效期（天）：%ld",(long)obj.expiryDate.integerValue];
    }
    
    self.meteringGoods.text =  [NSString stringWithFormat: @"%ld",(long)obj.goodsKindCount.integerValue];
    
    self.cardCount.text = [NSString stringWithFormat: @"%ld",(long)obj.salesNum.integerValue];
}

@end
