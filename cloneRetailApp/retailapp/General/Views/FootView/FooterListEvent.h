//
//  FooterListEvent.h
//  RestApp
//
//  Created by zxh on 14-4-10.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FooterListEvent <NSObject>

@optional
- (void)showAddEvent;

- (void)showDelEvent;

- (void)showSortEvent;

- (void)showHelpEvent;

- (void)showBatchEvent;

- (void)showScanEvent;

- (void)showEditEvent;

- (void)checkAllEvent;

- (void)notCheckAllEvent;

//导出事件（供应链新增）
- (void)showExportEvent;
/**手动生成*/
- (void)showUnautoEvent;

@end
