//
//  EditItemImage.h
//  RestApp
//
//  Created by zxh on 14-7-17.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditItemBase.h"
#import "IEditItemImageEvent.h"

@interface EditItemImage : EditItemBase<UIActionSheetDelegate>

@property (nonatomic, strong) IBOutlet UIView *view;
@property (nonatomic, strong) IBOutlet UIView *borderView;
@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UIButton *btnAdd;
@property (nonatomic, strong) IBOutlet UIButton *btnDel;
@property (nonatomic, strong) IBOutlet UIImageView *imgAdd;
@property (nonatomic, strong) IBOutlet UILabel *lblAdd;
@property (nonatomic, strong) IBOutlet UIImageView *img;
@property (nonatomic, strong) IBOutlet UIImageView *imgDel;
@property (weak, nonatomic) IBOutlet UILabel *lblDetail;
@property (nonatomic, strong) IBOutlet UIView *line;
@property (nonatomic, strong) IBOutlet UILabel *lblInfo;
@property (nonatomic, weak) id<IEditItemImageEvent> delegate;
@property (nonatomic, strong) NSString *imgFilePath;
@property (nonatomic) BOOL changed;

+ (instancetype)editItemImage;

- (void)initLabel:(NSString*)label withHit:(NSString *)_hit delegate:(id<IEditItemImageEvent>)_delegate;

- (void)initView:(NSString *)filePath path:(NSString *)path;

- (void)changeImg:(NSString *)filePath img:(UIImage*)img;

- (NSString *)getImageFilePath;

- (IBAction)btnAddClick:(id)sender;

- (IBAction)btnDelClick:(id)sender;

- (void)editEnabled:(BOOL)enable;

@end
