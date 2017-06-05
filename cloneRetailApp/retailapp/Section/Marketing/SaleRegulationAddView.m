//
//  SaleRegulationAddView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/9/8.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SaleRegulationAddView.h"
#import "EditItemList.h"
#import "EditItemText.h"
#import "NavigateTitle2.h"
#import "UIHelper.h"
#import "MarketModuleEvent.h"
#import "XHAnimalUtil.h"
#import "DiscountGoodsVo.h"
#import "PiecesDiscountEditView.h"
#import "BindingDiscountEditView.h"
#import "SymbolNumberInputBox.h"
#import "AlertBox.h"

@interface SaleRegulationAddView ()

@property (nonatomic, strong) DiscountGoodsVo* discountGoodsVo;

@property (nonatomic) int fromViewTag;

@property (nonatomic) int action;

@property (nonatomic) int goodsCount;

@property (nonatomic, strong) NSString* discountId;

@property (nonatomic, strong) NSMutableArray* countList;

@end

@implementation SaleRegulationAddView


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil goodsCount:(int) goodsCount fromViewTag:(int) viewTag discountId:(NSString*) discountId countList:(NSMutableArray*) countList
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _goodsCount = goodsCount;
        _fromViewTag = viewTag;
        _discountId = discountId;
        _countList = countList;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initHead];
    [self initMainView];
    [self loaddatas];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) loaddatas
{
    _action = ACTION_CONSTANTS_ADD;
    [self fillModel];
    [self showOrHidden];
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

#pragma 详情页面数据显示
-(void) fillModel
{
    [self.lsGoodsCount initData:nil withVal:nil];
    [self.txtGoodsCount initData:[NSString stringWithFormat:@"第%d件", self.goodsCount]];
    [self.lsDiscountRate initData:nil withVal:nil];
}

#pragma 页面信息是否显示
-(void) showOrHidden
{
    if (self.fromViewTag == BINDING_DISCOUNT_EDIT_VIEW) {
        [self.lsGoodsCount visibal:YES];
        [self.txtGoodsCount visibal:NO];
    }else{
        [self.lsGoodsCount visibal:NO];
        [self.txtGoodsCount visibal:YES];
    }
}

#pragma 页面数据初始化
-(void) initMainView
{
    [self.lsGoodsCount initLabel:@"购买数量(件)" withHit:nil isrequest:YES delegate:self];
    [self.txtGoodsCount initLabel:@"购买数量" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtGoodsCount editEnabled:NO];
    [self.lsDiscountRate initLabel:@"折扣率(%)" withHit:nil isrequest:YES delegate:self];
    
    self.lsGoodsCount.tag = SALES_REGULATION_ADD_GOODSCOUNT;
    self.lsDiscountRate.tag = SALES_REGULATION_ADD_DISCOUNTRATE;
}

#pragma 导航栏事件
-(void) onNavigateEvent:(Direct_Flag)event
{
    if (event == 1) {
        // 返回到N件打折or捆绑打折页面
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
        
    } else {
        [self save];
    }
}

#pragma 下拉框事件
-(void)onItemListClick:(EditItemList *)obj
{
    if (obj.tag == SALES_REGULATION_ADD_DISCOUNTRATE){
        [SymbolNumberInputBox initData:obj.lblVal.text];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:YES isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:3 digitLimit:2];
    } else if (obj.tag == SALES_REGULATION_ADD_GOODSCOUNT){
        [SymbolNumberInputBox initData:obj.lblVal.text];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:NO isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:8 digitLimit:0];
    }
}

#pragma mark - SymbolNumberInputClient协议
- (void)numberClientInput:(NSString *)val event:(NSInteger)eventType
{
    if (eventType == SALES_REGULATION_ADD_DISCOUNTRATE) {
        
        if (val.doubleValue>100.00) {
            
            [AlertBox show:@"折扣率(%)不能超过100.00，请重新输入!"];
            return;
            
        }
        
        if ([NSString isBlank:val]) {
            val = nil;
        } else {
            val = [NSString stringWithFormat:@"%.2f",val.doubleValue];
        }
        
        [self.lsDiscountRate changeData:val withVal:val];
    }else if (eventType == SALES_REGULATION_ADD_GOODSCOUNT){
        
        if ([NSString isBlank:val]) {
            val = nil;
        } else {
            val = [NSString stringWithFormat:@"%d",val.intValue];
        }
        
        [self.lsGoodsCount changeData:val withVal:val];
    }
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

#pragma 保存事件
-(void)save
{
    if (![self isValid]){
        return;
    }
    
    _discountGoodsVo = [[DiscountGoodsVo alloc] init];
    if (_fromViewTag == PIECES_DISCOUNT_EDIT_VIEW) {
        _discountGoodsVo.discountId = _discountId;
        _discountGoodsVo.rate = [self.lsDiscountRate getStrVal].doubleValue;
        _discountGoodsVo.count = _goodsCount;
        _discountGoodsVo.sortCode = _goodsCount;
        
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[PiecesDiscountEditView class]]) {
                PiecesDiscountEditView *listView = (PiecesDiscountEditView *)vc;
                [listView loaddatasFromSaleRegulationAddView:_discountGoodsVo];
            }
        }
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    } else if (_fromViewTag == BINDING_DISCOUNT_EDIT_VIEW){
        _discountGoodsVo.discountId = _discountId;
        _discountGoodsVo.rate = [self.lsDiscountRate getStrVal].doubleValue;
        _discountGoodsVo.count = [self.lsGoodsCount getStrVal].integerValue;
        _discountGoodsVo.sortCode = _goodsCount;
        
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[BindingDiscountEditView class]]) {
                BindingDiscountEditView *listView = (BindingDiscountEditView *)vc;
                [listView loaddatasFromSaleRegulationAddView:_discountGoodsVo];
            }
        }
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }
    
}

#pragma save-data
-(BOOL)isValid
{
    if (_fromViewTag == BINDING_DISCOUNT_EDIT_VIEW && [NSString isBlank:[self.lsGoodsCount getStrVal]]) {
        [AlertBox show:@"购买数量(件)不能为空，请输入!"];
        return NO;
    }
    
    if (_fromViewTag == BINDING_DISCOUNT_EDIT_VIEW && [self.lsGoodsCount getStrVal].intValue == 0) {
        [AlertBox show:@"购买数量(件)必须大于0，请重新输入!"];
        return NO;
    }
    
    if (_fromViewTag == BINDING_DISCOUNT_EDIT_VIEW && _countList > 0) {
        for (NSNumber* count in _countList) {
            if ([[NSNumber numberWithInteger:[self.lsGoodsCount getStrVal].integerValue] isEqualToNumber:count]) {
                [AlertBox show:@"该购买数量(件)的促销规则已存在，请重新输入!"];
                return NO;
            }
        }
    }

    if ([NSString isBlank:[self.lsDiscountRate getStrVal]]) {
        [AlertBox show:@"折扣率(%)不能为空，请输入!"];
        return NO;
    }

    return YES;
}

-(void) initHead
{
    self.titleBox=[NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"添加" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
    self.titleBox.lblRight.text = @"保存";
    self.titleBox.lblRight.hidden = NO;
    [self.titleDiv addSubview:self.titleBox];
}

@end
