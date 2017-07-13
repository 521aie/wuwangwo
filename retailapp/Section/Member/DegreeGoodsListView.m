//
//  DegreeGoodsView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/7/22.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "DegreeGoodsListView.h"
#import "NavigateTitle2.h"
#import "MemberModule.h"
#import "UIHelper.h"
#import "GoodsGiftVo.h"
#import "MemberDegreeGoodsCell.h"
#import "ObjectUtil.h"
#import "UIImageView+WebCache.h"
#import "NSString+Estimate.h"
#import "SearchBar3.h"
#import "PaperFooterListView.h"
#import "DegreeGoodsEditView.h"
#import "KxMenu.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "JsonHelper.h"
#import "Platform.h"
#import "ViewFactory.h"
#import "GoodsSingleChoiceView.h"
#import "XHAnimalUtil.h"
#import "GoodsVo.h"
#import "GoodsSingleChoiceView2.h"
#import "StyleGoodsVo.h"
#import "GoodsSkuVo.h"
#import "ColorHelper.h"
#import "ScanViewController.h"

@interface DegreeGoodsListView ()<LSScanViewDelegate>

@property (nonatomic, strong) MemberService* memberService;

@property (nonatomic,strong) NSArray* menuItems;

/**
 1表示为从搜索框搜索，当查询出来为一条信息时，跳转到下一个页面
 */
@property (nonatomic) short isJump;

@end

@implementation DegreeGoodsListView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _memberService = [ServiceFactory shareInstance].memberService;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initHead];
    [self initGrid];
    
    if ([[[Platform Instance] getkey:SHOP_MODE] integerValue] == 101) {
        [self.searchBar3 initDeleagte:self withName:@"店内码" placeholder:@""];
        [self.searchBar3 showCondition:YES];
    }else{
        [self.searchBar3 initDeleagte:self withName:@"店内码" placeholder:@"条形码/简码/拼音码"];
        [self.searchBar3 showCondition:NO];
    }
    [self initData];
    NSArray* arr=[[NSArray alloc] initWithObjects:@"add", @"scan", nil];
    [self.footView initDelegate:self btnArrs:arr];
    __weak DegreeGoodsListView* weakSelf = self;
    [self.mainGrid addHeaderWithCallback:^{
        [weakSelf selectDegreeGoodsList];
    }];
    self.footView.btnHelp.hidden = YES;
    [self loaddatas];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loaddatas
{
    self.searchBar3.txtKeyWord.text = @"";
    if ([[Platform Instance] getkey:SHOP_MODE].integerValue == 101) {
        self.searchType = @"店内码";
    }else{
        self.searchType = @"";
    }
    self.searchCode = @"";
    [self selectDegreeGoodsList];
}

- (void)selectDegreeGoodsList
{
    self.mainGrid.loading = YES;
    __weak DegreeGoodsListView* weakSelf = self;
    [_memberService selectDegreeGoodsList:[NSString isBlank:self.searchBar3.txtKeyWord.text]? @"":self.searchType searchCode:self.searchBar3.txtKeyWord.text completionHandler:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        [self responseSuccess:json];
        [self.mainGrid headerEndRefreshing];
    } errorHandler:^(id json) {
        [AlertBox show:json];
        [self.mainGrid headerEndRefreshing];
    }];
}

- (void)responseSuccess:(id)json {
    NSMutableArray *array = [json objectForKey:@"goodsGiftList"];
    self.datas = [[NSMutableArray alloc] init];
    for (NSDictionary* dic in array) {
        [self.datas addObject:[GoodsGiftVo convertToGoodsGiftVo:dic]];
    }
    [self.mainGrid reloadData];
    self.mainGrid.loading = NO;
}

- (void)onNavigateEvent:(Direct_Flag)event
{
    if (event == 1) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

#pragma mark - navigateTitle.
- (void)initHead {
    self.titleBox=[NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"积分商品" backImg:Head_ICON_BACK moreImg:nil];
    [self.titleDiv addSubview:self.titleBox];
}

// 搜索框输入完成方法
- (void)imputFinish:(NSString *)keyWord {
    self.mainGrid.loading = YES;
    self.searchCode = keyWord;
    __weak DegreeGoodsListView* weakSelf = self;
    [_memberService selectDegreeGoodsList:[NSString isBlank:self.searchBar3.txtKeyWord.text]? @"":self.searchType searchCode:self.searchCode completionHandler:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        NSMutableArray *array = [json objectForKey:@"goodsGiftList"];
        self.datas = [[NSMutableArray alloc] init];
        for (NSDictionary* dic in array) {
            [self.datas addObject:[GoodsGiftVo convertToGoodsGiftVo:dic]];
        }
        
        _isJump = 1;
        
        if (self.datas.count == 1 && _isJump == 1) {
            GoodsGiftVo *editObj = [self.datas objectAtIndex:0];
            DegreeGoodsEditView* degreeGoodsEditView = [[DegreeGoodsEditView alloc] initWithNibName:[SystemUtil getXibName:@"DegreeGoodsEditView"] bundle:nil goodsGiftVo:editObj action:ACTION_CONSTANTS_EDIT];
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
            [self.navigationController pushViewController:degreeGoodsEditView animated:NO];
        }
        
        _isJump = 0;
        
        [self.mainGrid reloadData];
        
        self.mainGrid.loading = NO;
        [self.mainGrid headerEndRefreshing];
    } errorHandler:^(id json) {
        [AlertBox show:json];
        [self.mainGrid headerEndRefreshing];
    }];
}

- (void)showHelpEvent
{
    
}


#pragma mark - 扫一扫
// 搜索框左侧扫一扫按钮
- (void)scanStart {
    ScanViewController *vc = [ScanViewController shareInstance:self types:LSScannerBarcode];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
}
// 底部扫一扫按钮
- (void)showScanEvent
{
    ScanViewController *vc = [ScanViewController shareInstance:self types:LSScannerBarcode];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
}

// LSScanDelegate
- (void)scanFail:(ScanViewController *)controller with:(NSString *)message {
    [AlertBox show:message];
}

- (void)scanSuccess:(ScanViewController *)controller result:(NSString *)scanString {
    
    self.searchBar3.txtKeyWord.text = scanString;
    self.searchBar3.lblName.text = @"条形码";
    self .mainGrid.loading = YES;
    __weak DegreeGoodsListView* weakSelf = self;
    [_memberService selectDegreeGoodsList:@"条形码" searchCode:scanString completionHandler:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        NSMutableArray *array = [json objectForKey:@"goodsGiftList"];
        weakSelf.datas = [[NSMutableArray alloc] init];
        for (NSDictionary* dic in array) {
            [weakSelf.datas addObject:[GoodsGiftVo convertToGoodsGiftVo:dic]];
        }
        if (weakSelf.datas.count == 1) {
            GoodsGiftVo *editObj = [weakSelf.datas objectAtIndex:0];
            DegreeGoodsEditView* degreeGoodsEditView = [[DegreeGoodsEditView alloc] initWithNibName:[SystemUtil getXibName:@"DegreeGoodsEditView"] bundle:nil goodsGiftVo:editObj action:ACTION_CONSTANTS_EDIT];
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
            [self.navigationController pushViewController:degreeGoodsEditView animated:NO];
        }
        
        [self.mainGrid reloadData];
        self .mainGrid.loading = NO;
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];

}

- (void)showAddEvent
{
    if ([[[Platform Instance] getkey:SHOP_MODE] integerValue] == 101) {
        
        GoodsSingleChoiceView2* goodsSingleChoiceView2 = [[GoodsSingleChoiceView2 alloc] initWithNibName:[SystemUtil getXibName:@"GoodsSingleChoiceView2"] bundle:nil];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
        [self.navigationController pushViewController:goodsSingleChoiceView2 animated:NO];
        __weak DegreeGoodsListView* weakSelf = self;
        [goodsSingleChoiceView2 loaddatas:@"" callBack:^(StyleGoodsVo *goodsItem) {
            if (goodsItem) {
                GoodsGiftVo* goodsGiftVo = [[GoodsGiftVo alloc] init];
                goodsGiftVo.goodsId = goodsItem.goodsId;
                goodsGiftVo.name = goodsItem.name;
                goodsGiftVo.innerCode = goodsItem.innerCode;
                goodsGiftVo.price = goodsItem.retailPrice;
                goodsGiftVo.picture = goodsItem.filePath;
                for (GoodsSkuVo* vo in goodsItem.goodsSkuVoList) {
                    if ([vo.attributeName isEqualToString:@"颜色"]) {
                        goodsGiftVo.goodsColor = vo.attributeVal;
                    }
                }
                
                for (GoodsSkuVo* vo in goodsItem.goodsSkuVoList) {
                    if ([vo.attributeName isEqualToString:@"尺码"]) {
                        goodsGiftVo.goodsSize = vo.attributeVal;
                    }
                }
                DegreeGoodsEditView* degreeGoodsEditView = [[DegreeGoodsEditView alloc] initWithNibName:[SystemUtil getXibName:@"DegreeGoodsEditView"] bundle:nil goodsGiftVo:goodsGiftVo action:ACTION_CONSTANTS_ADD];
                [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
                [weakSelf.navigationController pushViewController:degreeGoodsEditView animated:NO];
            }else{
                [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
                [weakSelf.navigationController popToViewController:weakSelf animated:NO];
                [weakSelf selectDegreeGoodsList];
            }
            
        }];
    }else{
        GoodsSingleChoiceView* goodsSingleChoiceView = [[GoodsSingleChoiceView alloc] initWithNibName:[SystemUtil getXibName:@"GoodsSingleChoiceView"] bundle:nil];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
        goodsSingleChoiceView.giftGoodsFlg = @"1";
        [self.navigationController pushViewController:goodsSingleChoiceView animated:NO];
        __weak DegreeGoodsListView* weakSelf = self;
        [goodsSingleChoiceView loaddatas: @"" callBack:^(GoodsVo *goodsItem) {
            if (goodsItem) {
                GoodsGiftVo* goodsGiftVo = [[GoodsGiftVo alloc] init];
                goodsGiftVo.goodsId = goodsItem.goodsId;
                goodsGiftVo.name = goodsItem.goodsName;
                goodsGiftVo.barCode = goodsItem.barCode;
                goodsGiftVo.number = [goodsItem.number integerValue];
                goodsGiftVo.price = goodsItem.retailPrice;
                goodsGiftVo.picture = goodsItem.filePath;
                DegreeGoodsEditView* degreeGoodsEditView = [[DegreeGoodsEditView alloc] initWithNibName:[SystemUtil getXibName:@"DegreeGoodsEditView"] bundle:nil goodsGiftVo:goodsGiftVo action:ACTION_CONSTANTS_ADD];
                [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
                [weakSelf.navigationController pushViewController:degreeGoodsEditView animated:NO];
            }else{
                [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
                [weakSelf.navigationController popToViewController:weakSelf animated:NO];
                [weakSelf selectDegreeGoodsList];
            }
        }];

    }
}



- (void)showEditNVItemEvent:(NSString *)event withObj:(id<INameValueItem>)obj {
    GoodsGiftVo *editObj = (GoodsGiftVo *) obj;
    DegreeGoodsEditView* degreeGoodsEditView = [[DegreeGoodsEditView alloc] initWithNibName:[SystemUtil getXibName:@"DegreeGoodsEditView"] bundle:nil goodsGiftVo:editObj action:ACTION_CONSTANTS_EDIT];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    [self.navigationController pushViewController:degreeGoodsEditView animated:NO];
    
}

//#pragma table部分
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.datas != nil) {
        [self showEditNVItemEvent:@"memberDegreeGoods" withObj:[self.datas objectAtIndex:indexPath.row]];
    }
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MemberDegreeGoodsCell *detailItem = (MemberDegreeGoodsCell *)[self.mainGrid dequeueReusableCellWithIdentifier:MemberSelectCellIndentifier];
    
    if (!detailItem) {
        detailItem = [[NSBundle mainBundle] loadNibNamed:@"MemberDegreeGoodsCell" owner:self options:nil].lastObject;
    }
    
    if ([ObjectUtil isNotEmpty:self.datas]) {
        GoodsGiftVo *item = [self.datas objectAtIndex:indexPath.row];
        detailItem.lblName.text = item.name;
        detailItem.lblDegree.text = [NSString stringWithFormat:@"%ld积分", item.point];
        if ([[Platform Instance] getkey:SHOP_MODE].integerValue == 101 || [[Platform Instance] getkey:SHOP_MODE].integerValue == 1) {
            detailItem.lblCode.text = item.innerCode;
            detailItem.lblAttribute.text = [NSString stringWithFormat:@"%@ %@", item.goodsColor, item.goodsSize];
        }else{
            detailItem.lblCode.text = item.barCode;
            detailItem.lblAttribute.text = @"";
        }
        
        [detailItem.lblName setTextColor:[ColorHelper getTipColor3]];
        [detailItem.lblCode setTextColor:[ColorHelper getTipColor6]];
        [detailItem.lblAttribute setTextColor:[ColorHelper getTipColor6]];
        [detailItem.lblDegree setTextColor:[ColorHelper getRedColor]];
        
        //暂无图片
        UIImage* placeholder = [UIImage imageNamed:@"img_default.png"];
        
        if (item.picture != nil && ![item.picture isEqualToString:@""]) {
            [detailItem.img.layer setMasksToBounds:YES];
            
            [detailItem.img.layer setCornerRadius:PANEL_OUTTER_CORNER_RADIUS];
            
            NSURL* url = [NSURL URLWithString:[NSString urlFilterRan:item.picture]];
            
            [detailItem.img sd_setImageWithURL:url placeholderImage:placeholder];
            
        }
        detailItem.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    return detailItem;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count == 0 ? 0 :self.datas.count;
}

- (void)initData
{
    if (_menuItems==nil|| _menuItems.count==0) {
        _menuItems = @[
                       [KxMenuItem menuItem:@"款号"
                                      image:nil
                                     target:self
                                     action:@selector(pushMenuItem:)],
                       
                       [KxMenuItem menuItem:@"条形码"
                                      image:nil
                                     target:self
                                     action:@selector(pushMenuItem:)],
                       
                       [KxMenuItem menuItem:@"店内码"
                                      image:nil
                                     target:self
                                     action:@selector(pushMenuItem:)],
                       
                       [KxMenuItem menuItem:@"拼音码"
                                      image:nil
                                     target:self
                                     action:@selector(pushMenuItem:)],
                       ];
    }
}

- (void)pushMenuItem:(id)sender
{
    KxMenuItem* item = (KxMenuItem*)sender;
    [self.searchBar3 changeLimitCondition:item.title];
    self.searchType = item.title;
}

#pragma mark - searchbar
- (void)selectCondition
{
    CGRect rect = CGRectMake(47, self.searchBar3.frame.origin.y, 80, 32);
    [KxMenu showMenuInView:self.view fromRect:rect menuItems:_menuItems];
}

- (void)initGrid
{
    self.mainGrid.opaque=YES;
    UIView* view=[ViewFactory generateFooter:88];
    view.backgroundColor=[UIColor clearColor];
    
    [self.mainGrid setTableFooterView:view];
    [self.mainGrid setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

@end
