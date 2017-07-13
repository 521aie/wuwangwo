//
//  LSImagePickerController.h
//  ScropViewController
//
//  Created by byAlex on 16/7/14.
//  Copyright © 2016年 DIY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger ,LSImageMessageType){
    LSImageMessageCancel = -1,           // 主动取消中断操作
    LSImageMessageNoSupportPhotoLibrary, // 无法访问相册
    LSImageMessageNoSupportCamera,       // 无法访问相机
    LSImageMessageNoSupportPhotosAlbum,  // 无法访问相薄
};

@protocol LSImagePickerDelegate;
@interface LSImagePickerController : UIViewController

@property (nonatomic, assign) CGSize cropSize; // 剪裁框size

+ (instancetype)showImagePickerWith:(UIImagePickerControllerSourceType)type presenter:(__kindof UIViewController<LSImagePickerDelegate> *)presentViewController;
@end

@protocol LSImagePickerDelegate <NSObject>

- (void)imagePicker:(LSImagePickerController *)controller pickerImage:(UIImage *)image;

- (void)imagePickerDidCancel:(LSImageMessageType)message;
@end
