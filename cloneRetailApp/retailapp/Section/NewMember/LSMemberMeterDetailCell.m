//
//  LSMemberMeterDetailCell.m
//  retailapp
//
//  Created by wuwangwo on 2017/3/31.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberMeterDetailCell.h"
#import "LSMemberMeterGoodsVo.h"
#import "LSMemberMeterVo.h"
#import "ColorHelper.h"
#import "NumberUtil.h"
#import "AlertBox.h"
#import "SymbolNumberInputBox.h"

@interface LSMemberMeterDetailCell ()<SymbolNumberInputClient>
@property (nonatomic, strong) UIView *viewLine;
@end

@implementation LSMemberMeterDetailCell

+ (instancetype)meterDetailCellWithTableView:(UITableView *)tableView{
    static NSString *cellIdentifier = @"LSMemberMeterDetailCell";
    LSMemberMeterDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[LSMemberMeterDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        [cell configViews];
        [cell configConstraints];
    }
    return cell;
}

- (void)configViews {
    CGFloat btnWidth = 34.0f;
    _myColor = [ColorHelper getTipColor9];
    
    self.lblName = [[UILabel alloc] init];
    self.lblName.font = [UIFont systemFontOfSize:15];
    self.lblName.textColor = [ColorHelper getTipColor3];
    self.lblName.numberOfLines = 0;    
    self.lblName.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:self.lblName];
    
    self.lblCode = [[UILabel alloc] init];
    self.lblCode.font = [UIFont systemFontOfSize:13];
    self.lblCode.textColor = [ColorHelper getTipColor6];
    [self.contentView addSubview:self.lblCode];
    
    //减按钮
    _deleteBtn = [self tempButton:
                  CGRectMake(240, 23, btnWidth, btnWidth) title:@"-"];
    [_addBtn setTitleColor:_myColor forState:UIControlStateNormal];
    [_deleteBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.deleteBtn.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(4, 4)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.deleteBtn.bounds;
    maskLayer.path = maskPath.CGPath;
    _deleteBtn.layer.mask = maskLayer;
    _deleteBtn.layer.borderWidth = 1;
    _deleteBtn.layer.borderColor = _myColor.CGColor;
    _deleteBtn.tag = 11;
    [self.contentView addSubview:_deleteBtn];
    
    //购买商品的数量
    _numCountLab = [[UILabel alloc]initWithFrame:CGRectMake(240+btnWidth, 23, 52, btnWidth)];
    _numCountLab.textAlignment = NSTextAlignmentCenter;
    _numCountLab.layer.borderWidth = 1;
    _numCountLab.layer.borderColor = _myColor.CGColor;
    _numCountLab.textColor = [ColorHelper getBlueColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_numCountLab addGestureRecognizer:tap];
        //打开用户交互
    _numCountLab.userInteractionEnabled = YES;
    _numCountLab.tag = 10;
    [self.contentView addSubview:_numCountLab];
    
    //加按钮
    _addBtn = [self tempButton:
               CGRectMake(self.frame.size.width - btnWidth-10, 23, btnWidth, btnWidth) title:@"+"];
    [_deleteBtn setTitleColor:_myColor forState:UIControlStateNormal];
    [_addBtn addTarget:self action:@selector(addBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBezierPath *maskPathG = [UIBezierPath bezierPathWithRoundedRect:self.addBtn.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(4, 4)];
    CAShapeLayer *maskLayerG = [[CAShapeLayer alloc] init];
    maskLayerG.frame = self.addBtn.bounds;
    maskLayerG.path = maskPathG.CGPath;
    _addBtn.layer.mask = maskLayerG;
    _addBtn.layer.borderWidth = 1;
    _addBtn.layer.borderColor = _myColor.CGColor;
    _addBtn.tag = 12;
    [self.contentView addSubview:_addBtn];
    
    //分割线
    self.viewLine = [[UIView alloc] init];
    self.viewLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [self.contentView addSubview:self.viewLine];
}

- (void)configConstraints {
    __weak typeof(self) wself = self;
    
    [self.lblName makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.contentView).offset(19);
        make.left.equalTo(wself.contentView).offset(12);
        make.right.equalTo(wself.contentView).offset(-130);
    }];
    
    [self.lblCode makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.lblName.bottom).offset(14);
        make.left.equalTo(wself.lblName.left);
        make.right.equalTo(wself.deleteBtn.left);
        make.bottom.equalTo(wself.contentView).offset(-19);
    }];
    
    [self.deleteBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.contentView).offset(23);
        make.right.equalTo(wself.numCountLab.left);
        make.width.equalTo(34);
        make.height.equalTo(34);
    }];
    
    [self.numCountLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.deleteBtn.top);
        make.right.equalTo(wself.addBtn.left);
        make.width.equalTo(80);
        make.height.equalTo(wself.deleteBtn);
    }];
    
    [self.addBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.contentView).offset(23);
        make.right.equalTo(wself.contentView).offset(-10);
        make.width.equalTo(34);
        make.height.equalTo(34);
    }];
    
    //分割线
    [self.viewLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself.contentView);
        make.height.equalTo(1);
    }];
}

- (void)setObj:(LSMemberMeterGoodsVo*)obj{
    _obj = obj;
    self.lblName.text = obj.goodsName;
    self.lblCode.text = obj.barCode;
    self.numCountLab.text = [NSString stringWithFormat:@"%d",obj.consumeTime];
}

/**
 *  点击减按钮实现数量的减少
 *
 *  @param sender 减按钮
 */
-(void)deleteBtnAction:(UIButton *)sender
{
    [self.delegate btnClick:self andFlag:(int)sender.tag];
}
/**
 *  点击加按钮实现数量的增加
 *
 *  @param sender 加按钮
 */
-(void)addBtnAction:(UIButton *)sender
{
    [self.delegate btnClick:self andFlag:(int)sender.tag];
}
/**
 *  点击按钮实现自定义数量的修改
 *
 *  @param sender 按钮
 */
-(void)tapAction:(UIRotationGestureRecognizer*)tap
{
    [self.delegate btnClick:self andFlag:10];
}

// UIButton初始化
- (UIButton*)tempButton:(CGRect)frame title:(NSString*)title {
    
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    btn.titleLabel.frame = btn.frame;
    
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleEdgeInsets = UIEdgeInsetsMake(-5, 0, 0, 0);
    [btn.titleLabel setFont:[UIFont systemFontOfSize:25]];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btn setTitleColor:_myColor forState:UIControlStateNormal];
    
    CALayer *line = [CALayer layer];
    line.backgroundColor = _myColor.CGColor;
    CGFloat originX = frame.origin.x > 10 ? 0 : CGRectGetWidth(frame) - 0.5;
    line.frame = CGRectMake(originX, 0, 0.8, 34.0f);
    [btn.layer addSublayer:line];
    return btn;
}

@end
