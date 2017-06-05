//
//  LSRightFilterListView.h
//  retailapp
//
//  Created by guozhi on 2017/2/10.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//
typedef enum {
    LSRightFilterListViewTypeCategoryFirst = 1,//顶级分类
    LSRightFilterListViewTypeCategoryLast,//末级分类
    LSRightFilterListViewTypeSuppilerCategory//供应商类别
} LSRightFilterListViewType;
#import <UIKit/UIKit.h>
#import "INameItem.h"
@protocol LSRightFilterListViewDelegate;
@interface LSRightFilterListView : UIView

/** 代理 */
@property (nonatomic, weak) id<LSRightFilterListViewDelegate> delegate;

/** 是否显示顶部按钮 默认不显示*/
@property (nonatomic, assign) BOOL isShowBtn;

/** 设置标题 如果指定了LSRightFilterListViewType(内部帮我们设置好了)则不需要进行设置标题 */
@property (nonatomic, strong) NSString *title;

/** 设置数据源如果指定了LSRightFilterListViewType(内部帮我们设置好了)则不需要进行设置数据源 */
@property (nonatomic, strong) NSMutableArray<id<INameItem>> *datas;
/**
 创建筛选页面不会帮我们创建数据需要调用

 @param view 筛选页面的superView一般指视图控制器的View
 @param delegate delegate
 @return
 */
+ (instancetype)addFilterView:(UIView *)view delegate:(id<LSRightFilterListViewDelegate>)delegate;

/**
 创建筛选页面

 @param view 筛选页面的superView一般指视图控制器的View
 @param type 指定类型 默认会帮我们创建数据
 @param delegate delegate
 @return
 */
+ (instancetype)addFilterView:(UIView *)view type:(LSRightFilterListViewType)type delegate:(id<LSRightFilterListViewDelegate>)delegate;

/**
 刷新数据
 */
- (void)reloadData;

@end

@protocol LSRightFilterListViewDelegate <NSObject>
@optional
/**
 点击右侧某一行时调用

 @param rightFilterListView rightFilterListView
 @param row 选中的行数
 */
- (void)rightFilterListView:(LSRightFilterListView *)rightFilterListView didSelectRow:(NSInteger)row;
/**
 点击右侧某一行时调用
 
 @param rightFilterListView rightFilterListView
 @param obj 选中的对象
 */
- (void)rightFilterListView:(LSRightFilterListView *)rightFilterListView didSelectObj:(id<INameItem>)obj;

/**
 点击顶部的按钮

 @param rightFilterListView rightFilterListView
 */
- (void)rightFilterListViewDidClickTopBtn:(LSRightFilterListView *)rightFilterListView;
@end
