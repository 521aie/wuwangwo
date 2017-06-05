//
//  AdjustStyleEditView.h
//  retailapp
//
//  Created by hm on 15/10/29.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"

typedef void(^AdjustStyleEditHandler)(void);
@class SearchBar2;
@interface AdjustStyleEditView : LSRootViewController<UITextFieldDelegate,UIActionSheetDelegate>


@property (nonatomic, strong) SearchBar2 *searchBar;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) long long adjustTime;

//备注
@property (nonatomic, copy) NSString *memo;
//页面模式
@property (nonatomic, assign) NSInteger action;
//页面是否可编辑
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, assign) double price;
/**  */
@property (nonatomic, strong) NSNumber *shopType;
//调整单状态
@property (nonatomic, assign) short billStatus;

//设置页面参数及回调block
- (void)loadData:(NSString *)shopId withStyleId:(NSString *)styleId withCode:(NSString *)adjustCode withLastVer:(NSInteger)lastVer callBack:(AdjustStyleEditHandler)handler;
@end
