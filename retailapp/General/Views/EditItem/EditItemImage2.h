//
//  EditItemImage2.h
//  retailapp
//
//  Created by hm on 15/8/9.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "EditItemBase.h"
#import "IEditItemImageEvent.h"
@interface EditItemImage2 : EditItemBase<UIActionSheetDelegate>

@property (nonatomic,weak) IBOutlet UIView *view;
@property (nonatomic, strong) IBOutlet UIView *borderView;
@property (nonatomic,weak) IBOutlet UILabel* lblName;
@property (nonatomic,weak) IBOutlet UIImageView* img;
@property (nonatomic,weak) IBOutlet UIImageView* imgAdd;
@property (nonatomic,weak) IBOutlet UILabel* lblAdd;
@property (nonatomic,weak) IBOutlet UIButton* btnAdd;
@property (nonatomic,weak) IBOutlet UIImageView* imgDel;
@property (nonatomic,weak) IBOutlet UIButton* btnDel;
@property (nonatomic, strong) IBOutlet UIView *line;

@property (nonatomic, assign) id<IEditItemImageEvent> delegate;
@property (nonatomic, strong) NSString *imgFilePath;
@property (nonatomic) BOOL changed;
@property (nonatomic) BOOL isShow;
@property (nonatomic, strong) NSString *title;

+ (instancetype)editItemImage;
- (void)initLabel:(NSString*)label delegate:(id<IEditItemImageEvent>)delegate title:(NSString*) title;
- (void)initView:(NSString *)filePath path:(NSString *)path;
- (void)changeImg:(NSString *)filePath img:(UIImage*)img;
- (void)initImg:(NSString *)filePath img:(UIImage*)img;//add for 员工管理EmployeeEditView
- (NSString *)getImageFilePath;

- (IBAction)btnAddClick:(id)sender;
- (IBAction)btnDelClick:(id)sender;
- (void)isEditable:(BOOL)editable;
@end
