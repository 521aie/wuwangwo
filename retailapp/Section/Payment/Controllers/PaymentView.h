//
//  PaymentView.h
//  retailapp
//
//  Created by guozhi on 16/5/10.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
@interface PaymentView : LSRootViewController
- (void)initDataView:(NSString *)payment isShowAccount:(BOOL)isShowAccount;
- (void)loadData;
@end
