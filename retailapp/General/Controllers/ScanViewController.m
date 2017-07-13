//
//  ScanView.m
//  retailapp
//
//  Created by hm on 15/7/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "ScanViewController.h"
#import "XHAnimalUtil.h"

#define kIntersetRectangleLenth  220   //扫描对准框的边长，是一个正方形
@interface ScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>
{
    UIImageView *_scanImageBox;
    UIImageView *_line;
    CGRect _lineOrginRect;
}

@property (strong, nonatomic) AVCaptureDevice *device;
@property (strong, nonatomic) AVCaptureDeviceInput *input;
@property (strong, nonatomic) AVCaptureMetadataOutput *output;
@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *preview;
@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGBA(255.0, 255.0, 255.0, 0.7);
    [self initNavigate];
    [self configScanUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginScanAnimation) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)setLblTitle:(NSString *)lblTitle {
    [self configTitle:lblTitle];
    _lblTitle = lblTitle;
}

// 默认是条形码扫描
- (LSScannerTypes)types{
    if (!_types) {
        _types = LSScannerBarcode;
    }
    return _types;
}

+ (ScanViewController *)shareInstance:(id)delegate types:(LSScannerTypes)scanTypes{
    ScanViewController *scanViewController = [[ScanViewController alloc] init];
    scanViewController.types = scanTypes;
    scanViewController.scanDelegate = delegate;
    [scanViewController startScan];
    return scanViewController;
}

- (void)initNavigate
{
    NSString *title = self.lblTitle ? self.lblTitle: @"扫一扫";
    [self configTitle:title leftPath:Head_ICON_BACK rightPath:nil];
}


- (BOOL)isAVCaptureActive {

    // 模拟器等没相机的
    if (![[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count]) {
        return NO; // 没有相机
    }

   // 已经询问过了获取相机权限，但被用户拒绝
   if ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusDenied || [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusRestricted) {

        if ([self.scanDelegate respondsToSelector:@selector(scanFail:with:)]) {
            // 没有用户权限
            [self.scanDelegate scanFail:self with:@"请在iPhone的“设置-隐私-相机”选项中，允许火掌柜访问你的相机。"];
        }
        return NO;
    }    return YES;
}

#pragma mark - 配置扫描界面
- (void)configScanUI{
    
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
    CGFloat height = CGRectGetHeight([UIScreen mainScreen].bounds);
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pick_bg"]];
    imageView.bounds = CGRectMake(0, 0, kIntersetRectangleLenth, kIntersetRectangleLenth);
    [self.view addSubview:imageView];
    imageView.center = self.view.center;
    _scanImageBox = imageView;
    
    
    // 创建中间扫描显示区域周围的遮罩layer
    CALayer *layerTop = [self createMaskLayer:CGRectMake(0, 64, width, (height -kIntersetRectangleLenth)/2-64)];
    CALayer *layerBottom = [self createMaskLayer:CGRectMake(0, CGRectGetMaxY(imageView.frame), width, (height -kIntersetRectangleLenth)/2)];
    CALayer *layerLeft = [self createMaskLayer:CGRectMake(0, CGRectGetMinY(imageView.frame), (width - kIntersetRectangleLenth)/2, kIntersetRectangleLenth)];
    CALayer *layerRight = [self createMaskLayer:CGRectMake(CGRectGetMaxX(imageView.frame), CGRectGetMinY(imageView.frame), (width - kIntersetRectangleLenth)/2, kIntersetRectangleLenth)];
    
    [self.view.layer addSublayer:layerTop];
    [self.view.layer addSublayer:layerBottom];
    [self.view.layer addSublayer:layerLeft];
    [self.view.layer addSublayer:layerRight];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame), width, 22)];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14.0];
    label.text = @"将二维码/条形码放入框内，即可自动扫描";
    [self.view addSubview:label];
    
    // 扫描动画 线
    CGFloat lineWidth = kIntersetRectangleLenth - 20.f;
    _lineOrginRect = CGRectMake((width - lineWidth)/2, CGRectGetMinY(_scanImageBox.frame) + 5, lineWidth, 2);
    _line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line"]];
    _line.frame = _lineOrginRect;
    [self.view addSubview:_line];

}

#pragma mark - 扫描设置
- (void)scanSetting
{
    //获取摄像设备
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    //创建输出流
    self.output = [[AVCaptureMetadataOutput alloc]init];
    //设置代理 在主线程里刷新
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //初始化链接对象
    self.session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.output]) {
        [self.session addOutput:self.output];
    }


    //设置扫码支持的编码格式(如下设置条形码)
//    if (self.types == LSScannerQRcode) {
//        [_output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode, AVMetadataObjectTypePDF417Code ,AVMetadataObjectTypeAztecCode]];
//    }else if (self.types == LSScannerBarcode){
//        [_output setMetadataObjectTypes:@[AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeUPCECode]];
//    }else if (self.types == (LSScannerQRcode|LSScannerBarcode)){
//        [_output setMetadataObjectTypes:@[AVMetadataObjectTypeAztecCode, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeUPCECode ,AVMetadataObjectTypePDF417Code]];
//    }
    [_output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode39Code]];
    
    //实例化预览图层
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    //设置图层的frame
    self.preview.frame=self.view.layer.bounds;
    //设置预览图层填充方式
    self.preview.videoGravity=AVLayerVideoGravityResizeAspectFill;
    //将图层添加到预览view的图层上
    [self.view.layer insertSublayer:self.preview atIndex:0];
    //设置扫描范围CGRectMake（y的起点/屏幕的高，x的起点/屏幕的宽，扫描的区域的高/屏幕的高，扫描的区域的宽/屏幕的宽）
    //self.output.rectOfInterest = CGRectMake(self.pickBox.frame.origin.y/ScreenHigh, self.pickBox.frame.origin.x/ScreenWidth,self.pickBox.frame.size.height/ScreenHigh,self.pickBox.frame.size.width/ScreenWidth);
    self.output.rectOfInterest = [_preview metadataOutputRectOfInterestForRect:_scanImageBox.frame];
}

// 开始扫描
- (void)startScan{
    
    if ([self isAVCaptureActive]) {
        if (!_session) {
            [self scanSetting];
        }
        if (_session && ![_session isRunning]) {
            [_session startRunning];
            [self beginScanAnimation];
//            [self setupCameraFocus];
        }
    }
}

// 结束扫描
- (void)stopScan{
    if ([_session isRunning]) {
        [_session stopRunning];
        [_line.layer removeAllAnimations];
    }
}

-(void)beginScanAnimation{
    
    _line.frame = _lineOrginRect;
    CGRect newRect = _line.frame;
    newRect.origin.y += (kIntersetRectangleLenth - 10);
    [UIView animateWithDuration:4.0 delay:0.0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveLinear animations:^{
        _line.frame = newRect;
    } completion:nil];
}

#pragma mark - 添加模糊效果
- (CALayer *)createMaskLayer:(CGRect)frame{
    CALayer *layer = [CALayer layer];
    layer.frame = frame;
    layer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor;
    return layer;
}

#pragma mark - Camera Focus

//- (void)setupCameraFocus {
//    
//    AVCaptureDevice *device = _input.device;
//    NSError *error;
//    if ([device lockForConfiguration:&error]) {
//        
//        if (1.2 < device.activeFormat.videoMaxZoomFactor) {
//            device.videoZoomFactor = 1.2; // 有的设备可能不支持变焦放缩
//        }
//        
//        if ([device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
//            [device setFocusMode:AVCaptureFocusModeAutoFocus];
//        }
//        if ([device isAutoFocusRangeRestrictionSupported]) {
//            [device setAutoFocusRangeRestriction:AVCaptureAutoFocusRangeRestrictionNear];
//        }
//        
//        [device unlockForConfiguration];
//    }
//}


#pragma mark - UIGesture Touch
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    
//    UITouch *touch = [touches anyObject];
//    if (touch) {
//        CGPoint touchPoint = [touch locationInView:_scanImageBox];
//        if (touchPoint.x && touchPoint.y) {
//            AVCaptureDevice *device = _input.device;
//            NSError *error;
//            if ([device lockForConfiguration:&error]) {
//                if ([device isFocusPointOfInterestSupported]) {
//                    [device setFocusPointOfInterest:touchPoint];
//                }
//                if ([device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
//                    [device setFocusMode:AVCaptureFocusModeAutoFocus];
//                }
//                [device unlockForConfiguration];
//            }
//        }
//    }
//}


#pragma mark - 扫描成功后的回调代理
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {

    [self.session stopRunning];
    //输出扫描字符串, 二维码扫描是可以识别一帧图中的多个，这里不考虑这种情况
    if (metadataObjects.count > 0) {
        
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
        NSString *resultString = metadataObject.stringValue;
        /* AVMetadataObjectTypeEAN13Code generated from EAN-13 (including UPC-A)
        *   http://blog.csdn.net/abcpanpeng/article/details/8130392
        */
        if ([metadataObject.type isEqualToString:AVMetadataObjectTypeEAN13Code]) {
            if ([resultString hasPrefix:@"0"] && resultString.length > 1) {
                resultString = [resultString substringFromIndex:1];
            }
        }
        
        if ([self.scanDelegate respondsToSelector:@selector(scanSuccess:result:)]) {
            if (![self.scanDelegate respondsToSelector:@selector(closeScanView)]) {
                [self closeScanView];
            }
            [self.scanDelegate scanSuccess:self result:resultString];
        }
    }
}

#pragma mark - 导航栏事件处理代理
- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event {
    // 点击导航左侧返回按钮
    if (event == LSNavigationBarButtonDirectLeft) {
        [self.session stopRunning];
        if ([self.scanDelegate respondsToSelector:@selector(closeScanView)]) {
            [self.scanDelegate closeScanView];
            return;
        }
        [self closeScanView];
    }
}

// 关闭scanView
- (void)closeScanView {
    if (self.navigationController) {
          [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    self.scanDelegate = nil;
    [_session removeInput:_input];
    [_session removeOutput:_output];
    [_preview removeFromSuperlayer];
    _session = nil;
    _input = nil;
    _output = nil;
    _preview = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
