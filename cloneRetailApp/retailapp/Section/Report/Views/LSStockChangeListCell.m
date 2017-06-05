//
//  LSStockChangeListCell.m
//  retailapp
//
//  Created by guozhi on 2017/1/10.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSStockChangeListCell.h"
#import "StockChangeLogVo.h"
@interface LSStockChangeListCell()
/** 商品名字 */
@property (nonatomic, strong) UILabel *lblName;
/** 条形码店内码 */
@property (nonatomic, strong) UILabel *lblCode;
/** 颜色尺码 */
@property (nonatomic, strong) UILabel *lblColorAndSize;
/** 库存变更 */
@property (nonatomic, strong) UILabel *lblStockChange;
/** 下一个图片 */
@property (nonatomic, strong) UIImageView *imgViewNext;
/** 分割线 */
@property (nonatomic, strong) UIView *viewLine;
@end

@implementation LSStockChangeListCell

+ (instancetype)stockChangeListCellWithTableView:(UITableView *)tableView {
    static NSString *cellIdentifier = @"cell";
    LSStockChangeListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[LSStockChangeListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        [cell configViews];
        [cell configConstraints];
    }
    return cell;
}

- (void)configViews {
    //商品名称
    self.lblName = [[UILabel alloc] init];
    self.lblName.font = [UIFont systemFontOfSize:15];
    self.lblName.textColor = [ColorHelper getTipColor3];
    [self.contentView addSubview:self.lblName];
    
    //条形码店内码
    self.lblCode = [[UILabel alloc] init];
    self.lblCode.font = [UIFont systemFontOfSize:13];
    self.lblCode.textColor = [ColorHelper getTipColor6];
    [self.contentView addSubview:self.lblCode];
    
    //颜色尺码
    self.lblColorAndSize = [[UILabel alloc] init];
    self.lblColorAndSize.font = [UIFont systemFontOfSize:13];
    self.lblColorAndSize.textColor = [ColorHelper getTipColor6];
    [self.contentView addSubview:self.lblColorAndSize];
    
    //库存变更
    self.lblStockChange = [[UILabel alloc] init];
    self.lblStockChange.font = [UIFont systemFontOfSize:13];
    self.lblStockChange.textColor = [ColorHelper getTipColor6];
    [self.contentView addSubview:self.lblStockChange];
    
    //下一个图片
    self.imgViewNext = [[UIImageView alloc] init];
    self.imgViewNext.image = [UIImage imageNamed:@"ico_next"];
    [self.contentView addSubview:self.imgViewNext];
    
    //分割线
    self.viewLine = [[UIView alloc] init];
    self.viewLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [self.contentView addSubview:self.viewLine];
}

- (void)configConstraints {
    __weak typeof(self) wself = self;
    //商品名称
    CGFloat margin = 10;
    CGFloat top = 10;
    [self.lblName makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.contentView).offset(margin);
        make.right.equalTo(wself.contentView).offset(-margin);
        make.top.equalTo(wself.contentView).offset(top);
    }];
    
    //条形码店内码
    if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {//服鞋（显示颜色尺码 要居中显示）
        [self.lblCode makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wself.lblName);
            make.centerY.equalTo(wself.contentView);
        }];
    } else {//商超（不显示颜色尺码 要靠下显示）
        [self.lblCode makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wself.lblName);
            make.bottom.equalTo(wself.contentView).offset(-top);
        }];
    }
    
    //颜色尺码
    [self.lblColorAndSize makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.lblName);
        make.bottom.equalTo(wself.contentView).offset(-top);
    }];
    
    //库存变更
    [self.lblStockChange makeConstraints:^(MASConstraintMaker *make) {
         make.bottom.equalTo(wself.contentView).offset(-top);
         make.right.equalTo(wself.imgViewNext.left);
    }];
    
    //下一个图片
    [self.imgViewNext makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(22);
        make.right.equalTo(wself.contentView).offset(-margin);
        make.centerY.equalTo(wself.contentView);
    }];
    
    //分割线
    [self.viewLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself.contentView);
        make.height.equalTo(1);
    }];
}

- (void)setObj:(StockChangeLogVo *)obj {
    _obj = obj;
    //商品名字
    self.lblName.text = obj.goodsName;
    if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) { //颜色尺码
        NSMutableString *sizeAndColor = [NSMutableString stringWithString:@""];
        if ([ObjectUtil isNotNull:obj.goodsColor]) {
            //颜色
            [sizeAndColor appendString:obj.goodsColor];
        }
        if ([ObjectUtil isNotNull:obj.goodsSize]) {
            //尺码
            [sizeAndColor appendString:@" "];
            [sizeAndColor appendString:obj.goodsSize];
        }
        self.lblColorAndSize.text = sizeAndColor;
        self.lblCode.text = obj.innerCode;
    } else {
        self.lblCode.text = obj.barCode;
    }
    //库存变更数
    self.lblStockChange.text = [NSString stringWithFormat:@"库存变更: %@",obj.nowStore];
    self.lblStockChange.hidden = YES;
}


@end
