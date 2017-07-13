//
//  GoodsSingleAttributeCell.h
//  retailapp
//
//  Created by zhangzhiliang on 15/8/10.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ReturnGuideListVo;
@interface ReturnGuideDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblReturnAbleCount;
@property (weak, nonatomic) IBOutlet UILabel *lblNowReturnAbleCount;
@property (weak, nonatomic) IBOutlet UILabel *lblCode;
- (void)initWithReturnGuideListVo:(ReturnGuideListVo *)returnGuideListVo;
@end
