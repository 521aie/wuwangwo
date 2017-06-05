//
//  GoodsInnerCodeRegulationSettingCell.h
//  retailapp
//
//  Created by zhangzhiliang on 15/8/13.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkuRuleVo.h"

@protocol GoodsInnerCodeRegulationSettingCellDelegate <NSObject>

-(void) deleteCell:(SkuRuleVo *) skuRuleVo;

@end
@interface GoodsInnerCodeRegulationSettingCell : UITableViewCell

// 属性名称
@property (strong, nonatomic) IBOutlet UILabel *lblName;

// 删除按键
//@property (strong, nonatomic) IBOutlet UIButton *btnDel;

@property (strong , nonatomic) SkuRuleVo *skuRuleVo;

@property (strong , nonatomic) id<GoodsInnerCodeRegulationSettingCellDelegate> delegate;

@end
