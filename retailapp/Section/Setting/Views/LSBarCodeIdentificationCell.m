//
//  LSBarCodeIdentificationCell.m
//  retailapp
//
//  Created by guozhi on 2017/1/6.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSBarCodeIdentificationCell.h"
#import "ColorHelper.h"
@interface LSBarCodeIdentificationCell()
/** 选中不选中图片 */
@property (nonatomic, strong) UIImageView *imgView;
/** 条码标识 */
@property (nonatomic, strong) UILabel *lblBarCodeIdentification;
/** 分割线 */
@property (nonatomic, strong) UIView *viewLine;
@end

@implementation LSBarCodeIdentificationCell
+ (instancetype)barCodeIdentificationCellWithTableView:(UITableView *)tableView {
    static NSString *cellIdentifier = @"cell";
    LSBarCodeIdentificationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[LSBarCodeIdentificationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configViews];
        [cell configConstraints];
    }
    return cell;
    
}

- (void)configViews {
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    //选中不选中图片
    self.imgView  = [[UIImageView alloc] init];
    [self.contentView addSubview:self.imgView];
    //条码标识
    self.lblBarCodeIdentification = [[UILabel alloc] init];
    self.lblBarCodeIdentification.font = [UIFont systemFontOfSize:15];
    self.lblBarCodeIdentification.textColor = [ColorHelper getBlueColor];
    [self.contentView addSubview:self.lblBarCodeIdentification];
    //分割线
    self.viewLine = [[UIView alloc] init];
    self.viewLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [self.contentView addSubview:self.viewLine];
    
}

- (void)configConstraints {
    UIView *superView = self.contentView;
    CGFloat margin = 20;
    //选中不选中图片
    [self.imgView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView).offset(margin);
        make.centerY.equalTo(superView);
        make.size.equalTo(22);
    }];
    //条码标识
    [self.lblBarCodeIdentification makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superView).offset(-margin);
        make.centerY.equalTo(superView);
    }];
    //分割线
    [self.viewLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(superView);
        make.height.equalTo(1);
    }];
    
}

- (void)setObj:(LSBarCodeMark *)obj {
    _obj = obj;
    self.lblBarCodeIdentification.text = [NSString stringWithFormat:@"%d", obj.val];
    NSString *path = obj.flag == 1 ? @"ico_check" : @"ico_uncheck";
    self.imgView.image = [UIImage imageNamed:path];
}

@end
