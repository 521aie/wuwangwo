//
//  ItemValue.h
//  retailapp
//
//  Created by Jianyong Duan on 15/9/28.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemBase.h"

@interface ItemValue : UIView <ItemBase>

@property (strong, nonatomic) IBOutlet UIView *view;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLable;

@property (weak, nonatomic) IBOutlet UIView *line;

- (void)initLabel:(NSString *)name withValue:(NSString *)value;

@end
