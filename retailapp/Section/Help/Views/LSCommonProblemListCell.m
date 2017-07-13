//
//  LSCommonProblemListCell.m
//  retailapp
//
//  Created by guozhi on 2017/3/4.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSCommonProblemListCell.h"

@interface LSCommonProblemListCell ()
/** 下一个图标 */
@property (nonatomic, strong) UIImageView *imgViewNext;
/** 名字 */
@property (nonatomic, strong) UILabel *lblName;
/** line */
@property (nonatomic, strong) UIView *viewLine;
@end

@implementation LSCommonProblemListCell

+ (instancetype)commonProblemListCellWithTableView:(UITableView *)tableView {
    static NSString *cellIdentifier = @"cell";
    LSCommonProblemListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[LSCommonProblemListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configViews];
        [cell configConstraints];
    }
    return cell;
}

- (void)configViews {
    //名字
    self.lblName = [[UILabel alloc] init];
    self.lblName.textColor = [ColorHelper getTipColor3];
    self.lblName.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.lblName];
    //下一个图标
    self.imgViewNext = [[UIImageView alloc] init];
    self.imgViewNext.image = [UIImage imageNamed:@"ico_next"];
    [self.contentView addSubview:self.imgViewNext];
    //横线
    self.viewLine = [[UIView alloc] init];
    self.viewLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [self.contentView addSubview:self.viewLine];
}

- (void)configConstraints {
    __weak typeof(self) wself = self;
    //名字
    [self.lblName makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.contentView).offset(10);
         make.right.equalTo(wself.imgViewNext.left);
        make.centerY.equalTo(wself.contentView);
    }];
    //下一个图标
    [self.imgViewNext makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wself.contentView).offset(-10);
        make.centerY.equalTo(wself.contentView);
        make.size.equalTo(22);
    }];
    //横线
    [self.viewLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.contentView).offset(10);
        make.right.equalTo(wself.contentView).offset(-10);
        make.bottom.equalTo(wself.contentView);
        make.height.equalTo(1);
    }];
    
}

- (void)setObj:(LSCommonProblemListVo *)obj {
    _obj = obj;
    self.lblName.text = obj.titleName;
}




@end

