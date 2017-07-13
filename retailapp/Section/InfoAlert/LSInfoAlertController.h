//
//  LSInfoAlertController.h
//  retailapp
//
//  Created by guozhi on 2016/10/20.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSInfoAlertVo.h"
@protocol LSInfoAlertDelegate;
@interface LSInfoAlertController : UIViewController
@property (nonatomic, strong) NSArray<LSInfoAlertVo *> *datas;
@property (nonatomic, weak) id <LSInfoAlertDelegate>delegate;
@end
@protocol LSInfoAlertDelegate <NSObject>
- (void)infoAlert:(LSInfoAlertVo *)infoAlertVo;
@end
