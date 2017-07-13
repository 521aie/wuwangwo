//
//  LSStockChangeRecordHeaderView.h
//  retailapp
//
//  Created by guozhi on 2017/2/13.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSStockChangeRecordHeaderView : UIView
+ (instancetype)stockChangeRecordHeaderView;
- (void)setName:(NSString *)name code:(NSString *)code colorAndsSize:(NSString *)colorAndsSize time:(NSString *)time filePath:(NSString *)filePath;
@end
