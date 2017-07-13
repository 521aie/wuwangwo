//
//  LSMemberConsumeDetailController.h
//  retailapp
//
//  Created by guozhi on 2016/12/27.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"

@interface LSMemberConsumeDetailController : LSRootViewController
/** 门店名称 */
@property (nonatomic, copy) NSString * shopName;
/** 请求参数 */
@property (nonatomic, strong) NSMutableDictionary *param;
@end
