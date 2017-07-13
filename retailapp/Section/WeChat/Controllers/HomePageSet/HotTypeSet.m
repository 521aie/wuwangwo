//
//  WeChatHomeSetHotTypeSet.m
//  retailapp
//
//  Created by diwangxie on 16/4/27.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "HotTypeSet.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "XHAnimalUtil.h"
#import "UIHelper.h"
#import "AlertBox.h"
#import "OptionPickerBox.h"
#import "ImageUtils.h"
#import "MicroShopHomepageVo.h"
#import "MicroShopHomepageDetailVo.h"
#import "WDRelatedGoodType.h"
#import "NavigateTitle2.h"
#import "EditItemList.h"
#import "EditItemRadio.h"
#import "TZImagePickerController.h"
#import "MHImagePickerMutilSelector.h"
#import "WeChatSetImageBox.h"
#import "LSImageDataVo.h"
#import "LSImageVo.h"

@interface HotTypeSet ()<OptionPickerClient,INavigateEvent,IEditItemRadioEvent,IEditItemListEvent,UINavigationControllerDelegate,UIImagePickerControllerDelegate,IEditItemImageEvent>
{
    UIImagePickerController *imagePickerController;
}

@property (weak, nonatomic) IBOutlet UIView *titleDiv;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UIView *imgBox;
@property (weak, nonatomic) IBOutlet EditItemRadio *lstCorrelation;
@property (weak, nonatomic) IBOutlet EditItemList *lstType;
@property (weak, nonatomic) IBOutlet UIView *radiusImg;
@property (weak, nonatomic) IBOutlet UIView *delView;
@property (nonatomic, strong) NSString *shopId;
@property (nonatomic, strong) NSMutableArray *styleList;
@property (nonatomic, strong) NSMutableArray *styleGoodsList;
@property (nonatomic, strong) MicroShopHomepageVo *microShopHomepageVo;
@property (nonatomic, strong) NSDictionary *microShopHomepageList;
@property (nonatomic, strong) NSArray *goodTypes;/* <品类列表*/
@property (nonatomic) NSInteger sortCode;
@property (nonatomic, strong) NSString *homePageId;
@property (nonatomic ,copy) void (^refreshHomepage)();/* <回调block，刷新微店主页*/
/**唯一性*/
@property (nonatomic ,copy) NSString *token;
@property (nonatomic ,strong) WeChatSetImageBox *box;
@property (nonatomic, strong) NavigateTitle2 *titleBox;
@end

@implementation HotTypeSet

- (void)setHomepageId:(NSString *)pageId sortCode:(NSInteger)code block:(void (^)())block {
    self.homePageId = pageId;
    self.sortCode = code;
    self.refreshHomepage = block;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.microShopHomepageVo = [[MicroShopHomepageVo alloc] init];
    self.microShopHomepageList = [[NSDictionary alloc] init];
    self.styleList = [[NSMutableArray alloc] init];
    
    [self initTitleBox];
    [self loadDate];
    [self configHelpButton:HELP_WECHAT_HOME_SETTING];
}

- (void)initTitleBox {
    
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"热门分类设置" backImg:Head_ICON_BACK moreImg:nil];
    [self.titleDiv addSubview:self.titleBox];
}

- (void)initView {
    
    if (!self.box) {
        self.box = [[WeChatSetImageBox alloc] initWithFrame:CGRectMake(0, 0, 106, 136) action:4 tag:1 delegate:self];
        [self.imgBox addSubview:self.box];
    }
    [self.box initBoxView:_microShopHomepageVo.filePath homePageId:_microShopHomepageVo.homePageId];
    

    [self.lstCorrelation initIndent:@"指定图片关联商品" withHit:nil indent:NO delegate:self];
    [self.lstCorrelation initData:[NSString stringWithFormat:@"%ld",_microShopHomepageVo.hasRelevance]];
    [self.lstType initLabel:@"关联品类" withHit:nil delegate:self];
    [self.lstType initData:@"请选择" withVal:nil];
    // 打开“指定图片关联商品”开关，才会显示“关联商品”选项
    [self.lstType visibal:[self.lstCorrelation getStrVal].intValue];
    
    for (MicroShopHomepageDetailVo *vo in _microShopHomepageVo.microShopHomepageDetailVoArr) {
        [self.lstType initData:vo.cateGoryName withVal:vo.relevanceId];
    }

    
    if (!_microShopHomepageVo.homePageId) {
        [self.delView setHidden:YES];
    }else{
        [self.delView setHidden:NO];
    }
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
}

#pragma mark - INavigateEvent
- (void)onNavigateEvent:(Direct_Flag)event {
    
    if (event == DIRECT_LEFT) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        [self saveSet];
    }
}

#pragma mark - IEditItemRadioEvent
- (void)onItemRadioClick:(EditItemRadio*)obj {
    
    if (obj==self.lstCorrelation) {
        if ([self.lstCorrelation getVal]) {
            [self.lstType visibal:YES];
        }else{
            [self.lstType visibal:NO];
        }
    }
    BOOL isChange = [self checkDataChange];
    [self.titleBox editTitle:isChange act:2];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
}

#pragma mark - IEditItemListEvent
- (void)onItemListClick:(EditItemList *)obj {
    
    [OptionPickerBox initData:_goodTypes itemId:[obj getStrVal]];
    [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
}

#pragma mark - OptionPickerClient
- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType {
    
    WDRelatedGoodType *obj = (WDRelatedGoodType *)selectObj;
    [self.lstType changeData:obj.microname withVal:[obj obtainItemId]];
    BOOL isChanged = [self checkDataChange];
    if (isChanged) {
        [self.titleBox editTitle:isChanged act:ACTION_CONSTANTS_ADD];
        MicroShopHomepageDetailVo *detailVo=[[MicroShopHomepageDetailVo alloc] init];
        detailVo.relevanceId = obj.categoryId;
        detailVo.relevanceType = 3;
        detailVo.sortCode = self.sortCode;
        detailVo.cateGoryName = obj.microname;
        detailVo.microShopHomepageId = self.homePageId;
        [self.styleList removeAllObjects];
        [self.styleList addObject:detailVo];
    }
    return YES;
}

#pragma mark - IEditItemImageEvent
- (void)onConfirmImgClick:(NSInteger)btnIndex {
    if (btnIndex==1) {
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

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        NSString* filePath = [NSString stringWithFormat:@"%@/%@.png", _shopId, [NSString getUniqueStrByUUID]];
        [self.box changeImg:filePath img:image];
        self.microShopHomepageVo.fileName=filePath;
        BOOL isChange = [self checkDataChange];
        [self.titleBox editTitle:isChange act:2];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}



- (IBAction)deleteCorrelation:(UIButton *)sender {
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否删除该分类图?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==1) {
        [self deleteHotTypeSet];
    }
}

#pragma mark - 数据加载
// 加载热点类型信息
- (void)loadDate {
    
    // 加载详情信息
    __weak typeof(self) weakSelf = self;
    NSString *url = @"microShopHomepage/selectHomePageDetail";
    
    self.shopId=[[Platform Instance] getkey:SHOP_ID];

    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:self.shopId forKey:@"shopId"];
    [param setValue:[NSNumber numberWithInt:4] forKey:@"setType"];
    [param setValue:@2 forKey:@"interface_version"];
    if (![_homePageId isEqual:@""] && _homePageId !=nil) {
        [param setValue:_homePageId forKey:@"homePageId"];
    }
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        if ([ObjectUtil isNotNull:[MicroShopHomepageVo convertToMicroGoodsVo:[json objectForKey:@"microShopHomepageVo"]] ]) {
            weakSelf.microShopHomepageVo=[MicroShopHomepageVo convertToMicroGoodsVo:[json objectForKey:@"microShopHomepageVo"]];
        }
        if ([ObjectUtil isNotNull:_microShopHomepageVo.microShopHomepageDetailVoArr]) {
            weakSelf.styleList=_microShopHomepageVo.microShopHomepageDetailVoArr;
        }
        [weakSelf initView];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
    
    
    
    // 加载关联品类列表
    url = @"category/lastCategoryInfo";
    NSDictionary *params = @{@"hasNoCategory":@"0"};
    [BaseService getRemoteLSDataWithUrl:url param:params withMessage:nil show:YES CompletionHandler:^(id json) {
        NSArray *arr = [json objectForKey:@"categoryList"];
        weakSelf.goodTypes = [WDRelatedGoodType getRelatedGoodTypeList:arr];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

// 保存当前热点信息
- (void)saveSet {
    
    if ([NSString isBlank:self.token]) {
        self.token = [[Platform Instance] getToken];
    }
  
    self.shopId = [[Platform Instance] getkey:SHOP_ID];
    NSString *url = @"microShopHomepage/save";
    self.microShopHomepageVo.setType = 4;
    self.microShopHomepageVo.sortCode = self.sortCode;
    self.microShopHomepageVo.hasRelevance = [self.lstCorrelation getStrVal].intValue;
    self.microShopHomepageVo.microShopHomepageDetailVoArr = self.styleList;
    self.microShopHomepageVo.fileName = self.box.currentVal;
    self.microShopHomepageList = [_microShopHomepageVo convertToDictionary];
    
    if([ObjectUtil isNull:self.box.img.image]) {
        [AlertBox show:@"请先添加图片!"];
        return;
    }
    if([self.lstCorrelation getStrVal].intValue==1) {
        if (self.styleList.count==0) {
            [AlertBox show:@"关联商品开关开启后，请添加关联的商品后再保存！"];
            return;
        }
    }

    
    NSDictionary *param = @{@"shopId":self.shopId,
                            @"microShopHomepageVo":self.microShopHomepageList,
                            @"token":self.token,
                            @"interface_version":@2};
    
    __weak typeof(self) wself = self;
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        wself.token = nil;
        if (wself.refreshHomepage) {
            wself.refreshHomepage();
        }
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [wself.navigationController popViewControllerAnimated:NO];
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

// 删除当前热点
- (void)deleteHotTypeSet {
   
    NSString *url  = @"microShopHomepage/delete";
    __weak typeof(self) weakSelf = self;
    NSDictionary *param = @{@"homePageId":weakSelf.homePageId};
    //是否启用主题销售
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        if (self.refreshHomepage) {
            self.refreshHomepage();
        }
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];

}

- (BOOL)checkDataChange {
    return self.lstCorrelation.isChange || self.lstType.isChange || self.box.isChange;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
