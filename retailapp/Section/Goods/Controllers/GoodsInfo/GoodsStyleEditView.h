//
//  GoodsStyleEditView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/8/4.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"

@class StyleVo,LSEditItemList,EditItemRadio2,LSEditItemRadio,LSEditItemText,LSEditItemTitle,EditItemImage;
@interface GoodsStyleEditView : LSRootViewController
@property (nonatomic, strong) StyleVo *styleVo;
@property (nonatomic, strong) NSString* synShopName;
@property (nonatomic, retain)  StyleVo* addStyleVo;
@property (nonatomic) int action;
@property (nonatomic) int viewTag;
@property (nonatomic, strong) NSString* shopId;
@property (nonatomic, strong) NSString* styleId;
@property (nonatomic, strong) NSString* synShopId;
/**<同步到的店铺或机构的shopEntityId>*/
@property (nonatomic, strong) NSString *synShopEntityId;

//商品上下架
@property (nonatomic, strong)  EditItemRadio2 *rdoStatus;
//基本信息
@property (nonatomic, strong)  LSEditItemTitle *TitBaseInfo;
//款式No
@property (nonatomic, strong)  LSEditItemText *txtStyleNo;
//款式名称
@property (nonatomic, strong)  LSEditItemText *txtStyleName;
//商品分类
@property (nonatomic, strong)  LSEditItemList *lsCategory;
//进货价
@property (nonatomic, strong)  LSEditItemList *lsPurPrice;
//吊牌价
@property (nonatomic, strong)  LSEditItemList *lsHangTagPrice;
//零售价
@property (nonatomic, strong)  LSEditItemList *lsRetailPrice;
//会员价
@property (nonatomic, strong)  LSEditItemList *lsMemberPrice;
//批发价
@property (nonatomic, strong)  LSEditItemList *lsWhoPrice;
//款式信息同步
@property (nonatomic, strong)  LSEditItemList *lsStyleInfoSyn;

//商品信息
@property (nonatomic, strong)  LSEditItemTitle *TitGoodsInfo;
//商品信息
@property (nonatomic, strong)  LSEditItemList *lsGoodsInfo;

//扩展信息
@property (nonatomic, strong)  LSEditItemTitle *TitExtendInfo;
//单位
@property (strong, nonatomic)  LSEditItemList *lstUnit;
//商品品牌
@property (nonatomic, strong)  LSEditItemList *lsBrand;
//适用性别
@property (nonatomic, strong)  LSEditItemList *lsSex;
//主型
@property (nonatomic, strong)  LSEditItemList *lsMainModel;
//辅型
@property (nonatomic, strong)  LSEditItemList *lsAuxiliaryModel;
//系列
@property (nonatomic, strong)  LSEditItemList *lsSeries;
//年度
@property (nonatomic, strong)  LSEditItemList *lsYear;
//阶段
@property (nonatomic, strong)  LSEditItemText *txtPhase;
//季节
@property (nonatomic, strong)  LSEditItemList *lsSeason;
//标签
@property (nonatomic, strong)  LSEditItemText *txtTag;
//面料
@property (nonatomic, strong)  LSEditItemList *lsFabric;
//里料
@property (nonatomic, strong)  LSEditItemList *lsMaterial;
//商品产地
@property (nonatomic, strong)  LSEditItemText *txtOrigin;
//款式图片
@property (nonatomic, strong)  EditItemImage *imgStyle;

//销售设置
@property (nonatomic, strong)  LSEditItemTitle *TitSaleSetting;
//销售提成比例
@property (nonatomic, strong)  LSEditItemList *lsSaleRoyaltyRatio;
//参与积分
@property (nonatomic, strong)  LSEditItemRadio *rdoIsJoinPoint;
//参与任何优惠活动
@property (nonatomic, strong)  LSEditItemRadio *rdoIsJoinActivity;
//微店设置
@property (nonatomic, strong)  LSEditItemTitle *TitMicroSetting;
//微店信息介绍
@property (nonatomic, strong)  LSEditItemList *lsMicroInfo;
@property (nonatomic, strong)  UIView *btnDel;

@property (nonatomic, strong) UIImage *goodsImage;

@property (nonatomic, strong) NSString* imgFilePathTemp;
@property (nonatomic, strong) NSMutableArray* goodsList;

-(void) loaddatasFromSelect:(int) viewTag;
-(void) loaddatasFromAttributeAddView;
@end
