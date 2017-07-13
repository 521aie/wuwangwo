//
//  GoodsCategoryEditView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/7/27.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GoodsCategoryEditView.h"
#import "OptionPickerClient.h"
#import "IEditItemListEvent.h"
#import "IEditItemRadioEvent.h"
#import "OptionPickerClient.h"
#import "GoodsModuleEvent.h"
#import "UIHelper.h"
#import "CategoryVo.h"
#import "LSEditItemText.h"
#import "LSEditItemList.h"
#import "LSEditItemRadio.h"
#import "XHAnimalUtil.h"
#import "OptionPickerBox.h"
#import "GoodsRender.h"
#import "INameItem.h"
#import "AlertBox.h"
#import "JsonHelper.h"
#import "ServiceFactory.h"
#import "GoodsCategoryListView.h"
#import "GoodsStyleEditView.h"
#import "LSGoodsEditView.h"
#import "LSEditItemList.h"
#import "EditItemList.h"

#define categoryName0 @"分类"
#define categoryName1 @"品类"

@interface GoodsCategoryEditView ()< OptionPickerClient,IEditItemRadioEvent, IEditItemListEvent>
@property (nonatomic,strong) GoodsService* goodsService;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *container;

//商品分类名称
@property (nonatomic, strong) LSEditItemText *txtCategoryName;
//微店分类别名
@property (nonatomic, strong) LSEditItemText *txtMicroName;
//商品分类编码
@property (nonatomic, strong) LSEditItemText *txtCode;
//此分类有上级
@property (nonatomic, strong) LSEditItemRadio *rdoIshasParent;
//上级分类
@property (nonatomic, strong) LSEditItemList *lsParentName;
@property (nonatomic, strong) UIButton *btnDel;

/**
 flg为YES时，点击了保存，且报错，点击返回刷新列表
 */
@property (nonatomic) BOOL flg;
@property (nonatomic, copy) NSString *categoryName;
@end

@implementation GoodsCategoryEditView

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[Platform Instance] getkey:SHOP_MODE].integerValue == 101) {
        _categoryName = categoryName1;
    } else {
        _categoryName = categoryName0;
    }
    
    [self configDatas];
    [self configSubViews];
    [self initNotifaction];
    [self initHead];
    [self initMainView];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
    
    [self loaddatas];
    [self configHelpButton:HELP_GOODS_CATEGORY_DETAIL];
}

- (void)configDatas {
    self.goodsService = [ServiceFactory shareInstance].goodsService;
}

- (void)configSubViews {
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    [self.view addSubview:self.scrollView];

    self.container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.ls_width, self.scrollView.ls_height)];
    [self.scrollView addSubview:self.container];
    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.scrollView);
        make.width.height.equalTo(self.scrollView);
    }];
    
    self.txtCategoryName = [LSEditItemText editItemText];
    [self.container addSubview:self.txtCategoryName];
    
    self.txtMicroName = [LSEditItemText editItemText];
    [self.container addSubview:self.txtMicroName];
    
    self.txtCode = [LSEditItemText editItemText];
    [self.container addSubview:self.txtCode];
    
    self.rdoIshasParent = [LSEditItemRadio editItemRadio];
    [self.container addSubview:self.rdoIshasParent];
    
    self.lsParentName = [LSEditItemList editItemList];
    [self.container addSubview:self.lsParentName];
    
    self.btnDel = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnDel setBackgroundImage:[UIImage imageNamed:@"btn_full_r"] forState:UIControlStateNormal];
    [self.btnDel setTitle:@"删除" forState:UIControlStateNormal];
    [self.btnDel addTarget:self action:@selector(btnDelClick) forControlEvents:UIControlEventTouchUpInside];
    [self.container addSubview:self.btnDel];
    [self.btnDel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lsParentName.bottom).offset(10);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.equalTo(44);
    }];
//    __weak typeof(self) wself = self;
}

-(void) loaddatas
{
    _flg = NO;
    [self.scrollView setContentOffset:CGPointMake(0, 0)animated:YES];
    [self.btnDel setHidden:_action == ACTION_CONSTANTS_ADD];
    if (_action == ACTION_CONSTANTS_ADD) {
        if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {
            //服鞋
            [self configTitle:@"添加商品品类"];
        } else {
            //商超
             [self configTitle:@"添加商品分类"];
        }
        [self clearDo];
    }else{
        [self configTitle:self.categoryVo.name];
        if ([[Platform Instance] getkey:SHOP_MODE].integerValue == 101) {
            if (self.categoryVo.step == 2 || (self.categoryVo.categoryVoList == nil || self.categoryVo.categoryVoList.count == 0)) {
                [self.btnDel setHidden:NO];
            } else {
                [self.btnDel setHidden:YES];
            }

        } else {
            if (self.categoryVo.step == 4 || (self.categoryVo.categoryVoList == nil || self.categoryVo.categoryVoList.count == 0)) {
                [self.btnDel setHidden:NO];
            } else {
                [self.btnDel setHidden:YES];
            }

        }
        [self fillModel];
    }
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

-(void) loaddatas:(goodsCategoryEditBack)callBack
{
    self.goodsCategoryEditBack = callBack;
}

-(void) clearDo
{
    [self.txtCategoryName initData:nil];
    
    [self.txtMicroName initData:nil];
    
    [self.txtCode initData:nil];
    
    [self.rdoIshasParent initData:@"0"];
    [self.lsParentName initData:@"请选择" withVal:@""];
    [self.rdoIshasParent editable:YES];
    
    [self.lsParentName visibal:NO];
    [self.lsParentName editEnable:YES];
    
}

-(void) fillModel
{
    [self.txtCategoryName initData:self.categoryVo.name];
    
    [self.txtMicroName initData:self.categoryVo.microname];
    
    [self.txtCode initData:self.categoryVo.code];
    if (self.categoryVo.parentName != nil && ![self.categoryVo.parentName isEqualToString:@""]) {
        [self.rdoIshasParent initData:@"1"];
    }else{
        [self.rdoIshasParent initData:@"0"];
    }
    [self.rdoIshasParent editable:NO];
    
    if ([[self.rdoIshasParent getStrVal] isEqualToString:@"0"]) {
        [self.lsParentName visibal:NO];
    }else{
        [self.lsParentName visibal:YES];
        [self.lsParentName initData:self.categoryVo.parentName withVal:self.categoryVo.parentId];
        [self.lsParentName editEnable:NO];
    }
}

-(void) initMainView
{
    [self.txtCategoryName initLabel:[NSString stringWithFormat:@"商品%@", _categoryName] withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    
    [self.txtMicroName initLabel:[NSString stringWithFormat:@"微店%@别名", _categoryName] withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    
    if ([[Platform Instance] getShopMode] == 3 || [[Platform Instance] getMicroShopStatus] == 2) {
        [self.txtMicroName visibal:YES];
    } else {
        [self.txtMicroName visibal:NO];
    }
    
    [self.lsParentName initLabel:[NSString stringWithFormat:@"上级%@", _categoryName] withHit:nil delegate:self];
    
    if ([[Platform Instance] getkey:SHOP_MODE].integerValue == 101) {
        
        [self.txtCode initLabel:@"品类编号" withHit:nil isrequest:NO type:UIKeyboardTypeAlphabet];
        
        [self.rdoIshasParent initLabel:@"此品类有上级" withHit:nil delegate:self];
    } else {
        
        [self.txtCode initLabel:@"分类编码" withHit:nil isrequest:NO type:UIKeyboardTypeAlphabet];

        [self.rdoIshasParent initLabel:@"此分类有上级" withHit:nil delegate:self];
    }
    
    [self.txtCategoryName initMaxNum:50];
    
    [self.txtMicroName initMaxNum:50];
    
    [self.txtCode initMaxNum:8];
    
    self.rdoIshasParent.tag = GOODS_CATEGORY_EDIT_ISHASPARENT;
    
    self.lsParentName.tag = GOODS_CATEGORY_EDIT_PARENTNAME;
}

-(void) initHead
{
    [self configTitle:@"" leftPath:Head_ICON_BACK rightPath:Head_ICON_OK];
}

-(void) onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event== LSNavigationBarButtonDirectLeft) {
        if (_fromViewTag == GOODS_STYLE_EDIT_CATEGORY || self.fromViewTag == GOODS_EDIT_CATEGORY) {
            if (_flg) {
                self.goodsCategoryEditBack(nil, ACTION_CONSTANTS_ADD, YES);
            } else {
                self.goodsCategoryEditBack(nil, 0, NO);
            }
        } else {
            if (self.action == ACTION_CONSTANTS_EDIT) {
                if (_flg) {
                    for (UIViewController *vc in self.navigationController.viewControllers) {
                        if ([vc isKindOfClass:[GoodsCategoryListView class]]) {
                            GoodsCategoryListView *listView = (GoodsCategoryListView *)vc;
                            [listView loadDataFromEditViewOfReturn];
                        }
                    }
                }
                [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
                
            } else {
                [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
            }
            
            [self.navigationController popViewControllerAnimated:NO];
        }
    }else{
        [self save];
    }
}

#pragma mark 保存
-(void) save
{
    if (![self isValid]){
        return;
    }
    
    CategoryVo* vo = [[CategoryVo alloc] init];
    
    if (self.action==ACTION_CONSTANTS_EDIT) {
        vo = self.categoryVo;
    }
    
    vo.name = self.txtCategoryName.txtVal.text;
    if ([[Platform Instance] getMicroShopStatus] == 2) {//微店未开通时添加或修改分类名称与微店分类别名保持一致
         vo.microname = self.txtMicroName.txtVal.text;
    } else {
        vo.microname = vo.name;
    }
   
    vo.code = self.txtCode.txtVal.text;
    if ([[self.rdoIshasParent getStrVal] isEqualToString:@"1"]) {
        vo.parentId = [self.lsParentName getStrVal];
    }else{
        vo.parentId = @"";
    }
    
    NSString* operateType = self.action==ACTION_CONSTANTS_ADD?@"add":@"edit";
    
//    NSString *categoryVo = [JsonHelper transJson:vo];
    
    __weak GoodsCategoryEditView* weakSelf = self;
    [_goodsService saveCategory:vo operateType:operateType completionHandler:^(id json) {
        if (!(weakSelf)) {
            return;
        }
        if ([NSString isNotBlank:vo.parentId]) {
            for (CategoryVo* tempVo in self.parentCategoryList) {
                if ([vo.parentId isEqualToString:tempVo.categoryId] && [tempVo.hasGoods isEqualToString:@"1"]) {
                     [AlertBox show:[NSString stringWithFormat:@"上级%@中的商品转移到当前%@!", _categoryName, _categoryName]];
                }
            }
        }
        [weakSelf responseSuccess:json];
    } errorHandler:^(id json) {
        _flg = YES;
        [AlertBox show:json];
    }];
    
}

- (void)responseSuccess:(id)json
{
    if (self.fromViewTag == GOODS_STYLE_EDIT_CATEGORY || self.fromViewTag == GOODS_EDIT_CATEGORY) {
        if (self.action == ACTION_CONSTANTS_EDIT) {
            self.goodsCategoryEditBack(self.categoryVo, self.action, YES);
        }else{
            self.goodsCategoryEditBack(nil, self.action, YES);
        }
    }else{
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[GoodsCategoryListView class]]) {
                GoodsCategoryListView *listView = (GoodsCategoryListView *)vc;
                if (self.action == ACTION_CONSTANTS_EDIT) {
                    [listView loadData:ACTION_CONSTANTS_EDIT goodsCategory:self.categoryVo];
                }else{
                    [listView loadData:ACTION_CONSTANTS_ADD goodsCategory:nil];
                }
            }
        }
        
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

#pragma save-data
-(BOOL)isValid
{
    if ([NSString isBlank:[self.txtCategoryName getStrVal]]) {
        [AlertBox show:[NSString stringWithFormat:@"商品%@不能为空，请输入!", _categoryName]];
        return NO;
    }
    NSString *categoryName = [self.txtCategoryName getStrVal];
    categoryName = [categoryName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([categoryName isEqualToString:@"未分类"]) {
        if ([[Platform Instance] getkey:SHOP_MODE].integerValue == 101) {
            [AlertBox show:@"商品品类不能为“未分类”，请重新输入!"];
            return NO;
        } else {
            [AlertBox show:@"商品分类名称不能为“未分类”，请重新输入!"];
            return NO;
        };
    }
    
    if ([NSString isNotBlank:[self.txtCode getStrVal]] && [NSString isNotNumAndLetter:[self.txtCode getStrVal]]) {
        if ([[Platform Instance] getkey:SHOP_MODE].integerValue == 101) {
            [AlertBox show:@"品类编号只能为英数字，请重新输入!"];
            return NO;
        } else {
            [AlertBox show:@"分类编码只能为英数字，请重新输入!"];
            return NO;
        }
    }
    
    if ([[self.rdoIshasParent getStrVal] isEqualToString:@"1"]) {
        if ([[self.lsParentName getStrVal] isEqualToString:@""]) {
            [AlertBox show:[NSString stringWithFormat:@"请选择上级%@!", _categoryName]];
            return NO;
        }
        
    }
    
    return YES;
}

-(void)btnDelClick
{
    for (UIView *view in self.container.subviews) {
        if ([view isKindOfClass:[LSEditItemText class]]) {
            LSEditItemText *text = (LSEditItemText *)view;
            [text.txtVal resignFirstResponder];
        }
    }
    if ([self.categoryVo.hasGoods isEqualToString:@"1"]) {
        static UIAlertView *alertView;
        if (alertView != nil) {
            [alertView dismissWithClickedButtonIndex:0 animated:NO];
            alertView = nil;
        }
        if ([[Platform Instance] getkey:SHOP_MODE].integerValue == 101) {
            alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该品类已被商品使用，删除品类，将使部分商品丢失品类信息。确认要删除吗？" delegate:self cancelButtonTitle:@"取消"  otherButtonTitles:@"确认", nil];
        } else {
        alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该分类已被商品使用，删除分类，将使部分商品丢失分类信息。确认要删除吗？" delegate:self cancelButtonTitle:@"取消"  otherButtonTitles:@"确认", nil];
        }
        
        [alertView show];
    } else {
        [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:@"确认要删除[%@]吗？",self.categoryVo.name]];
    }
}

//删除确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        [self delFinish];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self delFinish];
    }
}

- (void)delFinish
{
    __weak GoodsCategoryEditView* weakSelf = self;
    [_goodsService delCategory:self.categoryVo.categoryId completionHandler:^(id json) {
        if (!(weakSelf)) {
            return;
        }
        
        if (self.fromViewTag == GOODS_STYLE_EDIT_CATEGORY || self.fromViewTag == GOODS_EDIT_CATEGORY) {
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[LSGoodsEditView class]]) {
                    LSGoodsEditView *goodsEditView = (LSGoodsEditView *)vc;
                    if ([[goodsEditView.lsCategory getDataLabel] isEqualToString:self.categoryVo.name]) {
                        [goodsEditView.lsCategory initData:@"请选择" withVal:nil];
                    }
                }
                
                if ([vc isKindOfClass:[GoodsStyleEditView class]]) {
                    GoodsStyleEditView *goodsEditView = (GoodsStyleEditView *)vc;
                    if ([[goodsEditView.lsCategory getDataLabel] isEqualToString:self.categoryVo.name]) {
                        [goodsEditView.lsCategory initData:@"请选择" withVal:nil];
                    }
                }
            }

            self.goodsCategoryEditBack(nil, ACTION_CONSTANTS_DEL, YES);
        }else{
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[GoodsCategoryListView class]]) {
                    GoodsCategoryListView *listView = (GoodsCategoryListView *)vc;
                    [listView loadData:ACTION_CONSTANTS_DEL goodsCategory:nil];
                }
                
                if ([vc isKindOfClass:[LSGoodsEditView class]]) {
                    LSGoodsEditView *goodsEditView = (LSGoodsEditView *)vc;
                    if ([[goodsEditView.lsCategory getDataLabel] isEqualToString:self.categoryVo.name]) {
                        [goodsEditView.lsCategory initData:@"请选择" withVal:nil];
                    }
                }
                
                if ([vc isKindOfClass:[GoodsStyleEditView class]]) {
                    GoodsStyleEditView *goodsEditView = (GoodsStyleEditView *)vc;
                    if ([[goodsEditView.lsCategory getDataLabel] isEqualToString:self.categoryVo.name]) {
                        [goodsEditView.lsCategory initData:@"请选择" withVal:nil];
                    }
                }
            }
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
            [self.navigationController popViewControllerAnimated:NO];
        }
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

#pragma notification 处理.
-(void) initNotifaction
{
    [UIHelper initNotification:self.container event:Notification_UI_GoodsCategoryEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_GoodsCategoryEditView_Change object:nil];
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

// Radio控件变换.
- (void)onItemRadioClick:(LSEditItemRadio *)obj
{
    
    BOOL result = [[obj getStrVal] isEqualToString:@"1"];
    
    if (obj.tag == GOODS_CATEGORY_EDIT_ISHASPARENT) {
        if (result) {
            [self.lsParentName visibal:YES];
            [self.lsParentName editEnable:YES];
        }else{
            [self.lsParentName visibal:NO];
        }
    }
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];

}

#pragma mark 下拉框事件
-(void) onItemListClick:(EditItemList *)obj
{
    if (obj.tag == GOODS_CATEGORY_EDIT_PARENTNAME) {
        [OptionPickerBox initData:[GoodsRender listParentCategoryList:self.parentCategoryList]itemId:[obj getStrVal]];
        [OptionPickerBox showManager:obj.lblName.text managerName:[NSString stringWithFormat:@"清空%@", _categoryName] client:self event:obj.tag];
        [OptionPickerBox changeImgManager:@"setting_data_clear.png"];
    }
}

-(void) managerOption:(NSInteger)eventType
{
    if (eventType == GOODS_CATEGORY_EDIT_PARENTNAME) {
        [self.lsParentName initData:@"请选择" withVal:@""];
    }
}

-(BOOL) pickOption:(id)selectObj event:(NSInteger)eventType
{
    id<INameItem> item = (id<INameItem>)selectObj;
    if (eventType == GOODS_CATEGORY_EDIT_PARENTNAME) {
        [self.lsParentName changeData:[item obtainItemName] withVal:[item obtainItemId]];
    }
    return YES;
}

@end
