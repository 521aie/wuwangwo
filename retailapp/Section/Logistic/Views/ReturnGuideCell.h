//
//  GoodsSingleAttributeCell.h
//  retailapp
//
//  Created by zhangzhiliang on 15/8/10.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ReturnGoodsGuideVo;
@interface ReturnGuideCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *lblName;

@property (nonatomic, strong) IBOutlet UILabel *lblCode;
- (void)initWithReturnGoodsGuidoVo:(ReturnGoodsGuideVo *)returnGoodsGuideVo;
@end
