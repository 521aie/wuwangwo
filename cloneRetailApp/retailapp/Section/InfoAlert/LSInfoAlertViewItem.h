//
//  LSInfoAlertViewItem.h
//  retailapp
//
//  Created by guozhi on 2016/10/20.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSInfoAlertVo.h"
typedef void(^CallBlock)(LSInfoAlertVo *infoAlertVo);
@interface LSInfoAlertViewItem : UIView
/*
 * 传进去的值和block传出来的值是一样的
 */
- (void)infoAlertView:(LSInfoAlertVo *)infoAlertVo callBlock:(CallBlock)callBlock;
@end
