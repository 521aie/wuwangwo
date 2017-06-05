//
//  ImageUtils.h
//  retailapp
//
//  Created by hm on 15/6/26.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//


#define IMAGE_URL_FORMAT @"http://%@/upload_files/%@"

#define SMALL_IMAGE_URL_FORMAT @"http://%@/upload_files/%@_s"
@interface ImageUtils : NSObject

+ (NSString *)getImageUrl:(NSString *)server path:(NSString *)path;

+ (NSString *)getSmallImageUrl:(NSString *)server path:(NSString *)path;

+ (UIImage *)changeImageSize:(UIImage *)image size:(CGSize)size;

+ (UIImage *)scaleImage:(UIImage *)image width:(int)width height:(int)height;

+(NSString *) smallPath:(NSString *)sourcePath;

// 商超、服鞋
+ (UIImage *)scaleImageOfDifferentCondition:(UIImage*)image condition:(int)condition;

// 读取压缩后图片数据
+(NSData *)dataOfImageAfterCompression:(UIImage *)image;

+ (UIImage *)scaleWeChatHomePapeSetPic:(UIImage *)image setType:(int)setType;

/**
 *  根据宽度裁剪图片，注意这个宽度是最终在微店h5中显示的图片宽度
 */
+ (UIImage *)cropWeChatPhoto:(UIImage *)rawIamge dispalyWidth:(CGFloat)newWidth;
/**
 *  <#Description#>
 *
 *  @param rawIamge    <#rawIamge description#>
 *  @param expectWidth <#expectWidth description#>
 *
 *  @return <#return value description#>
 */
+ (UIImage *)compressImage:(UIImage *)rawIamge experWidth:(CGFloat)expectWidth;
@end
