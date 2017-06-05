//
//  ShopCommentTop.h
//  retailapp
//
//  Created by 小龙虾 on 2017/4/19.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShopCommentReportVo;
@interface ShopCommentTop : UIView
//店铺图片
@property(nonatomic, strong)UIImageView *imgViewShop;
//获取商店名称
-(void)upDataName:(NSString *)name;
//获取总的评价
-(void)upDataInfo:(ShopCommentReportVo *)model andType:(int)type;
@end
