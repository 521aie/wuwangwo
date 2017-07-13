//
//  TDFTwiceFilterCell.m
//  TDFConditionFilter
//
//  Created by taihangju on 2017/2/13.
//  Copyright © 2017年 2dfire. All rights reserved.
//

#import "TDFTwiceFilterCell.h"
#import "TDFFilterMoel.h"

@interface TDFTwiceFilterCell ()

@property (nonatomic ,strong) UILabel *itemName;/**<筛选项>*/
@property (nonatomic ,strong) UIView *bottomLine;/**<>*/
@property (nonatomic ,strong) UILabel *optionName;/**<<#说明#>>*/
@property (nonatomic ,strong) TDFTwiceCellModel *cellModel;/**<cell 需要的一系列数据>*/
@property (nonatomic, weak) NSLayoutConstraint *itemNameWidth;/**<UILabel：itemName 宽度>*/
@end

@implementation TDFTwiceFilterCell

+ (instancetype)tdf_FilterCellWithTableView:(UITableView *)tableView data:(TDFTwiceCellModel *)model {
    
    NSString *cellId = [NSString stringWithFormat:@"TDFTwiceFilterCell%@",model.optionName];
    TDFTwiceFilterCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[TDFTwiceFilterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.cellModel = model;
        [model addObserver:cell forKeyPath:@"currentName" options:NSKeyValueObservingOptionNew context:nil];
        
        UILabel *itemName = [[UILabel alloc] init];
        [itemName setTranslatesAutoresizingMaskIntoConstraints:NO];
        itemName.font = [UIFont systemFontOfSize:15];
        itemName.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        [cell.contentView addSubview:itemName];
        cell.itemName = itemName;
       
        
        UIView *bottomLine = [[UIView alloc] init];
        [bottomLine setTranslatesAutoresizingMaskIntoConstraints:NO];
        bottomLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        [cell.contentView addSubview:bottomLine];
        cell.bottomLine = bottomLine;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTranslatesAutoresizingMaskIntoConstraints:NO];
        [button addTarget:cell action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:button];
        
        UIImageView *arrowImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        [arrowImage setTranslatesAutoresizingMaskIntoConstraints:NO];
        [cell.contentView addSubview:arrowImage];
        arrowImage.image = [UIImage imageNamed:model.arrowImageName];
        
        UILabel *option = [[UILabel alloc] init];
        [option setTranslatesAutoresizingMaskIntoConstraints:NO];
        option.textColor = [UIColor colorWithRed:0/255.0 green:136/255.0 blue:204/255.0 alpha:1];
        option.font = [UIFont systemFontOfSize:15.0];
        option.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:option];
        cell.optionName = option;

        // 布局
        NSDictionary *views = NSDictionaryOfVariableBindings(itemName,bottomLine,button,arrowImage,option);
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:arrowImage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:22]];
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:arrowImage attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:22]];
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:arrowImage attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:6]];
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:itemName attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:5]];
         cell.itemNameWidth = [NSLayoutConstraint constraintWithItem:itemName attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:80];
        cell.itemNameWidth.priority = UILayoutPriorityFittingSizeLevel;
        [cell.contentView addConstraint:cell.itemNameWidth];
        [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[button(==100)]|" options:0 metrics:nil views:views]];
        if (model.type == TDF_TwiceFilterCellOneLine) {
            [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:itemName attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
            [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:arrowImage attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
            [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:option attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
            [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:option attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:itemName attribute:NSLayoutAttributeRight multiplier:1 constant:8]];
            [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:option attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:arrowImage attribute:NSLayoutAttributeLeft multiplier:1 constant:2]];
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-3-[button(==46)]-3-[bottomLine]|" options:0 metrics:nil views:views]];
            
        } else if (model.type == TDF_TwiceFilterCellTwoLine) {
            
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[itemName]-10-[option(==19)]-15-[bottomLine]|" options:0 metrics:nil views:views]];
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=10-[option]-0-[arrowImage]" options:0 metrics:nil views:views]];
            [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:option attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
            [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:40]];
            [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:arrowImage attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:option attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        }
        [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bottomLine]|" options:NSLayoutFormatAlignAllBottom metrics:nil views:views]];
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:bottomLine attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:1/[UIScreen mainScreen].scale]];
    }
    
    cell.itemName.text = model.optionName;
    [cell setOptionName];
    CGFloat widht = [cell.itemName systemLayoutSizeFittingSize:CGSizeMake(200, 22)].width;
    [cell.itemNameWidth setConstant:widht];
    
    return cell;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)buttonAction {
    
    if (self.showSelectPage) {
        self.showSelectPage(self.cellModel);
    }
}

- (void)tdf_FilterCellReset {
    [self.cellModel resetSelf];
    self.optionName.text = self.cellModel.restName;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    [self setOptionName];
}

// 设置optionName的文字及颜色
- (void)setOptionName {
   
    if (self.cellModel.currentName.length > 0) {
        self.optionName.text = self.cellModel.currentName;
    } else {
        self.optionName.text = self.cellModel.restName;
    }
    if ([self.optionName.text isEqualToString:@"可不填"]) {
        self.optionName.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    } else {
        self.optionName.textColor = [UIColor colorWithRed:0/255.0 green:136/255.0 blue:204/255.0 alpha:1];
    }
}

- (void)dealloc {
    [self.cellModel removeObserver:self forKeyPath:@"currentName"];
    self.cellModel = nil;
}

@end
