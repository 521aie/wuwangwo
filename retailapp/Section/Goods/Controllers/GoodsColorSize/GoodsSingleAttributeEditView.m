//
//  GoodsSingleAttributeEditView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/8/11.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GoodsSingleAttributeEditView.h"
#import "GoodsStyleAttributeVo.h"
#import "UIHelper.h"
#import "XHAnimalUtil.h"
#import "LSEditItemText.h"
#import "LSEditItemList.h"
#import "ServiceFactory.h"
#import "JsonHelper.h"
#import "AlertBox.h"
#import "AttributeGroupVo.h"
#import "AttributeValVo.h"
#import "GoodsRender.h"
#import "OptionPickerBox.h"
#import "GoodsModuleEvent.h"
#import "GoodsSingleAttributeListView.h"
#import "GoodsAttributeCategoryManageListView.h"
#import "NameItemVO.h"
#import "IEditItemListEvent.h"
#import "OptionPickerClient.h"

@interface GoodsSingleAttributeEditView ()< IEditItemListEvent, OptionPickerClient>
@property (nonatomic, strong) GoodsService* goodsService;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *container;
//名称
@property (nonatomic, strong) LSEditItemText *txtName;
//code
@property (nonatomic, strong) LSEditItemText *txtCode;
//分类
@property (nonatomic, strong) LSEditItemList *lsCategory;
@property (nonatomic, strong) UIView *btnDel;
@property (nonatomic, strong) NSMutableArray *attributeGroupVoList;
/** <#注释#> */
@property (nonatomic, assign) NSInteger groupVal;
@end

@implementation GoodsSingleAttributeEditView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configDatas];
    [self configViews];
    [self configContainerViews];
    [self initMainView];
    [self initNotifaction];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
    [self loaddatas];
}
- (void)configDatas{
    self.goodsService = [ServiceFactory shareInstance].goodsService;
}

- (void)configViews{
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    [self.view addSubview:self.scrollView];
    
    self.container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.ls_width, self.scrollView.ls_height)];
    [self.scrollView addSubview:self.container];
}


- (void)configContainerViews {
    [self configTitle:@"" leftPath:Head_ICON_BACK rightPath:nil];
    
    self.txtName = [LSEditItemText editItemText];
    [self.container addSubview:self.txtName];
    
    self.txtCode = [LSEditItemText editItemText];
    [self.container addSubview:self.txtCode];
    
    self.lsCategory = [LSEditItemList editItemList];
    [self.container addSubview:self.lsCategory];
    
    UIButton *btn = [LSViewFactor addRedButton:self.container title:@"删除" y:0];
    [btn addTarget:self action:@selector(delClick) forControlEvents:UIControlEventTouchUpInside];
    self.btnDel = btn.superview;
}

-(void) loaddatas
{
    if ([self.attributeVo.name isEqualToString:@"颜色"]) {
        [self.txtName initLabel:@"色称" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
        [self.txtName initData:nil];
        
        [self.txtCode initLabel:@"色号" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
        [self.txtCode initData:nil];
    } else if ([self.attributeVo.name isEqualToString:@"尺码"]) {
        [self.txtName initLabel:@"尺码" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
        [self.txtName initData:nil];
        
        [self.txtCode initLabel:@"尺码编号" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
        [self.txtCode initData:nil];

    }
    
    [self.lsCategory initLabel:[NSString stringWithFormat:@"%@分类",self.attributeVo.name] withHit:nil delegate:self];
    
    [self.btnDel setHidden:self.action == ACTION_CONSTANTS_ADD];
    if (self.action == ACTION_CONSTANTS_ADD) {
        NSString *title = @"";
        if ([self.attributeVo.name isEqualToString:@"颜色"]) {
            title = @"添加颜色";
        }else if ([self.attributeVo.name isEqualToString:@"尺码"]) {
            title = @"添加尺码";
        }
        [self configTitle:title leftPath:Head_ICON_CANCEL rightPath:Head_ICON_OK];
        [self clearDo];
    }else{
         [self configTitle:self.attributeValVo.attributeVal leftPath:Head_ICON_BACK rightPath:nil];
        [self fillModel];
    }
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

-(void) loaddatas:(AttributeVo *)attributeVo attributeGroupVoList:(NSMutableArray *)attributeGroupVoList attributeValVo:(AttributeValVo *)attributeValVo action:(int)action callBack:(goodsSingleAttributeEditBack)callBack
{
    self.goodsSingleAttributeEditBack = callBack;
    self.action = action;
    self.attributeGroupVoList = attributeGroupVoList;
    for (AttributeGroupVo* tempVo in attributeGroupVoList) {
        if ([tempVo.attributeGroupName isEqualToString:@"未分类"]) {
            [self.attributeGroupVoList removeObject:tempVo];
            break ;
        }
    }
    self.attributeValVo = attributeValVo;
    self.attributeVo = attributeVo;
}

-(void) clearDo
{
    [self.txtCode initData:nil];
    [self.txtName initData:nil];
    [self.txtCode editEnabled:YES];
    [self.lsCategory initData:@"请选择" withVal:@"0"];
}

-(void) fillModel
{
    [self.txtName initData:self.attributeValVo.attributeVal];
    [self.txtCode initData:self.attributeValVo.attributeCode];
    [self.txtCode editEnabled:NO];
    
    if ([self.attributeValVo.attributeValGroup isEqualToString:@"0"]) {
        [self.lsCategory initData:@"请选择" withVal:@"0"];
        self.groupVal = 0;
    }else{
        AttributeGroupVo* vo = [GoodsRender obtainAttributeGroup:self.attributeValVo.attributeValGroup attributeGroupList:self.attributeGroupVoList];
        [self.lsCategory initData:[vo obtainItemName] withVal:[vo obtainItemId]];
        self.groupVal = [vo obtainItemSortCode];
    }
}

-(void) initMainView
{
    [self.txtName initLabel:@"尺码" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtName initMaxNum:20];
    [self.txtCode initLabel:@"尺码编号" withHit:nil isrequest:YES type:UIKeyboardTypeNumbersAndPunctuation];
    if ([self.attributeVo.name isEqualToString:@"颜色"]) {
        [self.txtCode initMaxNum:6];
    } else {
        [self.txtCode initMaxNum:4];
    }
    [self.lsCategory initLabel:@"" withHit:nil delegate:self];
    self.lsCategory.tag = GOODS_SINGLE_ATTRIBUTE_EDIT_CATEGORY;
}

-(void) onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event==LSNavigationBarButtonDirectLeft) {
        self.goodsSingleAttributeEditBack(nil, GOODS_SINGLE_ATTRIBUTE_EDIT_VIEW);
    }else{
        [self save];
    }
}

-(void) save
{
    if (![self isValid]){
        return;
    }
    
    __weak GoodsSingleAttributeEditView* weakSelf = self;
    if (self.action == ACTION_CONSTANTS_ADD) {
        self.attributeValVo = [[AttributeValVo alloc] init];
        self.attributeValVo.attributeVal = [self.txtName getStrVal];
        self.attributeValVo.attributeCode = [self.txtCode getStrVal];
        self.attributeValVo.attributeValGroup = [self.lsCategory getStrVal];
        self.attributeValVo.groupSortCode= self.groupVal;
        self.attributeValVo.attributeNameId = self.attributeVo.attributeId;
        self.attributeValVo.attributeType = self.attributeVo.attributeType.intValue;
        [_goodsService saveAttributeVal:@"add" baseAttributeType:@"0" collectionType:[NSString stringWithFormat:@"%d", self.attributeVo.collectionType] attributeVal:self.attributeValVo completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            self.goodsSingleAttributeEditBack(self.attributeVo, GOODS_SINGLE_ATTRIBUTE_EDIT_VIEW);
            //            [parent showView:GOODS_SINGLE_ATTRIBUTE_LIST_VIEW];
            //            [parent.goodsSingleAttributeListView loaddatas:self.attributeVo fromViewTag:GOODS_SINGLE_ATTRIBUTE_EDIT_VIEW];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }else{
        self.attributeValVo.attributeVal = [self.txtName getStrVal];
        self.attributeValVo.attributeCode = [self.txtCode getStrVal];
        self.attributeValVo.attributeValGroup = [self.lsCategory getStrVal];
        [_goodsService saveAttributeVal:@"edit" baseAttributeType:@"0" collectionType:[NSString stringWithFormat:@"%d", self.attributeVo.collectionType] attributeVal:self.attributeValVo completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            self.goodsSingleAttributeEditBack(self.attributeVo, GOODS_SINGLE_ATTRIBUTE_EDIT_VIEW);
            //            [parent showView:GOODS_SINGLE_ATTRIBUTE_LIST_VIEW];
            //            [parent.goodsSingleAttributeListView loaddatas:self.attributeVo fromViewTag:GOODS_SINGLE_ATTRIBUTE_EDIT_VIEW];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }
}

#pragma save-data
-(BOOL)isValid
{
    if ([self.attributeVo.name isEqualToString:@"颜色"]) {
        if ([NSString isBlank:[self.txtName getStrVal]]) {
            [AlertBox show:@"色称不能为空，请输入!"];
            return NO;
        }
        
        if ([NSString isBlank:[self.txtCode getStrVal]]) {
            [AlertBox show:@"色号不能为空，请输入!"];
            return NO;
        }
        
    } else if ([self.attributeVo.name isEqualToString:@"尺码"]) {
        if ([NSString isBlank:[self.txtName getStrVal]]) {
            [AlertBox show:@"尺码不能为空，请输入!"];
            return NO;
        }
        
        if ([NSString isBlank:[self.txtCode getStrVal]]) {
            [AlertBox show:@"尺码编号不能为空，请输入!"];
            return NO;
        }
    }
    
    return YES;
}

-(void)delClick
{
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:@"确认要删除[%@]吗？",self.attributeValVo.attributeVal]];
}

//删除确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        __weak GoodsSingleAttributeEditView* weakSelf = self;
        NSMutableArray *list = [[NSMutableArray alloc] init];
        [list addObject:[AttributeValVo getDictionaryData:self.attributeValVo]];
        [_goodsService delAttributeVal:list completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            [self delFinish];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
        
        //[service removeKindPay:self.kindPay._id event:REMOTE_KINDPAY_DELONE];
    }
}

- (void)delFinish
{
    self.goodsSingleAttributeEditBack(self.attributeVo, GOODS_SINGLE_ATTRIBUTE_EDIT_VIEW);
    //    [parent showView:GOODS_SINGLE_ATTRIBUTE_LIST_VIEW];
    //    [parent.goodsSingleAttributeListView loaddatas:self.attributeVo fromViewTag:GOODS_SINGLE_ATTRIBUTE_EDIT_VIEW];
}


-(void) onItemListClick:(LSEditItemList *)obj
{
    if (obj.tag == GOODS_SINGLE_ATTRIBUTE_EDIT_CATEGORY) {
        __weak GoodsSingleAttributeEditView* weakSelf = self;
        [_goodsService selectAttributeTypeList:weakSelf.attributeVo.attributeId attributeType:weakSelf.attributeVo.attributeType completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            self.attributeGroupVoList = [JsonHelper transList:[json objectForKey:@"attributeGroupList"] objName:@"AttributeGroupVo"];
            for (AttributeGroupVo* tempVo in self.attributeGroupVoList) {
                if ([tempVo.attributeGroupName isEqualToString:@"未分类"]) {
                    [self.attributeGroupVoList removeObject:tempVo];
                    break ;
                }
            }
            [OptionPickerBox initData:[GoodsRender listAttributeGroup:self.attributeGroupVoList] itemId:[obj getStrVal]];
            [OptionPickerBox showManager:obj.lblName.text managerName:@"分类管理" client:self event:obj.tag];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }
}

-(void) managerOption:(NSInteger)eventType
{
    //    if (eventType == GOODS_SINGLE_ATTRIBUTE_EDIT_CATEGORY && self.action == ACTION_CONSTANTS_ADD) {
    //        [self.lsCategory initData:@"请选择" withVal:@"0"];
    //    }else if (eventType == GOODS_SINGLE_ATTRIBUTE_EDIT_CATEGORY && self.action == ACTION_CONSTANTS_EDIT){
    //        if ([self.attributeValVo.attributeValGroup isEqualToString:@"0"]) {
    //            [self.lsCategory initData:@"请选择" withVal:@"0"];
    //        }else{
    //            [self.lsCategory changeData:@"请选择" withVal:@"0"];
    ////            AttributeGroupVo* vo = [GoodsRender obtainAttributeGroup:self.attributeValVo.attributeValGroup attributeGroupList:self.attributeGroupVoList];
    ////            [self.lsCategory initData:[vo obtainItemName] withVal:[vo obtainItemId]];
    //        }
    //    }
    
    if (eventType == GOODS_SINGLE_ATTRIBUTE_EDIT_CATEGORY) {
        __weak GoodsSingleAttributeEditView* weakSelf = self;
        GoodsAttributeCategoryManageListView* vc = [[GoodsAttributeCategoryManageListView alloc] init];
        [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        [weakSelf.navigationController pushViewController:vc animated:NO];
        
        [vc loadData:self.attributeGroupVoList attributeVo:weakSelf.attributeVo callBack:^(AttributeVo *attributeVo, int fromViewTag) {
            [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [weakSelf onItemListClick:weakSelf.lsCategory];
            [weakSelf.navigationController popToViewController:weakSelf animated:NO];
        }];
    }
}

-(BOOL) pickOption:(id)selectObj event:(NSInteger)eventType
{
    id<INameItem> item = (id<INameItem>)selectObj;
    if (eventType == GOODS_SINGLE_ATTRIBUTE_EDIT_CATEGORY) {
        if ([item isKindOfClass:[NameItemVO class]]) {
            NameItemVO *vo = (NameItemVO *)item;
            self.attributeValVo.groupSortCode = vo.itemSortCode;
        }
        [self.lsCategory changeData:[item obtainItemName] withVal:[item obtainItemId]];
        self.groupVal = [item obtainItemSortCode];
    }
    return YES;
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
