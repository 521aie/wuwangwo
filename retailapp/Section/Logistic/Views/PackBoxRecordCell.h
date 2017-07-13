//
//  PackBoxRecordCell.h
//  retailapp
//
//  Created by hm on 15/11/3.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INameValueItem.h"
@protocol PackBoxRecordCellDelegate <NSObject>

@optional
- (void)delObj:(NSString *)itemId;
- (void)changeNavigateUI;
@end

@class GoodsPackRecordVo;
@class XBStepper;
@interface PackBoxRecordCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *lblName;
@property (nonatomic, weak) IBOutlet UILabel *lblVal;
@property (nonatomic, weak) IBOutlet UILabel *lblCount;
@property (nonatomic, weak) IBOutlet UILabel *lblTip;
@property (nonatomic, strong) XBStepper* stepper;

@property (nonatomic, assign) NSInteger oldCount;
@property (nonatomic, assign) NSInteger nowCount;

@property (nonatomic, strong) GoodsPackRecordVo *item;
@property (nonatomic, weak) id<PackBoxRecordCellDelegate> delegate;

- (void)loadDataWithItem:(GoodsPackRecordVo *)obj isEdit:(BOOL)isEdit;

@end
