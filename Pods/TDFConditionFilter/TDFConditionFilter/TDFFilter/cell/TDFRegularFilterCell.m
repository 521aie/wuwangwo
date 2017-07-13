//
//  TDFRegularFilterCell.m
//  TDFConditionFilter
//
//  Created by taihangju on 2017/2/13.
//  Copyright © 2017年 2dfire. All rights reserved.
//

#import "TDFRegularFilterCell.h"
#import "TDFFilterMoel.h"


@interface TDFRegularFilterCell ()

@property (nonatomic ,strong) NSArray *buttonArray;/**<保存选项对应的button>*/
@property (nonatomic ,strong) TDFRegularCellModel *rawDataDic;/**<cell 需要的一系列数据>*/
@property (nonatomic ,strong) UIButton *selectButton;/**<当前选择的button>*/
@property (nonatomic ,weak) TDFRegularCellModel *cellModel;/**<>*/
@end

@implementation TDFRegularFilterCell

+ (instancetype)tdf_FilterCellWithTableView:(UITableView *)tableView data:(TDFRegularCellModel *)model {
    
    // 这里这样写是为了防止重用cell，方便保存cell状态
    NSString *cellId = [NSString stringWithFormat:@"TDFRegularFilterCell%@",model.optionName];
    TDFRegularFilterCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[TDFRegularFilterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        UILabel *itemName = [[UILabel alloc] init];
        [itemName setTranslatesAutoresizingMaskIntoConstraints:NO];
        itemName.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        itemName.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:itemName];
        cell.itemName = itemName;
        itemName.text = model.optionName;
        
        UIView *bottomLine = [[UIView alloc] init];
        [bottomLine setTranslatesAutoresizingMaskIntoConstraints:NO];
        bottomLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        [cell.contentView addSubview:bottomLine];
        cell.bottomLine = bottomLine;
        
        [cell createConditionButtonsWith:model];
        [cell addContstraints];
    }

    cell.cellModel = model;
    return cell;
}

- (void)prepareForReuse {
    // 当选项更新时
    if (self.cellModel.updateOption) {
        [self.bottomLine removeConstraints:self.bottomLine.constraints];
        [self.buttonArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
        self.cellModel.updateOption = NO;
        self.buttonArray = nil;
        self.selectButton = nil;
        self.itemName.text = self.cellModel.optionName;
        [self createConditionButtonsWith:self.cellModel];
        [self addContstraints];
    }
}

// 根据可选项创建 对应的button
- (void)createConditionButtonsWith:(TDFRegularCellModel *)model {
    
    NSArray *items = model.optionItems;
    if (items.count >= 1) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:items.count];
        [items enumerateObjectsUsingBlock:^(TDFFilterItem *item, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            [button setTranslatesAutoresizingMaskIntoConstraints:NO];
            button.titleLabel.font = [UIFont systemFontOfSize:13.0];
            [button setTitle:item.itemName forState:UIControlStateNormal];
            [button setTitleColor:[self grayColor] forState:UIControlStateNormal];
            button.layer.cornerRadius = 4.0;
            button.layer.borderWidth = 1.0;
            button.layer.borderColor = [self grayColor].CGColor;
            button.tag = idx;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:button];
            [array addObject:button];
        }];
        
        self.buttonArray = [array copy];
        self.selectButton = [array objectAtIndex:model.resetItemIndex];
        [self.selectButton setTitleColor:[self redColor] forState:0];
        self.selectButton.layer.borderColor = [self redColor].CGColor;
    }
}

// 为子view设置布局
- (void)addContstraints {
    
    UIView *itemName = self.itemName;
    UIView *bottomLine = self.bottomLine;
    NSArray *array = self.buttonArray;
    // 说明： 每一列之间的间距 15, 每一行之间的距离：10；
    NSDictionary *views = NSDictionaryOfVariableBindings(itemName,bottomLine);
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[itemName]-(>=10)-|" options:NSLayoutFormatAlignAllLeft metrics:nil views:views]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.itemName attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:15]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.itemName attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:22]];
    
    UIView   *topView = self.itemName;                       // 约束起始高度参照的view
    if (array.count >= 2) {
        // i 代表button行数
        for (int i = 0; i < (int)array.count/2; ++i) {
            
            UIButton *leftButton = array[i*2];                // 同一行，位于左侧的button
            UIButton *rightButton = array[i*2+1];             // 同一行，位于右侧button
            CGFloat constant = i==0?15:10;
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:leftButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:topView attribute:NSLayoutAttributeBottom multiplier:1 constant:constant]];
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:leftButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:28]];
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:leftButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:topView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
            
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:rightButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:leftButton attribute:NSLayoutAttributeRight multiplier:1 constant:10]];
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:rightButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:28]];
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:rightButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:leftButton attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:rightButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:topView attribute:NSLayoutAttributeBottom multiplier:1 constant:constant]];
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:rightButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:-5]];
            topView = leftButton;
        }
    }
    
    // 如果数组的个数是奇数,针对最后一个奇数button的布局
    UIButton *lastButton = array.lastObject;
    if (array.count%2 == 1) {
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:lastButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:itemName attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:lastButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:0.5 constant:-10]];
        CGFloat constant = array.count==1?15:10;
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:lastButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:topView attribute:NSLayoutAttributeBottom multiplier:1 constant:constant]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:lastButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:28]];
    }
    views = NSDictionaryOfVariableBindings(lastButton,topView,bottomLine);
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[lastButton]-14-[bottomLine]|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bottomLine]|" options:0 metrics:nil views:views]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:bottomLine attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:1/[UIScreen mainScreen].scale]];
}

- (void)buttonClick:(UIButton *)sender {
    
    if (![sender isEqual:self.selectButton]) {
        [sender setTitleColor:[self redColor] forState:0];
        sender.layer.borderColor = [self redColor].CGColor;
        [self.selectButton setTitleColor:[self grayColor] forState:0];
        self.selectButton.layer.borderColor = [self grayColor].CGColor;
        self.selectButton = sender;
        self.cellModel.selectItemIndex = sender.tag;
        if (self.selectedCallBack) {
            self.selectedCallBack(self.cellModel);
        }
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)tdf_FilterCellReset {
    
    [self.selectButton setTitleColor:[self grayColor] forState:0];
    self.selectButton.layer.borderColor = [self grayColor].CGColor;
    [self.cellModel resetSelf];
    self.selectButton = [self.buttonArray objectAtIndex:self.cellModel.resetItemIndex];
    [self.selectButton setTitleColor:[self redColor] forState:0];
    self.selectButton.layer.borderColor = [self redColor].CGColor;
}

- (UIColor *)redColor {
    return [UIColor colorWithRed:204/255.0 green:0.0 blue:0.0 alpha:1];
}

- (UIColor *)grayColor {
    return [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
}

@end

