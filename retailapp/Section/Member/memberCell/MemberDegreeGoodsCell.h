//
//  MemberDegreeGoodsCell.h
//  retailapp
//
//  Created by zhangzhiliang on 15/7/22.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberDegreeGoodsCell : UITableViewCell

// 图片
@property (strong, nonatomic) IBOutlet UIImageView *img;
// 商品名称
@property (strong, nonatomic) IBOutlet UILabel *lblName;
// 所需积分
@property (strong, nonatomic) IBOutlet UILabel *lblDegree;

// 码
@property (strong, nonatomic) IBOutlet UILabel *lblCode;

// 属性
@property (strong, nonatomic) IBOutlet UILabel *lblAttribute;

@end
