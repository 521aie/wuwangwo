//
//  WechatApplyView.m
//  retailapp
//
//  Created by Jianyong Duan on 15/9/28.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "WechatApplyView.h"
#import "WechatAppTopView.h"
#import "WeChatAppMiddle.h"
#import "WeChatAppBottomView.h"

#import "NavigateTitle2.h"
#import "ItemValue.h"
#import "EditItemList.h"
#import "EditItemText.h"
#import "UIHelper.h"
//#import "OptionPickerBox.h"
#import "MemberRender.h"
#import "WechatService.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "Platform.h"
#import "EditItemMemo.h"
#import "MicroShopVo.h"
#import "JsonHelper.h"
//#import "CheckUnit.h"
#import "MemoInputView.h"
#import "XHAnimalUtil.h"
//#import "UMSocialData.h"
#import "UMSocialCore.h"
#import "OpenProtocolView.h"
#import <QuartzCore/QuartzCore.h>
#import "NSString+Estimate.h"
#import "MapView.h"
#import "MyPoint.h"
#import <CoreLocation/CoreLocation.h>
#import "MicroShopInfoVo.h"
//#import "UMSocialSnsService.h"
//#import "UMSocial.h"
#import "HomeViewController.h"
#import "LSWechatModuleController.h"
//会员类型编辑页面
#define MEMBER_TYPE_MICRO_STYLE 1
#define MEMBER_TYPE_KIND_CARD 2
#define TAG_TXT_ADRESS 3
#define TAG_TXT_INTRO 4
#define TAG_TXT_MESSAGE 5
@interface WechatApplyView () <AlertBoxClient,UIImagePickerControllerDelegate,UIAlertViewDelegate>
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UIView *container;
@property (nonatomic, strong)WechatAppTopView *topView;
@property (nonatomic, strong)WeChatAppMiddle *middleView;
@property (nonatomic, strong)WeChatAppBottomView *bootomView;



@property (nonatomic, strong) WechatService *wechatService;
@property (nonatomic, strong) MicroShopVo *microShopVo;
@property (nonatomic, strong) NSString *lat;
@property (nonatomic, strong) NSString *lng;
@property (nonatomic, strong) UIImage *imgQRCode;
/**
 *  分享地址
 */
@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong) MicroShopInfoVo *microShopInfoVo;/**<微店店信息vo>*/
@end

@implementation WechatApplyView


- (void)viewDidLoad {
    [super viewDidLoad];
    self.wechatService = [ServiceFactory shareInstance].wechatService;
    
    [self resignNotfication];
    [self initNavigate];
    [self configViews];
    [self getQrcode];
}

-(void)resignNotfication
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareClick:) name:@"shareType" object:nil];
}

- (void)initNavigate {
    [self configTitle:@"店铺二维码" leftPath:Head_ICON_BACK  rightPath:nil];
}

- (void)configViews {
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    [self.view addSubview:self.scrollView];
    
    self.container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.ls_width, self.scrollView.ls_height)];
    [self.scrollView addSubview:self.container];
    
    self.topView = [[WechatAppTopView alloc] initWithFrame:CGRectMake(0, 11, SCREEN_W, 259)];
    [self.container addSubview:self.topView];
    
    self.middleView = [[WeChatAppMiddle alloc] initWithFrame:CGRectMake(0, 280, SCREEN_W, 117)];
    [self.container addSubview:self.middleView];
    
    self.bootomView = [[WeChatAppBottomView alloc] initWithFrame:CGRectMake(0, 407, SCREEN_W, 165)];
    [self.container addSubview:self.bootomView];
}



// 生成二维码
- (void)initMainView {
    // 二维码, 优先使用后台传回的短码shortUrl，空的话前端生成
    if ([NSString isBlank:_microShopInfoVo.shortUrl]) {
        NSString *url = [NSString stringWithFormat:@"%@?shopEntityId=%@", QRCODE_ROOT, [[Platform Instance] getkey:RELEVANCE_ENTITY_ID]];
        self.url = url;
    } else {
        self.url = self.microShopInfoVo.shortUrl;
    }
    self.imgQRCode = [self generateQRCode:_url width:180 * 3 height:180 * 3];
    [self.topView createQRCodeWithImg:self.imgQRCode];
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
}


#pragma mark - 
-(void)shareClick:(NSNotification *)sender
{
    NSInteger type = ((UIButton *)sender.object).tag;
    switch (type) {
        case 2000:
            //点击微信好友
            [self shareEvent:UMSocialPlatformType_WechatSession tag:1];
            break;
        case 2001:
            //点击微信朋友圈
            [self shareEvent:UMSocialPlatformType_WechatTimeLine tag:2];
            break;
        case 2002:
            //点击下载二维码
            [self saveQrcode:nil];
            break;
        case 2003:{
            NSString* url = self.url;
            [[UIPasteboard generalPasteboard] setPersistent:YES];
            [[UIPasteboard generalPasteboard] setValue:url forPasteboardType:[UIPasteboardTypeListString objectAtIndex:0]];
            [AlertBox show:@"二维码链接已经复制到剪贴版了哦！"];
            break;
        }
        default:
            break;
    }
}

- (void)understand {
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
    [self.navigationController popViewControllerAnimated:NO];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
}

-(void)saveQrcode:(id)sender
{
    UIGraphicsBeginImageContext([self.topView getSzie]);
    [[self.topView getLayer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *temp = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(temp, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

#pragma mark - 店铺主页分享


#pragma mark 分享功能 tag 1是微信好友  2是朋友圈
- (void)shareEvent:(UMSocialPlatformType)paltformType tag:(int)tag {
    
    //分享标题
    NSString *title = _microShopInfoVo.microShopName;
    //分享地址
    NSString *url = self.url;
    //分享内容
    NSString *text = _microShopInfoVo.introduce;
    //发到朋友圈时店家介绍要在店名后面 没有店家介绍时就不显示默认值
    if (tag == 2 && [NSString isNotBlank:text]) {
        title = [NSString stringWithFormat:@"%@，%@", title, text];
    }
    if (tag == 1 && [NSString isBlank:text]) {
        text = @"正品低价就来我的微店，超多优惠等你来抢！";
    }
    
    //分享logo
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_microShopInfoVo.logoPath]]];
    if (image == nil) {
        image = [UIImage imageNamed:@"ico_weixin_share"];
    }
    
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:text thumImage:image];
    shareObject.webpageUrl = url;
    messageObject.shareObject = shareObject;
    [[UMSocialManager defaultManager] shareToPlatform:paltformType messageObject:messageObject currentViewController:self completion:^(id result, NSError *error) {
        
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        } else {
            UMSocialLogInfo(@"response data is %@",result);
        }
    }];
        
    
//    [UMSocialData defaultData].extConfig.wechatSessionData.url = url;
//    [UMSocialData defaultData].extConfig.wechatTimelineData.url = url;
//    [UMSocialData defaultData].extConfig.title = title;
//    [UMSocialSnsService presentSnsIconSheetView:self
//                                         appKey:UmengAppKey
//                                      shareText:text
//                                     shareImage:image shareToSnsNames:list
//                                       delegate:self];
    //注意当URL图片和UIImage同时存在时，只有URL图片生效
    
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo
{
    // Was there an error?
    if (error != NULL)
    {
        // Show error message…
        
    }
    else  // No errors
    {
        // Show message image successfully saved
        [AlertBox show:@"已保存至相册"];
    }
}



#pragma mark - 生成条形码以及二维码

// 参考文档
// https://developer.apple.com/library/mac/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html

- (UIImage *)generateQRCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height {
    
    // 生成二维码图片
    CIImage *qrcodeImage;
    NSData *data = [code dataUsingEncoding:NSISOLatin1StringEncoding allowLossyConversion:false];
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    [filter setValue:data forKey:@"inputMessage"];
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    qrcodeImage = [filter outputImage];
    
    // 消除模糊
    CGFloat scaleX = width / qrcodeImage.extent.size.width; // extent 返回图片的frame
    CGFloat scaleY = height / qrcodeImage.extent.size.height;
    CIImage *transformedImage = [qrcodeImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
    
    return [UIImage imageWithCIImage:transformedImage];
    
}

- (UIImage *)generateBarCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height {
    // 生成二维码图片
    CIImage *barcodeImage;
    NSData *data = [code dataUsingEncoding:NSISOLatin1StringEncoding allowLossyConversion:false];
    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    
    [filter setValue:data forKey:@"inputMessage"];
    barcodeImage = [filter outputImage];
    
    // 消除模糊
    CGFloat scaleX = width / barcodeImage.extent.size.width; // extent 返回图片的frame
    CGFloat scaleY = height / barcodeImage.extent.size.height;
    CIImage *transformedImage = [barcodeImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
    
    return [UIImage imageWithCIImage:transformedImage];
}

#pragma mark - 网络请求 - 
/*
 
 {
	"returnCode": "success",
	"microShopInfoVo": {
 "microShopName": "1002",
 "introduce": null,
 "shortUrl": "http://api.l.whereask.com/hwqm-Sx4onm"
	},
	"exceptionCode": null
 }
 
 */
- (void)getQrcode {
    
    __weak typeof(self) wself = self;
    [BaseService getRemoteLSDataWithUrl:@"microShop/shortUrl" param:nil withMessage:nil show:YES CompletionHandler:^(id json) {
        
        wself.microShopInfoVo = [MicroShopInfoVo microShopInfoVoFrom:json[@"microShopInfoVo"]];
        [wself initMainView];
        
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json];
        [wself initMainView];
    }];
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
