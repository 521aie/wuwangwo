//
//  LSWechatGoodsSortCell.m
//  retailapp
//
//  Created by taihangju on 2017/3/14.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSWechatGoodsSortCell.h"
#import "Masonry.h"

@interface LSWechatGoodsSortCell ()

@property (nonatomic, strong) UIImageView *optImage;/**<选中状态图标>*/
@property (nonatomic, strong) UILabel *optionName;/**<选项名称>*/
@property (nonatomic, strong) UIView *viewLine;/**<分割线>*/
@end

@implementation LSWechatGoodsSortCell

+ (instancetype)wechatGoodsSortCellWith:(UITableView *)tableView {
    NSString *cellIdentifier = @"LSWechatGoodsSortCell";
    LSWechatGoodsSortCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[LSWechatGoodsSortCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
   
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
      
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        
        self.optImage = [[UIImageView alloc] init];
        self.optImage.image = [UIImage imageNamed:@"ico_uncheck"];
        [self.contentView addSubview:self.optImage];
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        
        self.optionName = [[UILabel alloc] init];
        self.optionName.font = [UIFont systemFontOfSize:15.0f];
        self.optionName.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.optionName];
        
        self.viewLine = [[UIView alloc] init];
        self.viewLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        [self.contentView addSubview:self.viewLine];
        
        __weak typeof(self) wself = self;
        [wself.optionName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wself.contentView.mas_left).offset(10.0f);
            make.centerY.equalTo(wself.contentView.mas_centerY);
            make.right.equalTo(wself.contentView.mas_right).offset(-30.0f);
        }];
        
        [wself.optImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(wself.contentView.mas_right).offset(-10.0f);
            make.centerY.equalTo(wself.contentView.mas_centerY);
            make.width.and.height.equalTo(@22);
        }];
        
        [wself.viewLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wself.contentView.mas_left);
            make.right.equalTo(wself.contentView.mas_right);
            make.bottom.equalTo(wself.contentView.mas_bottom);
            make.height.equalTo(@(1/[UIScreen mainScreen].scale));
        }];
        
    }
    return self;
}

- (void)setOptionName:(NSString *)name optStatus:(BOOL)status {
    self.optionName.text = name;
    if (status) {
        self.optImage.image = [UIImage imageNamed:@"ico_check"];
    } else {
        self.optImage.image = [UIImage imageNamed:@"ico_uncheck"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
