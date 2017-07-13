//
//  LSBarCodeIdentificationController.h
//  retailapp
//
//  Created by guozhi on 2017/1/6.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LSBarCodeMark;
typedef void (^CallBlock)(NSArray<LSBarCodeMark *> *barCodeMarks);
@interface LSBarCodeIdentificationController : UIViewController

/**
 显示条码秤标识

 @param barCodeMarks 数据源
 @param callBlock 点击保存按钮时的数据源
 */
- (void)loadBarCodeList:(NSArray *)barCodeMarks callBlock:(CallBlock)callBlock;
@end
