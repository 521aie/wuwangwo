//
//  SalePackStyleImageView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/11/5.
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
#import "TZImagePickerController.h"

@class EditItemText, EditItemList, ItemTitle, EditImageBox, EditItemMemo;
@interface SalePackStyleImageView : BaseViewController<INavigateEvent, IEditItemListEvent, IEditItemImageEvent, TZImagePickerControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>

@property (nonatomic, retain) IBOutlet UIView *titleDiv;
@property (nonatomic, strong) NavigateTitle2 *titleBox;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *container;

//基本信息
@property (nonatomic, strong) IBOutlet ItemTitle *TitBaseInfo;
//款式名称
@property (nonatomic, strong) IBOutlet EditItemMemo *txtStyleName;
//款号
@property (nonatomic, strong) IBOutlet EditItemText *txtStyleNo;
//品牌
@property (nonatomic, strong) IBOutlet EditItemText *txtBrand;
//吊牌价
@property (nonatomic, strong) IBOutlet EditItemText *txtHangTagPrice;
//零售价
@property (nonatomic, strong) IBOutlet EditItemText *txtRetailPrice;

//扩展信息
@property (nonatomic, strong) IBOutlet ItemTitle *TitExtendInfo;
//款式图片
@property (nonatomic, strong) IBOutlet EditImageBox *boxPicture;

//颜色图片
@property (nonatomic, strong) IBOutlet ItemTitle *TitColorPic;
//设置每个颜色的图片
@property (nonatomic, strong) IBOutlet EditItemList *lsColorPic;

//图文详情
@property (nonatomic, strong) IBOutlet ItemTitle *TitDetails;
//图文详情
@property (nonatomic, strong) IBOutlet EditItemList *lsDetails;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil styleId:(NSString*) styleId;

@end
