//
//  LSMemberCardInfoCell.h
//  retailapp
//
//  Created by byAlex on 16/9/13.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>


// 会员查询后结果列表 用到
@interface LSMemberInfoCell : UITableViewCell

@property (nonatomic ,strong) UIImageView *mbImageView;/* <头像*/
@property (nonatomic ,strong) UILabel *mbNameLabel;/* 会员名<*/
@property (nonatomic ,strong) UILabel *mbPhoneLabel;/* <手机*/
@property (nonatomic ,strong) UILabel *mbStatus;/* <会员卡状态*/
@property (nonatomic ,strong) UIImageView *mbShowDetailImageView;/* <显示详情提示*/

- (void)fillMemberPackVo:(id)vo;
- (void)fillMemberNewAddedVo:(id)vo;
@end
