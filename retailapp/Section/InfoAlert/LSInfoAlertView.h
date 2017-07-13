//
//  LSInfoAlertView.h
//  retailapp
//
//  Created by guozhi on 2016/10/20.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSInfoAlertVo.h"
#import "LSInfoAlertViewItem.h"
@interface LSInfoAlertView : UIView
- (void)loadDatas:(NSArray<LSInfoAlertVo *> *)datas callBlcok:(CallBlock)callBlock;
@end
