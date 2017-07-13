//
//  EditItemAddCorrelation.h
//  retailapp
//
//  Created by diwangxie on 16/4/25.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditItemBase.h"

@interface EditItemCorrelation : EditItemBase
@property (nonatomic, strong) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIView *CorrelationView;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UILabel *lblCorrelationSum;

-(void)initCorrelationSum:(NSInteger)sum;
@end
