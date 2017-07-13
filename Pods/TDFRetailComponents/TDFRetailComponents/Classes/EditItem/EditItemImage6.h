//
//  EditItemImage3.h
//  retailapp
//
//  Created by zhangzt on 15/10/29.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IEditItemImageEvent.h"
#import "EditItemBase.h"

@class EditItemImage6;

@protocol EditItemImage6Delegate <NSObject>

- (void)editItemImage2:(EditItemImage6 *)item;
@end
@interface EditItemImage6 : EditItemBase

@property (strong, nonatomic) IBOutlet UIView *view;

@property (nonatomic, strong) IBOutlet UIView *borderView;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
@property (nonatomic, strong) IBOutlet UIImageView *imgAdd;
@property (weak, nonatomic) IBOutlet UIImageView *img;

@property (weak, nonatomic) IBOutlet UILabel *lblStyleName;
@property (weak, nonatomic) IBOutlet UILabel *lblWeChatPrice;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *lblHint;

@property (nonatomic, strong) id<EditItemImage6Delegate> delegate;
@property (nonatomic, strong) NSString *imgFilePath;
@property (nonatomic) BOOL changed;
@property (nonatomic,strong) NSString* paperId;
@property (nonatomic,strong) NSString* styleCode;
//@property (strong, nonatomic) IBOutlet UIView *contentView;

- (void)initView:(NSString *)filePath path:(NSString *)path  styleCode:(NSString *) styleCode;

- (void)changeImg:(NSString *)filePath img:(UIImage*)img;

- (id)initWithFrame:(CGRect)frame delegate:(id<EditItemImage6Delegate>)delegate;

- (void)initListView:(NSDictionary *)dic delegate:(id<EditItemImage6Delegate>)delegate;

-(void)initImgId:(NSString *) homePageId;

-(NSString *)getImgId;

- (NSString *)getImageFilePath;

//-(void)btnAddClick:(UIButton *)btnAdd;
@end
