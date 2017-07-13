//
//  SalePackStyleImageView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/11/5.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SalePackStyleImageView.h"
#import "UIHelper.h"
#import "XHAnimalUtil.h"
#import "EditItemList.h"
#import "EditItemText.h"
#import "ItemTitle.h"
#import "EditImageBox.h"
#import "UIView+Sizes.h"
#import "UIImageView+WebCache.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "AlertBox.h"
#import "INameItem.h"
#import "ServiceFactory.h"
#import "EditItemMemo.h"
#import "MicroStyleVo.h"
#import "MicroStyleImageVo.h"
#import "SalePackStyleListView.h"
#import "ImageUtils.h"
#import "WechatStyleColorImage.h"
#import "WechatStylePictureView.h"


#import "UIView+Layout.h"
#import "TZTestCell.h"

#define COLOR_PIC 1
#define DETAILS 2

@interface SalePackStyleImageView ()

@property (nonatomic, strong) WechatService *wechatService;

@property (nonatomic, strong) MicroStyleVo *microStyleVo;

@property (nonatomic, strong) NSString *styleId;

@property (nonatomic, strong) NSString *imgFilePathTemp;

@property (nonatomic) int action;

@property (nonatomic, strong) UIImage *goodsImage;

@property (nonatomic, strong) UIImagePickerController *imagePickerController;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *selectedPhotos;

@property (nonatomic) CGFloat itemWH;

@property (nonatomic) CGFloat margin;

@end

@implementation SalePackStyleImageView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil styleId:(NSString*) styleId
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _wechatService = [ServiceFactory shareInstance].wechatService;
        _styleId = styleId;
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString*)kUTTypeImage, nil];
        _imagePickerController.allowsEditing = YES;
        _imagePickerController.delegate = self;
    }
    return self;
}

-(void) loadDatas
{
    [self selectStyleImageInfo];
}

-(void) selectStyleImageInfo
{
    __weak SalePackStyleImageView* weakSelf = self;
    [_wechatService selectStyleImageInfo:_styleId completionHandler:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        [weakSelf responseSuccess:json];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

- (void)responseSuccess:(id)json
{
    _microStyleVo = [MicroStyleVo convertToMicroStyleVo:[json objectForKey:@"microStyleVo"]];
    
    [self fillModel];
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

-(void) fillModel
{
    [self.txtStyleName initData:_microStyleVo.styleName];
    self.txtStyleName.lblVal.textColor = [UIColor grayColor];
    
    [self.txtStyleNo initData:_microStyleVo.styleCode];
    
    [self.txtBrand initData:_microStyleVo.brandName];
    
    [self.txtHangTagPrice initData:[NSString stringWithFormat:@"%.2f", _microStyleVo.hangTagPrice]];
    
    [self.txtRetailPrice initData:[NSString stringWithFormat:@"%.2f", _microStyleVo.retailPrice]];
    
    if (_microStyleVo.mainImageVoList != nil && _microStyleVo.mainImageVoList.count > 0) {
        [self.boxPicture initImgList:_microStyleVo.mainImageVoList];
    }else{
        [self.boxPicture initImgList:nil];
    }
}

-(void) initMainView
{
    self.TitBaseInfo.lblName.text = @"基本信息";
    
//    [self.txtStyleName initLabel:@"款式名称" isrequest:YES delegate:self];
    [self.txtStyleName initLabel:@"款式名称"  withVal:nil];
    self.txtStyleName.lblVal.textColor = [UIColor grayColor];
//    self.txtStyleName.lblVal
    
    [self.txtStyleNo initLabel:@"款号" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    self.txtStyleNo.txtVal.enabled = NO;
    self.txtStyleNo.txtVal.textColor = [UIColor grayColor];
    
    [self.txtBrand initLabel:@"品牌" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    self.txtBrand.txtVal.enabled = NO;
    self.txtBrand.txtVal.textColor = [UIColor grayColor];
    
    [self.txtHangTagPrice initLabel:@"吊牌价" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    self.txtHangTagPrice.txtVal.enabled = NO;
    self.txtHangTagPrice.txtVal.textColor = [UIColor grayColor];
    
    [self.txtRetailPrice initLabel:@"零售价" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    self.txtRetailPrice.txtVal.enabled = NO;
    self.txtRetailPrice.txtVal.textColor = [UIColor grayColor];
    
    self.TitExtendInfo.lblName.text = @"扩展信息";
    [self.boxPicture initLabel:@"款式图片" delegate:self];
    
    self.TitColorPic.lblName.text = @"颜色图片";
    [self.lsColorPic initLabel:@"设置每个颜色的图片" withHit:nil delegate:self];
    [self.lsColorPic.imgMore setImage:[UIImage imageNamed:@"ico_next.png"]];
    self.lsColorPic.lblVal.placeholder = @"";
    
    self.TitDetails.lblName.text = @"图文详情";
    [self.lsDetails initLabel:@"图文详情" withHit:nil delegate:self];
    [self.lsDetails.imgMore setImage:[UIImage imageNamed:@"ico_next.png"]];
    self.lsDetails.lblVal.placeholder = @"";
    
    self.lsColorPic.tag = COLOR_PIC;
    self.lsDetails.tag = DETAILS;
}

-(void)onItemListClick:(EditItemList *)obj
{
    if (obj.tag == COLOR_PIC) {
        WechatStyleColorImage* vc = [[WechatStyleColorImage alloc] initWithNibName:[SystemUtil getXibName:@"WechatStyleColorImage"] bundle:nil];
        vc.styleId = _styleId;
        if ([[Platform Instance] getShopMode] == 3) {
            vc.shopId = [[Platform Instance] getkey:ORG_ID];
        } else {
            vc.shopId = [[Platform Instance] getkey:SHOP_ID];
        }
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    }else if (obj.tag == DETAILS){
        WechatStylePictureView* vc = [[WechatStylePictureView alloc] initWithNibName:[SystemUtil getXibName:@"WechatStylePictureView"] bundle:nil];
        vc.styleId = _styleId;
        if ([[Platform Instance] getShopMode] == 3) {
            vc.shopId = [[Platform Instance] getkey:ORG_ID];
        } else {
            vc.shopId = [[Platform Instance] getkey:SHOP_ID];
        }
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    }
}

#pragma notification 处理.
-(void) initNotifaction
{
    [UIHelper initNotification:self.container event:Notification_SalePackStyleImageView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_SalePackStyleImageView_Change object:nil];
}

#pragma 做好界面变动的支持.
-(void) dataChange:(NSNotification*) notification
{
    [self.titleBox editTitle:[UIHelper currChange:self.container] act:self.action];
}

-(void) onNavigateEvent:(Direct_Flag)event
{
    if (event==1) {
        [self.navigationController popViewControllerAnimated:YES];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
    }else{
        [self save];
    }
}

-(void)save
{
    _microStyleVo.mainImageVoList = [[NSMutableArray alloc] init];
    if ([self.boxPicture getFilePathList] != nil && [self.boxPicture getFilePathList].count > 0) {
        for (NSString* img in [self.boxPicture getFilePathList]) {
            MicroStyleImageVo* vo = [[MicroStyleImageVo alloc] init];
            NSDictionary*dic=[self.boxPicture fileImageMap];
            UIImage*PNG=[dic objectForKey:img];
            NSData *data = [ImageUtils dataOfImageAfterCompression:PNG];
            NSString *base64Encoded = [data base64EncodedStringWithOptions:0];
            
            vo.file = base64Encoded;
            vo.fileName = img;
            
            [_microStyleVo.mainImageVoList addObject:vo];
        }
    }
    NSDictionary* dic = nil;
    dic = [MicroStyleVo getDictionaryData:_microStyleVo];
    __weak SalePackStyleImageView* wealSelf = self;
    [_wechatService saveMainImageList:dic completionHandler:^(id json) {
        if (!(wealSelf)) {
            return ;
        }
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[SalePackStyleListView class]]) {
                SalePackStyleListView *listView = (SalePackStyleListView *)vc;
                [listView loadDatasFromBatchViewOrEditView:@"edit"];
            }
        }
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];        
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
    
}


-(void) initHead
{
    self.titleBox=[NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"款式图片信息" backImg:Head_ICON_BACK moreImg:nil];
    [self.titleDiv addSubview:self.titleBox];
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
            _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:_imagePickerController animated:YES completion:nil];
        }
    } else if(btnIndex==0) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            [AlertBox show:@"相册好像不能访问哦!"];
            return;
        }
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:5-[self.boxPicture getFilePathList].count delegate:self];
        
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

#pragma mark TZImagePickerControllerDelegate

/// User click cancel button
/// 用户点击了取消
- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker {
   [picker dismissViewControllerAnimated:YES completion:nil];
}

/// User finish picking photo，if assets are not empty, user picking original photo.
/// 用户选择好了图片，如果assets非空，则用户选择了原图。
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets{
    
    for (UIImage*img in photos) {
        _goodsImage = [ImageUtils scaleImageOfDifferentCondition:img condition:[[Platform Instance] getkey:SHOP_MODE].intValue];
        NSString* filePath = [NSString stringWithFormat:@"%@/menu/%@.png",@"001",[NSString getUniqueStrByUUID]];
        self.imgFilePathTemp = filePath;
        [self uploadImgFinsh];
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    //添加到集合中
    _goodsImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    //    NSString* entityId=[[Platform Instance] getkey:ENTITY_ID];
    _goodsImage = [ImageUtils scaleImageOfDifferentCondition:_goodsImage condition:[[Platform Instance] getkey:SHOP_MODE].intValue];
    NSString* filePath = [NSString stringWithFormat:@"%@/menu/%@.png",@"001",[NSString getUniqueStrByUUID]];
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

//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    [self dismissViewControllerAnimated:YES completion:nil];
//    //添加到集合中
//    _goodsImage = [info objectForKey:UIImagePickerControllerOriginalImage];
//    //    NSString* entityId=[[Platform Instance] getkey:ENTITY_ID];
//    _goodsImage = [ImageUtils scaleImageOfDifferentCondition:_goodsImage condition:[[Platform Instance] getkey:SHOP_MODE].intValue];
//    
//    NSString* filePath = [NSString stringWithFormat:@"%@/menu/%@.png",@"001",[NSString getUniqueStrByUUID]];
//    self.imgFilePathTemp = filePath;
//    [self uploadImgFinsh];
//    //    [self uploadImage:filePath image:menuImage width:1024 heigth:768 event:REMOTE_KABAWMENU_MENUIMG_UPLOAD];
//}

-(void) uploadImgFinsh
{
    [self.boxPicture changeImg:self.imgFilePathTemp img:_goodsImage];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void)updateViewSize
{
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void)onDelImgClickWithPath:(NSString *)path
{
    [self.boxPicture removeFilePath:path];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNotifaction];
    [self initHead];
    [self initMainView];
    [self loadDatas];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
