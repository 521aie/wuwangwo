//
//  LSMemberIntergalListController.h
//  retailapp
//
//  Created by guozhi on 2017/1/9.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"

@interface LSMemberIntergalListController : LSRootViewController
/**兑换门店*/
@property (nonatomic, copy) NSString *shopName;
/**查询会员积分兑换记录所需要的参数*/
@property (nonatomic, strong) NSMutableDictionary *param;
/**导出页面所需要的参数*/
@property (nonatomic, strong) NSMutableDictionary *exportParam;
@end
