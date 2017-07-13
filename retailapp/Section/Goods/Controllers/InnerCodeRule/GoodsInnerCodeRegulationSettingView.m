//
//  GoodsInnerCodeRegulationSettingView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/8/13.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GoodsInnerCodeRegulationSettingView.h"
#import "ObjectUtil.h"
#import "StyleVo.h"
#import "GoodsInnerCodeRegulationSettingCell.h"
#import "GoodsModuleEvent.h"
#import "AlertBox.h"
#import "GoodsInnerCodeAttributeSortView.h"
#import "XHAnimalUtil.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "JsonHelper.h"
#import "SkuRuleVo.h"
#import "AttributeVo.h"
#import "UIHelper.h"

@interface GoodsInnerCodeRegulationSettingView ()

@property (nonatomic,strong) GoodsService* goodsService;

@end

@implementation GoodsInnerCodeRegulationSettingView


- (void)viewDidLoad {
    [super viewDidLoad];
      _goodsService = [ServiceFactory shareInstance].goodsService;
    [self initHead];
    [self configViews];
    [self loaddatas];
}

- (void)configViews {
    CGFloat y = kNavH;
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, y, SCREEN_W, SCREEN_H - y)];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    NSString *text = @"提示：商品的店内码默认按照 “款号+颜色+尺码” 规则生成。可点击页面底部的排序按钮进入排序页面修改店内码规则的生成顺序。\n例如，将店内码规则生成顺序修改成 “款号+尺码+颜色” ，添加商品时系统默认生成的店内码为：款号(DS)+尺码(01)+颜色(001)=DS01001";
    UIView *viewFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 88)];
    UILabel *lbl = [LSViewFactor addExplainText:viewFooter text:text y:0];
    viewFooter.ls_height = lbl.ls_height;
    self.tableView.tableFooterView = viewFooter;
    
    self.footView = [LSFooterView footerView];
    [self.footView initDelegate:self btnsArray:@[kFootSort]];
    self.footView.ls_bottom = SCREEN_H;
    [self.view addSubview:self.footView];
}

- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootSort]) {
        [self showSortEvent];
    }
}


-(void) loaddatas
{
    __weak GoodsInnerCodeRegulationSettingView* weakSelf = self;
    [_goodsService selectInnerCodeSetting:^(id json) {
        if (!(weakSelf)) {
            return;
        }
        [self responseSuccess:json];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

-(void)reloadDatas:(NSMutableArray*) attributeList
{
    if (attributeList != nil && attributeList.count > 0) {
        for (AttributeVo* vo in attributeList) {
            BOOL flg = NO;
            if ([vo.isCheck isEqualToString:@"1"]) {
                for (SkuRuleVo* curVo in self.datas) {
                    if ([curVo.attributeName isEqualToString:vo.name]) {
                        flg = YES;
                        break;
                    }
                }
                if (!flg) {
                    SkuRuleVo* sku = [[SkuRuleVo alloc] init];
                    sku.attributeNameId = vo.attributeId;
                    sku.attributeName = vo.name;
                    SkuRuleVo* temp= [self.datas objectAtIndex:self.datas.count - 1];
                    sku.sortCode = temp.sortCode + 1;
                    sku.attributeType = vo.attributeType.intValue;
                    [self.datas addObject:sku];
                }
            }
        }
    }
    
    if (self.oldDatas.count == self.datas.count) {
        int count = 0;
        BOOL changeFlg = NO;
        for (SkuRuleVo* vo in self.oldDatas) {
            SkuRuleVo* curvo = [self.datas objectAtIndex:count];
            if (![vo.attributeName isEqualToString:curvo.attributeName]) {
                [self editTitle:YES act:ACTION_CONSTANTS_EDIT];
                changeFlg = YES;
                break;
            }
            count ++;
        }
        if (!changeFlg) {
            [self editTitle:NO act:ACTION_CONSTANTS_EDIT];
        }
    }else{
       [self editTitle:YES act:ACTION_CONSTANTS_EDIT];
    }
    
    [self.tableView reloadData];
}

-(void)reloadSortDatas:(NSMutableArray*) skuList
{
    self.datas = [NSMutableArray new];
    for (SkuRuleVo* vo in skuList) {
        [self.datas addObject:vo];
    }
    
//    if (self.oldDatas.count == self.datas.count) {
//        int count = 0;
//        BOOL changeFlg = NO;
//        for (SkuRuleVo* vo in self.oldDatas) {
//            SkuRuleVo* curvo = [self.datas objectAtIndex:count];
//            if (![vo.attributeName isEqualToString:curvo.attributeName]) {
//                [self.titleBox editTitle:YES act:ACTION_CONSTANTS_EDIT];
//                changeFlg = YES;
//                break;
//            }
//            count ++;
//        }
//        if (!changeFlg) {
//            [self.titleBox editTitle:NO act:ACTION_CONSTANTS_EDIT];
//        }
//    }else{
//        [self.titleBox editTitle:YES act:ACTION_CONSTANTS_EDIT];
//    }
    
    [self.tableView reloadData];
}

- (void)responseSuccess:(id)json
{
    self.datas = [JsonHelper transList:[json objectForKey:@"skuList"] objName:@"SkuRuleVo"];
    
    self.isOpen = [json objectForKey:@"isOpen"];
    
    self.oldDatas = [[NSMutableArray alloc] initWithCapacity:self.datas.count];
    for (SkuRuleVo* vo in self.datas) {
        [self.oldDatas addObject:vo];
    }
    
    [self.tableView reloadData];
}

#pragma navigateTitle.
-(void) initHead
{
    [self configTitle:@"店内码规则设置" leftPath:Head_ICON_BACK rightPath:nil];
}

- (void) showAddEvent
{
    if (self.datas.count >= 5) {
        [AlertBox show:@"属性个数已经最大，无法添加!"];
        return;
    }
}

-(void) onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event==LSNavigationBarButtonDirectLeft) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        __weak GoodsInnerCodeRegulationSettingView* weakSelf = self;
        short count = 1;
        for (SkuRuleVo* sku in self.datas) {
            sku.sortCode = count;
            count ++;
        }
        
        [_goodsService saveInnerCodeSetting:self.datas completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [weakSelf.navigationController popViewControllerAnimated:NO];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }
}

-(void) showSortEvent
{
    if (self.datas.count == 0) {
        [AlertBox show:@"属性个数为0，无法排序，请先添加属性!"];
        return;
    }
    GoodsInnerCodeAttributeSortView* vc = [[GoodsInnerCodeAttributeSortView alloc] init];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
    [self.navigationController pushViewController:vc animated:NO];
    __weak GoodsInnerCodeRegulationSettingView* weakSelf = self;
    [vc loadDatas:self.datas callBack:^(NSMutableArray *skuList) {
        [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        if (skuList) {
            [weakSelf reloadSortDatas:skuList];
        }
        [weakSelf.navigationController popToViewController:weakSelf animated:NO];
    }];    
}

//#pragma notification 处理.
//-(void) initNotifaction
//{
//    [UIHelper initNotification:self.container event:Notification_UI_GoodsInnerCodeRegulationSettingView_Change];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_GoodsInnerCodeRegulationSettingView_Change object:nil];
//}
//
//#pragma 做好界面变动的支持.
//-(void) dataChange:(NSNotification*) notification
//{
//
//    [self.titleBox editTitle:[UIHelper currChange:self.container] act:ACTION_CONSTANTS_EDIT];
//
//}

-(void) showHelpEvent
{
    
}

//-(void) deleteCell:(SkuRuleVo *)skuRuleVo
//{
//    [self.datas removeObject:skuRuleVo];
//    
//    if (self.oldDatas.count == self.datas.count) {
//        int count = 0;
//        bool changeFlg = NO;
//        for (SkuRuleVo* vo in self.oldDatas) {
//            SkuRuleVo* curvo = [self.datas objectAtIndex:count];
//            if (![vo.attributeName isEqualToString:curvo.attributeName]) {
//                [self.titleBox editTitle:YES act:ACTION_CONSTANTS_EDIT];
//                changeFlg = YES;
//                break;
//            }
//            count ++;
//        }
//        if (!changeFlg) {
//            [self.titleBox editTitle:NO act:ACTION_CONSTANTS_EDIT];
//        }
//    }else{
//        [self.titleBox editTitle:YES act:ACTION_CONSTANTS_EDIT];
//    }
//    
//    [self.tableView reloadData];
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.datas != nil) {
        [self showEditNVItemEvent:@"goodsAttribute" withObj:[self.datas objectAtIndex:indexPath.row]];
    }
}

- (void)showEditNVItemEvent:(NSString *)event withObj:(id<INameValueItem>)obj
{
//    [parent showView:GOODS_SINGLE_ATTRIBUTE_LIST_VIEW];
//    [parent.goodsSingleAttributeListView loaddatas:GOODS_ATTRIBUTE_COLOUR_LIST_VIEW];
    //    [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromRight];
    
}

#pragma table部分
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsInnerCodeRegulationSettingCell *detailItem = (GoodsInnerCodeRegulationSettingCell *)[self.tableView dequeueReusableCellWithIdentifier:GoodsInnerCodeRegulationSettingCellIndentifier];
    
    if (!detailItem) {
        detailItem = [[NSBundle mainBundle] loadNibNamed:@"GoodsInnerCodeRegulationSettingCell" owner:self options:nil].lastObject;
    }
    if ([ObjectUtil isNotEmpty:self.datas]) {
        SkuRuleVo* vo = [self.datas objectAtIndex:indexPath.row];
        detailItem.lblName.text = vo.attributeName;
//        if ([vo.attributeName isEqualToString:@"款式"] || [vo.attributeName isEqualToString:@"尺码"] || [vo.attributeName isEqualToString:@"颜色"]) {
//            detailItem.btnDel.enabled = NO;
//            detailItem.btnDel.hidden = YES;
//        }
        detailItem.skuRuleVo = vo;
        detailItem.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return detailItem;
}

#pragma mark UITableView无section列表

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count == 0 ? 0 :self.datas.count;
}

@end
