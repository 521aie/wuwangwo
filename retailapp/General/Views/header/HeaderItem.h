//
//  HeaderItem.h
//  retailapp
//
//  Created by qingmei on 15/9/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HEADER_RADIUS 12
#define HEADER_ITEM @"HEADER_ITEM"
#define HEADER_ITEM_HEIGHT 40

@interface HeaderItem : UIView

@property (nonatomic, strong) IBOutlet UIView *background;
@property (nonatomic, strong) IBOutlet UILabel *lbtitle;
+ (instancetype)headerItem;
- (void)initWithName:(NSString *)name;

@end
