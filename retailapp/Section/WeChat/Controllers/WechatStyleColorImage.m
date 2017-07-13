//
//  WechatStyleColorImage.m
//  retailapp
//
//  Created by zhangzt on 15/10/28.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "WechatStyleColorImage.h"

#import "EditItemImage3.h"
#import "UIImageView+WebCache.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "AlertBox.h"
#import "UIHelper.h"
#import "FooterListView.h"
#import "XHAnimalUtil.h"
#import "MicroGoodsImageVo.h"
//#import "GoodsMicroEditView.h"
#import "ServiceFactory.h"
#import "JsonHelper.h"
#import "AlertBox.h"
#import "Wechat_MicroStyleVo.h"
#import "ImageUtils.h"

#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import "TZTestCell.h"
#import "LSImageVo.h"
#import "LSImageDataVo.h"
#import "MJExtension.h"

@interface WechatStyleColorImage ()<TZImagePickerControllerDelegate>
{
    NSInteger number;
    UICollectionView *_collectionView;
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    
    CGFloat _itemWH;
    CGFloat _margin;
}

@property (nonatomic, strong) WechatService* wechatService;

@property (nonatomic, strong) NSMutableDictionary *dicImage;
@property (nonatomic, strong) NSMutableDictionary *dicFilePath;

@property (nonatomic, strong) NSMutableArray *ImageColorArray;//存动态颜色text控件的数组
/**关联图片和数据*/
@property (nonatomic, copy) NSString *unid;

@end

@implementation WechatStyleColorImage

- (void)selectInfoImageList
{
    __weak WechatStyleColorImage* weakSelf = self;
    
    [_wechatService selectInfoImageColorList:_styleId completionHandler:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        [self responseSuccess:json];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

- (void)responseSuccess:(id)json
{
    NSMutableArray* list = [json objectForKey:@"colorImageVoList"];
    self.microStyleVo = [[Wechat_MicroStyleVo alloc]init];
    self.microStyleVo.colorImageVoList = [NSMutableArray array];
    if ([ObjectUtil isNotNull:list] && list.count > 0) {
        for (NSDictionary* dic in list) {
            MicroGoodsImageVo *microGoodsImageVo = [MicroGoodsImageVo convertToMicroGoodsImageVo:dic];
            microGoodsImageVo.fileName = [NSString getImagePath:microGoodsImageVo.filePath];
            [self.microStyleVo.colorImageVoList addObject:microGoodsImageVo];
        }
    }
    [self fillModel];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void)fillModel {
    
    BOOL editable = YES;
    if (_action == ACTION_CONSTANTS_EDIT && !([[Platform Instance] getShopMode] == 1 || [[Platform Instance] isTopOrg])) {
        editable = NO;
    }

    self.unid = self.styleId;
    // 设置开始下不同颜色对应的图片
    if (self.microStyleVo.colorImageVoList.count > 0) {
        for (int i = 0; i < self.microStyleVo.colorImageVoList.count; i++) {
            MicroGoodsImageVo *vo = [self.microStyleVo.colorImageVoList objectAtIndex:i];
            EditItemImage3 *imagecolor = [[EditItemImage3 alloc] initWithFrame:CGRectMake(0 , 50, 320, 252)];
            imagecolor.tag = i;
            [imagecolor initLabel:vo.color colorId:vo.colorId withHit:nil delegate:self];
            [imagecolor initView:nil path:nil];
            if ([NSString isNotBlank:vo.filePath]) {
               [imagecolor initView:vo.filePath path:vo.fileName];
                imagecolor.oldImgFilePath = [NSString getImagePath:vo.filePath];
            }
            [self.container addSubview:imagecolor];
            [self.ImageColorArray addObject:imagecolor];
            if (!editable) {
                [imagecolor imageItemEditable:NO];
            }
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ImageColorArray = [NSMutableArray array];
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString*)kUTTypeImage, nil];
    imagePickerController.allowsEditing = YES;
    imagePickerController.delegate = self;
    [self initNotifaction];
    [self initHead];
    self.dicImage = [NSMutableDictionary dictionary];
    self.dicFilePath = [NSMutableDictionary dictionary];
    NSArray* arr=[[NSArray alloc] init];
    [self.footView initDelegate:self btnArrs:arr];
    self.footView.imgHelp.hidden = YES;
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
    _wechatService = [ServiceFactory shareInstance].wechatService;
    [self selectInfoImageList];
}

#pragma notification 处理.
- (void)initNotifaction
{
    [UIHelper initNotification:self.container event:Notification_UI_GoodsPictureView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_GoodsPictureView_Change object:nil];
}

#pragma 做好界面变动的支持.
- (void)dataChange:(NSNotification*) notification
{
    [self.titleBox editTitle:[UIHelper currChange:self.container] act:self.action];
}

- (void)initHead
{
    self.titleBox=[NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"颜色图片" backImg:Head_ICON_BACK moreImg:nil];
    [self.titleDiv addSubview:self.titleBox];
}

- (void)onNavigateEvent:(Direct_Flag)event
{
    if (event==1) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        [self save];
    }
}

- (void)save
{
    self.microStyleVo.styleId = _styleId;
    if ([ObjectUtil isEmpty:self.dicImage]){
        self.microStyleVo.colorImageVoList=[[NSMutableArray alloc]init];
    }
    self.microStyleVo.colorImageVoList=[[NSMutableArray alloc]init];
    //存放图片对象
    NSMutableArray *imageVoList = [NSMutableArray array];
    //存放图片数据
     NSMutableArray *imageDataList = [NSMutableArray array];
    for (EditItemImage3*Image3 in self.container.subviews) {
        MicroGoodsImageVo *vo=[[MicroGoodsImageVo alloc]init];
        vo.fileName=Image3.imgFilePath;
        vo.color=Image3.lblName.text;
        vo.colorId=[Image3 getColorId];
        vo.opType = 0;
        [self.microStyleVo.colorImageVoList addObject:vo];
        if (Image3.changed) {
             NSString *fileName = Image3.imgFilePath;
            //增加的图片
            UIImage *img = Image3.img.image;
            if ([NSString isNotBlank:Image3.imgFilePath] && img != nil) {
                NSData *data = [ImageUtils dataOfImageAfterCompression:img];
                LSImageDataVo *imageDataVo = [LSImageDataVo imageDataVoWithData:data file:fileName];
                [imageDataList addObject:imageDataVo];
                
                LSImageVo *imageVo = [LSImageVo imageVoWithFileName:fileName opType:1 type:@"style"];
                [imageVoList addObject:imageVo];
            }
            
           
            if (Image3.oldImgFilePath) {
                //删除的图片
                NSString *fileNameDel = Image3.oldImgFilePath;
                LSImageVo *imageVo = [LSImageVo imageVoWithFileName:fileNameDel opType:2 type:@"style"];
                [imageVoList addObject:imageVo];
            }
        }
    }
    
    __weak WechatStyleColorImage* weakSelf = self;
    [_wechatService saveMicroStyleColorPictures:self.shopId MicroStyleVo:[Wechat_MicroStyleVo getDictionaryData:self.microStyleVo] completionHandler:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        //[parent showView:WECHAT_GOODS_LIST_STYLE_EDIT_DETAIL_VIEW];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
    //上传图片
    [BaseService upLoadImageWithimageVoList:imageVoList imageDataVoList:imageDataList];
}

-  (void)onConfirmImgClick:(NSInteger)btnIndex Event:(EditItemImage3 *)event
{
    number = event.tag;
    //获取点击按钮的标题
    if (btnIndex==1)
    {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [AlertBox show:@"相机好像不能用哦!"];
            return;
        }
        NSArray* availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        
        if ([availableMediaTypes containsObject:(NSString*)kUTTypeImage]) {
            imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString*)kUTTypeImage, nil];
            imagePickerController.allowsEditing = YES;
            imagePickerController.delegate = self;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
        
    }
    else if(btnIndex==0)
    {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            [AlertBox show:@"相册好像不能访问哦!"];
            return;
        }
        NSArray* availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        
        if ([availableMediaTypes containsObject:(NSString*)kUTTypeImage]) {
            imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString*)kUTTypeImage, nil];
            imagePickerController.allowsEditing = YES;
            imagePickerController.delegate = self;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
    }
    
}

#pragma mark - UIImagePickerController代理方法
//完成
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        goodsImage = [ImageUtils cropWeChatPhoto:image dispalyWidth:300.0f];
        [self.dicImage setValue:goodsImage forKey:[NSString stringWithFormat:@"%ld",(long)number]];
        NSString* filePath = [NSString stringWithFormat:@"%@/%@.png",self.unid,[NSString getUniqueStrByUUID]];
        self.imgFilePathTemp = filePath;
        [self.dicFilePath setValue:filePath forKey:[NSString stringWithFormat:@"%ld",(long)number]];
        [self uploadImgFinsh];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)uploadImgFinsh
{
    [[self.ImageColorArray objectAtIndex:number] changeImg:self.imgFilePathTemp img:goodsImage];
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_UI_GoodsPictureView_Change object:self] ;
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void)updateViewSize
{
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void)onDelImgClick:(EditItemImage3 *)event;
{
    // 设定图片为nil
    goodsImage = nil;
    // 设定文件名为nil
    self.imgFilePathTemp = nil;
    
    [self.dicImage removeObjectForKey:[NSString stringWithFormat:@"%ld",(long)event.tag]];
    [self.dicFilePath removeObjectForKey:[NSString stringWithFormat:@"%ld",(long)event.tag]];
    
    [[self.ImageColorArray objectAtIndex:event.tag] changeImg:self.imgFilePathTemp img:goodsImage];
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_UI_GoodsPictureView_Change object:self] ;

}

@end
