//
//  ScanViewController.h
//  retailapp
//
//  Created by hm on 15/7/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
#import <AVFoundation/AVFoundation.h>

/**
 常见的条码类型有
 一维码：Code39码（标准39码）、Codabar码（库德巴码）、Code25码（标准25码）、ITF25码（交叉25码）、Matrix25码（矩阵25码）、UPC-A码、UPC-E码、EAN-13码（EAN-13国际商品条码）、EAN-8码（EAN-8国际商品条码）、中国邮政码（矩阵25码的一种变体）、Code-B码、MSI码、、Code11码、Code93码、ISBN码、ISSN码、Code128码（Code128码，包括EAN128码）、Code39EMS（EMS专用的39码）等
 二维码：PDF417码、QR码、Code49码、Code 16K码、Data Matrix码、MaxiCode码等
 *
 */

typedef NS_OPTIONS(NSInteger ,LSScannerTypes){
    LSScannerQRcode  = 1 << 0, // 二维码
    LSScannerBarcode = 1 << 1, // 条形码
};
@protocol LSScanViewDelegate;
@interface ScanViewController : LSRootViewController

/* 指示可以扫描的类型，QR || Bar Code, iOS原生条码扫描同时支持二维码和条形码，不如单一扫描一种是的速度快，所以如果不需要同时支持二者，建议制定扫描的类型。默认同时支持二维码和条形码。
 */
@property (nonatomic ,assign) LSScannerTypes types;
@property (nonatomic ,copy) NSString *lblTitle;/* <导航栏title*/
@property (nonatomic ,weak) id<LSScanViewDelegate> scanDelegate;

+ (ScanViewController *)shareInstance:(id<LSScanViewDelegate>)delegate types:(LSScannerTypes)scanTypes;
@end

@protocol LSScanViewDelegate <NSObject>

- (void)scanFail:(ScanViewController *)controller with:(NSString *)message;
- (void)scanSuccess:(ScanViewController *)controller result:(NSString *)scanString;

@optional
// 实现了该代理方法，自己负责处理ScanViewController从界面移除，如果没有实现，会尝试调用-popViewControllerAnimated 或 -dismissViewControllerAnimated 方法
- (void)closeScanView;
@end


