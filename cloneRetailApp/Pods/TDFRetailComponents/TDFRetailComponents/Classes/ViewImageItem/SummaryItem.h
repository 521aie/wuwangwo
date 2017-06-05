//
//  SummaryItem.h
//  retailapp
//
//  Created by hm on 15/9/21.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SummaryItem : UIView

@property (nonatomic,weak) IBOutlet UILabel* lblName;
@property (nonatomic,weak) IBOutlet UILabel* lblVal;
@property (nonatomic,weak) IBOutlet UIView* line;

+ (SummaryItem*)loadFromNib;

- (void)initWithName:(NSString*)name withVal:(NSString*)value withColor:(UIColor*)color;

@end
