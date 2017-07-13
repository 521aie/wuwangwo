//
//  ItemCertId.h
//  RestApp
//
//  Created by zxh on 14-10-2.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IEditItemImageEvent.h"

@protocol ImageRemoveHandle <NSObject>
@required
-(void)delImg:(id)obj;

@end

@interface SelectImgItem2 : UIView<UIActionSheetDelegate>
{
    NSString *filePath;
    
    NSString *path;
    
}
@property (nonatomic, strong) IBOutlet UIView *bgView;
@property (nonatomic, strong) IBOutlet UIView *addView;

@property (nonatomic, strong) IBOutlet UIImageView *imgView;
@property (nonatomic, strong) IBOutlet UIButton *btnItem;
@property (strong, nonatomic) IBOutlet UIButton *btnUp;
@property (weak, nonatomic) IBOutlet UIImageView *imgUp;
@property (strong, nonatomic) IBOutlet UIButton *btnDown;
@property (weak, nonatomic) IBOutlet UIImageView *imgDown;

@property (nonatomic,strong) NSString *homePageId;

@property (nonatomic, strong) id<IEditItemImageEvent> delegate;
@property (nonatomic, strong) NSString* objId;

- (void)initDelegate:(id<IEditItemImageEvent>)delegate;

- (IBAction)onBtnClick:self;

- (IBAction)UP:(id)sender;

- (IBAction)DOWN:(id)sender;

- (void)initView:(NSString *)filePath path:(NSString *)path;

- (void)initWithImage:(UIImage *)image path:(NSString *)path;

@end
