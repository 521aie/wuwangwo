//
//  LSSystemAuthority.m
//  retailapp
//
//  Created by guozhi on 2016/11/14.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSSystemAuthority.h"
#import "AlertBox.h"
#import <Photos/Photos.h>
@implementation LSSystemAuthority
#pragma mark - 相册权限
+ (BOOL)isCanUsePhotos {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [AlertBox show:@"相册好像不能访问哦!"];
        return NO;
    }
    /*kCLAuthorizationStatusNotDetermined = 0, // 用户尚未做出选择这个应用程序的问候
     kCLAuthorizationStatusRestricted,        // 此应用程序没有被授权访问的照片数据。可能是家长控制权限
     kCLAuthorizationStatusDenied,            // 用户已经明确否认了这一照片数据的应用程序访问
     kCLAuthorizationStatusAuthorized         // 用户已经授权应用访问照片数据
     */
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied) {
        [AlertBox show:[NSString stringWithFormat:@"请在设备的\"设置-隐私-照片\"选项中，允许%@访问你的手机相册",  [[NSBundle mainBundle] infoDictionary][@"CFBundleDisplayName"]]];
        //无权限
        return NO;
    }
    return YES;
}
#pragma mark - 相机权限
+ (BOOL)isCanUseCamera {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [AlertBox show:@"相机好像不能用哦!"];
        return NO;
    }
    /*AVAuthorizationStatusNotDetermined = 0,// 系统还未知是否访问，第一次开启相机时
     AVAuthorizationStatusRestricted, // 受限制的
     AVAuthorizationStatusDenied, //不允许
     AVAuthorizationStatusAuthorized // 允许状态*/
    AVAuthorizationStatus authStatus =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
    {
        [AlertBox show:[NSString stringWithFormat:@"请在设备的\"设置-隐私-相机\"选项中，允许%@访问你的手机相机",  [[NSBundle mainBundle] infoDictionary][@"CFBundleDisplayName"]]];
        //无权限
        return NO;
    }
    return YES;
}

@end
