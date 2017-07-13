//
//  ReturnTypeEditView.h
//  retailapp
//
//  Created by hm on 16/2/16.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
#import "INameValue.h"

typedef void(^EditReturnTypeBlock)(id<INameValue> item, NSInteger action);

@class LSEditItemText,LSEditItemRadio;
@interface ReturnTypeEditView :LSRootViewController
/** <#注释#> */
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) LSEditItemText *txtName;
@property (nonatomic, strong) LSEditItemRadio *rdoReturnCount;
@property (nonatomic, strong) UIButton *delBtn;
- (void)loadDataWithId:(NSString *)returnTypeId withName:(NSString *)name withAction:(NSInteger)action callBack:(EditReturnTypeBlock) callBack;

@end
