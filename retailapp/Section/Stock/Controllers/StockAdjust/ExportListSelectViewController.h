//
//  LogisticListExportViewController.h
//  retailapp
//
//  Created by taihangju on 16/8/19.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"

// 物流模块相关表单导出
@interface ExportListSelectViewController : LSRootViewController

/**
 *  初始化方法
 *
 *  @param code 待导出表单的类型，如采购叫货单、收货入库单等
 *  @param exportArr 导航title
 *  @param dic       表单请求需要的参数字典
 */
- (instancetype)initWith:(NSInteger)code title:(NSString *)title params:(NSMutableDictionary *)dic;
@end
