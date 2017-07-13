//
//  HeaderItem.m
//  retailapp
//
//  Created by qingmei on 15/9/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "HeaderItem.h"

@interface HeaderItem ()

@end

@implementation HeaderItem

+ (instancetype)headerItem {
    HeaderItem *headerItem = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
    return headerItem;
}
- (void)initWithName:(NSString *)name
{
    self.background.layer.cornerRadius = HEADER_RADIUS;
    self.lbtitle.text = name;
}

@end
