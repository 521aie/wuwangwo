//
//  MenuListCell.m
//  retailapp
//
//  Created by 果汁 on 15/9/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "MenuListCell.h"

@implementation MenuListCell
- (instancetype)initName:(NSString *)name val:(NSString *)val {
    self = [super init];
    if (self) {
        self.name = name;
        self.val = val;
    }
    return self;
}
@end
