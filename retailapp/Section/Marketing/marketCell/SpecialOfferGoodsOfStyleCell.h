//
//  SpecialOfferGoodsOfStyleCell.h
//  retailapp
//
//  Created by zhangzhiliang on 15/12/18.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpecialOfferGoodsOfStyleCell : UITableViewCell

// 图片
@property (strong, nonatomic) IBOutlet UIImageView *img;
// 名称
@property (strong, nonatomic) IBOutlet UILabel *lblName;

// 编号
@property (strong, nonatomic) IBOutlet UILabel *lblNo;

// 属性
@property (strong, nonatomic) IBOutlet UILabel *lblAttribute;

// 特价/折扣率
@property (strong, nonatomic) IBOutlet UILabel *lblPrice;

// %图标
@property (strong, nonatomic) IBOutlet UIButton *btnFlg;

// 特价/折扣率
@property (strong, nonatomic) IBOutlet UILabel *lblDiscount;

@end
