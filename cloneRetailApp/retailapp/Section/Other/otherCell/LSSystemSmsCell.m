//
//  LSSystemSmsCell.m
//  retailapp
//
//  Created by guozhi on 2016/11/3.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSSystemSmsCell.h"
#import "DateUtils.h"
@interface LSSystemSmsCell()
/** 通知标题 */
@property (nonatomic, strong) UILabel *lblNotificationTitle;
/** 通知图片 */
@property (nonatomic, strong) UIImageView *imgView;
/** 通知详情 */
@property (nonatomic, strong) UILabel *lblNotificationDetail;
/** 通知标题下方分割线 */
@property (nonatomic, strong) UIView *line;
/** 新消息标志 */
@property (nonatomic, strong) UIImageView *imgNewsStatus;
/** <#注释#> */
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation LSSystemSmsCell
+ (instancetype)systemSmsCellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"cell";
    LSSystemSmsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[LSSystemSmsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        [cell configViews];
        [cell configConstraints];
        cell.tableView = tableView;
        
    }
    return cell;
}

- (void)configViews {
    //配置通知标题
    self.lblNotificationTitle = [[UILabel alloc] init];
    self.lblNotificationTitle.font = [UIFont  systemFontOfSize:15];
    self.lblNotificationTitle.numberOfLines = 0;
    self.lblNotificationTitle.textColor = [ColorHelper getRedColor];
    [self.contentView addSubview:self.lblNotificationTitle];
    
    //配置标题下方分割线
    self.line = [[UIView alloc] init];
    self.line.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [self.contentView addSubview:self.line];
    
    //配置图片
    self.imgView = [[UIImageView alloc] init];
    self.imgView.contentMode = UIViewContentModeRedraw;
    [self.contentView addSubview:self.imgView];
    
    //配置通知详情
    self.lblNotificationDetail = [[UILabel alloc] init];
    self.lblNotificationDetail.font = [UIFont systemFontOfSize:14];
    self.lblNotificationDetail.numberOfLines = 0;
    self.lblNotificationDetail.textColor = [ColorHelper getTipColor3];
    [self.contentView addSubview:self.lblNotificationDetail];
    
    //配置新消息标志
    self.imgNewsStatus = [[UIImageView alloc] init];
    self.imgNewsStatus.image = [UIImage imageNamed:@"ico_news"];
    [self.contentView addSubview:self.imgNewsStatus];
}

- (void)configConstraints {
    __weak typeof(self) wself = self;
    CGFloat margin = 10;
    self.lblNotificationDetail.preferredMaxLayoutWidth = SCREEN_W - 20;
    self.lblNotificationTitle.preferredMaxLayoutWidth = SCREEN_W - 20;
    
    //配置通知标题
    [self.lblNotificationTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.contentView.top).offset(margin);
        make.left.equalTo(wself. contentView.left).offset(margin);
        make.right.equalTo(wself.contentView.right).offset(-margin);
    }];
    
    //配置新消息标志
    [self.imgNewsStatus makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.contentView.left).offset(margin);
        make.centerY.equalTo(wself.lblNotificationTitle.centerY);
        make.size.equalTo(CGSizeMake(22, 22));
    }];
    
    //配置通知图片
    [self.imgView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.contentView.left).offset(margin);
        make.right.equalTo(wself.contentView.right).offset(-margin);
        make.top.equalTo(wself.lblNotificationTitle.bottom).offset(margin);
        make.height.equalTo(0);
    }];
    
    // 配置消息详情
    [self.lblNotificationDetail remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.contentView.left).offset(margin);
        make.right.equalTo(wself.contentView.right).offset(-margin);
        make.top.equalTo(wself.imgView.bottom).offset(margin);
    }];
    
    //配置分割线
    [self.line makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.contentView.left);
        make.right.equalTo(wself.contentView.right);
        make.top.equalTo(wself.lblNotificationDetail.bottom).offset(margin);
        make.height.equalTo(1);
        make.bottom.equalTo(wself.contentView.bottom);
    }];
}

//- (void)updateConstraintsIfNeeded {
//    [super updateConstraintsIfNeeded];
//    
//}

- (void)updateConstraints {
    [super updateConstraints];
    
    CGFloat margin = 10.0;
    __weak typeof(self) wself = self;
    CGFloat leftSpace = self.imgNewsStatus.hidden ? margin : margin + 27.0;
    [self.lblNotificationTitle remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.contentView.top).offset(margin);
        make.left.equalTo(wself. contentView.left).offset(leftSpace);
        make.right.equalTo(wself.contentView.right).offset(-margin);
    }];
    
    
    CGFloat imageHeight = 0;
    if (self.imgView.image) {
       CGSize imageSize = self.imgView.image.size;
        imageHeight = imageSize.height/imageSize.width * (CGRectGetWidth([UIScreen mainScreen].bounds) - 2*margin);
    }
    [self.imgView remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.contentView.left).offset(margin);
        make.right.equalTo(wself.contentView.right).offset(-margin);
        make.top.equalTo(wself.lblNotificationTitle.bottom).offset(margin);
        make.height.equalTo(imageHeight);
    }];
}

- (void)setSystemNotificationVo:(LSSystemNotificationVo *)systemNotificationVo {
    _systemNotificationVo = systemNotificationVo;
    self.lblNotificationTitle.text = systemNotificationVo.name;
    self.lblNotificationDetail.text = systemNotificationVo.memo;
    long long createTime = systemNotificationVo.createTime;
    //7天内的消息是新消息
    NSString *sevenAgoTime = [DateUtils formateChineseTime3:([[NSDate date] timeIntervalSince1970] * 1000 - 7 *24*60*60*1000)];
    NSString *currentTime = [DateUtils formateChineseTime3:createTime];
    NSComparisonResult result = [currentTime compare:sevenAgoTime];
    
    if (result == NSOrderedDescending) {//新消息图标显示
        self.imgNewsStatus.hidden = NO;
    } else {//新消息图片不显示
        self.imgNewsStatus.hidden = YES;
    }
    
    self.imgView.image = nil;
    NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/upload_files/%@", systemNotificationVo.server, systemNotificationVo.path]];
    if (![[SDWebImageManager sharedManager] cacheKeyForURL:imageURL]) {
        [self.imgView sd_setImageWithURL:imageURL];
    } else {
        [self.imgView sd_setImageWithURL:imageURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (!error && image) {
                if ([self.delegate respondsToSelector:@selector(needReloadVisibleCell:)]) {
                    [self.delegate needReloadVisibleCell:self];
                }
            }
        }];
    }
    [self setNeedsUpdateConstraints];
}

@end
