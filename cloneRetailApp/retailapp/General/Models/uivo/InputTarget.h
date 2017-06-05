//
//  InputTarget.h
//  retailapp
//
//  Created by hm on 15/12/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InputTarget : NSObject
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) InputTarget *nextTarget;

- (instancetype)initWithTarget:(UITextField *)textField nextTarget:(InputTarget *)nextTarget;

@end
