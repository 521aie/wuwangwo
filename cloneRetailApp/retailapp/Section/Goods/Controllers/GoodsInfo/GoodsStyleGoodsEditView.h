//
//  GoodsStyleGoodsEditView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/8/5.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
#import "IEditItemListEvent.h"
#import "SymbolNumberInputBox.h"

@class StyleGoodsVo;
@class LSEditItemText, LSEditItemList, EditItemText2;
typedef void(^styleGoodsEditBack) (StyleGoodsVo* item, int action, NSString* lastVer);
@interface GoodsStyleGoodsEditView : LSRootViewController< IEditItemListEvent, SymbolNumberInputClient, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *container;


//颜色
@property (nonatomic, strong) LSEditItemText *txtColour;

//尺码
@property (nonatomic, strong) LSEditItemText *txtSize;

//地区
//@property (nonatomic, strong) EditItemText *txtRegion;

//店内码
@property (nonatomic, strong) LSEditItemText *txtInnerCode;

//条形码
@property (nonatomic, strong) EditItemText2 *txtBarCode;

//skc码
@property (nonatomic, strong) LSEditItemText *txtSkcCode;

//进货价
@property (nonatomic, strong) LSEditItemList *lsPurPrice;

//吊牌价
@property (nonatomic, strong) LSEditItemText *txtHangTagPrice;

//零售价
@property (nonatomic, strong) LSEditItemList *lsRetailPrice;

//会员价
@property (nonatomic, strong) LSEditItemList *lsMemberPrice;

//批发价
@property (nonatomic, strong) LSEditItemList *lsWhoPrice;

@property (nonatomic, strong) UIView *btnDel;

@property (nonatomic, copy) styleGoodsEditBack styleGoodsEditBack;

-(void) loaddatas:(StyleGoodsVo*) styleGoodsVo styleId:(NSString*) styleId lastVer:(NSString*) lastVer synShopId:(NSString*) synShopId action:(int) action callBack:(styleGoodsEditBack) callBack;

@end
