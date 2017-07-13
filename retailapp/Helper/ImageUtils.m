//
//  ImageUtils.m
//  retailapp
//
//  Created by hm on 15/6/26.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "ImageUtils.h"
#import "NSString+Estimate.h"
#import "RegexKitLite.h"
#import "UIImage+Resize.h"

@implementation ImageUtils
+ (NSString *)getImageUrl:(NSString *)server path:(NSString *)path
{
    return [NSString stringWithFormat:IMAGE_URL_FORMAT, server, path];
}

+ (NSString *)getSmallImageUrl:(NSString *)server path:(NSString *)path
{
    return [NSString stringWithFormat:SMALL_IMAGE_URL_FORMAT, server, path];
}

+ (UIImage *)changeImageSize:(UIImage *)image size:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (NSString *)smallPath:(NSString *)sourcePath
{
    if ([NSString isBlank:sourcePath]) {
        return sourcePath;
    }
    NSString *format=@"[\\?+?]ran=([^&]+)";
    return [sourcePath stringByReplacingOccurrencesOfRegex:format withString:@"_s"];
}

+ (UIImage *)scaleImageOfDifferentCondition:(UIImage *)image condition:(int)condition
{
    // 服鞋模式condition为101
    if (condition == 101) {
        return [self scaleImage:image width:800 height:800];
    } else {
        return [self scaleImage:image width:1080 height:720];
    }
}
//微店主页设置
+ (UIImage *)scaleWeChatHomePapeSetPic:(UIImage*)image setType:(int)setType
{
    //轮播图裁剪
    if (setType==1) {
        return [self scaleImage:image width:800 height:450];
    }else if (setType==2){
        //双列焦点图裁剪
        return [self scaleImage:image width:360 height:150];
    }else if (setType==3){
        //热门分类图裁剪
        return [self scaleImage:image width:180 height:180];
    }
    return nil;
}


+ (UIImage *)cropWeChatPhoto:(UIImage *)rawIamge dispalyWidth:(CGFloat)newWidth {
    
    CGFloat expectWidth = 1334.f;
    CGSize rawSize = rawIamge.size;
    CGSize newSize = CGSizeMake(rawSize.width, rawSize.height);
    if (rawSize.width >= expectWidth) {
        newSize.width = expectWidth;
        newSize.height = rawSize.height*(expectWidth/rawSize.width);
    }
    UIImage *newImage = [rawIamge resizedImage:newSize
                          interpolationQuality:kCGInterpolationLow];
    return newImage;
}

// 头像等压缩
+ (UIImage *)compressImage:(UIImage *)rawIamge experWidth:(CGFloat)expectWidth {
    
    CGSize rawSize = rawIamge.size;
    CGSize newSize = CGSizeMake(rawSize.width, rawSize.height);
    if (rawSize.width >= expectWidth) {
        newSize.width = expectWidth;
        newSize.height = rawSize.height*(expectWidth/rawSize.width);
    }
    UIImage *newImage = [rawIamge resizedImage:newSize
                          interpolationQuality:kCGInterpolationLow];
    return newImage;
}

+ (NSData *)dataOfImageAfterCompression:(UIImage *)image
{
    float point = 1;
    if (UIImageJPEGRepresentation(image, 1.0).length/1024 > 100) {
        point = 0.8;
        for (;;) {
            NSInteger size = UIImageJPEGRepresentation(image, point).length;
            if (size <= 200 || point <= 0.11) {
                break;
            }
            point = point - 0.1;
        }
    }
    
    return UIImageJPEGRepresentation(image, point);
}

+ (UIImage *)scaleImage:(UIImage *)image width:(int)targetWidth height:(int)targetHeight
{
    int width = targetWidth;
    int height = targetHeight;
    float scale = [self getScaleRatio:image width:targetWidth height:targetHeight];
    if (scale < 1) {
        width = image.size.width*scale;
        height = image.size.height*scale;
    }
    
    CGSize size = CGSizeMake(width, height);
    return [self changeImageSize:image size:size];
}

+ (float)getScaleRatio:(UIImage *)image width:(int)width height:(int)height
{
    float scaleRatio = 1.0;
    float originWidth = image.size.width;
    float originHeight = image.size.height;
    if (width > 0 && height <= 0) {
        if (originWidth > width) {
            scaleRatio=width/originWidth;
        }
    }else if(width<=0 && height>0){
        if (originHeight>height) {
            scaleRatio=height/originHeight;
        }
    }else if(width>0 && height>0){
        float widthRatio=1.0;
        float heightRatio=1.0;
        if (originWidth>width) {
            widthRatio=width/originWidth;
            scaleRatio=widthRatio;
        }
        if (originHeight>height) {
            heightRatio=height/originHeight;
            if (heightRatio<widthRatio) {
                scaleRatio=heightRatio;
            }
        }
    }
    return scaleRatio;
    
}

@end
