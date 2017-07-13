//
//  ExportView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/8/20.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"

@protocol ExportViewDelegate <NSObject>

- (void)showView;
@end

typedef void(^ExportHandler)(void);
@interface ExportView : LSRootViewController<UIActionSheetDelegate>

//邮箱名称
@property (nonatomic) NSInteger action;
@property (strong, nonatomic) id<ExportViewDelegate> delegate;
@property (nonatomic,copy) ExportHandler exportHandler;

//页面入口
- (void)loadData:(NSMutableDictionary*)param withPath:(NSString*)urlPath withIsPush:(BOOL)isPush callBack:(ExportHandler)handler;

// 库存模块相关导出
- (void)exportData:(NSArray *)arr type:(NSInteger)exportType CallBack:(ExportHandler)handler;

// 报表模块导出相关
- (void)reportExport:(NSDictionary *)param type:(NSInteger)exportType callBack:(ExportHandler)handler;
@end
