//
//  WeChatHomeSetCarouselSet.m
//  retailapp
//
//  Created by diwangxie on 16/4/25.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "CarouselFigureSet.h"
#import "XHAnimalUtil.h"
#import "UIHelper.h"
#import "AlertBox.h"
#import "WeChatStyleGoodsList.h"
#import "Wechat_StyleVo.h"
#import "EditItemList3.h"
#import "MicroShopHomepageVo.h"
#import "ImageUtils.h"
#import "MicroShopHomepageDetailVo.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "LSImagePickerController.h"
#import "LSWechatHomeSetBatchSelectViewController.h"
#import "MicroWechatGoodsVo.h"
#import "LSImageVo.h"
#import "LSImageDataVo.h"

@interface CarouselFigureSet ()<LSImagePickerDelegate,INavigateEvent,IEditItemRadioEvent,EditItemAddCorrelationDelegate,EditItemList3Delegate,IEditItemImageEvent>

@property (weak, nonatomic) IBOutlet UIView *titleDiv;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UIView *content;
@property (weak, nonatomic) IBOutlet EditItemRadio *lstCorrelation;
@property (weak, nonatomic) IBOutlet EditItemCorrelation *lstCorrelationView;
@property (weak, nonatomic) IBOutlet EditItemAddCorrelation *lstAddCorrelationGoods;
@property (weak, nonatomic) IBOutlet UIView *delView;
@property (weak, nonatomic) IBOutlet UIView *imgBoxWrapper;

@property (nonatomic, strong) NavigateTitle2 *titleBox;
@property (strong, nonatomic) WeChatSetImageBox *imgBox;

@property (nonatomic ,strong) NSString *homePageId;
@property (nonatomic ,copy) void (^refreshHomepage)();/* <回调block，刷新微店主页*/
@property (nonatomic, strong) NSMutableArray *styleList;
@property (nonatomic, strong) NSString *shopId;
@property (nonatomic, strong) NSMutableArray *styleGoodsList;
@property (nonatomic, strong) MicroShopHomepageVo *microShopHomepageVo;
/**唯一性*/
@property (nonatomic, copy) NSString *token;
@property (nonatomic, strong) LSImagePickerController *imagePicker;/* <<#desc#>*/
@end

@implementation CarouselFigureSet

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.styleList = [[NSMutableArray alloc] init];
    [self initTitleBox];
    [self loadDate];
    [self configHelpButton:HELP_WECHAT_HOME_SETTING];
}

- (void)setHomepageId:(NSString *)pageId callBack:(void (^)())block {
    self.homePageId = pageId;
    self.refreshHomepage = block;
}

#pragma mark - 导航栏
- (void)initTitleBox {
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"轮播图设置" backImg:Head_ICON_BACK moreImg:nil];
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
    
    // 轮播图片展示控件
    if (!self.imgBox) {
        self.imgBox = [[WeChatSetImageBox alloc] initWithFrame:CGRectMake(0, 0, 300, 200) action:1 tag:1 delegate:self];
        [self.imgBoxWrapper addSubview:self.imgBox];
    }
    [self.imgBox initBoxView:_microShopHomepageVo.filePath homePageId:_microShopHomepageVo.homePageId];
    
    // 关联商品控件
    [self.lstCorrelation initIndent:@"指定图片关联商品" withHit:nil indent:NO delegate:self];
    [self.lstCorrelation initData:[NSString stringWithFormat:@"%ld",_microShopHomepageVo.hasRelevance]];

    // 已关联商品数目显示
    [self.lstCorrelationView visibal:[self.lstCorrelation getStrVal].intValue];
    [self.lstCorrelationView initCorrelationSum:_microShopHomepageVo.microShopHomepageDetailVoArr.count];

    //创建一个列表容器，用于存放选中的关联商品
    _content.frame = CGRectMake(0, 0, 320, _styleList.count*46);
    [self.container insertSubview:_content belowSubview:self.lstAddCorrelationGoods];
    
    for (int i = 0; i < _styleList.count; i++) {
        MicroShopHomepageDetailVo *vo = [_styleList objectAtIndex:i];
        EditItemList3 *listItem = [[EditItemList3 alloc] init];
        [listItem initFromNib:self];
        listItem.frame = CGRectMake(0, 46*i, 320, 46);
        if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {
            [listItem initCode:vo.styleCode initName:vo.styleName];
        } else {
            [listItem initCode:vo.goodsBarCode initName:vo.goodsName];
        }
        
        listItem.tag = i;
        [_content addSubview:listItem];
    }
    _content.hidden = ![_lstCorrelation getStrVal].boolValue;
    
    // 添加图片关联商品
    [self.lstAddCorrelationGoods visibal:[self.lstCorrelation getStrVal].boolValue];
    [self.lstAddCorrelationGoods initView:@"添加图片关联商品" delegate:self];
    
    // 只有homepageId有的情况下才显示删除按钮
    self.delView.hidden = !_microShopHomepageVo.homePageId;
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

// 更新ui
-(void)reconfigureUI {
    
    // 更新展示关联商品数目，如果关闭关联商品，则隐藏
    [self.lstCorrelationView visibal:[self.lstCorrelation getStrVal].boolValue];
    [self.lstCorrelationView initCorrelationSum:_styleList.count];
    
    for(UIView *view in [_content subviews]) {
        [view removeFromSuperview];
    }
    
    //更新_content 的frame
    _content.frame = CGRectMake(0, 0, 320, _styleList.count*46);
    // 只有开启
    _content.hidden = ![_lstCorrelation getStrVal].boolValue;
    [self.lstAddCorrelationGoods visibal:[self.lstCorrelation getStrVal].intValue];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    
    for (int i = 0; i < _styleList.count; i++) {
        MicroShopHomepageDetailVo *vo = [_styleList objectAtIndex:i];
        EditItemList3 *listItem = [[EditItemList3 alloc] init];
        [listItem initFromNib:self];
        listItem.frame = CGRectMake(0, 46*i, 320, 46);
        if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {
            [listItem initCode:vo.styleCode initName:vo.styleName];
        } else {
            [listItem initCode:vo.goodsBarCode initName:vo.goodsName];
        }
        listItem.tag = i;
        [_content addSubview:listItem];
    }
    
}

- (BOOL)checkDataChange {
    return self.lstCorrelation.isChange || self.imgBox.isChange;
}

#pragma mark - IEditItemRadioEvent
// 开关-- 指定图片关联商品
- (void)onItemRadioClick:(EditItemRadio *)obj {
    
    if (obj == self.lstCorrelation) {
        if ([self.lstCorrelation getVal]) {
            [self.lstCorrelationView visibal:YES];
            [self.lstAddCorrelationGoods visibal:YES];
            [self.content setHidden:NO];
        }else {
            [self.lstCorrelationView visibal:NO];
            [self.lstAddCorrelationGoods visibal:NO];
            [self.content setHidden:YES];
        }
    }
    BOOL isChange = [self checkDataChange];
    [self.titleBox editTitle:isChange act:2];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}


#pragma mark - IEditItemImageEvent
// 点击选择从相机或者相册获取图片
- (void)onConfirmImgClick:(NSInteger)btnIndex {
    
    [self showImagePickerController:btnIndex];
}

#pragma mark EditItemAddCorrelationDelegate
// 添加关联商品
- (void)addClick:(EditItemAddCorrelation *)item {
    if ([[[Platform Instance] getkey:SHOP_MODE] integerValue] == 101) {//服鞋
        WeChatStyleGoodsList*vc = [[WeChatStyleGoodsList alloc] initWithNibName:@"WeChatStyleGoodsList" bundle:nil];
        vc.mode = 1;
        [vc loadStyleGoodsList:1 callBack:^(NSMutableArray *styleGoodsList) {
            [_styleList removeAllObjects];
            for (Wechat_StyleVo *styleVo in styleGoodsList) {
                MicroShopHomepageDetailVo *detailVo = [[MicroShopHomepageDetailVo alloc] init];
                detailVo.relevanceId = styleVo.styleId;
                detailVo.relevanceType = 2;
                detailVo.styleCode = styleVo.styleCode;
                detailVo.styleName = styleVo.styleName;
                [_styleList addObject:detailVo];
            }
            _microShopHomepageVo.hasRelevance = 1;
            //        [self.titleBox initWithName:@"双列焦点图设置" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
            [self.titleBox editTitle:YES act:ACTION_CONSTANTS_EDIT];
            self.titleBox.lblRight.text = @"保存";
            [self reconfigureUI];
            
        }];
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    } else  if ([[[Platform Instance] getkey:SHOP_MODE] integerValue] == 102) {//商超
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
            [self reconfigureUI];
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [self.navigationController popViewControllerAnimated:NO];
            
        }];
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        
    }
   
}

// 删除当前轮播图及相关配置
- (IBAction)deletePic:(UIButton *)sender {
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否删除该轮播图?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self deleteCurrentScrollPageSet];
    }
}



#pragma mark - EditItemList3Delegate
// 点击EditItemList3右侧删除按钮删除指定的关联商品
- (void)btnDelClick:(EditItemList3 *)item {
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要删除该商品？" preferredStyle:UIAlertControllerStyleAlert];
    [self.navigationController presentViewController:alertVc animated:YES completion:nil];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.styleList removeObjectAtIndex:item.tag];
        [self.titleBox editTitle:YES act:ACTION_CONSTANTS_EDIT];
        [self reconfigureUI];

    }]];
    
}

#pragma mark - 网络请求
// 获取轮播图配置信息
- (void)loadDate {
    
    NSString *url = @"microShopHomepage/selectHomePageDetail";
    self.shopId=[[Platform Instance] getkey:SHOP_ID];
    
     __weak typeof(self) weakSelf = self;
     NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:weakSelf.shopId forKey:@"shopId"];
    [param setValue:[NSNumber numberWithInt:2] forKey:@"setType"];
    if (![_homePageId isEqual:@""] && _homePageId !=nil) {
        [param setValue:_homePageId forKey:@"homePageId"];
    }
    [param setValue:@2 forKey:@"interface_version"];
    
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        if ([ObjectUtil isNotNull:[MicroShopHomepageVo convertToMicroGoodsVo:[json objectForKey:@"microShopHomepageVo"]] ]) {
            _microShopHomepageVo=[MicroShopHomepageVo convertToMicroGoodsVo:[json objectForKey:@"microShopHomepageVo"]];
        }
        if ([ObjectUtil isNotNull:_microShopHomepageVo.microShopHomepageDetailVoArr]) {
            self.styleList=_microShopHomepageVo.microShopHomepageDetailVoArr;
        }
        [self initView];

    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
   
}

// 保存轮播图及设置、变化
- (void)saveSet {
    
    if ([NSString isBlank:self.token]) {
        self.token = [[Platform Instance] getToken];
    }

    self.shopId = [[Platform Instance] getkey:SHOP_ID];

    

    
    NSString *url = @"microShopHomepage/save";
    
    __weak typeof(self) weakSelf = self;
    weakSelf.microShopHomepageVo.setType = 1;
    weakSelf.microShopHomepageVo.hasRelevance = [weakSelf.lstCorrelation getStrVal].intValue;
    weakSelf.microShopHomepageVo.microShopHomepageDetailVoArr = weakSelf.styleList;
    weakSelf.microShopHomepageVo.fileName = self.imgBox.currentVal;
    NSDictionary *microShopHomepageList = [_microShopHomepageVo convertToDictionary];
    if([ObjectUtil isNull:self.imgBox.img.image]) {
        [AlertBox show:@"请先添加图片!"];
        return;
    }
    if([self.lstCorrelation getStrVal].intValue == 1) {
        if (self.styleList.count == 0) {
            [AlertBox show:@"关联商品开关开启后，请添加关联的商品后再保存！"];
            return;
        }
    }
    
    NSDictionary *param = @{@"shopId":self.shopId,
                            @"microShopHomepageVo":microShopHomepageList,
                            @"token":self.token,
                            @"interface_version":@2};
    // 新增修改微店主页设置
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
    if (self.imgBox.isChange) {
        if ([NSString isNotBlank:self.imgBox.oldVal]) {
            imageVo = [LSImageVo imageVoWithFileName:self.imgBox.oldVal opType:2 type:@"shop"];
            [imageVoList addObject:imageVo];
        }
        if ([NSString isNotBlank:self.imgBox.currentVal]) {
            imageVo = [LSImageVo imageVoWithFileName:self.imgBox.currentVal opType:1 type:@"shop"];
            [imageVoList addObject:imageVo];
            NSData *data = [ImageUtils dataOfImageAfterCompression:self.imgBox.img.image];
            imageDataVo = [LSImageDataVo imageDataVoWithData:data file:self.imgBox.currentVal];
            [imageDataList addObject:imageDataVo];
        }
    }
    //上传图片
    [BaseService upLoadImageWithimageVoList:imageVoList imageDataVoList:imageDataList];

}

// 删除当前轮播图及相关设置
- (void)deleteCurrentScrollPageSet {
    
    NSString *url = @"microShopHomepage/delete";
    NSDictionary *param = @{@"homePageId":self.homePageId};
    
    //是否启用主题销售
    __weak typeof(self) weakSelf = self;
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        if (weakSelf.refreshHomepage) {
            weakSelf.refreshHomepage();
        }
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}


#pragma mark - LSImagePickerController, 选择处理照片
- (void)showImagePickerController:(UIImagePickerControllerSourceType)type {
    
    _imagePicker = [LSImagePickerController showImagePickerWith:type presenter:self];
}

// LSImagePickerDelegate
- (void)imagePicker:(LSImagePickerController *)controller pickerImage:(UIImage *)image {
    
    NSString* filePath = [NSString stringWithFormat:@"%@/%@.png", _shopId, [NSString getUniqueStrByUUID]];
    [self.imgBox changeImg:filePath img:image];
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
