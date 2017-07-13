//
//  SelectMicShopItem.h
//  retailapp
//
//  Created by guozhi on 16/3/1.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MicroOrderDealVo;
@interface SelectMicShopItem : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblVal;

@property (nonatomic, strong) MicroOrderDealVo *microOrderDealVo;
@end
