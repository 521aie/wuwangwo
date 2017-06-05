//
//  ISearchBarEvent.h
//  retailapp
//
//  Created by zhangzhiliang on 15/7/8.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ISearchBarEvent <NSObject>

@optional
// 输入完成
- (void)imputFinish:(NSString *)keyWord;

// 开始扫描
- (void)scanStart;

// 结束扫描
- (void)scanFinish:(NSString *)code;

// 关闭扫一扫页面
- (void)closeScanView;

- (void)selectCondition;

@end
