//
//  LSMemberExchangeableNumSetViewController.h
//  retailapp
//
//  Created by taihangju on 2017/3/1.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "BaseViewController.h"

@interface LSMemberExchangeableNumSetViewController : BaseViewController

@property (nonatomic, copy) void (^callBackBlock)();/**<回调>*/
- (instancetype)initWith:(NSInteger)type gifts:(NSString *)string;
@end
