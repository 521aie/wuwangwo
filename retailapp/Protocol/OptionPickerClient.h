//
//  OptionPickerClient.h
//  retailapp
//
//  Created by hm on 15/6/30.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OptionPickerClient <NSObject>
- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType;

@optional
- (void)managerOption:(NSInteger)eventType;
@end
