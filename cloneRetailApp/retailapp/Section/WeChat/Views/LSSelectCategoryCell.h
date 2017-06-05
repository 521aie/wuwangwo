//
//  LSSelectCategoryCell.h
//  retailapp
//
//  Created by guozhi on 16/10/9.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryVo.h"
@interface LSSelectCategoryCell : UITableViewCell
@property (nonatomic, strong) CategoryVo *categoryVo;
/**选中不选中图标*/
@property (nonatomic, strong) UIImageView *img;
/**分类名称*/
@property (nonatomic, strong) UILabel *lblCategoryName;
/**分割线*/
@property (nonatomic, strong) UIView *viewLine;
+ (instancetype)selectCategoryCellWithTableView:(UITableView *)tableView;
@end
