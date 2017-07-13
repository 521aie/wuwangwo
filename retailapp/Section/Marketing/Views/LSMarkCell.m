//
//  LSMarkCell.m
//  retailapp
//
//  Created by guozhi on 2016/10/28.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMarkCell.h"
@interface LSMarkCell ()
/** 活动名称 */
@property (nonatomic, strong) UILabel *lblName;
/** 分割线 */
@property (nonatomic, strong) UIView *viewLine;
/** 下一个图标 */
@property (nonatomic, strong) UIImageView *imgView;
@end

@implementation LSMarkCell
+ (instancetype)markCellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"mark";
    LSMarkCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[LSMarkCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        [cell configViews];
        [cell configConstraints];
    }
    return cell;
}
- (void)configViews {
    //设置活动名称
    self.lblName = [[UILabel alloc] init];
    self.lblName.font = [UIFont systemFontOfSize:13];
    self.lblName.textColor = [ColorHelper getTipColor3];
    self.lblName.numberOfLines = 0;
    [self.contentView addSubview:self.lblName];
    
    //设置下一个图标
    self.imgView = [[UIImageView alloc] init];
    self.imgView.image = [UIImage imageNamed:@"ico_next"];
    [self.contentView addSubview:self.imgView];
    
    //设置分割线
    self.viewLine = [[UIView alloc] init];
    self.viewLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [self.contentView addSubview:self.viewLine];
}

-(void)setName:(NSString *)name {
    self.lblName.text = name;
}

- (void)configConstraints {
    //设置下一个图片约束
    CGFloat margin = 10;
    __weak typeof(self) wself = self;
    [self.imgView makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(22, 22));
        make.centerY.equalTo(wself.contentView);
        make.right.equalTo(wself.right).offset(-margin);
    }];
    //设置名称约束
    [self.lblName makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(wself.contentView);
        make.left.equalTo(wself.contentView).offset(margin);
        make.right.equalTo(wself.imgView.left).offset(-margin);
    }];
    //设置分割线约束
    [self.viewLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself.contentView);
        make.height.equalTo(1);
    }];
}
@end
