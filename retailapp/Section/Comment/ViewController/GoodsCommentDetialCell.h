//
//  GoodsCommentDetialCell.h
//  retailapp
//
//  Created by Jianyong Duan on 15/11/19.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsCommentVo.h"

@interface GoodsCommentDetialCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewType;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblColorSize;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;

- (void)dataWithGoodsComment:(GoodsCommentVo *)commentVo;
+ (CGFloat)heightForContent:(NSString *)content;

@end
