//
//  WeChatHomeSetSingleFocus.m
//  retailapp
//
//  Created by diwangxie on 16/4/23.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "SingleGoodsSet.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIHelper.h"
#import "XHAnimalUtil.h"
#import "ImageUtils.h"
#import "AlertBox.h"
#import "WeChatSetImageBox.h"
#import "Wechat_StyleVo.h"
#import "MicroShopHomepageVo.h"
#import "MicroShopHomepageDetailVo.h"
#import "MicroWechatGoodsVo.h"
#import "NavigateTitle2.h"
#import "EditItemRadio.h"
#import "EditItemList2.h"
#import "EditItemList3.h"
#import "TZImagePickerController.h"
#import "MHImagePickerMutilSelector.h"
#import "WeChatStyleGoodsList.h"
#import "LSWechatHomeSetGoodListViewController.h"
#import "LSImageVo.h"
#import "LSImageDataVo.h"


@interface SingleGoodsSet ()<INavigateEvent,IEditItemRadioEvent,EditItemList2Delegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,IEditItemImageEvent>
{
    UIImagePickerController *imagePickerController;
}
@property (weak, nonatomic) IBOutlet UIView *titleDiv;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UIView *imgBox;
@property (weak, nonatomic) IBOutlet EditItemRadio *lstCorrelation;
@property (weak, nonatomic) IBOutlet EditItemList2 *lstCorrelationGoods;
@property (weak, nonatomic) IBOutlet UIView *delView;
@property (nonatomic, strong) WeChatSetImageBox *box;
@property (nonatomic, strong) NavigateTitle2 *titleBox;
@property (nonatomic,strong) NSMutableArray *styleList;
@property (nonatomic,strong) MicroShopHomepageVo *microShopHomepageVo;
@property (nonatomic,strong) MicroShopHomepageDetailVo *microShopHomepageDetailVoArrVo;
@property (nonatomic,strong) NSDictionary *microShopHomepageList;
@property (nonatomic,strong) NSString *shopId;
@property (nonatomic,strong) NSString *homePageId;
@property (nonatomic ,copy) void (^refreshHomepage)();/* <回调block，刷新微店主页*/
/**唯一性*/
@property (nonatomic,copy) NSString *token;
@end

@implementation SingleGoodsSet

- (void)setHomepageId:(NSString *)pageId callBack:(void (^)())block {
    _homePageId = pageId;
    _refreshHomepage = block;
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
    [self.titleBox initWithName:@"单列商品设置" backImg:Head_ICON_BACK moreImg:nil];
    [self.titleDiv addSubview:self.titleBox];
}

- (void)initView {
    
    if (!self.box) {
        self.box = [[WeChatSetImageBox alloc] initWithFrame:CGRectMake(0, 0, 300, 200) action:1 tag:1 delegate:self];
        [self.imgBox addSubview:self.box];
    }
    self.box.img.contentMode = UIViewContentModeScaleToFill;
    [self.box initBoxView:_microShopHomepageVo.filePath homePageId:_microShopHomepageVo.homePageId];
    
    [self.lstCorrelation initIndent:@"指定图片关联商品" withHit:nil indent:NO delegate:self];
    [self.lstCorrelation initData:[NSString stringWithFormat:@"%ld",_microShopHomepageVo.hasRelevance]];
    
    
    [self.lstCorrelationGoods initLabel:@"关联商品" request:YES delegate:self];
    [self.lstCorrelationGoods visibal:[self.lstCorrelation getStrVal].intValue];
    self.lstCorrelationGoods.lblContent.text = @"请选择";
    self.lstCorrelationGoods.lblContent.textColor = [ColorHelper getBlueColor];
    [self.lstCorrelationGoods initCode:@"" initName:@""];
    for (MicroShopHomepageDetailVo *vo in _microShopHomepageVo.microShopHomepageDetailVoArr) {
        if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {
            [self.lstCorrelationGoods initCode:vo.styleCode initName:vo.styleName];
        } else {
            [self.lstCorrelationGoods initCode:vo.goodsBarCode initName:vo.goodsName];
        }
        
    }
    if (_microShopHomepageVo.homePageId == nil) {
        [self.delView setHidden:YES];
    }else{
        [self.delView setHidden:NO];
    }
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    
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
            [self.lstCorrelationGoods visibal:YES];
        }else{
            [self.lstCorrelationGoods visibal:NO];
        }
    }
    BOOL isChange = [self checkDataChange];
    [self.titleBox editTitle:isChange act:2];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (BOOL)checkDataChange {
    return self.lstCorrelation.isChange || self.lstCorrelationGoods.isChange || self.box.isChange;
}

- (void)btnAddClick:(EditItemList2 *)item {
    if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {
        WeChatStyleGoodsList*vc = [[WeChatStyleGoodsList alloc] initWithNibName:@"WeChatStyleGoodsList" bundle:nil];
        vc.mode = 0;
        [vc loadStyleGoodsList:1 callBack:^(NSMutableArray *styleGoodsList) {
            [_styleList removeAllObjects];
            
            for (Wechat_StyleVo *vo in styleGoodsList) {
                self.microShopHomepageDetailVoArrVo=[[MicroShopHomepageDetailVo alloc] init];
                _microShopHomepageDetailVoArrVo.relevanceId=vo.styleId;
                _microShopHomepageDetailVoArrVo.relevanceType=2;
                _microShopHomepageDetailVoArrVo.microShopHomepageId=self.homePageId;
                [_styleList addObject:_microShopHomepageDetailVoArrVo];
                [self.lstCorrelationGoods changeCode:vo.styleCode initName:vo.styleName];
            }
            _microShopHomepageVo.microShopHomepageDetailVoArr=_styleList;
            BOOL isChange = [self checkDataChange];
            [self.titleBox editTitle:isChange act:2];
            [UIHelper refreshUI:self.container scrollview:self.scrollView];
        }];
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    } else {
        LSWechatHomeSetGoodListViewController *vc = [[LSWechatHomeSetGoodListViewController alloc] initWithBlock:^(MicroWechatGoodsVo *microWechatGoodsVo) {
            [_styleList removeAllObjects];
            self.microShopHomepageDetailVoArrVo=[[MicroShopHomepageDetailVo alloc] init];
            _microShopHomepageDetailVoArrVo.relevanceId=microWechatGoodsVo.goodsId;
            _microShopHomepageDetailVoArrVo.relevanceType=1;
            _microShopHomepageDetailVoArrVo.microShopHomepageId=self.homePageId;
            [_styleList addObject:_microShopHomepageDetailVoArrVo];
            [self.lstCorrelationGoods changeCode:microWechatGoodsVo.barCode initName:microWechatGoodsVo.goodsName];
            _microShopHomepageVo.microShopHomepageDetailVoArr=_styleList;
            BOOL isChange = [self checkDataChange];
            [self.titleBox editTitle:isChange act:2];
            [UIHelper refreshUI:self.container scrollview:self.scrollView];
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [self.navigationController popViewControllerAnimated:NO];
        }];
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    }
}

- (void)onConfirmImgClick:(NSInteger)btnIndex
{
    if (btnIndex == 1)
    {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [AlertBox show:@"相机好像不能用哦!"];
            return;
        }
        NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        
        if ([availableMediaTypes containsObject:(NSString*)kUTTypeImage]) {
            imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString*)kUTTypeImage, nil];
            imagePickerController.allowsEditing = YES;
            imagePickerController.delegate = self;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
        
    }
    else if(btnIndex == 0)
    {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            [AlertBox show:@"相册好像不能访问哦!"];
            return;
        }
        NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        
        if ([availableMediaTypes containsObject:(__bridge NSString *)kUTTypeImage]) {
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
    
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        NSString* filePath = [NSString stringWithFormat:@"%@/%@.png", _shopId, [NSString getUniqueStrByUUID]];
        [self.box changeImg:filePath img:image];
        _microShopHomepageVo.fileName = filePath;
        BOOL isChange = [self checkDataChange];
        [self.titleBox editTitle:isChange act:2];
        CGFloat newHeight = (image.size.height/image.size.width)*self.box.ls_width;
        self.box.ls_height = newHeight;
         [UIHelper refreshUI:self.container scrollview:self.scrollView];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)deleteCorrelation:(UIButton *)sender {
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否删除该单列商品图?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        [self deleteSet];
    }
}

#pragma mark - 网络请求
// 获取单列商品详情
- (void)loadDate {
    
    NSString *url = @"microShopHomepage/selectHomePageDetail";
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
   weakSelf.shopId=[[Platform Instance] getkey:SHOP_ID];
    
    [param setValue:weakSelf.shopId forKey:@"shopId"];
    [param setValue:[NSNumber numberWithInt:5] forKey:@"setType"];
    [param setValue:@2 forKey:@"interface_version"];
    if (![_homePageId isEqual:@""] && _homePageId !=nil) {
        [param setValue:_homePageId forKey:@"homePageId"];
    }
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        if ([ObjectUtil isNotNull:[MicroShopHomepageVo convertToMicroGoodsVo:[json objectForKey:@"microShopHomepageVo"]]]){
            _microShopHomepageVo=[MicroShopHomepageVo convertToMicroGoodsVo:[json objectForKey:@"microShopHomepageVo"]];
            [self initView];
        }

    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

// 保存单列商品设置
- (void)saveSet {
    
    if ([NSString isBlank:self.token]) {
        self.token = [[Platform Instance] getToken];
    }
    __weak typeof(self) weakSelf = self;
    NSString *url = @"microShopHomepage/save";
    _microShopHomepageVo.setType = 5;
    _microShopHomepageVo.hasRelevance=[self.lstCorrelation getStrVal].intValue;
    _microShopHomepageVo.sortCode = 1;
    _microShopHomepageVo.fileName = self.box.currentVal;
    _microShopHomepageList = [_microShopHomepageVo convertToDictionary];
    
    if([ObjectUtil isNull:self.box.img.image]) {
        [AlertBox show:@"请先添加图片!"];
        return;
    }
    if([self.lstCorrelation getStrVal].intValue == 1) {
        
        if ([ObjectUtil isNull:_microShopHomepageVo.microShopHomepageDetailVoArr] || !_microShopHomepageVo.microShopHomepageDetailVoArr.count) {
            [AlertBox show:@"关联商品开关开启后，请添加关联的商品后再保存！"];
            return;
        }
    }
    
    NSMutableDictionary *param = [[NSMutableDictionary dictionary]init];
    [param setValue:weakSelf.shopId forKey:@"shopId"];
    [param setValue:_microShopHomepageList forKey:@"microShopHomepageVo"];
    [param setValue:weakSelf.token forKey:@"token"];
    [param setValue:@2 forKey:@"interface_version"];
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

// 删除当前的单列商品
- (void)deleteSet {
    
    NSString *url = @"microShopHomepage/delete";
    __weak typeof(self) weakSelf = self;
    NSDictionary *param = @{@"homePageId":weakSelf.homePageId};
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        if (self.refreshHomepage) {
            self.refreshHomepage();
        }
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [weakSelf.navigationController popViewControllerAnimated:NO];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
