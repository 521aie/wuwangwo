//
//  LSFooterView.h
//  retailapp
//
//  Created by guozhi on 16/7/14.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#define kFootExport @"kFootExport" //导出
#define kFootAdd @"kFootAdd" //添加
#define kFootSort @"kFootSort" //排序
#define kFootScan @"kFootScan" //扫一扫
#define kFootBatch @"kFootBatch" //批量
#define kFootSelectAll @"kFootSelectAll" //全选
#define kFootSelectNo @"kFootSelectNo" //全不选
#define kFootOneClick @"kFootOneClick" //一键上架
#define kFootManual @"kFootManual" //手动生成
#define kFootColor @"kFootColor" //颜色库管理
#define kFootSize @"kFootSize" //尺码库管理
#import <UIKit/UIKit.h>
@class LSFooterView;
@protocol LSFooterViewDelegate;
@interface LSFooterView : UIView
/**
 *  创建footerView
 *
 *  @return 返回footView
 */
+ (instancetype)footerView;
/**
 *  设置代理赋值view上的按钮
 *
 *  @param delegate 代理
 *  @param arr      @[kFootExport,kFootAdd,kFootSort];
 */
- (void)initDelegate:(id<LSFooterViewDelegate>)delegate btnsArray:(NSArray<NSString *>*)arr;
- (void)updateButtons:(NSArray *)arr;
/**
 是否显示手动生成按钮默认显示
 
 @param isShow YES 显示手动生成按钮 此时按钮是可以点击的 NO 显示灰色背景及时间此时按钮是不可点击的
 @param text   时间
 */
- (void)showManualBtn:(BOOL)isShow text:(NSString *)text;
@end
@protocol LSFooterViewDelegate <NSObject>
@optional
/**
 *  点击时调用
 *
 *  @param index @[kFootExport,kFootAdd,kFootSort]; kFootExport,kFootAdd,kFootSort
 */
- (void)footViewdidClickAtFooterType:(NSString *)footerType;
@end
