//
//  InputTarget.m
//  retailapp
//
//  Created by hm on 15/12/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "InputTarget.h"

@implementation InputTarget
- (instancetype)initWithTarget:(UITextField *)textField nextTarget:(InputTarget *)nextTarget
{
    self = [super init];
    if (self) {
        self.textField = textField;
        self.nextTarget = nextTarget;
    }
    return self;
}
@end
