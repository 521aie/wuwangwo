//
//  LSMemberConsumeListController.h
//  retailapp
//
//  Created by guozhi on 2017/1/9.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"

@interface LSMemberConsumeListController : LSRootViewController
/**查询会员交易信息进行网络请求的参数*/
@property (nonatomic, strong) NSMutableDictionary *param;
/**导出页面进行网络请求的参数*/
@property (nonatomic, strong) NSMutableDictionary *exportParam;
@property (nonatomic, copy) NSString *shopName;
@end
