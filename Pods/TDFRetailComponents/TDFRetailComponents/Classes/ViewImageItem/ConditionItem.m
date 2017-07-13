//
//  ConditionItem.m
//  retailapp
//
//  Created by hm on 16/1/5.
//  Copyright (c) 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "ConditionItem.h"
#import "NSString+Estimate.h"

@implementation ConditionItem

+ (ConditionItem *)loadFromNib {
    ConditionItem *conditionItem = [[[NSBundle mainBundle] loadNibNamed:@"ConditionItem" owner:self options:nil] lastObject];
    return conditionItem;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (IBAction)onSelectBtnClick:(id)sender {
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(onConditionClick:)]) {
        [self.delegate onConditionClick:self];
    }
}

- (void)initLabel:(NSString *)label delegate:(id<ConditionItemDelegate>)delegate {
    
    self.delegate = delegate;
    self.lblName.text = label;
}

- (void) initData:(NSString*)dataLabel withVal:(NSString*)data {
    
    self.currentVal = ([NSString isBlank:data]) ? @"" :data;
    self.txtVal.text = ([NSString isBlank:dataLabel]) ? @"" :dataLabel;
}

- (NSString *)getStrVal {
    
    return self.currentVal;
}

@end
