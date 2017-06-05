//
//  LSMemberRechargeRuleEditViewController.h
//  ;
//
//  Created by taihangju on 16/10/6.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^RechargeRuleHandleBlock)(NSInteger type);
@interface LSMemberRechargeRuleEditViewController : BaseViewController

- (instancetype)init:(NSInteger)type vo:(id)obj callBack:(RechargeRuleHandleBlock)block;
@end
