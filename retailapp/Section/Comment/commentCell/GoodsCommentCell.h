//
//  GoodsCommentCell.h
//  retailapp
//
//  Created by Jianyong Duan on 15/11/4.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsCommentReportVo.h"

@interface GoodsCommentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageViewPic;
@property (weak, nonatomic) IBOutlet UILabel *lblGoodsname;
@property (weak, nonatomic) IBOutlet UILabel *lblCOde;
@property (weak, nonatomic) IBOutlet UILabel *lblFeedback;
@property (weak, nonatomic) IBOutlet UILabel *lblCount;

- (void)initWithReport:(GoodsCommentReportVo *)reportVo;

@end
