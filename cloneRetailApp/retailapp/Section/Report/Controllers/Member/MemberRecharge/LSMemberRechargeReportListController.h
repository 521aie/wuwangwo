//
//  LSMemberRechargeReportListController.h
//  retailapp
//
//  Created by guozhi on 2017/1/9.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"

@interface LSMemberRechargeReportListController : LSRootViewController
/**查询会员充值记录列表所需要的参数*/
@property (nonatomic, strong) NSMutableDictionary *param;
/**导出页面所需要的参数*/
@property (nonatomic, strong) NSMutableDictionary *exportParam;
/**  后台返回数量需要传给后台 Integer*/
@property (nonatomic, strong) NSNumber *startNum;
/**  是否查询搜索引擎需要传给后台  Boolean*/
@property (nonatomic, strong) NSNumber *isFromSolr;
@end
