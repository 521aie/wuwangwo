//
//  GoodCommentDetailTopTableViewCell.h
//  retailapp
//
//  Created by 小龙虾 on 2017/4/20.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GoodsCommentReportVo;

@interface GoodCommentDetailTopCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgPic;
@property (weak, nonatomic) IBOutlet UILabel *lblGoodsName;
@property (weak, nonatomic) IBOutlet UILabel *lblStyle;
@property (weak, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UILabel *lblFeedback;
@property (weak, nonatomic) IBOutlet UILabel *lblTotal;
@property (weak, nonatomic) IBOutlet UILabel *lblGoodComment;
@property (weak, nonatomic) IBOutlet UILabel *lblMediumComment;
@property (weak, nonatomic) IBOutlet UIImageView *imgMed;

@property (weak, nonatomic) IBOutlet UIImageView *imgBad;
@property (weak, nonatomic) IBOutlet UILabel *lblBadComment;

-(void)upDataWithModel:(GoodsCommentReportVo *)model;
@end
