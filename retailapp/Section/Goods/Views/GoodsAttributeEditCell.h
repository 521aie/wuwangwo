//
//  GoodsAttributeEditCell.h
//  retailapp
//
//  Created by zhangzhiliang on 15/8/26.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsAttributeEditCell : UITableViewCell

// 属性名称
@property (strong, nonatomic) IBOutlet UILabel *lblName;

// 属性信息
@property (strong, nonatomic) IBOutlet UILabel *lblInfo;

// 属性信息
@property (strong, nonatomic) IBOutlet UIImageView *imgEdit;

@end
