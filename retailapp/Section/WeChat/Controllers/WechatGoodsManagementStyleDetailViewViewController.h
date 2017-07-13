//
//  WechatGoodsManagementStyleDetailViewViewController.h
//  retailapp
//
//  Created by zhangzt on 15/10/16.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigateTitle2.h"
#import "IEditItemListEvent.h"
#import "IEditItemRadioEvent.h"
#import "OptionPickerClient.h"
#import "DatePickerBox.h"
#import "FooterListEvent.h"
#import "IEditItemImageEvent.h"
#import "SymbolNumberInputBox.h"
#import "IEditItemMemoEvent.h"
#import "MHImagePickerMutilSelector.h"
#import "MemoInputView.h"

typedef void(^wechatStyleDetailBack) (BOOL flg);
@class WechatModule, FooterListView, Wechat_MicroStyleVo, StyleVo, StyleGoodsVo,MicroStyleGoodsVo;
@class EditItemText, EditItemRadio, EditItemList, ItemTitle, EditItemRadio2, EditItemImage, EditImageBox,EditItemMemo;

@interface WechatGoodsManagementStyleDetailViewViewController : BaseViewController<INavigateEvent, OptionPickerClient,IEditItemRadioEvent, IEditItemListEvent, FooterListEvent, IEditItemImageEvent, SymbolNumberInputClient, IEditItemMemoEvent, MemoInputClient,UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate,MHImagePickerMutilSelectorDelegate>
{
    WechatModule *parent;
    
    UIImage *goodsImage;
    
    UIImagePickerController *imagePickerController;
    
}

@property (nonatomic, retain) IBOutlet UIView *titleDiv;
@property (nonatomic, strong) NavigateTitle2 *titleBox;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *container;
//是否在微店销售
@property (nonatomic, strong) IBOutlet EditItemRadio2 *rdoIsSale;
//基本信息
@property (nonatomic, strong) IBOutlet ItemTitle *TitBaseInfo;
//款式名称
@property (weak, nonatomic) IBOutlet EditItemMemo *meStyleName;
//商品款号
@property (nonatomic, strong) IBOutlet EditItemText *txtBarcode;
//商品品牌
@property (nonatomic, strong) IBOutlet EditItemText *txtBrand;
//吊牌价
@property (nonatomic, strong) IBOutlet EditItemText *txtHangTagPrice;
//零售价
@property (nonatomic, strong) IBOutlet EditItemText *txtRetailPrice;
//优先度
@property (nonatomic, strong) IBOutlet EditItemList *lsPriority;
//微店售价策略
@property (nonatomic, strong) IBOutlet EditItemList *lsSalesStrategy;
//折扣
@property (nonatomic, strong) IBOutlet EditItemList *lsDiscount;
//自定义方式
@property (weak, nonatomic) IBOutlet EditItemList *lsCustomWay;
//微店售价
@property (weak, nonatomic) IBOutlet EditItemList *lsMicroPrice;

//扩展信息
@property (nonatomic, strong) IBOutlet ItemTitle *TitExtendInfo;
//详情介绍
@property (weak, nonatomic) IBOutlet EditItemMemo *txtDetails;
//图片
@property (nonatomic, strong) IBOutlet EditImageBox *boxPicture;

//颜色图片
@property (weak, nonatomic) IBOutlet ItemTitle *TitColourImage;
//颜色图片
@property (weak, nonatomic) IBOutlet EditItemList *lsColourImage;
//图文详情
@property (nonatomic, strong) IBOutlet ItemTitle *TitPictureInfo;
//图文详情
@property (nonatomic, strong) IBOutlet EditItemList *lsPictureInfo;
//分类Id
@property (nonatomic, copy) NSString *categoryId;


@property (nonatomic, strong) NSString* imgFilePathTemp;

@property (nonatomic) int action;

@property (nonatomic) int detai;

@property (nonatomic, strong) Wechat_MicroStyleVo *microStyleVo;

@property (nonatomic, strong) MicroStyleGoodsVo *microStyleGoodsVo;

@property (nonatomic, strong) StyleVo *styleVo;

@property (nonatomic, strong) StyleGoodsVo *styleGoodsVo;

@property (nonatomic, strong) NSString* shopId;

@property (nonatomic, strong) NSString* styleId;
@property (nonatomic, strong) NSString *synShopEntityId;/**<同步到的机构或者门店的shopEntityId>*/
//viewTag为1的时候，页面从商品款式详情跳转过来
@property (nonatomic, assign) int viewTag;

@property (nonatomic, strong) wechatStyleDetailBack callback;

- (void)loadDatasFromStyleEditView:(wechatStyleDetailBack)callback;


@end
