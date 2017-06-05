//
//  IEditItemImageEvent.h
//  RestApp
//
//  Created by zxh on 14-7-17.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class  EditItemImage3;
@class SelectImgItem2;
@protocol IEditItemImageEvent <NSObject>

@optional
/**
 * 图片确认.
 */
- (void)onConfirmImgClick:(NSInteger)btnIndex;
/**
 * 图片确认，带标记(区分多个上传时使用).
 */
- (void)onConfirmImgClickWithTag:(NSInteger)btnIndex tag:(NSInteger)tag;

/**
 * 删除图片.
 */
- (void)onDelImgClick;


/**
 * 删除图片,带标记.
 */
- (void)onDelImgClickWithTag:(NSInteger)tag;

/**
 * 删除图片,带路径.
 */
- (void)onDelImgClickWithPath:(NSString *)path;

/**
 * 重新刷新界面尺寸.
 */
- (void)updateViewSize;


/**
 * 图片确认 Image3用
 */
- (void)onConfirmImgClick:(NSInteger)btnIndex Event:(EditItemImage3 *)event;

/**
 * 删除图片 Image3用
 */
- (void)onDelImgClick:(EditItemImage3 *)event;

/**
 * 上移图片 用
 */
- (void)upImg:(NSString *)path;

/**
 * 下移图片 用
 */
- (void)downImg:(NSString *)path;

/**
 * 点击图片整体
 */
- (void)imgClick:(SelectImgItem2 *) selectImgItem2;

@end
