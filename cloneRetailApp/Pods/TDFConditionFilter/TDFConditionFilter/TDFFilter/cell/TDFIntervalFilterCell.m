//
        //  TDFConditionFilter
//
//  Created by taihangju on 2017/2/10.
//  Copyright © 2017年 2dfire. All rights reserved.
//

#import "TDFIntervalFilterCell.h"
#import "TDFFilterMoel.h"

@interface TDFIntervalFilterCell ()<UITextFieldDelegate>

@property (nonatomic ,strong) TDFInterValCellModel *cellModel;/**<>*/
@end

@implementation TDFIntervalFilterCell

+ (instancetype)tdf_FilterCellWithTableView:(UITableView *)tableView data:(TDFInterValCellModel *)model {
    
    NSString *cellId = [NSString stringWithFormat:@"TDFIntervalFilterCell%@",model.optionName];
    TDFIntervalFilterCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[TDFIntervalFilterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cellModel = model;
        [model addObserver:cell forKeyPath:@"lowRange" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        [model addObserver:cell forKeyPath:@"highRange" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        
        UILabel *itemName = [[UILabel alloc] init];
        [itemName setTranslatesAutoresizingMaskIntoConstraints:NO];
        itemName.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        itemName.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:itemName];
        cell.itemName = itemName;
        itemName.text = model.optionName;
        
        NSDictionary *attributesDic = @{NSFontAttributeName:[UIFont systemFontOfSize:12.0],NSForegroundColorAttributeName:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1],NSBaselineOffsetAttributeName:@(-1.0)};
        
        UITextField *lowRangeTextField = [[UITextField alloc] init];
        [lowRangeTextField setTranslatesAutoresizingMaskIntoConstraints:NO];
        lowRangeTextField.font = [UIFont systemFontOfSize:13.0];
        lowRangeTextField.delegate = cell;
        lowRangeTextField.textAlignment = NSTextAlignmentCenter;
        lowRangeTextField.layer.cornerRadius = 4.0;
        lowRangeTextField.layer.borderWidth = 1.0;
        lowRangeTextField.layer.borderColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1].CGColor;
        lowRangeTextField.textColor = [UIColor colorWithRed:0/255.0 green:136/255.0 blue:204/255.0 alpha:1];
        [cell.contentView addSubview:lowRangeTextField];
        cell.lowRangeTextField = lowRangeTextField;
        NSAttributedString *lowPlacehoder = [[NSAttributedString alloc] initWithString:model.lowPlaceholder attributes:attributesDic];
        lowRangeTextField.attributedPlaceholder = lowPlacehoder;
        if (model.lowRange && model.lowRange.length > 0) {
            lowRangeTextField.text = model.lowRange;
        }
        
        
        UIView *signView = [[UIView alloc] init];
        [signView setTranslatesAutoresizingMaskIntoConstraints:NO];
        signView.backgroundColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        [cell.contentView addSubview:signView];
        

        UITextField *highRangeTextField = [[UITextField alloc] init];
        [highRangeTextField setTranslatesAutoresizingMaskIntoConstraints:NO];
        highRangeTextField.font = [UIFont systemFontOfSize:15];
        highRangeTextField.delegate = cell;
        highRangeTextField.textAlignment = NSTextAlignmentCenter;
        highRangeTextField.layer.cornerRadius = 4.0;
        highRangeTextField.layer.borderWidth = 1.0;
        highRangeTextField.textColor = [UIColor colorWithRed:0/255.0 green:136/255.0 blue:204/255.0 alpha:1];
        highRangeTextField.layer.borderColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1].CGColor;
        [cell.contentView addSubview:highRangeTextField];
        cell.highRangeTextField = highRangeTextField;
        NSAttributedString *highPlacehoder = [[NSAttributedString alloc] initWithString:model.highPlaceholder attributes:attributesDic];
        highRangeTextField.attributedPlaceholder = highPlacehoder;
        if (model.highRange && model.highRange.length > 0) {
            highRangeTextField.text = model.highRange;
        }
        
        
        UIView *bottomLine = [[UIView alloc] init];
        [bottomLine setTranslatesAutoresizingMaskIntoConstraints:NO];
        [bottomLine setTranslatesAutoresizingMaskIntoConstraints:NO];
        bottomLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        [cell.contentView addSubview:bottomLine];
        cell.bottomLine = bottomLine;
        
        // 布局
        NSDictionary *views = NSDictionaryOfVariableBindings(itemName,signView,lowRangeTextField,highRangeTextField,bottomLine);
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:itemName attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:5]];
        [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[lowRangeTextField]-5-[signView(10)]-5-[highRangeTextField(==lowRangeTextField)]-5-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
        [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[itemName(22)]-15-[lowRangeTextField(24)]-15-[bottomLine]|" options:0 metrics:nil views:views]];
        [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bottomLine]|" options:NSLayoutFormatAlignAllBottom metrics:nil views:views]];
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:bottomLine attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:1/[UIScreen mainScreen].scale]];
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:highRangeTextField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:lowRangeTextField attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:signView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:1]];
    }
    return cell;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)tdf_FilterCellReset {
    [self.cellModel resetSelf];
    self.lowRangeTextField.text = nil;
    self.highRangeTextField.text = nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    self.cellModel.currentAction = TDF_Action_None;
    self.lowRangeTextField.text = self.cellModel.lowRange;
    self.highRangeTextField.text = self.cellModel.highRange;
}

- (void)dealloc {
    [self.cellModel removeObserver:self forKeyPath:@"lowRange"];
    [self.cellModel removeObserver:self forKeyPath:@"highRange"];
    self.cellModel = nil;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (self.editActionBlock) {
        self.cellModel.currentAction = [textField isEqual:self.lowRangeTextField] ? TDF_Action_EditLowRange : TDF_Action_EditHighRange;
        self.editActionBlock(_cellModel);
    }
    return NO;
}
@end
