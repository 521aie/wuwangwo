//
//  NavigateTitle2.m
//  retailapp
//
//  Created by hm on 15/6/26.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "NavigateTitle2.h"
#import "SystemUtil.h"
#import "NSString+Estimate.h"

@interface NavigateTitle2 ()

@end

@implementation NavigateTitle2

+ (NavigateTitle2 *)navigateTitle:(id<INavigateEvent>)host{
    
    NavigateTitle2 *navigateTitle2 = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil][0];
    navigateTitle2.ls_width = SCREEN_W;
    navigateTitle2.delegate = host;
//    navigateTitle2.isResign = NO;
    return navigateTitle2;
}
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil delegate:(id<INavigateEvent>)host
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        self.delegate=host;
//        self.isResign = YES;
//    }
//    return self;
//}

//更多.
- (IBAction)btnMoreClick:(id)sender{
    [SystemUtil hideKeyboard];
    if ([self.delegate respondsToSelector:@selector(onNavigateEvent:)]) {
        [self.delegate onNavigateEvent:DIRECT_RIGHT];
    }
}

//返回.
- (IBAction)btnBackClick:(id)sender{
    [SystemUtil hideKeyboard];
//    if (self.isResign) {
//        
//    }
    if ([self.delegate respondsToSelector:@selector(onNavigateEvent:)]) {
        [self.delegate onNavigateEvent:DIRECT_LEFT];
    }
}

- (void)initWithName:(NSString *)title backImg:(NSString *)backImgPath moreImg:(NSString *)moreImgPath{
    
    self.lblTitle.text = title;
    
    self.btnBack.hidden = (backImgPath == nil);
    self.btnUser.hidden = (moreImgPath == nil);
    self.imgBack.hidden = (backImgPath == nil);
    self.imgMore.hidden = (moreImgPath == nil);
    self.lblLeft.hidden = (backImgPath == nil);
    self.lblRight.hidden = (moreImgPath == nil);
    if(backImgPath != nil){
        UIImage *backPicture=[UIImage imageNamed:backImgPath];
        self.imgBack.image=backPicture;
        if ([Head_ICON_CANCEL isEqualToString:backImgPath]) {
            self.lblLeft.text=@"取消";
        }else if([Head_ICON_BACK isEqualToString:backImgPath]){
            self.lblLeft.text=@"返回";
        }
    }
    
    if(moreImgPath != nil){
        UIImage *morePicture=[UIImage imageNamed:moreImgPath];
        self.imgMore.image=morePicture;
        if ([Head_ICON_OK isEqualToString:moreImgPath]) {
            self.lblRight.text=@"保存";
        }else if ([Head_ICON_CONFIRM isEqualToString:moreImgPath]){
            self.lblRight.text = @"确认";
        }else if([Head_ICON_MORE isEqualToString:moreImgPath]){
            self.lblRight.text=@"更多";
        }else if ([Head_ICON_CHOOSE isEqualToString:moreImgPath]){
            self.lblRight.text = @"筛选";
        }else if ([Head_ICON_CATE isEqualToString:moreImgPath]){
            self.lblRight.text = @"分类";
        } else {
            self.lblRight.text = moreImgPath;
        }
    }
}

- (void)btnVisibal:(BOOL)show direct:(Direct_Flag)flag{
    if (flag==DIRECT_LEFT) {
        self.btnBack.hidden = !show;
    }else{
        self.btnUser.hidden = !show;
    }
    [self navVisibal:show direct:flag];
}

- (void)navVisibal:(BOOL)show direct:(Direct_Flag)flag
{
    if (flag==DIRECT_LEFT) {
        self.imgBack.hidden = !show;
        self.lblLeft.hidden = !show;
    }else{
        self.imgMore.hidden = !show;
        self.lblRight.hidden = !show;
    }
}

-(void)loadImg:(NSString *)img direct:(Direct_Flag)flag
{
    if([NSString isNotBlank:img]){
        UIImage *pic=[UIImage imageNamed:img];
        if(flag==DIRECT_LEFT){
            self.imgBack.image=pic;
            if ([Head_ICON_CANCEL isEqualToString:img]) {
                self.lblLeft.text=@"取消";
            }else if([Head_ICON_BACK isEqualToString:img]){
                self.lblLeft.text=@"返回";
            }
            
        }else{
            self.imgMore.image=pic;
            if ([Head_ICON_OK isEqualToString:img]) {
                self.lblRight.text=@"保存";
            }else if([Head_ICON_MORE isEqualToString:img]){
                self.lblRight.text=@"更多";
            }
        }
    }
}

-(void)editTitle:(BOOL)change act:(NSInteger)action
{
    if (action==ACTION_CONSTANTS_ADD) {
        
        NSString* imgLeft=Head_ICON_CANCEL;
        self.lblLeft.text=@"取消";
        UIImage *pic=[UIImage imageNamed:imgLeft];
        self.imgBack.image=pic;
        [self btnVisibal:YES direct:DIRECT_LEFT];
        
        UIImage *more=[UIImage imageNamed:Head_ICON_OK];
        self.imgMore.image=more;
        self.lblRight.text=@"保存";
        
        [self btnVisibal:YES direct:DIRECT_RIGHT];
        return;
    }else{
        NSString* imgLeft=change?Head_ICON_CANCEL:Head_ICON_BACK;
        self.lblLeft.text=change?@"取消":@"返回";
        UIImage *pic=[UIImage imageNamed:imgLeft];
        self.imgBack.image=pic;
        [self btnVisibal:YES direct:DIRECT_LEFT];
        
        UIImage *more=[UIImage imageNamed:Head_ICON_OK];
        self.imgMore.image=more;
        self.lblRight.text=@"保存";
        
        [self btnVisibal:change direct:DIRECT_RIGHT];
    }
}




@end
