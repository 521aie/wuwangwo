//
//  WechatStylePictureView.m
//  retailapp
//
//  Created by zhangzt on 15/10/26.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GoodsPicturesView.h"
#import "EditImageBox1.h"
#import "UIImageView+WebCache.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "AlertBox.h"
#import "UIHelper.h"
#import "FooterListView.h"
#import "XHAnimalUtil.h"
#import "MicroGoodsImageVo.h"
#import "ServiceFactory.h"
#import "JsonHelper.h"
#import "AlertBox.h"
#import "SelectImgItem.h"
#import "LSImageVo.h"
#import "LSImageDataVo.h"
#import "TZImagePickerController.h"
#import "ImageUtils.h"
#import "NavigateTitle2.h"
#import "FooterListEvent.h"
#import "Wechat_MircoGoodsVo.h"


@interface GoodsPicturesView ()<TZImagePickerControllerDelegate, FooterListEvent, INavigateEvent, IEditItemImageEvent, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate> {
    UICollectionView *_collectionView;
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    
    CGFloat _itemWH;
    CGFloat _margin;
    
    NSMutableArray *filePathList;
    UIImage *goodsImage;
    UIImagePickerController *imagePickerController;
}


@property (nonatomic, strong) NavigateTitle2 *titleBox;
@property (weak, nonatomic) IBOutlet UIView *titleDiv;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet FooterListView *footView;
@property (weak, nonatomic) IBOutlet EditImageBox1 *boxPicture;

@property (nonatomic, strong) NSString *imgFilePathTemp;
@property (nonatomic, strong) WechatService* wechatService;
@property (nonatomic, strong) NSMutableArray *oldPathList;
/**关联图片和数据*/
@property (nonatomic, copy) NSString *unid;

@end

@implementation GoodsPicturesView

- (void)viewDidLoad {
    [super viewDidLoad];
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString*)kUTTypeImage, nil];
    imagePickerController.allowsEditing = YES;
    imagePickerController.delegate = self;
    [self initNotifaction];
    [self initHead];
    [self initMainView];
    if (_action == ACTION_CONSTANTS_EDIT && !([[Platform Instance] isTopOrg] || [[Platform Instance] getShopMode] == 1)) {
        self.footView.hidden = YES;
    } else {
        
        NSArray *arr = [[NSArray alloc] initWithObjects:@"add",nil];
        [self.footView initDelegate:self btnArrs:arr];
    }

    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
    _wechatService = [ServiceFactory shareInstance].wechatService;
    [self selectInfoImageList];

    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
    filePathList = [NSMutableArray array];
}


- (void)initHead {
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"图文详情" backImg:Head_ICON_BACK moreImg:nil];
    [self.titleDiv addSubview:self.titleBox];
}

- (void)onNavigateEvent:(Direct_Flag)event {
   
    if (event == DIRECT_LEFT) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    } else {
        [self save];
    }
}

- (void)initMainView {
    [self.boxPicture initLabel:@"" delegate:self];
    self.boxPicture.hidden = YES;
}

#pragma notification 处理.
- (void)initNotifaction {
    
    [UIHelper initNotification:self.container event:Notification_UI_GoodsPictureView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_GoodsPictureView_Change object:nil];
}

#pragma 做好界面变动的支持.
- (void)dataChange:(NSNotification*) notification {
    [self.titleBox editTitle:[UIHelper currChange:self.container] act:self.action];
}

- (void)showAddEvent {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从手机相册选择",@"拍照", nil];
    sheet.tag=1;
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
   
    //获取点击按钮的标题
    if (actionSheet.tag == 2) {
        if (buttonIndex == 0) {
        }
    } else {
        if (buttonIndex == 0 || buttonIndex == 1) {
            [self onConfirmImgClickWithTag:buttonIndex tag:actionSheet.tag];
        }
    }
}

- (void)selectInfoImageList {
    
    __weak GoodsPicturesView *weakSelf = self;
    [_wechatService selectWechatGoodsPictureList:_goodsId completionHandler:^(id json) {
        [weakSelf responseSuccess:json];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

- (void)responseSuccess:(id)json {
    
    self.unid = self.goodsId;
    NSMutableArray* list = [json objectForKey:@"infoImageVoList"];
    self.microGoodsVo.infoImageVoList = [[NSMutableArray alloc] init];
    if ([ObjectUtil isNotNull:list] && list.count > 0) {
        for (NSDictionary* dic in list) {
            MicroGoodsImageVo *microGoodsImageVo = [MicroGoodsImageVo convertToMicroGoodsImageVo:dic];
            //由于版本兼容这个参数先前台赋值
            microGoodsImageVo.fileName = [NSString getImagePath:microGoodsImageVo.filePath];
            [self.microGoodsVo.infoImageVoList addObject:microGoodsImageVo];
            self.oldPathList = [NSMutableArray array];
            [self.oldPathList addObject:microGoodsImageVo.fileName];
            self.boxPicture.hidden=NO;
        }
    }
    if (self.microGoodsVo.infoImageVoList != nil && self.microGoodsVo.infoImageVoList.count > 0) {
        [self.boxPicture initImgList:self.microGoodsVo.infoImageVoList];
    } else {
        [self.boxPicture initImgList:nil];
    }
    
    for (SelectImgItem*SelectImgItem in [self.boxPicture selectImgItemList]) {
       
        if ([self.boxPicture getFilePathList].count == 0) {
            break;
        }
        if (SelectImgItem==[self.boxPicture selectImgItemList][0]) {
            SelectImgItem.btnUp.hidden=YES;
        } else {
            SelectImgItem.btnUp.hidden=NO;
        }
        if (SelectImgItem==[self.boxPicture selectImgItemList][[self.boxPicture getFilePathList].count-1]) {
            SelectImgItem.btnDown.hidden=YES;
        }else{
            SelectImgItem.btnDown.hidden=NO;
        }
    }
    
    // 默认开微店：非总部用户和单店用户无编辑图文详情的权限
    if (_action == ACTION_CONSTANTS_EDIT && !([[Platform Instance] isTopOrg] || [[Platform Instance] getShopMode] == 1)) {
        [self.boxPicture imageBoxUneditable];
    }
    
    [filePathList addObjectsFromArray:[self.boxPicture getFilePathList]];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    
}
-(void)save
{
    self.microGoodsVo = [[ Wechat_MircoGoodsVo alloc]init];
    self.microGoodsVo.goodsId = _goodsId;
    self.microGoodsVo.infoImageVoList = [[NSMutableArray alloc] init];
    //存放图片对象
    NSMutableArray *imageVoList = [NSMutableArray array];
    //存放图片数据
    NSMutableArray *imageDataList = [NSMutableArray array];

    
    if ([self.boxPicture getFilePathList] != nil && [self.boxPicture getFilePathList].count > 0) {
        int idx = 0;
        for (NSString* img in [self.boxPicture getFilePathList]) {
            MicroGoodsImageVo* vo = [[MicroGoodsImageVo alloc] init];
            vo.fileName = img;
            [self.microGoodsVo.infoImageVoList addObject:vo];
            
            
            SelectImgItem *selectImgItem = [[self.boxPicture getImageItemList] objectAtIndex:idx];
            
            NSString *oldPath = selectImgItem.oldPath;
            [self.oldPathList removeObject:oldPath];
            if (![oldPath isEqualToString:selectImgItem.path]) {
                if (oldPath != nil) {
                    //删除图片
                    LSImageVo *imageVo = [LSImageVo imageVoWithFileName:oldPath opType:2 type:@"goods"];
                    [imageVoList addObject:imageVo];
                }
                NSDictionary*dic=[self.boxPicture fileImageMap];
                UIImage*PNG=[dic objectForKey:img];
                //添加图片
                if (PNG != nil) {
                    
                    NSData *data = [ImageUtils dataOfImageAfterCompression:PNG];
                    LSImageDataVo *imageDataVo = [LSImageDataVo imageDataVoWithData:data file:img];
                    [imageDataList addObject:imageDataVo];
                    LSImageVo *imageVo = [LSImageVo imageVoWithFileName:img opType:1 type:@"goods"];
                    [imageVoList addObject:imageVo];
                }
            }
            idx ++;

        }
    }
    
    for (NSString *oldPath in self.oldPathList) {
        LSImageVo *imageVo = [LSImageVo imageVoWithFileName:oldPath opType:2 type:@"goods"];
        [imageVoList addObject:imageVo];
    }
    __weak GoodsPicturesView* weakSelf = self;
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    [param setValue:self.shopId forKey:@"shopId"];
    [param setValue:@2 forKey:@"interface_version"];
    [param setValue:[Wechat_MircoGoodsVo getDictionaryData:self.microGoodsVo] forKey:@"microGoodsVo"];
    NSString *url = @"microGoods/saveInfoImageList";
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [weakSelf.navigationController popViewControllerAnimated:NO];

    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
    [BaseService upLoadImageWithimageVoList:imageVoList imageDataVoList:imageDataList];
    
    
}

- (void)onConfirmImgClickWithTag:(NSInteger)btnIndex tag:(NSInteger)tag
{
    if (btnIndex==1) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [AlertBox show:@"相机好像不能用哦!"];
            return;
        }
        NSArray* availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        
        if ([availableMediaTypes containsObject:(NSString*)kUTTypeImage]) {
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
    } else if(btnIndex==0) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            [AlertBox show:@"相册好像不能访问哦!"];
            return;
        }
        
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:12-[self.boxPicture getFilePathList].count delegate:self];
        
        // You can get the photos by block, the same as by delegate.
        // 你可以通过block或者代理，来得到用户选择的照片.
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets) {
            
        }];
        
        // Set the appearance
        // 在这里设置imagePickerVc的外观
        // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
        // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
        // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
        
        // Set allow picking video & originalPhoto or not
        // 设置是否可以选择视频/原图
        // imagePickerVc.allowPickingVideo = NO;
        // imagePickerVc.allowPickingOriginalPhoto = NO;
        
        [self presentViewController:imagePickerVc animated:YES completion:nil];
        
    }
}

/// User click cancel button
/// 用户点击了取消
- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

/// User finish picking photo，if assets are not empty, user picking original photo.
/// 用户选择好了图片，如果assets非空，则用户选择了原图。
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets{
    
    for (UIImage*img in photos) {
        goodsImage = [ImageUtils cropWeChatPhoto:img dispalyWidth:450.f];
        NSString* filePath = [NSString stringWithFormat:@"%@/%@.png",self.unid,[NSString getUniqueStrByUUID]];
        
        self.imgFilePathTemp = filePath;
        [self uploadImgFinsh];
    }
    
    for (SelectImgItem*SelectImgItem in [self.boxPicture selectImgItemList]) {
        if ([self.boxPicture getFilePathList].count==0) {
            break;
        }
        if (SelectImgItem==[self.boxPicture selectImgItemList][0]) {
            SelectImgItem.btnUp.hidden=YES;
        }else{
            SelectImgItem.btnUp.hidden=NO;
        }
        if (SelectImgItem==[self.boxPicture selectImgItemList][[self.boxPicture getFilePathList].count-1]) {
            SelectImgItem.btnDown.hidden=YES;
        }else{
            SelectImgItem.btnDown.hidden=NO;
        }
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    //添加到集合中
    goodsImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    //    NSString* entityId=[[Platform Instance] getkey:ENTITY_ID];
    goodsImage = [ImageUtils cropWeChatPhoto:goodsImage dispalyWidth:450.f];
    NSString* filePath = [NSString stringWithFormat:@"%@/%@.png",self.unid,[NSString getUniqueStrByUUID]];
    
    self.imgFilePathTemp = filePath;
    [self uploadImgFinsh];
    
}

/// User finish picking video,
/// 用户选择好了视频
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    [_selectedPhotos addObjectsFromArray:@[coverImage]];
    [_collectionView reloadData];
    _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
}


- (void)uploadImgFinsh {
    
    [self.boxPicture changeImg:self.imgFilePathTemp img:goodsImage];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void)updateViewSize
{
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}
- (void)upImg:(NSString *)path{
    [self.boxPicture upFilePath:path];
    if ([[self.boxPicture getFilePathList] isEqual:filePathList]) {
        [self.titleBox initWithName:@"图文详情" backImg:Head_ICON_BACK moreImg:nil];
        self.boxPicture.lblTip.hidden=YES;
    }
    
}

-(void)downImg:(NSString *)path{
    [self.boxPicture downFilePath:path];
    if ([[self.boxPicture getFilePathList] isEqual:filePathList]) {
        [self.titleBox initWithName:@"图文详情" backImg:Head_ICON_BACK moreImg:nil];
        self.boxPicture.lblTip.hidden=YES;
    }
}


- (void)onDelImgClickWithPath:(NSString *)path
{
    [self.boxPicture removeFilePath:path];
    if ([[self.boxPicture getFilePathList] isEqual:filePathList]) {
        [self.titleBox initWithName:@"图文详情" backImg:Head_ICON_BACK moreImg:nil];
        self.boxPicture.lblTip.hidden=YES;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_UI_GoodsPictureView_Change object:nil];
//    NSLog(@"%s has dealloced!!\n",__FUNCTION__);
}

@end
