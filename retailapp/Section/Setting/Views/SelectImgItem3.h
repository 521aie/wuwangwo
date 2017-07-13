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

@interface SelectImgItem3 : UIView<UIActionSheetDelegate>
{
    NSString *filePath;
    
}
@property (nonatomic, strong) IBOutlet UIView *bgView;
@property (nonatomic, strong) IBOutlet UIView *addView;

@property (nonatomic, strong) IBOutlet UIImageView *imgView;
@property (nonatomic, strong) IBOutlet UIImageView *imgDel;
@property (nonatomic, strong) IBOutlet UIButton *btnDel;
@property (nonatomic, strong) IBOutlet UIButton *btnItem;
@property (strong, nonatomic) IBOutlet UIButton *btnUp;
@property (strong, nonatomic) IBOutlet UIButton *btnDown;
@property (nonatomic, copy) NSString *path;
/**
 *  初始路径 只有后台有图片数据时赋值 是为了区分这张图片是删除还是修改还是添加 如果oldPath = path 
 */
@property (nonatomic, copy) NSString *oldPath;

@property (nonatomic, strong) id<IEditItemImageEvent> delegate;
@property (nonatomic, strong) NSString* objId;
/** 上传中 */
@property (weak, nonatomic) IBOutlet UIView *viewUploading;
/** 上传失败 */
@property (weak, nonatomic) IBOutlet UILabel *lblFailed;


- (void)initDelegate:(id<IEditItemImageEvent>)delegate;

- (IBAction)onBtnClick:(id)sender;

- (IBAction)onDelClick:(id)sender;

- (IBAction)UP:(id)sender;

- (IBAction)DOWN:(id)sender;

- (void)initView:(NSString *)filePath path:(NSString *)path;

- (void)initWithImage:(UIImage *)image path:(NSString *)path;

@end
