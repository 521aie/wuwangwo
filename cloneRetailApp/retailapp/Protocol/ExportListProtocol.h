//
//  ExportListProtocol.h
//  retailapp
//
//  Created by taihangju on 16/8/20.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#ifndef ExportListProtocol_h
#define ExportListProtocol_h
#import <Foundation/Foundation.h>

@protocol ExportListProtocol <NSObject>

- (NSString *)getBillNum;   // 获取单号
- (NSString *)getBillDate;  // 单子生成日期
- (NSString *)getName;      // 单子类型名 如供应商名
- (NSString *)getStatus;    // 单子的当前状态描述
- (NSInteger)getBillStatus;    // 单子当前状态对应的值
@end

#endif /* ExportListProtocol_h */
