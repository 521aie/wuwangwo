//
//  LSScreenShot.m
//  retailapp
//
//  Created by guozhi on 16/8/29.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSScreenShot.h"

@implementation LSScreenShot
+ (UIImage *)screenShot:(UIView *)view {
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    //获取图片
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    //关闭上下文
    UIGraphicsEndImageContext();
    /**
     *  将图片保存到本地相册
     */
    UIImageWriteToSavedPhotosAlbum(image, self , @selector(image:didFinishSavingWithError:contextInfo:), nil);//保存图片到照片库
    return image;
    
}

+ (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
    if(!error){
        NSLog(@"保存成功");
    }
}
@end
