//
//  SRButtonView.h
//  retailapp
//
//  Created by Jianyong Duan on 15/11/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SRButtonView : UIView

@property (weak, nonatomic) IBOutlet UIButton *buttonNext;

+ (SRButtonView *)loadFromNibWithTitle:(NSString *)title;

@end
