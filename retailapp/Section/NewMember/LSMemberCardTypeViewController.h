//
//  LSMemberCardTypeViewController.h
//  retailapp
//
//  Created by taihangju on 16/9/10.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^ReloadCallBack)(); // 刷新重新获取卡类型列表
@interface LSMemberCardTypeViewController : BaseViewController

- (instancetype)initWithType:(NSInteger)type typeVo:(id)vo cardTypes:(NSArray *)list block:(ReloadCallBack)block;
@end
