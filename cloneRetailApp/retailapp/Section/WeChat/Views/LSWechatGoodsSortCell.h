//
//  LSWechatGoodsSortCell.h
//  retailapp
//
//  Created by taihangju on 2017/3/14.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//  微店商品分类选项cell

#import <UIKit/UIKit.h>

@interface LSWechatGoodsSortCell : UITableViewCell

+ (instancetype)wechatGoodsSortCellWith:(UITableView *)tableView;
- (void)setOptionName:(NSString *)name optStatus:(BOOL)status;
@end
