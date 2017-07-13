//
//  SalesStyleAreaView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/11/12.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SalesStyleAreaView.h"
#import "NavigateTitle2.h"
#import "ObjectUtil.h"
#import "GoodsFooterListView.h"
#import "SearchBar2.h"
#import "MyUILabel.h"
#import "GoodsStyleEditView.h"
#import "EditItemList.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "StyleVo.h"
#import "DateUtils.h"
#import "XHAnimalUtil.h"
#import "GoodsStyleInfoView.h"
#import "SearchBar.h"
#import "ViewFactory.h"
#import "GridColHead5.h"
#import "StyleBatchChoiceView2.h"
#import "Platform.h"
#import "SaleStyleVo.h"
#import "ListStyleVo.h"
#import "SalePackStyleVo.h"
#import "StyleAreaCell.h"
#import "AddStyleByConditionView.h"
#import "UIHelper.h"
#import "SaleCouponEditView.h"
#import "SalesStyleBatchView.h"
#import "PiecesDiscountEditView.h"
#import "BindingDiscountEditView.h"
#import "SaleMinusEditView.h"
#import "SaleSendOrSwapEditView.h"

@interface SalesStyleAreaView ()

@property (nonatomic, strong) MarketService* marketService;

@property (nonatomic, strong) WechatService* wechatService;

@property (nonatomic, strong) NSMutableDictionary* condition;

@property (nonatomic, strong) NSString* lastDateTime;

@property (nonatomic, strong) SaleStyleVo* tempVo;

@property (nonatomic, retain) NSString* searchCode;

@property (nonatomic, retain) NSString* discountId;

@property (nonatomic, retain) NSMutableArray* datas;

@property (nonatomic, retain) NSString* discountType;

@property (nonatomic) int styleCount;

@property (nonatomic) BOOL tipFlg;

@property (nonatomic) int showViewCount;

@property (nonatomic) int oldStyleCount;

@property (nonatomic) BOOL delOrEditFlg;

@property (nonatomic, retain) NSString* shopId;

@property (nonatomic, retain) NSMutableArray* styleIdList;

@property (nonatomic) int action;

@property (nonatomic) short searchType;

@end

@implementation SalesStyleAreaView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil discountId:(NSString*) discountId discountType:(NSString*) discountType shopId:(NSString*) shopId action:(int) action {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _discountId = discountId;
        _discountType = discountType;
        _action = action;
        _shopId = shopId;
        _tipFlg = NO;
        _delOrEditFlg = NO;
        _marketService = [ServiceFactory shareInstance].marketService;
        _wechatService = [ServiceFactory shareInstance].wechatService;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initGrid];
    [self initHead];
    [self loaddatas];
    [self.searchBar initDelagate:self placeholder:@"名称/款号"];
    [self.view addSubview:self.searchBar.view];
    
    self.searchBar.view.frame = CGRectMake(0, 64, 320, 44);
    NSArray* arr = nil;
    if ([self.isCanDeal isEqualToString:@"1"]) {
        arr=[[NSArray alloc] initWithObjects:@"add", @"batch", nil];
    } else {
        arr=[[NSArray alloc] init];
    }
    
    [self.footView initDelegate:self btnArrs:arr];
    
    __weak SalesStyleAreaView* weakSelf = self;
    [weakSelf.mainGrid ls_addHeaderWithCallback:^{
        _lastDateTime = nil;
        [weakSelf selectStyleList];
    }];
    
    [weakSelf.mainGrid ls_addFooterWithCallback:^{
        [weakSelf selectStyleList];
    }];
}

-(void) loaddatas
{
    if ([NSString isNotBlank:self.titleName]) {
        self.titleBox.lblTitle.text = self.titleName;
    }
    
    _searchBar.keyWordTxt.text = @"";
    _lastDateTime = nil;
    [self selectStyleList];
}

#pragma 从”选择条件添加“页面返回
-(void) loadDatasFromAddByConditionView
{
    _searchCode = nil;
    [self.mainGrid headerBeginRefreshing];
}

#pragma 从批量页面返回
-(void) loadDatasFromBatchOperateView
{
    _delOrEditFlg = YES;
    [self.mainGrid headerBeginRefreshing];
}

#pragma 从批量选择页面返回
-(void) loadDatasFromBatchSelectView
{
    _lastDateTime = nil;
    [self.mainGrid headerBeginRefreshing];
}

#pragma 查询促销款式列表
-(void) selectStyleList
{
    __weak SalesStyleAreaView* weakSelf = self;
    [_marketService selectStyleList:_searchCode discountId:_discountId discountType:_discountType lastDateTime:_lastDateTime completionHandler:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        [weakSelf responseSuccess:json];
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
    } errorHandler:^(id json) {
        [AlertBox show:json];
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
    }];
}

#pragma 后台返回数据封装
- (void)responseSuccess:(id)json
{
    NSMutableArray *array = [json objectForKey:@"saleStyleVoList"];
    if (_lastDateTime == nil || [_lastDateTime isEqualToString:@""]) {
        self.datas = [[NSMutableArray alloc] init];
    }
    if ([ObjectUtil isNotNull:array]) {
        for (NSDictionary* dic in array) {
            [self.datas addObject:[SaleStyleVo convertToSaleStyleVo:dic]];
        }
    }
    
    if ([NSString isNotBlank:_searchBar.keyWordTxt.text] && _searchType == 1 && (self.datas == nil || self.datas.count == 0) && [self.isCanDeal isEqualToString:@"1"]) {
        [AlertBox show:@"您查询的款式不在本次促销范围内，如需添加，请点击页面底部的添加按钮!"];
    }
    
    _searchType = 0;
    
    if ([ObjectUtil isNotNull:[json objectForKey:@"lastDateTime"]]) {
        _lastDateTime = [[json objectForKey:@"lastDateTime"] stringValue];
    }
    
    _styleCount = [[json objectForKey:@"styleNum"] intValue];
    
    if (!_delOrEditFlg) {
        if (_showViewCount == 0) {
            //第一次进入页面_showViewCount为0。保留原先的款式数量，设置_showViewCount为1
            _oldStyleCount = [[json objectForKey:@"styleNum"] intValue];
            //未保存 字段不显示
            _tipFlg = NO;
            _showViewCount = 1;
        } else {
            // 不是第一次进入页面，比较初始的款式数量和现在的对比
            if (_oldStyleCount == _styleCount) {
                //未保存 字段不显示
                _tipFlg = NO;
            } else {
                //未保存 字段显示
                _tipFlg = YES;
                [self.titleBox initWithName:@"款式范围" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
                if ([NSString isNotBlank:self.titleName]) {
                    self.titleBox.lblTitle.text = self.titleName;
                }
            }
        }
    } else {
        //未保存 字段显示
        _tipFlg = YES;
        [self.titleBox initWithName:@"款式范围" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
        if ([NSString isNotBlank:self.titleName]) {
            self.titleBox.lblTitle.text = self.titleName;
        }
    }
    
    if ([self.operateMode isEqualToString:@"add"]) {
        //未保存 字段显示
        _tipFlg = YES;
        [self.titleBox initWithName:@"款式范围" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
        if ([NSString isNotBlank:self.titleName]) {
            self.titleBox.lblTitle.text = self.titleName;
        }
    }
    
    [self.mainGrid reloadData];
    
    self.mainGrid.ls_show = YES;
}

#pragma mark 删除业务临时表
-(void) deleteTempTable
{
    __weak SalesStyleAreaView* weakSelf = self;
    [_wechatService deleteTempSelectStyles:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

#pragma mark 导航栏事件
-(void) onNavigateEvent:(Direct_Flag)event
{
    if (event == 1) {
        //删除业务临时表
        [self deleteTempTable];
        //返回到前一个编辑页面
        [self backToEditView];
    }else{
        __weak SalesStyleAreaView* weakSelf = self;
        [_marketService addSaleStyleList:_discountId discountType:_discountType completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            //删除业务临时表
            [weakSelf deleteTempTable];
            //返回到前一个编辑页面
            [weakSelf backToEditView];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }
}

#pragma mark 返回到编辑页面
-(void) backToEditView
{
    if (_action == PIECES_DISCOUNT_LIST_VIEW) {
        //返回到N件打折详情页面
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[PiecesDiscountEditView class]]) {
                PiecesDiscountEditView *listView = (PiecesDiscountEditView *)vc;
                [listView loaddatasFromGoodsOrStyleListView];
            }
        }
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    } else if (_action == BINDING_DISCOUNT_LIST_VIEW){
        //返回到捆绑打折详情页面
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[BindingDiscountEditView class]]) {
                BindingDiscountEditView *listView = (BindingDiscountEditView *)vc;
                [listView loaddatasFromGoodsOrStyleListView];
            }
        }
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
        
    } else if (_action == SALES_SEND_OR_SWAP_LIST_VIEW){
        //返回到满送详情页面
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[SaleSendOrSwapEditView class]]) {
                SaleSendOrSwapEditView *listView = (SaleSendOrSwapEditView *)vc;
                [listView loaddatasFromGoodsOrStyleListView];
            }
        }
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
        
    } else if (_action == SALES_MINUS_LIST_VIEW){
        //返回到满减详情页面
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[SaleMinusEditView class]]) {
                SaleMinusEditView *listView = (SaleMinusEditView *)vc;
                [listView loaddatasFromGoodsOrStyleListView];
            }
        }
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
        
    } else if (_action == SALES_COUPON_LIST_VIEW){
        //返回到优惠券详情页面
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[SaleCouponEditView class]]) {
                SaleCouponEditView *listView = (SaleCouponEditView *)vc;
                [listView loaddatasFromGoodsOrStyleListView];
            }
        }
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    } else if (_action == SPECIAL_OFFER_EDIT_VIEW) {//特价管里编辑页面
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

#pragma mark 跳转到批量操作页面
-(void) showBatchEvent
{
    SalesStyleBatchView* salesStyleBatchView = [[SalesStyleBatchView alloc] initWithNibName:[SystemUtil getXibName:@"SalesStyleBatchView"] bundle:nil styleList:_datas discountId:_discountId discountType:_discountType lastDateTime:_lastDateTime searchCode:_searchCode];
    [self.navigationController pushViewController:salesStyleBatchView animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
}

#pragma mark 搜索框检索
-(void) imputFinish:(NSString *)keyWord
{
    _searchType = 1;
    
    _searchCode = keyWord;
    _lastDateTime = nil;
    [self.mainGrid headerBeginRefreshing];
}

#pragma mark 跳转到添加选择页面
- (void) showAddEvent
{
    UIActionSheet *menu = [[UIActionSheet alloc]
                           initWithTitle:nil
                           delegate:self
                           cancelButtonTitle:@"取消"
                           destructiveButtonTitle:nil
                           otherButtonTitles: @"选择条件添加", @"选择款式添加", nil];
    menu.tag = 1;
    [menu showInView:self.view];
}

#pragma mark 点击删除单个款式
-(void) delObjEvent:(NSString *)event obj:(id)obj
{
    SaleStyleVo *tempVo = (SaleStyleVo*) obj;
    [self.datas removeObject:tempVo];
    _styleIdList = [[NSMutableArray alloc] init];
    [_styleIdList addObject:tempVo.styleId];
    UIActionSheet *menu = [[UIActionSheet alloc]
                           initWithTitle:@"确认要删除该款式吗?"
                           delegate:self
                           cancelButtonTitle:@"取消"
                           destructiveButtonTitle:nil
                           otherButtonTitles: @"确认", nil];
    menu.tag = 2;
    [menu showInView:self.view];
}

#pragma mark actionSheet协议
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1) {
        // 跳转到添加选择页面
        if (buttonIndex == 0) {
            // 跳转到选择条件添加页面
            AddStyleByConditionView* addStyleByConditionView = [[AddStyleByConditionView alloc] initWithNibName:[SystemUtil getXibName:@"AddStyleByConditionView"] bundle:nil discountId:_discountId shopId:[[Platform Instance] getkey:SHOP_ID] discountType:_discountType];
            [self.navigationController pushViewController:addStyleByConditionView animated:NO];
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
        } else if (buttonIndex == 1){
            // 跳转到选择款式添加页面
            StyleBatchChoiceView2* styleBatchChoiceView2 = [[StyleBatchChoiceView2 alloc] initWithNibName:[SystemUtil getXibName:@"StyleBatchChoiceView2"] bundle:nil];
            [self.navigationController pushViewController:styleBatchChoiceView2 animated:NO];
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
            [styleBatchChoiceView2 loaddatas:[[Platform Instance] getkey:SHOP_ID] type:@"1" callBack:^(NSMutableArray *styleList) {
                if (styleList) {
                    __weak SalesStyleAreaView* weakSelf = self;
                    NSMutableArray* list = [[NSMutableArray alloc] init];
                    for (ListStyleVo* temp in styleList) {
                        SalePackStyleVo* vo = [[SalePackStyleVo alloc] init];
                        vo.styleId = temp.styleId;
                        vo.styleName = temp.styleName;
                        vo.styleCode = temp.styleCode;
                        vo.createTime = temp.createTime;
                        vo.filePath = temp.filePath;
                        [list addObject:[SalePackStyleVo getDictionaryData:vo]];
                    }
                    [_marketService saveSalesStyleBySearch:list discountId:_discountId discountType:_discountType completionHandler:^(id json) {
                        if (!(weakSelf)) {
                            return ;
                        }
                        [weakSelf loadDatasFromBatchSelectView];
                    } errorHandler:^(id json) {
                        [AlertBox show:json];
                    }];
                }
                [styleBatchChoiceView2.navigationController popViewControllerAnimated:YES];
                [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
            }];
        }
    } else if (actionSheet.tag == 2) {
        // 点击删除款式操作
        if(buttonIndex==0){
            __weak SalesStyleAreaView* weakSelf = self;
            [_marketService deleteSalesStyle:_styleIdList discountId:_discountId discountType:_discountType completionHandler:^(id json) {
                if (!(weakSelf)) {
                    return ;
                }
                _delOrEditFlg = YES;
                _lastDateTime = nil;
                [weakSelf selectStyleList];
            } errorHandler:^(id json) {
                [AlertBox show:json];
            }];
        }
    }
    
}

#pragma mark table head
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GridColHead5 *headItem = (GridColHead5 *) [self.mainGrid dequeueReusableCellWithIdentifier:GridColHead2Indentifier];
    if (!headItem) {
        headItem = [[NSBundle mainBundle] loadNibNamed:@"GridColHead5" owner:self options:nil].lastObject;
    }
    
    [headItem initColHead:[NSString stringWithFormat:@"合计%d款", self.styleCount]];
    
    // 是否显示“未保存”标志
    if (_tipFlg) {
        headItem.lblTip.hidden = NO;
        headItem.lblTip.clipsToBounds = YES;
        headItem.lblTip.layer.cornerRadius = 2.0;
        self.titleBox.imgMore.hidden = NO;
        self.titleBox.lblRight.hidden = NO;
    }else{
        headItem.lblTip.hidden = YES;
        self.titleBox.imgMore.hidden = YES;
        self.titleBox.lblRight.hidden = YES;
        
    }
    
    return headItem;
}

#pragma mark 点击cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark table部分
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StyleAreaCell *detailItem = (StyleAreaCell *)[self.mainGrid dequeueReusableCellWithIdentifier:StyleAreaCellIndentifier];
    
    if (!detailItem) {
        detailItem = [[NSBundle mainBundle] loadNibNamed:@"StyleAreaCell" owner:self options:nil].lastObject;
    }
    
    detailItem.delegate = self;
    if ([ObjectUtil isNotEmpty:self.datas]) {
        SaleStyleVo *item = [self.datas objectAtIndex:indexPath.row];
        detailItem.saleStyleVo = item;
        detailItem.lblName.text = item.styleName;
        detailItem.lblStyleNo.text = [NSString stringWithFormat:@"款号：%@", item.styleCode];
        
        [detailItem.lblName setVerticalAlignment:VerticalAlignmentTop];
        //暂无图片
        UIImage* placeholder = [UIImage imageNamed:@"img_default.png"];
        //图片处理
        if (item.stylePic != nil && ![item.stylePic isEqualToString:@""]) {
            [detailItem.img.layer setMasksToBounds:YES];
            
            [detailItem.img.layer setCornerRadius:PANEL_OUTTER_CORNER_RADIUS];
            
            NSURL* url = [NSURL URLWithString:[NSString urlFilterRan:item.stylePic]];
            
            [detailItem.img sd_setImageWithURL:url placeholderImage:placeholder];
            
        }
        if ([self.isCanDeal isEqualToString:@"0"]) {
            [detailItem.btnDel setHidden:YES];
            [detailItem.btnDel setEnabled:NO];
            [detailItem.imgDel setHidden:YES];
        }
        detailItem.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        
    }
    return detailItem;
}

#pragma mark UITableView无section列表

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count == 0 ? 0 :self.datas.count;
}

#pragma navigateTitle.
-(void) initHead
{
    self.titleBox=[NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"款式范围" backImg:Head_ICON_BACK moreImg:Head_ICON_OK];
    self.titleBox.lblRight.text = @"保存";
    [self.titleDiv addSubview:self.titleBox];
}

-(void)initGrid
{
    self.mainGrid.opaque=YES;
    UIView* view=[ViewFactory generateFooter:88];
    view.backgroundColor=[UIColor clearColor];
    
    [self.mainGrid setTableFooterView:view];
    [self.mainGrid setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

@end
