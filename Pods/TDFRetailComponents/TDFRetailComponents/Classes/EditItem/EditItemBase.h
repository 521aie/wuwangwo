//
//  EditItemBase.h
//  RestApp
//
//  Created by zxh on 14-4-2.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemBase.h"
#import "EditItemChange.h"

@interface EditItemBase : UIView<ItemBase, EditItemChange>

@property (nonatomic, strong) NSString *notificationType;
@property (nonatomic, strong) NSString *oldVal;
@property (nonatomic) NSInteger groupSortCode;
@property (nonatomic, strong) IBOutlet UILabel *lblTip;
@property (nonatomic, strong) NSString *currentVal;
@property (nonatomic) BOOL baseChangeStatus;

/**ItemID*/
@property (nonatomic, assign) NSInteger ItemID;

- (BOOL)isChange;

//保存完取消 【未保存】状态 用
- (void)setChangedStatus;

-(void)visibal:(BOOL)show;

- (id)loadNibWithowner:(id)owner;
@end
