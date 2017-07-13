//
//  EditItemRatio.h
//  RestApp
//
//  Created by zxh on 14-4-2.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "EditItemBase.h"
#import "EditItemChange.h"
#import "IEditItemRadioEvent.h"

@interface EditItemRadio : EditItemBase<EditItemChange>
{
    //UIView *view;
}

@property (nonatomic) id<IEditItemRadioEvent> delegate;

@property (nonatomic, strong) IBOutlet UIView *view;
@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UIImageView *imgOn;
@property (nonatomic, strong) IBOutlet UIImageView *imgOff;
@property (nonatomic, strong) IBOutlet UITextView *lblDetail;
@property (nonatomic, strong) IBOutlet UIView *line;
@property (nonatomic, strong) IBOutlet UIButton *btnRadio;
//@property (nonatomic, strong) IBOutlet UIButton *btnRadioDynamic;
@property (weak, nonatomic) IBOutlet UIImageView *imgIndent;

- (void)initLabel:(NSString *)label withHit:(NSString *)hit;
- (void)initLabel:(NSString *)label withHit:(NSString *)hit delegate:(id<IEditItemRadioEvent>)delegate;
- (void)initCompanion:(NSString *)label withHit:(NSString *)hit delegate:(id<IEditItemRadioEvent>)delegate;

- (void)initIndent:(NSString *)label withHit:(NSString *)hit delegate:(id<IEditItemRadioEvent>)delegate;
- (void)initIndent:(NSString *)label withHit:(NSString *)hit indent:(BOOL)indent delegate:(id<IEditItemRadioEvent>)delegate;

- (void)initLabel:(NSString *)label  withVal:(NSString *)data;
- (void)initShortData:(short)shortVal;
- (void)initData:(NSString *)data;

- (void)changeLabel:(NSString *)label withVal:(NSString *)data;
- (void)changeData:(NSString *)data;

- (void)initLabel:(NSString *)label withVal:(NSString*)data withHit:(NSString *)hit;

- (IBAction)btnRatioClick:(id)sender;

- (BOOL)getVal;
- (NSString *)getStrVal;

- (void)isEditable:(BOOL)editable;
+ (EditItemRadio *)editItemRadio;
+ (EditItemRadio *)itemRadio;
@end
