//
//  LSNavigateItem.m
//  retailapp
//
//  Created by taihangju on 16/8/30.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSNavigateItem.h"

@interface LSNavigateItem()

@end

@implementation LSNavigateItem


- (void)configSubViewsWith:(BOOL)showOneRowText {
    
    CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    CGFloat labelsWidth = screenWidth - 30; // label 和 contentView的宽度
    CGFloat totalHeight = CGRectGetHeight(self.frame); //LSNavigateItem 高度
    CGFloat imageViewSide = 22.0f; // iamgeView的宽高
    
    if (showOneRowText) {
        
        // 单一一行的高度固定 24.0
        self.singleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, (totalHeight - 24)/2, labelsWidth - 12, 24)];
        self.singleLabel.textColor = [UIColor colorWithRed:0.0 green:136/255.0 blue:204/255.0 alpha:1];
        self.singleLabel.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:self.singleLabel];
    }
    else
    {
        // 固定contentView 高度36 ， 预算headLabel 高度20 ，assistantLabel 高度 16.0f
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, (totalHeight - 36)/2, labelsWidth, 36)];
        [self addSubview:contentView];
        // 主标题信息
        self.headLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, labelsWidth - 12, 20)];
        self.headLabel.textColor = [UIColor blackColor];
        self.headLabel.font = [UIFont systemFontOfSize:15.0];
        [contentView addSubview:self.headLabel];
        
        // 副标题信息
        self.assistantLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 20, labelsWidth - 12, 16)];
        self.assistantLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        self.assistantLabel.font = [UIFont systemFontOfSize:13];
        [contentView addSubview:self.assistantLabel];
    }
    
    
    // 指示image， 向右的箭头
    self.indicateImageView = [[UIImageView alloc] initWithFrame:
                              CGRectMake(labelsWidth, (totalHeight - imageViewSide)/2 , imageViewSide, imageViewSide)];
    self.indicateImageView.image = [UIImage imageNamed:@"ico_next"];
    [self addSubview:self.indicateImageView];
    
    // bottom Line
    self.bottomLine = [[UIView alloc] initWithFrame:CGRectMake(10, totalHeight - 0.5, screenWidth - 20, 1)];
    self.bottomLine.backgroundColor = [UIColor blackColor];
    self.bottomLine.alpha = 0.1;
    [self addSubview:self.bottomLine];
}


+ (LSNavigateItem *)createItem:(NSString *)headText assisantText:(NSString *)assisantText {
    
    LSNavigateItem *item = [[LSNavigateItem alloc] initWithFrame:
                            CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 48.0f)];
    [item configSubViewsWith:NO];
    item.bottomLine.hidden = YES;
    item.headLabel.text = headText ? : @"";
    item.assistantLabel.text = assisantText ? : @"";
    return item;
}

+ (LSNavigateItem *)createItem:(NSString *)singleText {
    
    LSNavigateItem *item = [[LSNavigateItem alloc] initWithFrame:
                            CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 48.0f)];
    [item configSubViewsWith:YES];
    item.singleLabel.text = singleText ? : @"";
    return item;
}

- (nullable UIView *)hitTest:(CGPoint)point withEvent:(nullable UIEvent *)event {
    
    if ([self pointInside:point withEvent:event]) {
        return self;
    }
    return nil;
}

@end
