//
//  LSRightFilterListCell.m
//  retailapp
//
//  Created by guozhi on 2017/1/12.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRightFilterListCell.h"
#import "LSRightFilterListView.h"

@interface LSRightFilterListCell ()
/** 标签图片 */
@property (nonatomic, strong) UIImageView *imgViewTag;
/** 分类名称 */
@property (nonatomic, strong) UILabel *lblName;
/** 分割线 */
@property (nonatomic, strong) UIView *viewLine;


@end

@implementation LSRightFilterListCell
+ (instancetype)rightFilterListCellWithTableView:(UITableView *)tableView {
    static NSString *cellIdentifier = @"cell";
    LSRightFilterListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[LSRightFilterListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configViews];
        [cell configConstraints];
    }
    return cell;
}

- (void)configViews {
    //标签图片
    self.imgViewTag = [[UIImageView alloc] init];
    self.imgViewTag.image = [UIImage imageNamed:@"filter_category_tag"];
    [self.contentView addSubview:self.imgViewTag];
    //分类名称
    self.lblName = [[UILabel alloc] init];
    self.lblName.textColor = [ColorHelper getTipColor6];
    self.lblName.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.lblName];
    //分割线
    self.viewLine = [[UIView alloc] init];
    self.viewLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [self.contentView addSubview:self.viewLine];
}


- (void)configConstraints {
    //标签图片
    __weak typeof(self) wself = self;
    [self.imgViewTag makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(wself.contentView);
        make.left.equalTo(wself.contentView.left).offset(20);
    }];
    //分类名称
    [self.lblName makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.imgViewTag.right).offset(20);
        make.centerY.equalTo(wself.contentView);
    }];
    //分割线
    [self.viewLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.contentView.left).offset(10);
        make.right.equalTo(wself.contentView).offset(-10);
        make.bottom.equalTo(wself.contentView);
        make.height.equalTo(1);
    }];
    
}
- (void)setObj:(id<INameItem>)obj {
    self.lblName.text = [obj obtainItemName];
}



@end
