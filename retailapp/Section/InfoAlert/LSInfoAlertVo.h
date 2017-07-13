//
//  LSInfoAlertVo.h
//  retailapp
//
//  Created by guozhi on 2016/10/20.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSInfoAlertVo : NSObject
/** 提示标题 */
@property (nonatomic, copy) NSString *title;
/** 提示内容 */
@property (nonatomic, copy) NSString *content;
/** 提示按钮标题 */
@property (nonatomic, copy) NSString *buttonTitle;
/** 图片路径 */
@property (nonatomic, copy) NSString *imagePath;
/** 区分对象 */
@property (nonatomic, assign) NSInteger tag;
/*
 * title         提示标题
 * content       提示内容
 * buttonTitle   按钮标题
 * imagePath     图片路径
 */
+ (instancetype)infoAlertVo:(NSString *)title content:(NSString *)content buttonTitle:(NSString *)buttonTitle imagePath:(NSString *)imagePath;

@end
