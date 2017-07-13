//
//  LSHelpVideoListCell.m
//  retailapp
//
//  Created by guozhi on 2017/2/28.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSHelpVideoListCell.h"
@interface LSHelpVideoListCell()
/** 名字 */
@property (nonatomic, strong) UILabel *lblName;
/** 播放图标 */
@property (nonatomic, strong) UIImageView *imgViewPlay;
/** 分割线 */
@property (nonatomic, strong) UIView *viewLine;
@end

@implementation LSHelpVideoListCell
+ (instancetype)helpVideoListCellWithTableView:(UITableView *)tableView {
    static NSString *cellIdentifier = @"cell";
    LSHelpVideoListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[LSHelpVideoListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configViews];
        [cell configConstraints];
    }
    return cell;
}

- (void)configViews {
    //名字
    self.lblName = [[UILabel alloc] init];
    self.lblName.font = [UIFont systemFontOfSize:16];
    self.lblName.textColor = [ColorHelper getTipColor3];
    [self.contentView addSubview:self.lblName];
    //播放图标
    self.imgViewPlay = [[UIImageView alloc] init];
    self.imgViewPlay.image = [UIImage imageNamed:@"icon_play"];
    [self.contentView addSubview:self.imgViewPlay];
    //分割线
    self.viewLine = [[UIView alloc] init];
    self.viewLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [self.contentView addSubview:self.viewLine];
}

- (void)configConstraints {
    //名字
    __weak typeof(self) wself = self;
    [self.lblName makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.contentView.left).offset(20);
        make.centerY.equalTo(wself.contentView.centerY);
    }];
    //播放图标
    [self.imgViewPlay makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wself.contentView.right).offset(-30);
        make.centerY.equalTo(wself.contentView.centerY);
        make.size.equalTo(36);
    }];
    //分割线
    [self.viewLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself.contentView);
        make.height.equalTo(1);
    }];
}

- (void)setObj:(LSVideoItemVo *)obj {
    _obj = obj;
    self.lblName.text = obj.vedioName;
}
@end
