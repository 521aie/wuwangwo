//
//  LSMeterAdjustStyleCell.m
//  retailapp
//
//  Created by wuwangwo on 2017/3/31.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMeterAdjustStyleCell.h"
#import "LSMemberMeterGoodsVo.h"

@interface LSMeterAdjustStyleCell ()
@property (nonatomic, strong) UILabel *lblName;
@property (nonatomic, strong) UILabel *lblCode;
@property (nonatomic, strong) UILabel *lblCount;
@property (nonatomic, strong) UIView *viewLine;
@end

@implementation LSMeterAdjustStyleCell

+ (instancetype)meterAdjustStyleCellWithTableView:(UITableView *)tableView{
    static NSString *cellIdentifier = @"LSMeterAdjustStyleCell";
    LSMeterAdjustStyleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[LSMeterAdjustStyleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
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
    self.lblName.numberOfLines = 0;
    self.lblName.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:self.lblName];
    
    self.lblCode = [[UILabel alloc] init];
    self.lblCode.font = [UIFont systemFontOfSize:13];
    self.lblCode.textColor = [ColorHelper getTipColor6];
    [self.contentView addSubview:self.lblCode];
    
    self.lblCount = [[UILabel alloc] init];
    self.lblCount.textAlignment = 2;
    self.lblCount.font = [UIFont systemFontOfSize:13];
    self.lblCount.textColor = [ColorHelper getTipColor6];
    [self.contentView addSubview:self.lblCount];
    
    //分割线
    self.viewLine = [[UIView alloc] init];
    self.viewLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [self.contentView addSubview:self.viewLine];
}

- (void)configConstraints {
    __weak typeof(self) wself = self;
    
    [self.lblName makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.contentView).offset(19);
        make.left.equalTo(wself.contentView).offset(12);
        make.right.equalTo(wself.contentView).offset(-10);
    }];
    
    [self.lblCode makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.lblName.bottom).offset(19);
        make.left.equalTo(wself.lblName.left);
        make.right.equalTo(wself.lblCount.left);
        make.bottom.equalTo(wself.contentView).offset(-19);        
        make.height.equalTo(13);
    }];
    
    [self.lblCount makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.lblCode.top);
        make.right.equalTo(wself.contentView).offset(-10);
        make.width.equalTo(100);
        make.height.equalTo(13);
    }];
    
    //分割线
    [self.viewLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself.contentView);
        make.height.equalTo(1);
    }];
}

- (void)setObj:(LSMemberMeterGoodsVo *)obj {
    _obj = obj;
    self.lblName.text = obj.goodsName;
    self.lblCode.text = obj.barCode;
    self.lblCount.text = [NSString stringWithFormat:@"数量：%d",obj.consumeTime];
}
@end
