//
//  SellReturnAddressView.h
//  retailapp
//
//  Created by Jianyong Duan on 15/11/26.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditItemList.h"
#import "EditItemText.h"
#import "NavigateTitle2.h"
#import "ShopReturnInfoVo.h"

typedef void(^SellReturnAddressBack)(ShopReturnInfoVo *info);

@interface SellReturnAddressView : BaseViewController
//input
@property (nonatomic, copy) NSString *shopId;
@property (nonatomic, strong) SellReturnAddressBack sellReturnAddressBack;

@property (nonatomic) NavigateTitle2 *titleBox;
@property (weak, nonatomic) IBOutlet UIView *titleDiv;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) IBOutlet UIView *container;
@property (nonatomic, strong) NSArray *addressList;
//联系人
@property (weak, nonatomic) IBOutlet EditItemText *txtLinkman;

//联系电话
@property (weak, nonatomic) IBOutlet EditItemText *txtPhone;

//所在地区
@property (weak, nonatomic) IBOutlet EditItemList *lstArea;

//详细地址
@property (weak, nonatomic) IBOutlet EditItemText *txtAddress;

//邮编
@property (weak, nonatomic) IBOutlet EditItemText *txtZipcode;

@end
