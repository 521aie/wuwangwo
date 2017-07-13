//
//  LSFilterCell.m
//  retailapp
//
//  Created by guozhi on 2016/10/25.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//
#define kWidth (SCREEN_W/2 + 40)
#define kMargin 10
#import "LSFilterCell.h"
#import "ColorHelper.h"
@interface LSFilterCell()
/** 标题 */
@property (nonatomic, strong) UILabel *titleLbl;
/** 分割线 */
@property (nonatomic, strong) UIView *lineView;
/** View */
@property (nonatomic, strong) UIView *view;
@property (nonatomic, weak) id<LSFilterCellDelegate> delegate;
@end

@implementation LSFilterCell
+ (instancetype)filterCellWithTableView:(UITableView *)tableView delegate:(id<LSFilterCellDelegate>)delegate {
    static NSString *ID = @"filter";
    LSFilterCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[LSFilterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.delegate = delegate;
        [cell configViews];
        [cell configConstraints];
    }
    return cell;
}

- (void)configViews {
    //设置标题
    self.titleLbl = [[UILabel alloc] init];
    self.titleLbl.font = [UIFont systemFontOfSize:16];
    self.titleLbl.textColor = [ColorHelper getTipColor6];
    [self.contentView addSubview:self.titleLbl];
    //设置分割线
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [self.contentView addSubview:self.lineView];
    //设置View
    self.view = [[UIView alloc] init];
    [self.contentView addSubview:self.view];
}

- (void)configConstraints {
    //设置标题约束
    UIView *superView = self.contentView;
    CGFloat margin = 10;
    __weak typeof(self) wself = self;
    [self.titleLbl makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left);
        make.top.equalTo(superView).offset(kMargin);
    }];
    //设置中间View约束
    [self.view makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left);
        make.top.equalTo(wself.titleLbl.bottom).offset(kMargin);
        make.width.equalTo(kWidth- 2* margin);
        make.height.equalTo(40);
    }];
    //设置分割线约束
    [self.lineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left);
        make.width.equalTo(kWidth- 2*kMargin);
        make.top.equalTo(wself.view.bottom);
        make.height.equalTo(1);
    }];
    
}

- (void)setModel:(LSFilterModel *)model {
    [self.contentView layoutIfNeeded];
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _model = model;
    _model.cell = self;
    self.titleLbl.text = model.title;
    __weak typeof(self) wself = self;
    if (model.type == LSFilterModelTypeDefult) {
        // 每一列之间的间距
        CGFloat colMargin = 15;
        // 每一行之间的间距
        CGFloat rowMargin = 10;
        CGFloat btnW = (kWidth - 2* kMargin - colMargin)/2;
        CGFloat btnH = 28;
        __block CGFloat btnLeft = 0;
        __block CGFloat btnTop = 0;
        [model.items enumerateObjectsUsingBlock:^(LSFilterItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            btnLeft = (idx) % 2 * (btnW + colMargin);
            btnTop = (idx) / 2 * (btnH + rowMargin);
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
            [btn setTitle:obj.itemName forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            btn.layer.cornerRadius = 4;
            btn.layer.borderWidth = 1;
            btn.tag = idx;
            if ([obj.itemId isEqualToString:model.selectItem.itemId]) {
                btn.layer.borderColor = [ColorHelper getRedColor].CGColor;
                [btn setTitleColor:[ColorHelper getRedColor] forState:UIControlStateNormal];
            } else {
                btn.layer.borderColor = [ColorHelper getTipColor9].CGColor;
                [btn setTitleColor:[ColorHelper getTipColor9] forState:UIControlStateNormal];
            }
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:btn];
            [btn makeConstraints:^(MASConstraintMaker *make) {
                make.size.equalTo(CGSizeMake(btnW, btnH));
                make.left.equalTo(wself.view.left).offset(btnLeft);
                make.top.equalTo(wself.view.top).offset(btnTop);
            }];
        }];
        //设置中间View约束
        [self.view updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(((model.items.count + 1)/2) *(btnH + rowMargin));
        }];
    } else {
        [self.view updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(32);
        }];
        UIImageView *imgView = [[UIImageView alloc] init];
        if (model.type == LSFilterModelTypeBottom) {
            imgView.image = [UIImage imageNamed:@"ico_next_down"];
        } else {
            imgView.image = [UIImage imageNamed:@"ico_next"];
        }
        [self.view addSubview:imgView];
        [imgView makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(22, 22));
            make.right.top.equalTo(wself.view);
        }];
        
        UILabel *lbl = [[UILabel alloc] init];
        lbl.font = [UIFont systemFontOfSize:16];
        lbl.textColor = [ColorHelper getBlueColor];
        lbl.text = model.selectItem.itemName;
        lbl.textAlignment = NSTextAlignmentRight;
        [self.view addSubview:lbl];
        
        [lbl makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(imgView.centerY);
            make.right.equalTo(imgView.left);
            make.left.equalTo(wself.view.left);
        }];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        [btn makeConstraints:^(MASConstraintMaker *make) {
            make.size.top.left.equalTo(wself.view);
        }];
        
        
    }
    [self layoutIfNeeded];
    model.height = CGRectGetMaxY(self.lineView.frame);
    
}

- (void)btnClick:(UIButton *)btn {
    if(_model.type == LSFilterModelTypeDefult) {
        _model.selectItem = _model.items[btn.tag];
    }
    if ([self.delegate respondsToSelector:@selector(filterCellDidClickModel:)]) {
        //点击那个数据源传出去这时数据源更新数据
        [self.delegate filterCellDidClickModel:_model];
    }
}
@end
