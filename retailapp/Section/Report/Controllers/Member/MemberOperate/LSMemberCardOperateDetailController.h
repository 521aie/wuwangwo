//
//  LSMemberCardOperateDetailController.h
//  retailapp
//
//  Created by wuwangwo on 17/1/6.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
#import "LSCardOperateDetailVo.h"

@interface LSMemberCardOperateDetailController : LSRootViewController
@property (nonatomic, strong) NSMutableDictionary *param;
@property (nonatomic,strong) LSCardOperateDetailVo *detailVo;//会员卡操作详情
@property (nonatomic, copy) NSString *id; //主键
- (instancetype)initWith:(id)vo;
@end
