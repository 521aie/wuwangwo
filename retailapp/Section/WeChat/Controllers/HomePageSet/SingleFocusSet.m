//
//  WeChatHomeSetSingleFocus.m
//  retailapp
//
//  Created by diwangxie on 16/4/23.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "SingleFocusSet.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "XHAnimalUtil.h"
#import "AlertBox.h"
#import "UIHelper.h"
#import "ImageUtils.h"
#import "LSWechatHomeSetBatchSelectViewController.h"
#import "Wechat_StyleVo.h"
#import "MicroShopHomepageVo.h"
#import "MicroShopHomepageDetailVo.h"
#import "MicroWechatGoodsVo.h"
#import "EditItemCorrelation.h"
#import "EditItemAddCorrelation.h"
#import "EditItemRadio.h"
#import "EditItemList2.h"
#import "EditItemList3.h"
#import "NavigateTitle2.h"
#import "TZImagePickerController.h"
#import "MHImagePickerMutilSelector.h"
#import "WeChatStyleGoodsList.h"
#import "WeChatImageBox.h"
#import "LSImageVo.h"
#import "LSImageDataVo.h"

@interface SingleFocusSet ()<INavigateEvent ,IEditItemRadioEvent ,UINavigationControllerDelegate ,UIImagePickerControllerDelegate,IEditItemImageEvent,EditItemList3Delegate ,EditItemAddCorrelationDelegate ,EditItemImageDelegate ,UIActionSheetDelegate>
{
    UIImagePickerController *imagePickerController;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UIView *titleDiv;
@property (weak, nonatomic) IBOutlet EditItemRadio *lstCorrelation;
@property (weak, nonatomic) IBOutlet EditItemCorrelation *lstCorrelationView;
@property (weak, nonatomic) IBOutlet UIView *imgContent;
@property (weak, nonatomic) IBOutlet UIView *content;
@property (weak, nonatomic) IBOutlet EditItemAddCorrelation *lstAddCorrelationGoods;
@property (weak, nonatomic) IBOutlet UIView *delView;

@property (nonatomic,strong) NSString *shopId;
@property (nonatomic,strong) NSString *homePageId;
@property (nonatomic ,copy) void (^refreshHomepage)();/* <回调block，刷新微店主页*/
@property (nonatomic,strong) NSMutableArray *styleList;
@property (nonatomic,strong) NSDictionary *microShopHomepageList;
@property (nonatomic,strong) MicroShopHomepageVo *microShopHomepageVo;
@property (nonatomic,strong) MicroShopHomepageDetailVo *microShopHomepageDetailVoArrVo;

@property (nonatomic, strong) EditItemList3 *list;
@property (nonatomic, strong) WeChatImageBox *box;
@property (nonatomic, strong) NavigateTitle2 *titleBox;
/**唯一性*/
@property (nonatomic,copy) NSString *token;

@end

@implementation SingleFocusSet

- (void)setHomepageId:(NSString *)pageId callBack:(void (^)())block {
    self.homePageId = pageId;
    self.refreshHomepage = block;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _shopId=[[Platform Instance] getkey:SHOP_ID];
    self.microShopHomepageVo=[[MicroShopHomepageVo alloc] init];
    self.microShopHomepageDetailVoArrVo=[[MicroShopHomepageDetailVo alloc] init];
    self.styleList=[[NSMutableArray alloc] init];
    self.microShopHomepageList=[[NSDictionary alloc] init];
    
    [self initTitleBox];
    [self initView];
    [self loadDate];
    [self configHelpButton:HELP_WECHAT_HOME_SETTING];
}

- (void)initTitleBox {
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"单列焦点图设置" backImg:Head_ICON_BACK moreImg:nil];
    [self.titleDiv addSubview:self.titleBox];
}

- (void)initView {

    if (!self.box) {
        
//         self.box = [[WeChatImageBox alloc] initWithFrame:CGRectMake(0, 10, 300, 100) action:3 tag:1 delegate:self];
        self.box = [[WeChatImageBox alloc] initWithFrame:CGRectMake(0, 10, 300, 100) action:3 tag:1 delegate:self];
        [self.imgContent addSubview:self.box];
    }
    [self.box initBoxView:_microShopHomepageVo.filePath homePageId:_microShopHomepageVo.homePageId];

    
    [self.lstCorrelation initIndent:@"指定图片关联商品" withHit:nil indent:NO delegate:self];
    [self.lstCorrelation initData:[NSString stringWithFormat:@"%ld",_microShopHomepageVo.hasRelevance]];
    
    [self.lstCorrelationView visibal:[self.lstCorrelation getStrVal].intValue];
    [self.lstCorrelationView initCorrelationSum:_microShopHomepageVo.microShopHomepageDetailVoArr.count];
    
    for(UIView *view in [_content subviews]) {
        [view removeFromSuperview];
    }
    
    //创建一个列表容器，用于存放选中的关联商品
    _content.frame=CGRectMake(0, 0, 320, _styleList.count*46);
    [self.container addSubview:_content];
    [self.container insertSubview:_content belowSubview:self.lstAddCorrelationGoods];
    
    int h=0;
    
    for (int i=0; i<_styleList.count; i++) {
        MicroShopHomepageDetailVo *vo=[_styleList objectAtIndex:i];
        _list=[[EditItemList3 alloc] init];
        [_list initFromNib:self];
        _list.frame=CGRectMake(0, h, 320, 46);
        h=h+46;
        if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {
            [_list initCode:vo.styleCode initName:vo.styleName];
        } else {
            [_list initCode:vo.goodsBarCode initName:vo.goodsName];
        }
        _list.tag=i;
        [_content addSubview:_list];
    }
    if ([self.lstCorrelation getStrVal].intValue) {
        [_content setHidden:NO];
    }else{
        [_content setHidden:YES];
    }
    
    [self.lstAddCorrelationGoods visibal:[self.lstCorrelation getStrVal].intValue];
    [self.lstAddCorrelationGoods initView:@"添加图片关联商品" delegate:self];
    
    if (_microShopHomepageVo.homePageId==nil) {
        [self.delView setHidden:YES];
    }else{
        [self.delView setHidden:NO];
    }
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    
}

- (void)onNavigateEvent:(Direct_Flag)event {
    if (event == DIRECT_LEFT) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        [self saveSet];
    }
}

- (void)onItemRadioClick:(EditItemRadio *)obj {
    if (obj==self.lstCorrelation) {
        if ([self.lstCorrelation getVal]) {
            [self.lstAddCorrelationGoods visibal:YES];
            [self.lstCorrelationView visibal:YES];
            [self.content setHidden:NO];
        }else{
            [self.lstAddCorrelationGoods visibal:NO];
            [self.lstCorrelationView visibal:NO];
            [self.content setHidden:YES];
        }
    }
    BOOL isChange = [self checkDataChange];
    [self.titleBox editTitle:isChange act:2];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
}

- (BOOL)checkDataChange {
    return self.lstCorrelation.isChange || self.box.isChange;
}

- (void)addClick:(EditItemAddCorrelation *)item {
     if ([[[Platform Instance] getkey:SHOP_MODE] integerValue] == 101) {//服鞋
         WeChatStyleGoodsList*vc = [[WeChatStyleGoodsList alloc] initWithNibName:@"WeChatStyleGoodsList" bundle:nil];
         vc.mode=1;
         [vc loadStyleGoodsList:1 callBack:^(NSMutableArray *styleGoodsList) {
             [_styleList removeAllObjects];
             for (Wechat_StyleVo *styleVo in styleGoodsList) {
                 MicroShopHomepageDetailVo *detailVo=[[MicroShopHomepageDetailVo alloc] init];
                 detailVo.relevanceId=styleVo.styleId;
                 detailVo.relevanceType=2;
                 detailVo.styleCode=styleVo.styleCode;
                 detailVo.styleName=styleVo.styleName;
                 [_styleList addObject:detailVo];
             }
             _microShopHomepageVo.hasRelevance=1;
             [self.titleBox initWithName:@"单列焦点图设置" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
             self.titleBox.lblRight.text=@"保存";
             [self showViewDate:_styleList];
             
         }];
         [self.navigationController pushViewController:vc animated:NO];
         [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
     } else {
         //商超
         LSWechatHomeSetBatchSelectViewController *vc = [[LSWechatHomeSetBatchSelectViewController alloc] initWithBlock:^(NSMutableArray *WechatGoodsList) {
             NSMutableArray *oldStyleList = [NSMutableArray arrayWithArray:_styleList];
             for (MicroWechatGoodsVo *wechatGoodsVo in WechatGoodsList) {
                 MicroShopHomepageDetailVo *detailVo = [[MicroShopHomepageDetailVo alloc] init];
                 detailVo.relevanceId = wechatGoodsVo.goodsId;
                 detailVo.relevanceType = 1;
                 detailVo.goodsBarCode = wechatGoodsVo.barCode;
                 detailVo.goodsName = wechatGoodsVo.goodsName;
                 BOOL isContain = NO;
                 for (MicroShopHomepageDetailVo *oldDetailVo in oldStyleList) {
                     if ([oldDetailVo.relevanceId isEqualToString:detailVo.relevanceId]) {
                         isContain = YES;
                         break;
                     }
                 }
                 if (!isContain) {
                     [_styleList addObject:detailVo];
                 }
                 
             }
             _microShopHomepageVo.hasRelevance = 1;
             [self.titleBox editTitle:YES act:ACTION_CONSTANTS_EDIT];
              [self showViewDate:_styleList];
             [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
             [self.navigationController popViewControllerAnimated:NO];
             
         }];
         [self.navigationController pushViewController:vc animated:NO];
         [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];

     }
}

- (void)btnDelClick:(EditItemList3 *)item {
    [self.styleList removeObjectAtIndex:item.tag];
    [self.titleBox initWithName:@"单列焦点图设置" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
    self.titleBox.lblRight.text=@"保存";
    [self showViewDate:self.styleList];
    
}

- (void)showViewDate:(NSMutableArray *)styleList {
    
    [self.lstCorrelationView visibal:[self.lstCorrelation getStrVal].intValue];
    [self.lstCorrelationView initCorrelationSum:_styleList.count];
    
    for(UIView *view in [_content subviews])
    {
        [view removeFromSuperview];
    }
    //创建一个列表容器，用于存放选中的关联商品
    _content.frame=CGRectMake(0, 0, 320, styleList.count*46);
    [self.container addSubview:_content];
    [self.container insertSubview:_content belowSubview:self.lstAddCorrelationGoods];
    
    int h=0;
    
    for (int i=0; i<styleList.count; i++) {
        MicroShopHomepageDetailVo *vo=[styleList objectAtIndex:i];
        _list=[[EditItemList3 alloc] init];
        [_list initFromNib:self];
        _list.frame=CGRectMake(0, h, 320, 46);
        h=h+46;
        if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {
            [_list initCode:vo.styleCode initName:vo.styleName];
        } else {
            [_list initCode:vo.goodsBarCode initName:vo.goodsName];
        }
        _list.tag=i;
        [_content addSubview:_list];
    }
    if ([self.lstCorrelation getStrVal].intValue) {
        [_content setHidden:NO];
    }else{
        [_content setHidden:YES];
    }
    
    [self.lstAddCorrelationGoods visibal:[self.lstCorrelation getStrVal].intValue];
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (IBAction)deleteCorrelation:(UIButton *)sender {
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否删除该单列焦点图?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==1) {
        [self deleteSet];
    }
}



- (void)onDelImgClick {
}

#pragma mark - EditItemImageDelegate
- (void)editItemImage:(WeChatImageBox *)item {
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从手机相册选择",@"拍照", nil];
    sheet.tag = 11;
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)itemImageDownloadSuccess:(WeChatImageBox *)item {
    
    UIImage *image = item.img.image;
    [self adjustUIFrame:image];
}

#pragma makr - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  
    [self onConfirmImgClick:buttonIndex];
}


- (void)onConfirmImgClick:(NSInteger)btnIndex
{
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


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        NSString *fileName = [NSString stringWithFormat:@"%@/%@.png", _shopId, [NSString getUniqueStrByUUID]];
        _microShopHomepageVo.fileName = fileName;
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        [self adjustUIFrame:image];
        self.box.currentVal = fileName;
        [self.box isChange];
        [self.titleBox initWithName:@"单列焦点图设置" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

// 重新调整界面布局
- (void)adjustUIFrame:(UIImage *)image {

    
    self.box.img.image = image;
    if (self.box.img.hidden) {
        [self.box.img setHidden:NO];
        [self.box.imgAdd setHidden:YES];
        [self.box.lblAdd setHidden:YES];
    }
    CGFloat newHeight = (image.size.height/image.size.width)*self.box.ls_width;
    CGFloat dValue = newHeight - self.box.ls_height;
    self.box.ls_height = newHeight;
    self.imgContent.ls_height += dValue;
    self.container.ls_height += dValue;
    
    [self.container.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (![obj isEqual:self.imgContent]) {
            obj.ls_top += dValue;
        }
    }];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    
}

#pragma mark - 网络请求
// 获取单列焦点图信息
- (void)loadDate {
   
    __weak typeof(self) weakSelf = self;
    NSString *url = @"microShopHomepage/selectHomePageDetail";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
   weakSelf.shopId=[[Platform Instance] getkey:SHOP_ID];
    
    [param setValue:self.shopId forKey:@"shopId"];
    [param setValue:[NSNumber numberWithInt:3] forKey:@"setType"];
    [param setValue:@2 forKey:@"interface_version"];
    if (![_homePageId isEqual:@""] && _homePageId !=nil) {
        [param setValue:_homePageId forKey:@"homePageId"];
    }
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        if ([ObjectUtil isNotNull:[MicroShopHomepageVo convertToMicroGoodsVo:[json objectForKey:@"microShopHomepageVo"]] ]) {
            _microShopHomepageVo=[MicroShopHomepageVo convertToMicroGoodsVo:[json objectForKey:@"microShopHomepageVo"]];
        }
        if ([ObjectUtil isNotNull:_microShopHomepageVo.microShopHomepageDetailVoArr]) {
            weakSelf.styleList=_microShopHomepageVo.microShopHomepageDetailVoArr;
        }
        [weakSelf initView];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
    
}

// 保存单列焦点图信息
- (void)saveSet {
    __weak typeof(self) weakSelf = self;
    if ([NSString isBlank:self.token]) {
        self.token = [[Platform Instance] getToken];
    }
    
    NSString *url = @"microShopHomepage/save";
    weakSelf.microShopHomepageVo.setType = 3;
    weakSelf.microShopHomepageVo.sortCode = 1;
    weakSelf.microShopHomepageVo.hasRelevance = [weakSelf.lstCorrelation getStrVal].intValue;
    weakSelf.microShopHomepageVo.microShopHomepageDetailVoArr = weakSelf.styleList;
    weakSelf.microShopHomepageVo.fileName = self.box.currentVal;
    weakSelf.microShopHomepageList=[_microShopHomepageVo convertToDictionary];
    if([ObjectUtil isNull:self.box.img.image]){
        [AlertBox show:@"请先添加图片!"];
        return;
    }
    if([self.lstCorrelation getStrVal].intValue==1){
        
        if ([ObjectUtil isNull:_microShopHomepageVo.microShopHomepageDetailVoArr] || !_microShopHomepageVo.microShopHomepageDetailVoArr.count) {
            [AlertBox show:@"关联商品开关开启后，请添加关联的商品后再保存！"];
            return;
        }
    }
    
    NSMutableDictionary *param = [[NSMutableDictionary dictionary]init];
    [param setValue:weakSelf.shopId forKey:@"shopId"];
    [param setValue:_microShopHomepageList forKey:@"microShopHomepageVo"];
    [param setValue:weakSelf.token forKey:@"token"];
    [param setValue:@2 forKey: @"interface_version"];
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        weakSelf.token = nil;
        if (weakSelf.refreshHomepage) {
            weakSelf.refreshHomepage();
        }
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [weakSelf.navigationController popViewControllerAnimated:NO];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
    //存放图片对象
    NSMutableArray *imageVoList = [NSMutableArray array];
    //存放图片数据
    NSMutableArray *imageDataList = [NSMutableArray array];
    LSImageVo *imageVo = nil;
    LSImageDataVo *imageDataVo = nil;
    if (self.box.isChange) {
        if ([NSString isNotBlank:self.box.oldVal]) {
            imageVo = [LSImageVo imageVoWithFileName:self.box.oldVal opType:2 type:@"shop"];
            [imageVoList addObject:imageVo];
        }
        if ([NSString isNotBlank:self.box.currentVal]) {
            imageVo = [LSImageVo imageVoWithFileName:self.box.currentVal opType:1 type:@"shop"];
            [imageVoList addObject:imageVo];
            NSData *data = [ImageUtils dataOfImageAfterCompression:self.box.img.image];
            imageDataVo = [LSImageDataVo imageDataVoWithData:data file:self.box.currentVal];
            [imageDataList addObject:imageDataVo];
        }
    }
    //上传图片
    [BaseService upLoadImageWithimageVoList:imageVoList imageDataVoList:imageDataList];

}

// 删除当前的单列焦点图
- (void)deleteSet {
    
    NSString *url = @"microShopHomepage/delete";
    NSDictionary *param = @{@"homePageId":self.homePageId};
    //是否启用主题销售
    __weak typeof(self) weakSelf = self;
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        if (self.refreshHomepage) {
            self.refreshHomepage();
        }
        [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [weakSelf.navigationController popViewControllerAnimated:NO];
    } errorHandler:^(id json) {
         [AlertBox show:json];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
