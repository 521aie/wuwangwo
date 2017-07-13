//
//  ConditionItem.h
//  retailapp
//
//  Created by hm on 16/1/5.
//  Copyright (c) 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ConditionItem;
@protocol ConditionItemDelegate <NSObject>

@optional
- (void)onConditionClick:(ConditionItem *)item;

@end

@interface ConditionItem : UIView
@property (nonatomic, weak) IBOutlet UILabel *lblName;
@property (nonatomic, weak) IBOutlet UITextField *txtVal;
@property (nonatomic, weak) IBOutlet UIButton *button;
@property (nonatomic, weak) IBOutlet UIImageView *imageNext;
@property (nonatomic, strong) NSString* currentVal;
@property (nonatomic, weak) id<ConditionItemDelegate> delegate;
- (IBAction)onSelectBtnClick:(id)sender;
+ (ConditionItem *)loadFromNib;
- (void)initLabel:(NSString*)label delegate:(id<ConditionItemDelegate>) _delegate;
- (void) initData:(NSString*)dataLabel withVal:(NSString*)data;
-(NSString*)getStrVal;
@end
