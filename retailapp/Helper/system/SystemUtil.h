//
//  SystemUtil.h
//  retailapp
//
//  Created by hm on 15/6/26.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SystemUtil : NSObject

+ (void)hideKeyboard;

+ (NSString *)getXibName:(NSString *)xibName;

+ (NSString *)getDeviceName;
@end
