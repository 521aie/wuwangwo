//
//  GoodsChoiceCell.h
//  retailapp
//
//  Created by zhangzhiliang on 15/10/27.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsChoiceCell : UITableViewCell

// 图片
@property (strong, nonatomic) IBOutlet UIImageView *img;
// 商品名称
@property (strong, nonatomic) IBOutlet UILabel *lblName;
// 店内码
@property (strong, nonatomic) IBOutlet UILabel *lblInnerCode;
// 属性
@property (strong, nonatomic) IBOutlet UILabel *lblAttributeVal;

@end
