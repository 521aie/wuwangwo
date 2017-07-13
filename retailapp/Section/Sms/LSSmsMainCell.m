//
//  LSSmsMainCell.m
//  retailapp
//
//  Created by wuwangwo on 2017/2/10.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSSmsMainCell.h"
#import "DateUtils.h"
#import "Notice.h"

@interface LSSmsMainCell ()
@property (nonatomic,strong)  UIImageView* imgViewNext;
/** 分割线 */
@property (nonatomic, strong) UIView *viewLine;
@end

@implementation LSSmsMainCell
+ (instancetype)smsMainCellWithTableView:(UITableView *)tableView{
    static NSString* smsMainCellId = @"LSSmsMainCell";
    LSSmsMainCell* cell = [tableView dequeueReusableCellWithIdentifier:smsMainCellId];
    if (!cell) {
        cell =[[LSSmsMainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:smsMainCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        [cell configViews];
        [cell configConstraints];
    }
    return cell;
}

- (void)configViews {
    //标题
    self.lblName = [[UILabel alloc] init];
    self.lblName.font = [UIFont systemFontOfSize:16];
    self.lblName.textColor = [ColorHelper getTipColor3];
    [self.contentView addSubview:self.lblName];
    
    //读取状态
    self.lblVal = [[UILabel alloc] init];
    self.lblVal.font = [UIFont systemFontOfSize:16];
    self.lblVal.textAlignment = 2;
    self.lblVal.textColor = [ColorHelper getTipColor3];
    [self.contentView addSubview:self.lblVal];
    
    //发布时间
    self.lblDetail = [[UILabel alloc] init];
    self.lblDetail.font = [UIFont systemFontOfSize:13];
    self.lblDetail.textColor = [ColorHelper getTipColor6];
    [self.contentView addSubview:self.lblDetail];
    
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
    
    //标题
    [self.lblName makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.contentView).offset(margin);
        make.top.equalTo(wself.contentView).offset(23);
        make.width.equalTo(199);
        make.height.equalTo(21);
    }];
    
    //下一个图片
    [self.imgViewNext makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(22);
        make.right.equalTo(wself.contentView).offset(-margin);
        make.centerY.equalTo(wself.contentView);
    }];
    
    //读取状态
    [self.lblVal makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(wself.imgViewNext);
        make.left.equalTo(wself.lblName.right);
        make.right.equalTo(wself.imgViewNext.left);
    }];
    
    //发布时间
    [self.lblDetail makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.lblName);
        make.top.equalTo(wself.contentView).offset(49);
        make.right.equalTo(wself.lblVal.left);
        make.height.equalTo(21);
    }];
    
    //分割线
    [self.viewLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.equalTo(1);
    }];
}

- (void)setObj:(Notice *)obj{
    _obj = obj;

    self.lblName.text = obj.noticeTitle;
    self.lblVal.text = obj.status==1?@"未读":@"已读";
    self.lblVal.textColor = obj.status==1?[ColorHelper getBlueColor]:[ColorHelper getTipColor6];
    self.lblDetail.text = [NSString stringWithFormat:@"发布时间:%@",[DateUtils formateTime:obj.publishTime]];
}

@end
