//
//  TDFBasicFilterCell.m
//  TDFConditionFilter
//
//  Created by taihangju on 2017/2/10.
//  Copyright © 2017年 2dfire. All rights reserved.
//

#import "TDFBasicFilterCell.h"

@implementation TDFBasicFilterCell

+ (instancetype)tdf_basicFilterCellWithTableView:(UITableView *)tableView {
    
    static NSString *cellId = @"TDFBasicFilterCell";
    TDFBasicFilterCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[TDFBasicFilterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        UIImageView *imageViewTag = [[UIImageView alloc] init];
        [imageViewTag setTranslatesAutoresizingMaskIntoConstraints:NO];
        imageViewTag.image = [UIImage imageNamed:@"filter_category_tag"];
        [cell.contentView addSubview:imageViewTag];
        cell.imageViewTag = imageViewTag;
        
        UILabel *itemName = [[UILabel alloc] init];
        [itemName setTranslatesAutoresizingMaskIntoConstraints:NO];
        itemName.font = [UIFont systemFontOfSize:15.0];
        itemName.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        [cell.contentView addSubview:itemName];
        cell.itemName = itemName;
        
        UIView *bottomLine = [[UIView alloc] init];
        [bottomLine setTranslatesAutoresizingMaskIntoConstraints:NO];
        bottomLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        [cell.contentView addSubview:bottomLine];
        cell.bottomLine = bottomLine;
        
        // 添加约束
        NSDictionary *views = NSDictionaryOfVariableBindings(imageViewTag,itemName,bottomLine);
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:imageViewTag attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:imageViewTag attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:imageViewTag attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:itemName attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:22.0]];
        [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[imageViewTag(21)]-20-[itemName]-(>=10)-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
        [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[bottomLine]-10-|" options:NSLayoutFormatAlignAllBottom metrics:nil views:views]];
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:bottomLine attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-1]];
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:bottomLine attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:1/[UIScreen mainScreen].scale]];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
