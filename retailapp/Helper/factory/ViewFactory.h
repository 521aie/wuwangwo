//
//  ViewFactory.h
//  retailapp
//
//  Created by hm on 15/7/2.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewFactory : NSObject
+ (UIView *)generateFooter:(CGFloat)height;

+ (UIView *)backgroundOfTableView:(UITableView*)table;

+ (void)clearTableView:(UITableView *)table;

+ (UIView *)setTableViewOfClear:(UITableView *)table;

+ (UIView *)setClearView:(CGRect)frame;
@end
