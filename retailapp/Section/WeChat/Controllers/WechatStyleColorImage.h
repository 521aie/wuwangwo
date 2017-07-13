//
//  WechatStyleColorImage.h
//  retailapp
//
//  Created by zhangzt on 15/10/28.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IEditItemImageEvent.h"
#import "NavigateTitle2.h"
#import "FooterListEvent.h"
#import "MHImagePickerMutilSelector.h"
@class WechatModule,  FooterListView, Wechat_MicroStyleVo;
@class EditItemImage3;

@interface WechatStyleColorImage : BaseViewController<FooterListEvent, INavigateEvent, IEditItemImageEvent, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate,MHImagePickerMutilSelectorDelegate>
{
    WechatModule *parent;
    
    UIImage *goodsImage;
    
    UIImagePickerController *imagePickerController;
}
@property (nonatomic, strong) NavigateTitle2 *titleBox;
@property (weak, nonatomic) IBOutlet UIView *titleDiv;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet FooterListView *footView;
//@property (weak, nonatomic) IBOutlet EditItemImage3 *redImage;
//@property (weak, nonatomic) IBOutlet EditItemImage3 *whiteImage;
//@property (weak, nonatomic) IBOutlet EditItemImage3 *blueImage;
//@property (weak, nonatomic) IBOutlet EditItemImage3 *blackImage;

@property (nonatomic, strong) NSString* imgFilePathTemp;

@property (nonatomic) int action;

@property (nonatomic, strong) NSString* shopId;

@property (nonatomic, strong) NSString* styleId;

@property (nonatomic, strong) Wechat_MicroStyleVo* microStyleVo;


//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(WechatModule *)_parent;

//-(void) loaddatas:(NSString *)shopId Vo:(Wechat_MicroStyleVo*) microStyleVoTemp action:(int)action;

@end
