//
//  WechatStylePictureView.h
//  retailapp
//
//  Created by zhangzt on 15/10/26.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IEditItemImageEvent.h"
#import "NavigateTitle2.h"
#import "FooterListEvent.h"
#import "MHImagePickerMutilSelector.h"
@class WechatModule,  FooterListView, Wechat_MicroStyleVo;
@class EditImageBox1,EditItemImage3;

@interface WechatStylePictureView : BaseViewController<FooterListEvent, INavigateEvent, IEditItemImageEvent, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate,MHImagePickerMutilSelectorDelegate>{
    WechatModule *parent;
    
    UIImage *goodsImage;
    
    UIImagePickerController *imagePickerController;
}
@property (nonatomic, strong) NavigateTitle2 *titleBox;
@property (weak, nonatomic) IBOutlet UIView *titleDiv;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet FooterListView *footView;
@property (weak, nonatomic) IBOutlet EditImageBox1 *boxPicture;

@property (nonatomic, strong) NSString* imgFilePathTemp;

@property (nonatomic) int action;

@property (nonatomic, strong) NSString* shopId;

@property (nonatomic, strong) NSString* styleId;

@property (nonatomic, strong) Wechat_MicroStyleVo* microStyleVo;
@end
