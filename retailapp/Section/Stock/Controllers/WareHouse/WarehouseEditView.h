//
//  WarehouseEditView.h
//  retailapp
//
//  Created by hm on 15/9/9.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
#import "INameCode.h"
typedef void(^EditWarehouseHandler)(id<INameCode> item, NSInteger operateType);

@class LSEditItemList,LSEditItemText;
@interface WarehouseEditView : LSRootViewController<UIActionSheetDelegate>

@property (nonatomic,strong) UIScrollView* scrollView;
@property (nonatomic,strong) UIView* container;
@property (nonatomic,strong) LSEditItemText* txtName;
@property (nonatomic,strong) LSEditItemText* txtCode;
@property (nonatomic,strong) LSEditItemList* lsOrg;
@property (nonatomic,strong) LSEditItemList* lsDistrict;
@property (nonatomic,strong) LSEditItemText* txtAddress;
@property (nonatomic,strong) LSEditItemText* txtLinkMan;
@property (nonatomic,strong) LSEditItemText* txtMobile;
@property (nonatomic,strong) LSEditItemText* txtTel;
@property (nonatomic,strong) UIView* delView;
//设置页面参数及回调block
- (void)showDetail:(NSString*)warehouseId action:(NSInteger)action callBack:(EditWarehouseHandler)handler;

@end
