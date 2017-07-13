//
//  LSMemberCardOperateListCell.m
//  retailapp
//
//  Created by wuwangwo on 17/1/6.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberCardOperateListCell.h"
#import "DateUtils.h"

@interface LSMemberCardOperateListCell ()
@property (nonatomic, strong) UILabel *card;//会员卡信息
@property (nonatomic, strong) UILabel *opTime;//操作时间
@property (nonatomic, strong) UILabel *action;//会员卡操作类型
@property (nonatomic, strong) UIImageView *imgNext;//下一个图标
@property (nonatomic, strong) UIView *viewLine;//分割线
@end

@implementation LSMemberCardOperateListCell

+ (instancetype)shopCollectionListCellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"cell";
    LSMemberCardOperateListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[LSMemberCardOperateListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configViews];
        [cell configConstraints];
    }
    return cell;
}

- (void)configViews {
    //会员卡信息
    self.card = [[UILabel alloc] init];
    self.card.font = [UIFont systemFontOfSize:15];
    self.card.textColor = [ColorHelper getTipColor3];
    [self.contentView addSubview:self.card];
    
    //操作时间
    self.opTime = [[UILabel alloc] init];
    self.opTime.font = [UIFont systemFontOfSize:13];
    self.opTime.textColor = [ColorHelper getTipColor6];
    [self.contentView addSubview:self.opTime];
    
    //会员卡操作类型
    self.action = [[UILabel alloc] init];
    self.action.font = [UIFont systemFontOfSize:13];
    self.action.textColor = [ColorHelper getTipColor3];
    [self.contentView addSubview:self.action];
    
    //下一个图标
    self.imgNext = [[UIImageView alloc] init];
    self.imgNext.image = [UIImage imageNamed:@"ico_next"];
    [self.contentView addSubview:self.imgNext];
    
    //分割线
    self.viewLine = [[UIView alloc] init];
    self.viewLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [self.contentView addSubview:self.viewLine];
}

- (void)configConstraints {
    CGFloat margin = 10;
    __weak typeof(self) wself = self;
    [self.card makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.contentView.left).offset(margin);
        make.top.equalTo(wself.contentView).offset(14);
        make.height.mas_equalTo(wself.contentView).multipliedBy(0.2);
    }];
    
    [self.opTime makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.card.bottom).offset(25);
        make.left.equalTo(wself.card);
         make.height.mas_equalTo(wself.contentView).multipliedBy(0.2);
    }];
    
    //下一个图标
    [self.imgNext makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wself.contentView.right).offset(-margin);
        make.centerY.equalTo(wself.contentView.centerY);
        make.size.equalTo(22);
    }];
    
    [self.action makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(wself.imgNext);
        make.right.equalTo(wself.imgNext.left);
    }];
    
    //分割线
    [self.viewLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself.contentView);
        make.height.equalTo(1);
    }];
}
	
-(void)setoperateVo:(LSCardOperateListVo *)operateVo showNextimg:(BOOL)show{
    self.operateVo = operateVo;

    NSString *customerName;
    NSString *kindCardName;
    NSString *cardCode;
    if (operateVo.customerName.length >= 5) {
        NSString *str1 = [operateVo.customerName substringToIndex:5];
        customerName = [NSString stringWithFormat:@"%@...",str1];
    }else{
        customerName = operateVo.customerName;
    }
    if (operateVo.kindCardName.length >= 5) {
        NSString *str1 = [operateVo.kindCardName substringToIndex:5];
        kindCardName = [NSString stringWithFormat:@"%@...",str1];
    }else{
        kindCardName = operateVo.kindCardName;
    }
    if (operateVo.cardCode.length >= 10) {
        NSString *str1 = [operateVo.cardCode substringToIndex:10];
        cardCode = [NSString stringWithFormat:@"%@...",str1];
    }else{
        cardCode = operateVo.cardCode;
    }
    self.card.text = [NSString stringWithFormat:@"%@(%@ %@)",customerName,kindCardName,cardCode];
    
    self.opTime.text = [DateUtils getTimeStringFromCreaateTime:operateVo.opTime.stringValue     format:@"yyyy-MM-dd HH:mm:ss"];
    
    //挂失、退卡操作类型红色文字表示；换卡、解挂操作类型绿色文字表示
    if ([operateVo.action isEqual:@(2)]) {
        self.action.text = @"挂失";
        self.action.textColor = [ColorHelper getRedColor];
    } else if ([operateVo.action isEqual:@(3)]){
        self.action.text = @"解挂";
        self.action.textColor = [ColorHelper getGreenColor];
    }else if ([operateVo.action isEqual:@(12)]){
        self.action.text = @"退卡";
        self.action.textColor = [ColorHelper getRedColor];
    }else if ([operateVo.action isEqual:@(8)]){
        self.action.text = @"换卡";
        self.action.textColor = [ColorHelper getGreenColor];
    }
}

@end
