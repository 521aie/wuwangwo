//
//  GoodsAttributeCategoryManageEditView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/8/11.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GoodsAttributeCategoryManageEditView.h"
#import "AttributeGroupVo.h"
#import "UIHelper.h"
#import "XHAnimalUtil.h"
#import "LSEditItemText.h"
#import "AttributeGroupVo.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "JsonHelper.h"
#import "GoodsAttributeCategoryManageListView.h"


@interface GoodsAttributeCategoryManageEditView ()

@property (nonatomic, strong) GoodsService* goodsService;

@end

@implementation GoodsAttributeCategoryManageEditView

- (void)viewDidLoad {
    [super viewDidLoad];
    _goodsService = [ServiceFactory shareInstance].goodsService;
    [self configViews];
    [self initMainView];
    [self initNotifaction];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
    [self loaddatas];
}
- (void)configViews {
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    [self.view addSubview:self.scrollView];
    
    self.container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.ls_width, self.scrollView.ls_height)];
    [self.scrollView addSubview:self.container];
    
    self.txtCategoryName = [LSEditItemText editItemText];
    [self.container addSubview:self.txtCategoryName];
    
    UIButton *btn = [LSViewFactor addRedButton:self.container title:@"删除" y:0];
    self.btnDel = btn.superview;
    [btn addTarget:self action:@selector(btnDelClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void) loaddatas
{
    [self.btnDel setHidden:self.action == ACTION_CONSTANTS_ADD];
    if (self.action == ACTION_CONSTANTS_ADD) {
        NSString *title = @"";
        if ([self.attributeVo.name isEqualToString:@"颜色"]) {
            title = @"添加颜色分类";
        }else if ([self.attributeVo.name isEqualToString:@"尺码"]) {
            title = @"添加尺码分类";
        }
        [self configTitle:title leftPath:Head_ICON_CANCEL rightPath:Head_ICON_OK];
        [self clearDo];
    }else{
        [self configTitle:self.attributeGroupVo.attributeGroupName leftPath:Head_ICON_BACK rightPath:nil];
        [self fillModel];
    }
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

-(void) loaddatas:(AttributeGroupVo *)attributeGroupVoTemp attributeVo:(AttributeVo *)attributeVo action:(int)action callBack:(goodsAttributeCategoryManageEditBack) callBack
{
    self.goodsAttributeCategoryManageEditBack = callBack;
    self.action = action;
    self.attributeGroupVo = attributeGroupVoTemp;
    self.attributeVo = attributeVo;
}

-(void) clearDo
{
    [self.txtCategoryName initData:nil];
}

-(void) fillModel
{
    [self.txtCategoryName initData:self.attributeGroupVo.attributeGroupName];
}

-(void) initMainView
{
    [self.txtCategoryName initLabel:@"分类名称" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtCategoryName initMaxNum:20];
}

-(void) onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event == LSNavigationBarButtonDirectLeft) {
        self.goodsAttributeCategoryManageEditBack(nil, self.action);
    }else{
        [self save];
    }
}

-(void) save
{
    if (![self isValid]){
        return;
    }
    __weak GoodsAttributeCategoryManageEditView* weakSelf = self;
    if (self.action == ACTION_CONSTANTS_ADD) {
        self.attributeGroupVo = [[AttributeGroupVo alloc]init];
        self.attributeGroupVo.attributeNameId = self.attributeVo.attributeId;
        self.attributeGroupVo.attributeGroupName = [self.txtCategoryName getStrVal];
        self.attributeGroupVo.attributeType = self.attributeVo.attributeType.intValue;
        [_goodsService saveAttributeType:@"add" attributeGroupVo:self.attributeGroupVo completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            self.goodsAttributeCategoryManageEditBack(self.attributeGroupVo, ACTION_CONSTANTS_ADD);
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }else{
        self.attributeGroupVo.attributeGroupName = [self.txtCategoryName getStrVal];
        [_goodsService saveAttributeType:@"edit" attributeGroupVo:self.attributeGroupVo completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            self.goodsAttributeCategoryManageEditBack(self.attributeGroupVo, ACTION_CONSTANTS_EDIT);
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }  
}

#pragma save-data
-(BOOL)isValid
{
    if ([NSString isBlank:[self.txtCategoryName getStrVal]]) {
        [AlertBox show:@"分类名称不能为空，请输入!"];
        return NO;
    }
    
    if ([[self.txtCategoryName getStrVal] isEqualToString:@"未分类"]) {
        [AlertBox show:@"分类名称不能为“未分类”，请重新输入!"];
        return NO;
    }
    
    return YES;
}

-(IBAction)btnDelClick:(id)sender
{
    if (self.action == ACTION_CONSTANTS_EDIT) {
        [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:@"确认要删除[%@]吗？",self.attributeGroupVo.attributeGroupName]];
    }
}

//删除确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        if (self.action == ACTION_CONSTANTS_EDIT) {
            [self delFinish];
        }
        
        //[service removeKindPay:self.kindPay._id event:REMOTE_KINDPAY_DELONE];
    }
}

- (void)delFinish
{
    __weak GoodsAttributeCategoryManageEditView* weakSelf = self;
    [_goodsService delAttributeType:self.attributeGroupVo.attributeGroupId lastVer:[NSString stringWithFormat:@"%d", self.attributeGroupVo.lastVer] completionHandler:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        self.goodsAttributeCategoryManageEditBack(self.attributeGroupVo, ACTION_CONSTANTS_DEL);
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

#pragma notification 处理.
-(void) initNotifaction
{
    [UIHelper initNotification:self.container event:Notification_UI_GoodsAttributeCategoryManageEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_GoodsAttributeCategoryManageEditView_Change object:nil];
}

#pragma 做好界面变动的支持.
-(void) dataChange:(NSNotification*) notification
{
    if (self.action == ACTION_CONSTANTS_ADD) {
        [self editTitle:[UIHelper currChange:self.container] act:self.action];
    }else{
        [self editTitle:[UIHelper currChange:self.container] act:self.action];
    }
    
}

@end
