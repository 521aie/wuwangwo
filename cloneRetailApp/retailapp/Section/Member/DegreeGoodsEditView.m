//
//  DegreeGoodsEditView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/7/22.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "DegreeGoodsEditView.h"
#import "UIHelper.h"
#import "NavigateTitle2.h"
#import "MemberModule.h"
#import "XHAnimalUtil.h"
#import "EditItemText.h"
#import "EditItemList.h"
#import "MemberModuleEvent.h"
#import "SymbolNumberInputBox.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "DegreeGoodsListView.h"
#import "GoodsSingleChoiceView.h"
#import "GoodsVo.h"
#import "GoodsSingleChoiceView2.h"
#import "StyleGoodsVo.h"
#import "GoodsSkuVo.h"

@interface DegreeGoodsEditView ()

@property (nonatomic, strong) MemberService* memberService;

@property (nonatomic) int action;

@property (nonatomic, strong) GoodsGiftVo *goodsGiftVo;

@end

@implementation DegreeGoodsEditView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil goodsGiftVo:(GoodsGiftVo *)goodsGiftVo action:(int)action
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _goodsGiftVo = goodsGiftVo;
        _action = action;
        _memberService = [ServiceFactory shareInstance].memberService;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNotifaction];
    [self initHead];
    [self initMainView];
    [self loaddatas];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
    [UIHelper clearColor:self.scrollView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) loaddatas
{
    [self.btnDel setHidden:_action == ACTION_CONSTANTS_ADD];
    if (_action == ACTION_CONSTANTS_ADD) {
        self.titleBox.lblRight.hidden = NO;
        self.titleBox.imgMore.hidden = NO;
        self.titleBox.lblTitle.text = @"添加";
        [self clearDo];
    }else{
        self.titleBox.lblRight.hidden = YES;
        self.titleBox.imgMore.hidden = YES;
        self.titleBox.lblTitle.text = @"商品详情";
        [self fillModel];
    }
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

-(void) clearDo
{
    [self.txtName initData:self.goodsGiftVo.name];
    
    if ([[Platform Instance] getkey:SHOP_MODE].intValue == 101) {
        [self.txtBarcode initData:self.goodsGiftVo.innerCode];
    } else {
        [self.txtBarcode initData:self.goodsGiftVo.barCode];
    }
    
    if ([[Platform Instance] getkey:SHOP_MODE].intValue == 101) {
        [self.txtColour initData:self.goodsGiftVo.goodsColor];
        [self.txtSize initData:self.goodsGiftVo.goodsSize];
    }
    
    [self.txtPrice initData:[NSString stringWithFormat:@"%.2f", self.goodsGiftVo.price]];
    
    [self.lsNeedPoint initData:@"" withVal:@""];
}

-(void) fillModel
{
    [self.txtName initData:self.goodsGiftVo.name];
    
    if ([[Platform Instance] getkey:SHOP_MODE].intValue == 101) {
        [self.txtBarcode initData:self.goodsGiftVo.innerCode];
    } else {
        [self.txtBarcode initData:self.goodsGiftVo.barCode];
    }
    
    if ([[Platform Instance] getkey:SHOP_MODE].intValue == 101) {
        [self.txtColour initData:self.goodsGiftVo.goodsColor];
        [self.txtSize initData:self.goodsGiftVo.goodsSize];
    }
    
    [self.txtPrice initData:[NSString stringWithFormat:@"%.2f", self.goodsGiftVo.price]];
    [self.lsNeedPoint initData:[NSString stringWithFormat:@"%ld", self.goodsGiftVo.point] withVal:[NSString stringWithFormat:@"%ld", self.goodsGiftVo.point]];
}

-(void) initMainView
{
    [self.txtName initLabel:@"商品名称" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtName editEnabled:NO];

    if ([[Platform Instance] getkey:SHOP_MODE].intValue == 101) {
        [self.txtBarcode initLabel:@"店内码" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    } else {
        [self.txtBarcode initLabel:@"条形码" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    }
    self.txtBarcode.txtVal.placeholder = @"";
    
    [self.txtBarcode editEnabled:NO];
    
    [self.txtColour initLabel:@"颜色" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtColour editEnabled:NO];
    
    [self.txtSize initLabel:@"尺码" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtSize editEnabled:NO];
    if ([[Platform Instance] getkey:SHOP_MODE].intValue == 101) {
        [self.txtColour visibal:YES];
        [self.txtSize visibal:YES];
    } else {
        [self.txtColour visibal:NO];
        [self.txtSize visibal:NO];
    }
    
    [self.txtPrice initLabel:@"零售价(元)" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtPrice editEnabled:NO];
    
    [self.lsNeedPoint initLabel:@"兑换所需积分" withHit:nil isrequest:YES delegate:self];

    self.lsNeedPoint.tag = DEGREE_GOODS_EDIT_NEEDPOINT;
}

-(void) onItemListClick:(EditItemList *)obj
{
    if (obj.tag == DEGREE_GOODS_EDIT_NEEDPOINT) {
        [SymbolNumberInputBox initData:obj.lblVal.text];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:NO isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:8 digitLimit:0];
    }
}

-(void)numberClientInput:(NSString *)val event:(NSInteger)eventType
{
    if ([NSString isBlank:val]){
        val = @"";
    }
    if (eventType == DEGREE_GOODS_EDIT_NEEDPOINT) {
        [self.lsNeedPoint changeData:val withVal:val];
    }
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

-(void) initHead
{
    self.titleBox=[NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"" backImg:Head_ICON_BACK moreImg:Head_ICON_OK];
    self.titleBox.lblRight.text = @"保存";
    self.titleBox.lblRight.hidden = NO;
    [self.titleDiv addSubview:self.titleBox];
}

#pragma notification 处理.
-(void) initNotifaction
{
    [UIHelper initNotification:self.container event:Notification_UI_DegreeGoodsEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_DegreeGoodsEditView_Change object:nil];
}

#pragma 做好界面变动的支持.
-(void) dataChange:(NSNotification*) notification
{
    [self.titleBox editTitle:[UIHelper currChange:self.container] act:self.action];
}

-(void) onNavigateEvent:(Direct_Flag)event
{
    if (event == 1) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        [self save];
    }
}

-(BOOL) isValid
{
    if ([NSString isBlank:[self.lsNeedPoint getStrVal]]) {
        [AlertBox show:@"兑换所需积分不能为空，请输入!"];
        return NO;
    }

    return YES;
}

-(void)save
{
    if (![self isValid]){
        return;
    }
    
    __weak DegreeGoodsEditView* weakSelf = self;
    if (self.action == ACTION_CONSTANTS_ADD) {
        [_memberService saveDegreeGoods:self.goodsGiftVo.goodsId point:[self.lsNeedPoint getStrVal] operateType:@"add" completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            
            [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [weakSelf.navigationController popViewControllerAnimated:NO];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }else{
        [_memberService saveDegreeGoods:self.goodsGiftVo.goodsId point:[self.lsNeedPoint getStrVal] operateType:@"edit" completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[DegreeGoodsListView class]]) {
                    DegreeGoodsListView *listView = (DegreeGoodsListView *)vc;
                    [listView loaddatas];
                }
            }
            [self.navigationController popViewControllerAnimated:NO];
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }
}

-(IBAction)btnDelClick:(id)sender
{
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:@"确认要删除[%@]吗？",self.goodsGiftVo.name]];
}

//删除确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        __weak DegreeGoodsEditView* weakSelf = self;
        [_memberService cancelDegreeGoods:self.goodsGiftVo.goodsId completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            [self delFinish];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }
}

- (void)delFinish
{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[DegreeGoodsListView class]]) {
            DegreeGoodsListView *listView = (DegreeGoodsListView *)vc;
            [listView loaddatas];
        }
    }
    [self.navigationController popViewControllerAnimated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
}

@end
