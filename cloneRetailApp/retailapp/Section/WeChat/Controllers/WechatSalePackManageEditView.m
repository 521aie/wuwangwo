//
//  GoodsSalePackManageEditView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/8/17.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "WechatSalePackManageEditView.h"
#import "StyleVo.h"
#import "UIHelper.h"
#import "XHAnimalUtil.h"
#import "EditItemList.h"
#import "EditItemText.h"
#import "ItemTitle.h"
#import "AlertBox.h"
#import "DateUtils.h"
#import "OptionPickerBox.h"
#import "SalePackVo.h"
#import "ObjectUtil.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "NameItemVO.h"
#import "WechatSalePackManageListView.h"
#import "SalePackStyleListView.h"

#define YEAR 1
#define STYLE_INFO 2

@interface WechatSalePackManageEditView ()

@property (nonatomic, strong) WechatService* wechatService;

@property (nonatomic, strong) SalePackVo *salePackVo;

@property (nonatomic, strong) NSString *salePackId;

@property (nonatomic) int action;

@property (nonatomic) BOOL saveFlg;

/**
 1: 右上角保存按键保存 2: 点击款式信息保存
 */
@property (nonatomic, strong) NSString *saveWay;

@property (nonatomic, strong) NSString *lastVer;

@end

@implementation WechatSalePackManageEditView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil action:(int)action salePackId:(NSString *)salePackId
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _wechatService = [ServiceFactory shareInstance].wechatService;
        _action = action;
        _salePackId = salePackId;
    }
    return self;
}

-(void) loaddatas
{
    [self.btnDel setHidden:_action == ACTION_CONSTANTS_ADD];
    if (_action == ACTION_CONSTANTS_ADD) {
        self.titleBox.lblTitle.text = @"添加";
        [self clearDo];
        [UIHelper refreshUI:self.container scrollview:self.scrollView];
    }else{
        [self selectSalePackDetail];
    }
}

-(void) loaddatasFromStyleListView
{
    _action = ACTION_CONSTANTS_EDIT;
    [self.btnDel setHidden:_action == ACTION_CONSTANTS_ADD];
    [self selectSalePackDetail];
    
}

-(void) selectSalePackDetail
{
    __weak WechatSalePackManageEditView* weakSelf = self;
    [_wechatService selectSalePackDetail:_salePackId completionHandler:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        [weakSelf responseSuccess:json];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

- (void)responseSuccess:(id)json
{
    _salePackVo = [SalePackVo convertToSalePackVo:[json objectForKey:@"salePackVo"]];
    _lastVer = [NSString stringWithFormat:@"%ld", _salePackVo.lastVer];
    self.titleBox.lblTitle.text = self.salePackVo.packName;
    [self fillModel];
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

-(void) clearDo
{
    
    [self.txtSalePackCode initData:nil];
    
    [self.txtSalePackName initData:nil];
    
    NSString *dateStr = [DateUtils formateDate4:[NSDate date]];
    [self.lsYear initData:dateStr withVal:dateStr];

}

-(void) fillModel
{
    [self.txtSalePackCode initData:_salePackVo.packCode];
    [self.txtSalePackName initData:_salePackVo.packName];
    [self.lsYear initData:[NSString stringWithFormat:@"%ld", _salePackVo.applyYear] withVal:[NSString stringWithFormat:@"%ld", _salePackVo.applyYear]];

}

-(void) initMainView
{

    [self.txtSalePackCode initLabel:@"销售包编号" withHit:nil isrequest:YES type:UIKeyboardTypeAlphabet];
    [self.txtSalePackCode initMaxNum:20];
    [self.txtSalePackName initLabel:@"销售包名称" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtSalePackName initMaxNum:50];
    [self.lsYear initLabel:@"年度" withHit:nil delegate:self];
    [self.lsStyleInfo initLabel:@"款式信息" withHit:nil delegate:self];
    [self.lsStyleInfo.imgMore setImage:[UIImage imageNamed:@"ico_next.png"]];
    self.lsStyleInfo.lblVal.placeholder = @"";
    
    self.lsYear.tag = YEAR;
    self.lsStyleInfo.tag = STYLE_INFO;
}

-(void)onItemListClick:(EditItemList *)obj
{
    
    if (obj.tag == YEAR) {
        
        NSMutableArray* vos=[NSMutableArray array];
        NSString *dateStr = [DateUtils formateDate4:[NSDate date]];
        NameItemVO *item= [[NameItemVO alloc] initWithVal:dateStr andId:dateStr];
        [vos addObject:item];
        dateStr = [NSString stringWithFormat:@"%d", [DateUtils formateDate4:[NSDate date]].intValue + 1];
        item=[[NameItemVO alloc] initWithVal:dateStr andId:dateStr];
        [vos addObject:item];
        
        [OptionPickerBox initData:vos itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    }else if (obj.tag == STYLE_INFO){
        
        _saveWay = @"2";
        if (!(!_saveFlg && _action == ACTION_CONSTANTS_EDIT)) {
            [self save];
        }else{
            SalePackStyleListView * salePackStyleListView = [[SalePackStyleListView alloc] initWithNibName:[SystemUtil getXibName:@"SalePackStyleListView"] bundle:nil salePackId:_salePackId lastVer:_lastVer];
            [self.navigationController pushViewController:salePackStyleListView animated:NO];
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        }
        
    }
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];

}

// 拾取器值更改
- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType
{
    id<INameItem> item = (id<INameItem>)selectObj;
    if (eventType == YEAR) {
        [self.lsYear changeData:[item obtainItemName] withVal:[item obtainItemId]];
    }
    return YES;
}

#pragma notification 处理.
-(void) initNotifaction
{
    [UIHelper initNotification:self.container event:Notification_UI_WechatSalePackManageEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_WechatSalePackManageEditView_Change object:nil];
}

#pragma 做好界面变动的支持.
-(void) dataChange:(NSNotification*) notification
{

    if (self.action == ACTION_CONSTANTS_ADD) {
        [self.titleBox editTitle:YES act:self.action];
    }else{
        [self.titleBox editTitle:[UIHelper currChange:self.container] act:self.action];
        _saveFlg = [UIHelper currChange:self.container];
    }

}

-(void) onNavigateEvent:(Direct_Flag)event
{
    if (event==1) {
        [self.navigationController popViewControllerAnimated:YES];
        [XHAnimalUtil animalEdit:self.navigationController action:self.action];
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[WechatSalePackManageListView class]]) {
                WechatSalePackManageListView *list= (WechatSalePackManageListView *)vc;
                [list loaddatas];
            }
        }
    }else{
        _saveWay = @"1";
        [self save];
    }
}

-(void) save
{
    if (![self isValid]){
        return;
    }
    
    __weak WechatSalePackManageEditView *weakSelf = self;
    if (_action == ACTION_CONSTANTS_ADD) {
        _salePackVo = [[SalePackVo alloc] init];
        _salePackVo.packCode = [self.txtSalePackCode getStrVal];
        _salePackVo.packName = [self.txtSalePackName getStrVal];
        _salePackVo.applyYear = [self.lsYear getStrVal].integerValue;
        NSDictionary* dic = [SalePackVo getDictionaryData:_salePackVo];
        [_wechatService saveSalePackDetail:dic completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            if ([_saveWay isEqualToString:@"1"]) {
                for (UIViewController *vc in self.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[WechatSalePackManageListView class]]) {
                        WechatSalePackManageListView *list= (WechatSalePackManageListView *)vc;
                        [list loaddatasFromEdit:ACTION_CONSTANTS_ADD salePackVo:nil];
                    }
                }
                [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                _salePackId = [[json objectForKey:@"salePackId"] stringValue];
                _lastVer = [[json objectForKey:@"lastVer"] stringValue];
                SalePackStyleListView * salePackStyleListView = [[SalePackStyleListView alloc] initWithNibName:[SystemUtil getXibName:@"SalePackStyleListView"] bundle:nil salePackId:_salePackId lastVer:_lastVer];
                [self.navigationController pushViewController:salePackStyleListView animated:NO];
                [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
            }
            
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }else{
        _salePackVo.packCode = [self.txtSalePackCode getStrVal];
        _salePackVo.packName = [self.txtSalePackName getStrVal];
        _salePackVo.applyYear = [self.lsYear getStrVal].integerValue;
        NSDictionary* dic = [SalePackVo getDictionaryData:_salePackVo];
        [_wechatService saveSalePackDetail:dic completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            if ([_saveWay isEqualToString:@"1"]) {
                for (UIViewController *vc in self.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[WechatSalePackManageListView class]]) {
                        WechatSalePackManageListView *list= (WechatSalePackManageListView *)vc;
                        [list loaddatasFromEdit:ACTION_CONSTANTS_EDIT salePackVo:_salePackVo];
                    }
                }
                [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
                [self.navigationController popViewControllerAnimated:YES];
                

            }else{
                _lastVer = [[json objectForKey:@"lastVer"] stringValue];
                SalePackStyleListView * salePackStyleListView = [[SalePackStyleListView alloc] initWithNibName:[SystemUtil getXibName:@"SalePackStyleListView"] bundle:nil salePackId:_salePackId lastVer:_lastVer];
                [self.navigationController pushViewController:salePackStyleListView animated:NO];
                [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
            }
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
        
    }

    
}

-(BOOL) isValid
{
    if ([NSString isBlank:[self.txtSalePackCode getStrVal]]) {
        [AlertBox show:@"销售包编号不能为空，请输入!"];
        return NO;
    }
    
    if ([NSString isNotBlank:[self.txtSalePackCode getStrVal]] && [NSString isNotNumAndLetter:[self.txtSalePackCode getStrVal]]) {
        [AlertBox show:@"销售包编号必须为英数字，请重新输入!"];
        return NO;
    }
    
    if ([NSString isBlank:[self.txtSalePackName getStrVal]]) {
        [AlertBox show:@"销售包名称不能为空，请输入!"];
        return NO;
    }
    
    return YES;
}

-(void) initHead
{
    self.titleBox=[NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"" backImg:Head_ICON_BACK moreImg:nil];
    [self.titleDiv addSubview:self.titleBox];
}

-(IBAction)btnDelClick:(id)sender
{
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:@"确认要删除[%@]吗？",self.salePackVo.packName]];
}

//删除确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        if (self.action == ACTION_CONSTANTS_EDIT) {
            __weak WechatSalePackManageEditView* weakSelf = self;
            [_wechatService delSalePack:[NSString stringWithFormat:@"%@", _salePackVo.salePackId] completionHandler:^(id json) {
                if (!(weakSelf)) {
                    return ;
                }
                [self delFinish];
            } errorHandler:^(id json) {
                [AlertBox show:json];
            }];
        }
    }
}

- (void)delFinish
{
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
    [self.navigationController popViewControllerAnimated:YES];
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[WechatSalePackManageListView class]]) {
            WechatSalePackManageListView *list= (WechatSalePackManageListView *)vc;
            [list loaddatasFromEdit:ACTION_CONSTANTS_DEL salePackVo:_salePackVo];
            [list loaddatas];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNotifaction];
    [self initHead];
    [self initMainView];
    [self loaddatas];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
