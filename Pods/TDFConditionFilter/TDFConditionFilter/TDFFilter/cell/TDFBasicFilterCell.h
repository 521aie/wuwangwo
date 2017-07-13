//
//  TDFBasicFilterCell.h
//  TDFConditionFilter
//
//  Created by taihangju on 2017/2/10.
//  Copyright © 2017年 2dfire. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDFBasicFilterCell : UITableViewCell

@property (strong, nonatomic) UIImageView *imageViewTag;
@property (strong, nonatomic) UILabel *itemName;
@property (strong, nonatomic) UIView *bottomLine;

+ (instancetype)tdf_basicFilterCellWithTableView:(UITableView *)tableView;
@end
