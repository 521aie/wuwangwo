//
//  LSSelectMemberCell.m
//  retailapp
//
//  Created by guozhi on 2016/10/28.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSSelectMemberCell.h"

@interface LSSelectMemberCell ()
/** 活动名称 */
@property (nonatomic, strong) UILabel *lblMemberName;
/** 分割线 */
@property (nonatomic, strong) UIView *viewLine;
/** 选中图标 */
@property (nonatomic, strong) UIImageView *imgView;
@end

@implementation LSSelectMemberCell
+ (instancetype)selectMemberCellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"cell";
    LSSelectMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[LSSelectMemberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        [cell configViews];
        [cell configConstraints];
    }
    return cell;
}
- (void)configViews {
    //设置活动名称
    self.lblMemberName = [[UILabel alloc] init];
    self.lblMemberName.font = [UIFont systemFontOfSize:15];
    self.lblMemberName.textColor = [ColorHelper getTipColor3];
    self.lblMemberName.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:self.lblMemberName];
    
    //设置选中不选择图标
    self.imgView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.imgView];
    
    //设置分割线
    self.viewLine = [[UIView alloc] init];
    self.viewLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [self.contentView addSubview:self.viewLine];
}

- (void)configConstraints {
    //设置选中不选择约束
    CGFloat margin = 10;
    __weak typeof(self) wself = self;
    [self.imgView makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(22, 22));
        make.centerY.equalTo(wself.contentView);
        make.left.equalTo(wself.contentView).offset(margin);
    }];
    //设置名称约束
    [self.lblMemberName makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(wself.contentView);
        make.left.equalTo(wself.imgView.right).offset(margin);
        make.right.equalTo(wself.contentView.right).offset(-margin);
    }];
    //设置分割线约束
    [self.viewLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself.contentView);
        make.height.equalTo(1);
    }];
}

- (void)setCardVo:(LSMemberTypeVo *)cardVo {
    _cardVo = cardVo;
    self.lblMemberName.text = _cardVo.name;
    NSString *fileName = nil;
    if (cardVo.isSelect) {
        fileName = @"ico_check";
    } else {
        fileName = @"ico_uncheck";
    }
    self.imgView.image = [UIImage imageNamed:fileName];
}
@end

