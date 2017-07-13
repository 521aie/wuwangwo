//
//  LSSmsTemplateViewController.h
//  retailapp
//
//  Created by guozhi on 16/9/7.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SmsTemplateVo.h"
typedef void (^CallBackBlock) (NSString *smsContext, SmsTemplateVo *smsTemplateVo, NSString *strText, NSString *strMemo);
@interface LSSmsTemplateViewController : UIViewController
/**
 *  当前操作的模板Code
 */
@property (nonatomic, strong) NSString *smsCode;
@property (nonatomic, copy) NSString *templateContent;
/**
 *
 */
@property (nonatomic, copy) NSString *strText;
/**
 *
 */
@property (nonatomic, copy) NSString *strMemo;
/**
 *  //1:营销短信    3:生日提醒
 */
@property (nonatomic, assign) int type;
@property (nonatomic, copy) CallBackBlock callBack;
- (void)getSelectInfo:(CallBackBlock)callBack;
@end
