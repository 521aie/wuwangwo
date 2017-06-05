//
//  SRItemView2.h
//  retailapp
//
//  Created by Jianyong Duan on 15/11/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SRItemView2 : UIView

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblValue;

+ (SRItemView2 *)loadFromNib;
- (void)setTitle:(NSString *)title value:(NSString *)value;

@end
