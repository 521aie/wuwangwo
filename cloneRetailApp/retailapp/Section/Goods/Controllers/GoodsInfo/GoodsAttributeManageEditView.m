//
//  GoodsAttributeManageEditView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/10/21.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GoodsAttributeManageEditView.h"
#import "GoodsModuleEvent.h"
#import "ServiceFactory.h"
#import "JsonHelper.h"
#import "AlertBox.h"
#import "UIHelper.h"
#import "XHAnimalUtil.h"
#import "LSEditItemText.h"
#import "AttributeValVo.h"
#import "GoodsAttributeManageListView.h"
#import "GoodsBrandVo.h"

@interface GoodsAttributeManageEditView ()

@property (nonatomic, strong) GoodsService *goodsService;

@property (nonatomic) int fromViewTag;

@property (nonatomic, strong) NSString *baseAttributeType;

@property (nonatomic, strong) AttributeValVo *attributeValVo;

@property (nonatomic, strong) GoodsBrandVo *goodsBrandVo;

@end

@implementation GoodsAttributeManageEditView


- (void)viewDidLoad {
    [super viewDidLoad];
     _goodsService = [ServiceFactory shareInstance].goodsService; _goodsService = [ServiceFactory shareInstance].goodsService;
    [self initHead];
    [self initMainView];
    [self initNotifaction];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
    [self loaddatas];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) loaddatas
{
    [self clearDo];
    if (_fromViewTag == GOODS_STYLE_EDIT_BRAND || _fromViewTag == GOODS_EDIT_BRAND) {
        self.txtName.lblName.text = @"品牌";
    } else if (_fromViewTag == GOODS_STYLE_EDIT_SERIES){
        self.txtName.lblName.text = @"系列";
        _baseAttributeType = @"1";
    } else if (_fromViewTag == GOODS_STYLE_EDIT_SEASON){
        self.txtName.lblName.text = @"季节";
        _baseAttributeType = @"2";
    } else if (_fromViewTag == GOODS_STYLE_EDIT_FABRIC || _fromViewTag == GOODS_STYLE_EDIT_MATERIAL){
        self.txtName.lblName.text = @"材质";
        _baseAttributeType = @"3";
    } else if (_fromViewTag == GOODS_STYLE_EDIT_MAINMODEL) {
        self.txtName.lblName.text = @"主型";
        _baseAttributeType = @"5";
    } else if (_fromViewTag == GOODS_STYLE_EDIT_AUXILIARYMODEL) {
        self.txtName.lblName.text = @"辅型";
        _baseAttributeType = @"6";
    }
}

-(void) loaddatas:(int)fromViewTag callBack:(goodsAttributeManageEditBack)callBack
{
    self.goodsAttributeManageEditBack = callBack;
    self.action = ACTION_CONSTANTS_ADD;
    _fromViewTag = fromViewTag;
}

-(void) clearDo
{
    [self.txtName initData:nil];
}

-(void) initMainView
{
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    [self.view addSubview:self.scrollView];
    
    self.container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.ls_width, self.scrollView.ls_height)];
    [self.scrollView addSubview:self.container];
    
    
    self.txtName = [LSEditItemText editItemText];
    [self.container addSubview:self.txtName];

    [self.txtName initLabel:@"系列" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtName initMaxNum:50];
}

#pragma notification 处理.
-(void) initNotifaction
{
    [UIHelper initNotification:self.container event:Notification_UI_GoodsAttributeManageEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_GoodsAttributeManageEditView_Change object:nil];
}

#pragma 做好界面变动的支持.
-(void) dataChange:(NSNotification*) notification
{
    [self editTitle:[UIHelper currChange:self.container] act:self.action];
}

-(void) initHead
{
    [self configTitle:@"添加" leftPath:Head_ICON_BACK rightPath:Head_ICON_OK];
    NSString *title = @"";
    if (_fromViewTag == GOODS_STYLE_EDIT_BRAND || _fromViewTag == GOODS_EDIT_BRAND) {
        title = @"添加品牌";
    } else if (_fromViewTag == GOODS_STYLE_EDIT_SERIES){
        title = @"添加系列";
    } else if (_fromViewTag == GOODS_STYLE_EDIT_SEASON){
        title = @"添加季节";
    } else if (_fromViewTag == GOODS_STYLE_EDIT_FABRIC || _fromViewTag == GOODS_STYLE_EDIT_MATERIAL){
        title = @"添加材质";
    } else if (_fromViewTag == GOODS_STYLE_EDIT_MAINMODEL) {
        title = @"添加主型";
    } else if (_fromViewTag == GOODS_STYLE_EDIT_AUXILIARYMODEL) {
        title = @"添加辅型";
    }
    [self configTitle:title];
}

-(void) onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event==LSNavigationBarButtonDirectLeft) {
        self.goodsAttributeManageEditBack(NO);
    }else{
        [self save];
    }
}

-(void) save
{
    if (![self isValid]) {
        return ;
    }
    __weak GoodsAttributeManageEditView* weakSelf = self;
    if (_fromViewTag == GOODS_STYLE_EDIT_BRAND || _fromViewTag == GOODS_EDIT_BRAND) {
        _goodsBrandVo = [[GoodsBrandVo alloc] init];
        _goodsBrandVo.name = [self.txtName getStrVal];
        [_goodsService saveBrand:@"add" goodsBrand:[GoodsBrandVo getDictionaryData:_goodsBrandVo] completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            self.goodsAttributeManageEditBack(YES);
//            [_parent showView:GOODS_ATTRIBUTE_MANAGE_LIST_VIEW];
//            [_parent.goodsAttributeManageListView loadDatasFromEditView];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }else{
        _attributeValVo = [[AttributeValVo alloc] init];
        _attributeValVo.attributeVal = [self.txtName getStrVal];
        _attributeValVo.attributeType = 1;
        [_goodsService saveAttributeVal:@"add" baseAttributeType:_baseAttributeType collectionType:@"2" attributeVal:_attributeValVo completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            self.goodsAttributeManageEditBack(YES);
//            [_parent showView:GOODS_ATTRIBUTE_MANAGE_LIST_VIEW];
//            [_parent.goodsAttributeManageListView loadDatasFromEditView];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }
    
}

-(BOOL) isValid
{
    if ([NSString isBlank:[self.txtName getStrVal]]) {
        if (_fromViewTag == GOODS_STYLE_EDIT_BRAND || _fromViewTag == GOODS_EDIT_BRAND) {
            [AlertBox show:@"品牌不能为空，请输入!"];
        } else if (_fromViewTag == GOODS_STYLE_EDIT_SERIES){
            [AlertBox show:@"系列不能为空，请输入!"];
        } else if (_fromViewTag == GOODS_STYLE_EDIT_SEASON){
            [AlertBox show:@"季节不能为空，请输入!"];
        } else if (_fromViewTag == GOODS_STYLE_EDIT_FABRIC || _fromViewTag == GOODS_STYLE_EDIT_MATERIAL){
            [AlertBox show:@"材质不能为空，请输入!"];
        } else if (_fromViewTag == GOODS_STYLE_EDIT_MAINMODEL){
            [AlertBox show:@"主型不能为空，请输入!"];
        } else if (_fromViewTag == GOODS_STYLE_EDIT_AUXILIARYMODEL){
            [AlertBox show:@"辅型不能为空，请输入!"];
        }
        return NO;
    }
    return YES;
}

@end
