//
//  AddStyleByConditionView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/11/16.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "AddStyleByConditionView.h"
#import "UIView+Sizes.h"
#import "EditItemList.h"
#import "ColorHelper.h"
#import "DateUtils.h"
#import "UIHelper.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "SymbolNumberInputBox.h"
#import "GoodsRender.h"
#import "OptionPickerBox.h"
#import "XHAnimalUtil.h"
#import "NavigateTitle2.h"
#import "SalesStyleAreaView.h"

#define CATEGORY 1
#define SEX 2
#define SEASON 3
#define YEAR 4
#define MINPRICE 5
#define MAXPRICE 6
#define MAINMODEL 7
#define AUXILIARYMODEL 8

@interface AddStyleByConditionView ()

@property (nonatomic, strong) MarketService* marketService;

@property (nonatomic, strong) WechatService* wechatService;

@property (nonatomic, strong) GoodsService* goodsService;

/**
 分类list
 */
@property (nonatomic, strong) NSMutableArray *categoryList;

/**
 季节list
 */
@property (nonatomic, strong) NSMutableArray *attributeList;

/**
 折扣ID
 */
@property (nonatomic, strong) NSString *discountId;

/**
 折扣类别
 */
@property (nonatomic, retain) NSString* discountType;

@property (nonatomic, strong) NSString *shopId;

@end

@implementation AddStyleByConditionView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil discountId:(NSString *)discountId shopId:(NSString *) shopId discountType:(NSString *) discountType{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _wechatService = [ServiceFactory shareInstance].wechatService;
        _goodsService = [ServiceFactory shareInstance].goodsService;
        _marketService = [ServiceFactory shareInstance].marketService;
        _discountId = discountId;
        _discountType = discountType;
        _shopId = shopId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMainView];
    [self initHead];
    [self clearDo];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loaddatas
{
    
}

//初始化条件项内容
- (void)initMainView
{
    [self.lsCategory initLabel:@"中品类" withHit:nil delegate:self];
    
    [self.lsSex initLabel:@"性别" withHit:nil delegate:self];
    
    [self.lsMainModel initLabel:@"主型" withHit:nil delegate:self];
    
    [self.lsAuxiliaryModel initLabel:@"辅型" withHit:nil delegate:self];
    
    [self.lsYear initLabel:@"年份" withHit:nil delegate:self];
    
    [self.lsSeason initLabel:@"季节" withHit:nil delegate:self];
    
    [self.lsMaxHangTagPrice initLabel:@"吊牌价(元)" withHit:nil delegate:self];
    
    self.lsCategory.tag = CATEGORY;
    self.lsSex.tag = SEX;
    self.lsSeason.tag = SEASON;
    self.lsYear.tag = YEAR;
    self.txtMinHangTagPrice.tag = MINPRICE;
    self.lsMaxHangTagPrice.tag = MAXPRICE;
    self.lsMainModel.tag = MAINMODEL;
    self.lsAuxiliaryModel.tag = AUXILIARYMODEL;
}

#pragma navigateTitle.
-(void) initHead
{
    self.titleBox=[NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"选择款式" backImg:Head_ICON_BACK moreImg:nil];
    [self.titleDiv addSubview:self.titleBox];
}


#pragma mark - 重置
- (void) clearDo
{
    [self.lsCategory initData:@"全部" withVal:@""];
    
    [self.lsSex initData:@"全部" withVal:@""];
    
    [self.lsMainModel initData:@"全部" withVal:@""];
    
    [self.lsAuxiliaryModel initData:@"全部" withVal:@""];
    
    [self.lsYear initData:@"请输入" withVal:@""];
    
    [self.lsSeason initData:@"全部" withVal:@""];
    
    [self.lsMaxHangTagPrice initData:@"请输入" withVal:@""];
    
    self.txtMinHangTagPrice.text = @"请输入";
    
    [self.txtMinHangTagPrice setTextColor:[ColorHelper getBlueColor]];
}

#pragma 导航栏事件
-(void) onNavigateEvent:(Direct_Flag)event
{
    if (event == 1) {
        // 返回到促销款式范围页面
        [self.navigationController popViewControllerAnimated:YES];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
    }
}

#pragma 点击最小吊牌价
-(IBAction)clickMinPrice:(id)sender
{
    if ([self.txtMinHangTagPrice.text isEqualToString:@"请输入"]) {
        [SymbolNumberInputBox initData:@""];
    } else {
        [SymbolNumberInputBox initData:self.txtMinHangTagPrice.text];
    }
    
    [SymbolNumberInputBox show:@"吊牌价(开始)" client:self isFloat:YES isSymbol:NO event:MINPRICE];
    [SymbolNumberInputBox limitInputNumber:6 digitLimit:2];
}

#pragma 下拉框事件
-(void) onItemListClick:(EditItemList *)obj
{
    if (obj.tag == CATEGORY) {
        __weak AddStyleByConditionView* weakSelf = self;
        [_goodsService selectFirstCategoryInfo:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            NSMutableArray* list = [json objectForKey:@"categoryList"];
            _categoryList = [[NSMutableArray alloc] init];
            if (list != nil && list.count > 0) {
                for (NSDictionary* dic in list) {
                    [_categoryList addObject:[CategoryVo convertToCategoryVo:dic]];
                }
            }
            [OptionPickerBox initData:[GoodsRender listCategoryList:_categoryList isShow:YES]itemId:[obj getStrVal]];
            [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    } else if (obj.tag == SEX){
        [OptionPickerBox initData:[GoodsRender listSex:YES]itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    } else if (obj.tag == SEASON){
        __weak AddStyleByConditionView* weakSelf = self;
        [_goodsService selectBaseAttributeValList:@"2" completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            NSMutableArray* list = [json objectForKey:@"attributeValList"];
            _attributeList = [[NSMutableArray alloc] init];
            if (list != nil && list.count > 0) {
                for (NSDictionary* dic in list) {
                    [_attributeList addObject:[AttributeValVo convertToAttributeValVo:dic]];
                }
            }
            [OptionPickerBox initData:[GoodsRender listAttributeVal:_attributeList isShow:YES]itemId:[obj getStrVal]];
            [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    } else if (obj.tag == YEAR){
        [SymbolNumberInputBox initData:[obj getStrVal]];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:NO isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:4 digitLimit:0];
        
    } else if (obj.tag == MAXPRICE){
        [SymbolNumberInputBox initData:[obj getStrVal]];
        [SymbolNumberInputBox show:@"吊牌价(结束)" client:self isFloat:YES isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:6 digitLimit:2];
    } else if (obj.tag == MAINMODEL) {
        __weak AddStyleByConditionView* weakSelf = self;
        [_goodsService selectBaseAttributeValList:@"5" completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            NSMutableArray* list = [json objectForKey:@"attributeValList"];
            _attributeList = [[NSMutableArray alloc] init];
            if (list != nil && list.count > 0) {
                for (NSDictionary* dic in list) {
                    [_attributeList addObject:[AttributeValVo convertToAttributeValVo:dic]];
                }
            }
            [OptionPickerBox initData:[GoodsRender listAttributeVal:_attributeList isShow:YES]itemId:[obj getStrVal]];
            [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    } else if (obj.tag == AUXILIARYMODEL) {
        __weak AddStyleByConditionView* weakSelf = self;
        [_goodsService selectBaseAttributeValList:@"6" completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            NSMutableArray* list = [json objectForKey:@"attributeValList"];
            _attributeList = [[NSMutableArray alloc] init];
            if (list != nil && list.count > 0) {
                for (NSDictionary* dic in list) {
                    [_attributeList addObject:[AttributeValVo convertToAttributeValVo:dic]];
                }
            }
            [OptionPickerBox initData:[GoodsRender listAttributeVal:_attributeList isShow:YES]itemId:[obj getStrVal]];
            [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

// 拾取器值更改
- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType
{
    id<INameItem> item = (id<INameItem>)selectObj;
    if (eventType == CATEGORY) {
        [self.lsCategory initData:[item obtainItemName] withVal:[item obtainItemId]];
    } else if (eventType == SEX){
        [self.lsSex initData:[item obtainItemName] withVal:[item obtainItemId]];
    } else if (eventType == SEASON){
        [self.lsSeason initData:[item obtainItemName] withVal:[item obtainItemId]];
    } else if (eventType == MAINMODEL) {
        [self.lsMainModel initData:[item obtainItemName] withVal:[item obtainItemId]];
    } else if (eventType == AUXILIARYMODEL) {
        [self.lsAuxiliaryModel initData:[item obtainItemName] withVal:[item obtainItemId]];
    }
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    return YES;
}

#pragma mark - SymbolNumberInputClient协议
- (void)numberClientInput:(NSString *)val event:(NSInteger)eventType
{
    if ([NSString isBlank:val]) {
        val = @"";
    } else {
        val = [NSString stringWithFormat:@"%.2f",val.doubleValue];
    }
    
    if (eventType == MINPRICE) {
        
        if ([NSString isBlank:val]) {
            self.txtMinHangTagPrice.text = @"请输入";
        } else {
            self.txtMinHangTagPrice.text = val;
        }
        
        
    } else if (eventType == MAXPRICE) {
        if ([NSString isBlank:val]) {
            [self.lsMaxHangTagPrice initData:@"请输入" withVal:val];
        } else {
            [self.lsMaxHangTagPrice initData:val withVal:val];
        }
    }
    
    if (eventType == YEAR) {
        
        if ([NSString isBlank:val]) {
            val = @"";
        } else {
            val = [NSString stringWithFormat:@"%d",val.intValue];
        }
        
        if ([NSString isBlank:val]) {
            [self.lsYear initData:@"请输入" withVal:@""];
        } else {
            [self.lsYear initData:val withVal:val];
        }
    }
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

//确认按钮
- (IBAction)btnOkClick
{
    NSString* minPrice = self.txtMinHangTagPrice.text;
    if ([minPrice isEqualToString:@"请输入"]) {
        minPrice = @"";
    }
    if ([NSString isNotBlank:[self.lsMaxHangTagPrice getStrVal]] && [NSString isNotBlank:self.txtMinHangTagPrice.text]) {
        if ([self.lsMaxHangTagPrice getStrVal].doubleValue < minPrice.doubleValue) {
            [AlertBox show:@"吊牌价下限应小于等于上限!"];
            return ;
        }
    }
    
    NSString* categoryId = nil;
    if ([[self.lsCategory getStrVal] isEqualToString:@"noCategory"]) {
        categoryId = @"0";
    } else {
        categoryId = [self.lsCategory getStrVal];
    }
    __weak AddStyleByConditionView* weakSelf = self;
    [_marketService saveStyleByCondition:_shopId discountId:_discountId categoryId:categoryId applySex:[self.lsSex getStrVal] year:[self.lsYear getStrVal] seasonValId:[self.lsSeason getStrVal] minHangTagPrice:minPrice maxHangTagPrice:[self.lsMaxHangTagPrice getStrVal] discountType:_discountType prototypeValId:[self.lsMainModel getStrVal] auxiliaryValId:[self.lsAuxiliaryModel getStrVal] completionHandler:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[SalesStyleAreaView class]]) {
                SalesStyleAreaView *listView = (SalesStyleAreaView *)vc;
                [listView loadDatasFromAddByConditionView];
                [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
                [self.navigationController popViewControllerAnimated:NO];
            }
        }
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
    
}

@end
