//
//  LSMemberGoodDetailViewController.h
//  retailapp
//
//  Created by taihangju on 16/10/8.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "BaseViewController.h"

@interface LSMemberGoodDetailViewController : BaseViewController


/**
 初始化方法

 @param type 添加或者编辑
 @param obj 积分商品对象
 */
- (instancetype)init:(NSInteger)type selectObj:(id)obj;
@end
