//
//  EditItemImage3.h
//  retailapp
//
//  Created by zhangzt on 15/10/29.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditItemBase.h"
#import "IEditItemImageEvent.h"

@interface EditItemImage3 : EditItemBase<UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UIView *view;
@property (nonatomic, strong) IBOutlet UIView *borderView;
@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UIButton *btnAdd;
@property (nonatomic, strong) IBOutlet UIButton *btnDel;
@property (nonatomic, strong) IBOutlet UIImageView *imgAdd;
@property (nonatomic, strong) IBOutlet UILabel *lblAdd;
@property (nonatomic, strong) IBOutlet UIImageView *img;
@property (nonatomic, strong) IBOutlet UIImageView *imgDel;
@property (nonatomic, strong) IBOutlet UITextView *lblDetail;
@property (nonatomic, strong) IBOutlet UIView *line;
@property (nonatomic, strong) id<IEditItemImageEvent> delegate;
@property (nonatomic, strong) NSString *imgFilePath;
@property (nonatomic, strong) NSString *oldImgFilePath;
@property (nonatomic, strong) NSString *colorId;
@property (nonatomic) BOOL changed;

- (void)initLabel:(NSString*)label withHit:(NSString *)_hit delegate:(id<IEditItemImageEvent>)_delegate;

- (void)initLabel:(NSString*)label colorId:(NSString *) colorId withHit:(NSString *)hit delegate:(id<IEditItemImageEvent>)delegate;

- (void)initView:(NSString *)filePath path:(NSString *)path;

- (void)changeImg:(NSString *)filePath img:(UIImage*)img;

- (NSString *)getImageFilePath;

- (NSString *)getColorId;

- (IBAction)btnAddClick:(id)sender;

- (IBAction)btnDelClick:(id)sender;

- (void)imageItemEditable:(BOOL)editable;
@end
