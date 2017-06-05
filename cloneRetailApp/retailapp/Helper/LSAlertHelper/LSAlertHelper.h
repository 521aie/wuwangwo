//
//  LSAlertHelper.h
//  LSScanner
//
//  Created by taihangju on 2016/12/24.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSAlertHelper : NSObject

/**
 * 显示状态信息，可以一定时间后自动隐藏
 * @block ，隐藏时回调
 **/
+ (void)showStatus:(NSString *)status afterDeny:(NSTimeInterval)seconds block:(void(^)())block;


/**
 * 默认标题为“提示”，确认标题 "我知道了"， 可通过参数“alertString”定制具体提示信息，传入回调block
 **/
+ (void)showAlert:(NSString *)alertString;


/**
 * 默认标题为“提示”，确认标题 "我知道了"， 可通过参数“alertString”定制具体提示信息，传入回调block
 * @block ，当用户点击确认按钮，可进行回调
 **/
+ (void)showAlert:(NSString *)alertString block:(void(^)())block;


/**
 *  使用于提示用户，展示注意信息，可以自定义"标题"，“取消”，"提醒信息" ,“回调block”
 *
 *  @param title     标题 如“提示”
 *  @param alertStr  具体的提示信息
 *  @param cancleStr 取消按钮text
 *  @param block     回调block
 */
+ (void)showAlert:(NSString *)title message:(NSString *)alertString cancle:(NSString *)cancleStr block:(void(^)())block;

/**
 *  样式： 标题title：@“提示” 提示信息alertString： 可定制 ， 取消：@“取消” 取消block 确定：@“确认” 确定block
 *
 *  @param alertString 提示信息
 *  @param cancleBlock 取消后的回调block
 *  @param ensureBlcok 确认block
 */
+ (void)showAlert:(NSString *)alertString block:(void(^)())cancleBlock block:(void(^)())ensureBlcok;

/**
 *  标题，提示信息，取消按钮，确认按钮，都可以定制
 *
 *  @param title       标题
 *  @param alertString 提示信息
 *  @param cancleStr   取消
 *  @param cancleBlock 取消回调
 *  @param ensureStr   确认
 *  @param ensureBlock 确认回调
 */
+ (void)showAlert:(NSString *)title message:(NSString *)alertString cancle:(NSString *)cancleStr block:(void (^)())cancleBlock
           ensure:(NSString *)ensureStr block:(void(^)())ensureBlock;


/**
 *  定制UIActionSheet
 *
 *  @param title       title
 *  @param cancle      取消
 *  @param cancleBlock 取消回调
 *  @param options     可供用户选择的选项
 *  @param selectBlock 选中选项后的回调
 */
+ (void)showSheet:(NSString *)title cancle:(NSString *)cancle cancleBlock:(void(^)())cancleBlock selectItems:(NSArray<NSString *> *)options selectdblock:(void(^)(NSInteger index))selectBlock;


/**
 提示可以输入文字

 @param title 标题
 @param message 提示信息
 @param ensureBlcok 确认回调
 */
+ (void)showAlertTextInput:(NSString *)title message:(NSString *)message block:(void(^)(NSString *text))ensureBlcok;
@end
