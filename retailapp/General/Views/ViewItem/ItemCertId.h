//
//  ItemCertId.h
//  RestApp
//
//  Created by zxh on 14-10-2.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageRemoveHandle.h"
#import "IEditItemImageEvent.h"

@interface ItemCertId : UIView<UIActionSheetDelegate>

@property (nonatomic, strong) IBOutlet UIView *view;

@property (nonatomic, strong) IBOutlet UIView *bgView;
@property (nonatomic, strong) IBOutlet UIView *addView;
@property (nonatomic, strong) IBOutlet UILabel *lblTitle;

@property (nonatomic, strong) IBOutlet UIImageView *imgView;
@property (nonatomic, strong) IBOutlet UIImageView *imgDel;
@property (nonatomic, strong) IBOutlet UIButton *btnDel;
@property (nonatomic, strong) IBOutlet UIButton *btnAdd;

@property (nonatomic, strong) NSString* filePath;
@property (nonatomic, strong) id<IEditItemImageEvent> delegate;
@property (nonatomic, strong) NSString* objId;
@property (nonatomic, copy) NSString *currentVal;
@property (nonatomic, copy) NSString *oldVal;
@property (nonatomic, assign) BOOL isChange;

- (void)initLabel:(NSString*)label delegate:(id<IEditItemImageEvent>)delegate;

- (IBAction)onDelClick:(id)sender;

- (IBAction)onBtnClick:(id)sender;

- (void)initView:(NSString *)filePath;

- (void)changeImg:(NSString*)filePath img:(UIImage*)img;

- (void)setOnlyShow;
- (void)showAddUI:(BOOL)flag;

@end
