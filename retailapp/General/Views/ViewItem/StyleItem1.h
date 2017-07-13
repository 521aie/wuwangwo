//
//  StyleItem.h
//  retailapp
//
//  Created by hm on 15/10/26.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StyleItem1 : UIView
@property (nonatomic, weak) IBOutlet UIImageView* pic;
@property (nonatomic, weak) IBOutlet UILabel* lblName;
@property (nonatomic, weak) IBOutlet UILabel* lblStyleCode;
+ (StyleItem1 *)loadFromNib;
- (void)loadDataWithPath:(NSString *)filePath withName:(NSString *)name withCode:(NSString *)code withPrice:(NSString *)price;
// 服鞋：微店商品详情，计算商品信息显示所需高度
- (void)resetHeight;
@end
