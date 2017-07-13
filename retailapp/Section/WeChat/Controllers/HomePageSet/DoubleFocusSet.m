//
//  WeChatHomeSetDoubleFocus.m
//  retailapp
//
//  Created by diwangxie on 16/4/23.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "DoubleFocusSet.h"
#import "NavigateTitle2.h"
#import "EditItemRadio.h"
#import "EditItemCorrelation.h"
#import "EditItemAddCorrelation.h"
#import "EditItemList3.h"
#import "TZImagePickerController.h"
#import "MHImagePickerMutilSelector.h"
#import "WeChatSetImageBox.h"
#import "XHAnimalUtil.h"
#import "AlertBox.h"
#import "UIHelper.h"
#import "ObjectUtil.h"
#import "ImageUtils.h"
#import "WeChatStyleGoodsList.h"
#import "MicroShopHomepageDetailVo.h"
#import "MicroShopHomepageVo.h"
#import "Wechat_StyleVo.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "LSImagePickerController.h"
#import "LSWechatHomeSetBatchSelectViewController.h"
#import "MicroWechatGoodsVo.h"
#import "LSImageDataVo.h"
#import "LSImageVo.h"

@interface DoubleFocusSet ()<LSImagePickerDelegate,INavigateEvent,IEditItemRadioEvent,EditItemAddCorrelationDelegate,EditItemList3Delegate,IEditItemImageEvent>

@property (weak, nonatomic) IBOutlet UIView *titleDiv;
@property (nonatomic, strong) NavigateTitle2 *titleBox;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UIView *content;

@property (weak, nonatomic) IBOutlet UIView *imgContent;
@property (weak, nonatomic) IBOutlet EditItemRadio *lstCorrelation;
@property (weak, nonatomic) IBOutlet EditItemCorrelation *lstCorrelationView;
@property (weak, nonatomic) IBOutlet EditItemAddCorrelation *lstAddCorrelationGoods;
@property (weak, nonatomic) IBOutlet UIView *delView;

@property (nonatomic,strong) NSMutableArray *styleList;
@property (nonatomic,strong) NSMutableArray *styleGoodsList;
@property (nonatomic,strong) MicroShopHomepageVo *microShopHomepageVo;
@property (nonatomic,strong) NSDictionary *microShopHomepageList;
@property (nonatomic,strong) NSString *shopId;
@property (nonatomic, strong) EditItemList3 *list;
@property (nonatomic, strong) WeChatSetImageBox *box;
//区分是修改第几张的双列焦点图
@property (nonatomic) NSInteger sortCode;
@property (nonatomic,strong) NSString *homePageId;
@property (nonatomic ,copy) void (^refreshHomepage)();/* <回调block，刷新微店主页*/
/**唯一性*/
@property (nonatomic,copy) NSString *token;
@property (nonatomic ,strong) LSImagePickerController *imagePicker;/* <<#desc#>*/
@end

@implementation DoubleFocusSet

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
    [self initView];
    [self loadDate];
    [self configHelpButton:HELP_WECHAT_HOME_SETTING];
}

- (void)initTitleBox {
    
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"双列焦点图设置" backImg:Head_ICON_BACK moreImg:nil];
    [self.titleDiv addSubview:self.titleBox];
}

- (void)onNavigateEvent:(Direct_Flag)event {
    if (event == DIRECT_LEFT) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        [self saveSet];
    }
}

- (void)initView {
    
    if (!self.box) {
        self.box = [[WeChatSetImageBox alloc] initWithFrame:CGRectMake(0, 10, 160, 77) action:2 tag:1 delegate:self];
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
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}



- (void)onItemRadioClick:(EditItemRadio *)obj {
    
    if (obj == self.lstCorrelation) {
        if ([self.lstCorrelation getVal]) {
            [self.lstCorrelationView visibal:YES];
            [self.lstAddCorrelationGoods visibal:YES];
            [self.content setHidden:NO];
        }else{
            [self.lstCorrelationView visibal:NO];
            [self.lstAddCorrelationGoods visibal:NO];
            [self.content setHidden:YES];
        }
    }
    BOOL isChange = [self checkDataChange];
    [self.titleBox editTitle:isChange act:2];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (BOOL)checkDataChange {
    return self.lstCorrelation.isChange || self.box.isChange;
}

- (void)addClick:(EditItemAddCorrelation *)item{
    
    if ([[[Platform Instance] getkey:SHOP_MODE] integerValue] == 101) {//服鞋
        WeChatStyleGoodsList*vc = [[WeChatStyleGoodsList alloc] initWithNibName:@"WeChatStyleGoodsList" bundle:nil];
        vc.mode = 1;
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
            [self.titleBox initWithName:@"双列焦点图设置" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
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

- (void)showViewDate:(NSMutableArray *) styleList{
    
    [self.lstCorrelationView visibal:[self.lstCorrelation getStrVal].intValue];
    [self.lstCorrelationView initCorrelationSum:_styleList.count];
    
    for(UIView *view in [_content subviews]) {
        [view removeFromSuperview];
    }
    //创建一个列表容器，用于存放选中的关联商品
    _content.frame=CGRectMake(0, 0, 320, styleList.count*46);
    [self.container addSubview:_content];
    [self.container insertSubview:_content belowSubview:self.lstAddCorrelationGoods];
    
    int h = 0;
    for (int i=0; i<styleList.count; i++) {
        MicroShopHomepageDetailVo *vo = [styleList objectAtIndex:i];
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

- (void)onConfirmImgClick:(NSInteger)btnIndex {
    // btnIndex = 0 :UIImagePickerControllerSourceTypePhotoLibrary
    // 1 : UIImagePickerControllerSourceTypeCamera
    [self showImagePickerController:btnIndex];
}


- (IBAction)deleteCorrelation:(UIButton *)sender {
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否删除该双列焦点图?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==1) {
        [self deleteCurrentSet];
    }
}

- (void)btnDelClick:(EditItemList3 *)item{
    
    [self.styleList removeObjectAtIndex:item.tag];
    [self.titleBox initWithName:@"双列焦点图设置" backImg:Head_ICON_CANCEL
                        moreImg:Head_ICON_OK];
    self.titleBox.lblRight.text=@"保存";
    [self showViewDate:self.styleList];
}

#pragma mark - 网络请求

- (void)loadDate {
    
    NSString *url = @"microShopHomepage/selectHomePageDetail";
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    weakSelf.shopId=[[Platform Instance] getkey:SHOP_ID];
    [param setValue:@2 forKey:@"interface_version"];
    [param setValue:weakSelf.shopId forKey:@"shopId"];
    [param setValue:[NSNumber numberWithInt:2] forKey:@"setType"];
    if (![_homePageId isEqual:@""] && _homePageId !=nil) {
        [param setValue:_homePageId forKey:@"homePageId"];
    }
    //是否启用主题销售
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        if ([ObjectUtil isNotNull:[MicroShopHomepageVo convertToMicroGoodsVo:[json objectForKey:@"microShopHomepageVo"]] ]) {
            _microShopHomepageVo=[MicroShopHomepageVo convertToMicroGoodsVo:[json objectForKey:@"microShopHomepageVo"]];
        }
        if ([ObjectUtil isNotNull:_microShopHomepageVo.microShopHomepageDetailVoArr]) {
            self.styleList = _microShopHomepageVo.microShopHomepageDetailVoArr;
        }
        [self initView];

    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

// 保存更改，设置等
- (void)saveSet {
    
    if ([NSString isBlank:self.token]) {
        self.token = [[Platform Instance] getToken];
    }
     self.shopId=[[Platform Instance] getkey:SHOP_ID];

    NSString *url = @"microShopHomepage/save";
    self.microShopHomepageVo.setType = 2;
    self.microShopHomepageVo.sortCode = self.sortCode;
    self.microShopHomepageVo.hasRelevance = [self.lstCorrelation getStrVal].intValue;
    self.microShopHomepageVo.microShopHomepageDetailVoArr = self.styleList;
    self.microShopHomepageVo.fileName = self.box.currentVal;
    self.microShopHomepageList = [_microShopHomepageVo convertToDictionary];
    
    if([ObjectUtil isNull:self.box.img.image]){
        [AlertBox show:@"请先添加图片!"];
        return;
    }
    if([self.lstCorrelation getStrVal].intValue==1){
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
        [XHAnimalUtil animal:wself.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
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

// 删除当前的焦点图
- (void)deleteCurrentSet {
    
    NSString *url = @"microShopHomepage/delete";
    __weak typeof(self) weakSelf = self;
    NSDictionary *param = @{@"homePageId":self.homePageId};
    //是否启用主题销售
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



#pragma mark - LSImagePickerController, 选择处理照片

- (void)showImagePickerController:(UIImagePickerControllerSourceType)type {
    
    _imagePicker = [LSImagePickerController showImagePickerWith:type presenter:self];
    if (_imagePicker) {
        CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds) - 2*5;
        _imagePicker.cropSize = CGSizeMake(width, width*5/12);
    }
}

// LSImagePickerDelegate
- (void)imagePicker:(LSImagePickerController *)controller pickerImage:(UIImage *)image {
    
    NSString* filePath = [NSString stringWithFormat:@"%@/%@.png", _shopId, [NSString getUniqueStrByUUID]];
    [self.box changeImg:filePath img:image];
    _microShopHomepageVo.fileName=filePath;
    BOOL isChange = [self checkDataChange];
    [self.titleBox editTitle:isChange act:2];
    _imagePicker = nil;
}

- (void)imagePickerDidCancel:(LSImageMessageType)message {
    
    if (message == LSImageMessageNoSupportCamera) {
        [AlertBox show:@"相机好像不能用哦!"];
    }else if (message == LSImageMessageNoSupportPhotoLibrary) {
        [AlertBox show:@"相册好像不能访问哦!"];
    }
    _imagePicker = nil;
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
