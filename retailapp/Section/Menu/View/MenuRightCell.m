//
//  MenuRightCell.m
//  retailapp
//
//  Created by taihangju on 16/6/21.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "MenuRightCell.h"
#import "JSBadgeView.h"

@interface MenuRightCell()
/** 头像 */
@property (nonatomic, strong) UIImageView *imgIcon;
/** 标题 */
@property (nonatomic, strong) UILabel *titleText;
/** 分割线 */
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) JSBadgeView *badgeView;
@end
@implementation MenuRightCell

+ (instancetype)menuRightCellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"cell";
    MenuRightCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[MenuRightCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        [cell configViews];
        [cell configConstraints];
    }
    return cell;
}

- (void)configViews {
    //头像
    self.imgIcon = [[UIImageView alloc] init];
    [self.contentView addSubview:self.imgIcon];
    //菜单内容
    self.titleText = [[UILabel alloc] init];
    self.titleText.textColor = [UIColor colorWithRed:38/255.0 green:38/255.0 blue:38/255.0 alpha:1];
    self.titleText.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.titleText];
    //设置红点(消息中心有消息时显示)
    self.imgNotice = [[UIImageView alloc] init];
    self.imgNotice.image = [UIImage imageNamed:@"ico_notice"];
    [self.contentView addSubview:self.imgNotice];
    //设置分割线
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [self.contentView addSubview:self.lineView];
    self.badgeView = [[JSBadgeView alloc] initWithParentView:self.contentView alignment:JSBadgeViewAlignmentCenterRight];
    self.badgeView.badgePositionAdjustment = CGPointMake(-35, 0);
    self.badgeView.badgeBackgroundColor = [UIColor colorWithRed:204/255.0 green:0/255.0 blue:0/255.0 alpha:0.8];
}

- (void)setUnreadNumber:(NSUInteger)number {
    if (number < 100) {
        self.badgeView.badgeText = [NSString stringWithFormat:@"%lu", (unsigned long) number];
    }else {
        self.badgeView.badgeText = @"...";
    }
    
    self.badgeView.hidden = number == 0;
}

- (void)configConstraints {
    //设置头像
    __weak typeof(self) wself = self;
    [self.imgIcon makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(32);
        make.left.equalTo(30);
        make.centerY.equalTo(wself.contentView.centerY);
    }];
    //设置菜单内容
    [self.titleText makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.imgIcon.right).offset(10);
        make.centerY.equalTo(wself.contentView.centerY);
    }];
    //设置红点
    [self.imgNotice makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.titleText.right).offset(13);
        make.centerY.equalTo(wself.contentView.centerY);
        make.size.equalTo(10);
    }];
    //设置分割线
    [self.lineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.contentView.left).offset(10);
        make.right.equalTo(wself.contentView.right).offset(-10);
        make.bottom.equalTo(wself.contentView.bottom);
        make.height.equalTo(1);
    }];
    
}

// {@"image":@"ico_more_pw" ,@"title":@"修改密码" ,@"hiddeLine":@(0)}
- (void)fillData:(NSDictionary *)dic
{
    [self.imgIcon setImage:[UIImage imageNamed:dic[@"image"]]];
    [self.titleText setText:dic[@"title"]];
    self.lineView.hidden = [dic[@"hiddeLine"] boolValue];
    if ([dic[@"title"] isEqualToString:@"消息中心"] &&([[[Platform Instance] getkey:STOCK_WARNNING] isEqualToString:@"1"] || [[[Platform Instance] getkey:OVERDUE_ALERT] isEqualToString:@"1"] || [[[Platform Instance] getkey:NOTICE_SMS] isEqualToString:@"1"] || [[[Platform Instance] getkey:NOTICE_SYSTEM] isEqualToString:@"1"])) {
        self.imgNotice.hidden = NO;
    } else {
        self.imgNotice.hidden = YES;
    }
    if ([dic[@"title"] isEqualToString:@"系统通知"]) {
        id data = [[Platform Instance] getkey:SYSTEM_NOFITICATION_NUM];
        if ([ObjectUtil isNotNull:data]) {
            [self setUnreadNumber:[data intValue]];
        }
        NSString *userId = [[Platform Instance] getkey:USER_ID];
        NSString *notificationId = [[Platform Instance] getkey:NOFITICATION_ID];
        NSString *key = [NSString stringWithFormat:@"%@ %@ %@", SYSTEM_NOFITICATION, userId, notificationId];
        if ([NSString isNotBlank:key] && [[[Platform Instance] getkey:key] isEqualToString:@"1"]) {
            [self setUnreadNumber:[data intValue]];

        } else {
            self.badgeView.hidden = YES;
        }
    } else {
        self.badgeView.hidden = YES;
    }
}

@end
