//
//  EditItemList2.h
//  retailapp
//
//  Created by diwangxie on 16/4/28.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditItemBase.h"

@class EditItemList2;
@protocol EditItemList2Delegate <NSObject>

@optional
- (void)btnAddClick:(EditItemList2 *)item;
@end

@interface EditItemList2 : EditItemBase
@property (nonatomic, strong) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UILabel *lblStyleCode;
@property (weak, nonatomic) IBOutlet UILabel *lblStyleName;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
@property (nonatomic, strong) id<EditItemList2Delegate> delegate;
//@property (weak, nonatomic) IBOutlet UILabel *lblTip;

-(void)initLabel:(NSString *)label request:(BOOL)request delegate:(id<EditItemList2Delegate>)delegate;

- (void)initCode:(NSString *)code initName:(NSString *)name;

- (void)changeCode:(NSString *)code initName:(NSString *)name;

- (NSString *)getVal;

@end
