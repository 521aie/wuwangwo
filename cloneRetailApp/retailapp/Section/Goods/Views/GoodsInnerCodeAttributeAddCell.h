//
//  GoodsInnerCodeAttributeAddCell.h
//  retailapp
//
//  Created by zhangzhiliang on 15/8/14.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsInnerCodeAttributeAddCell : UITableViewCell

// 名称
@property (strong, nonatomic) IBOutlet UILabel *lblName;
// 选中图标
@property (nonatomic, weak) IBOutlet UIImageView* imgCheck;
// 未选中图标
@property (nonatomic, weak) IBOutlet UIImageView* imgUnCheck;

@end
