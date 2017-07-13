//
//  EditItemCertId.h
//  RestApp
//
//  Created by zxh on 14-10-2.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "EditItemBase.h"
#import "IEditItemImageEvent.h"

#define TAG_FRONTCERTID 10000   //前面身份证
#define TAG_BACKCERTID 10001    //背面身份证.

@class ItemCertId;
@interface EditItemCertId : EditItemBase

@property (nonatomic, strong) IBOutlet UIView *view;
@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet ItemCertId *frontCertId;
@property (nonatomic, strong) IBOutlet ItemCertId *backCertId;

@property (nonatomic) id<IEditItemImageEvent> delegate;

@property (nonatomic) BOOL frontChange;
@property (nonatomic) BOOL backChange;

@property (nonatomic, strong) NSString* frontPath;
@property (nonatomic, strong) NSString* backPath;
+ (instancetype)editItemCartId;
- (void)initLabel:(NSString*)label delegate:(id<IEditItemImageEvent>)delegate;
//身份证正面
- (void)initFrontImg:(NSString *)filePath;
- (void)changeFrontImg:(NSString*)filePath img:(UIImage*)img;

//身份证背面
- (void)initBackImg:(NSString *)filePath;
- (void)changeBackImg:(NSString*)filePath img:(UIImage*)img;



@end
