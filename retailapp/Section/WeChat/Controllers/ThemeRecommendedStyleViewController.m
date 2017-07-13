//
//  GoodsSalePackManageListView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/8/17.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "ThemeRecommendedStyleViewController.h"
#import "LSWechatStyleManageViewController.h"
#import "NavigateTitle2.h"
#import "ObjectUtil.h"
#import "FooterListView2.h"
#import "SearchBar2.h"
#import "SalePackVo.h"
#import "SelectGoodsCell.h"
#import "GridColHead.h"
#import "UIHelper.h"
#import "WechatSalePackManageEditView.h"
#import "XHAnimalUtil.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "NameValueItemVO.h"
#import "DateUtils.h"
#import "SalePackVo.h"
#import "GridHead.h"

#import "IMultiNameValueItem.h"

@interface ThemeRecommendedStyleViewController ()

@property (nonatomic, strong) WechatService* wechatService;

@property (nonatomic,retain) NSMutableArray *headList;    //商品.
@property (nonatomic,retain) NSMutableDictionary *detailMap;

@property (nonatomic,retain) NSMutableArray* datas;

@property (nonatomic, retain) NSString *searchCode;

@property (nonatomic, retain) SalePackVo* tempVo;

@property (nonatomic,retain) NSMutableArray *IDList;

@property (nonatomic, retain) NSString *shopId;

@end

@implementation ThemeRecommendedStyleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _wechatService = [ServiceFactory shareInstance].wechatService;
    }
    return self;
}

-(void) loaddatas
{
    [self initHeadData];
    
    [self.mainGrid headerBeginRefreshing];
}

-(void) loaddatasFromEdit:(int) action salePackVo:(SalePackVo*) salePackVo
{
    if (action == ACTION_CONSTANTS_EDIT) {
        
        [self.mainGrid headerBeginRefreshing];
    }else if (action == ACTION_CONSTANTS_DEL){
        NSMutableArray* details = [self.detailMap objectForKey:[NSString stringWithFormat:@"%ld", salePackVo.applyYear]];
        for (SalePackVo* vo in details) {
            if (salePackVo.salePackId == vo.salePackId) {
                [details removeObject:vo];
                break;
            }
        }
        [self.mainGrid reloadData];
    }else if (action == ACTION_CONSTANTS_ADD){
        [self.mainGrid headerBeginRefreshing];
    }
}

-(void) selectSalePack
{
    __weak ThemeRecommendedStyleViewController* weakSelf = self;
    [_wechatService selectSalePackList:self.searchCode completionHandler:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf responseSuccess:json];
    } errorHandler:^(id json) {
        [weakSelf.mainGrid headerEndRefreshing];
        [AlertBox show:json];
    }];
}

- (void)responseSuccess:(id)json
{
    NSLog(@"%@",json);
    self.datas = [[NSMutableArray alloc] init];
    self.datas = [SalePackVo converToArr:[json objectForKey:@"salePackList"]];
    if ([ObjectUtil isNotNull:self.datas] && self.datas.count > 0) {
        self.detailMap=[NSMutableDictionary dictionary];
        NSMutableArray* details = nil;
        for (NameValueItemVO* vo in self.headList) {
            details=[NSMutableArray array];
            for (SalePackVo* item in self.datas) {
                //                NSLog(@"%@",item);
                if (item.applyYear == [vo obtainItemId].intValue) {
                    [details addObject:item];
                }
            }
            [self.detailMap setValue:details forKey:vo.itemId];
        }
    }else{
        [self.detailMap removeAllObjects];
    }
    
    [self.mainGrid reloadData];
}

-(void) initHeadData
{
    self.headList=[NSMutableArray array];
    NSString* date = [NSString stringWithFormat:@"%d", [DateUtils formateDate4:[NSDate date]].intValue + 1];
    NameValueItemVO* item=[[NameValueItemVO alloc] initWithVal:[NSString stringWithFormat:@"%@年", date] val:date andId:date];
    [self.headList addObject:item];
    NSString* date1 = [DateUtils formateDate4:[NSDate date]];
    item=[[NameValueItemVO alloc] initWithVal:[NSString stringWithFormat:@"%@年", date1] val:date1 andId:date1];
    [self.headList addObject:item];
    
    
}

#pragma navigateTitle.
-(void) initHead
{
    self.titleBox=[NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"选择主题销售包" backImg:Head_ICON_BACK moreImg:nil];
    [self.titleDiv addSubview:self.titleBox];
}

-(void) showAddEvent
{
    WechatSalePackManageEditView* wechatSalePackManageEditView = [[WechatSalePackManageEditView alloc] initWithNibName:[SystemUtil getXibName:@"WechatSalePackManageEditView"] bundle:nil action:ACTION_CONSTANTS_ADD salePackId:nil];
    [self.navigationController pushViewController:wechatSalePackManageEditView animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
}

-(void) showHelpEvent{
    
}


-(void) onNavigateEvent:(Direct_Flag)event
{

    if (event==1) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }else if (event==2){
        [self save];
    }
}

-(void) imputFinish:(NSString *)keyWord
{
    self.searchCode = keyWord;
    [self selectSalePack];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NameValueItemVO *head = [self.headList objectAtIndex:indexPath.section];
    if ([ObjectUtil isNotNull:head]) {
        NSMutableArray *temps = [self.detailMap objectForKey:head.itemId];
        _tempVo = [temps objectAtIndex:indexPath.row];
        id<IMultiNameValueItem> item = (id<IMultiNameValueItem>)_tempVo;
        if (item) {
            [item mCheckVal:![item obtainCheckVal]];
            [self.mainGrid reloadData];
        }
        [self changeNavigate];
    }
    
    
//    id<IMultiNameValueItem> item=[self.datas objectAtIndex: indexPath.row];
//    if (item) {
//        [item mCheckVal:![item obtainCheckVal]];
//        [self.mainGrid reloadData];
//    }
//    [self changeNavigate];
}

- (void)changeNavigate
{
    __block BOOL isChange = NO;
    if (self.datas.count>0) {
        [self.datas enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            id<IMultiNameValueItem> item = (id<IMultiNameValueItem>)obj;
            if ([item obtainCheckVal]) {
                isChange = YES;
                *stop = YES;
            }
        }];
    }
    [self.titleBox editTitle:isChange act:ACTION_CONSTANTS_EDIT];
}

#pragma table部分
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NameValueItemVO *head = [self.headList objectAtIndex:indexPath.section];
    
    if ([ObjectUtil isNotNull:head]) {
        NSMutableArray *temps = [self.detailMap objectForKey:head.itemId];
        if (temps!=nil ) {
            SelectGoodsCell *detailItem = (SelectGoodsCell *)[self.mainGrid dequeueReusableCellWithIdentifier:WechatSalePackCellIndentifier];
            
            if (!detailItem) {
                detailItem = [[NSBundle mainBundle] loadNibNamed:@"SelectGoodsCell" owner:self options:nil].lastObject;
            }
            
            if ([ObjectUtil isNotNull:temps]) {
                SalePackVo* item = [temps objectAtIndex:indexPath.row];
                NSMutableArray *temps = [self.detailMap objectForKey:head.itemId];
                _tempVo = [temps objectAtIndex:indexPath.row];
                id<IMultiNameValueItem> item1 = (id<IMultiNameValueItem>)_tempVo;
                detailItem.lblName.text = item.packName;
                detailItem.lblCode.text = [NSString stringWithFormat:@"编号：%@",item.packCode];
                detailItem.selectionStyle = UITableViewCellSelectionStyleNone;
                [detailItem.checkPic setHidden:![item1 obtainCheckVal]];
                
                return detailItem;
            }
        }
    }
    
    
    abort();
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    NSMutableArray *array=[[NSMutableArray alloc] initWithArray:self.headList];
    // array=(NSMutableArray *)[[array reverseObjectEnumerator] allObjects];
    NameValueItemVO *head = [self.headList objectAtIndex:section];
    GridHead *headItem = (GridHead *)[tableView dequeueReusableCellWithIdentifier:GridHeadIndentifier];
    
    if (!headItem) {
        headItem = [[NSBundle mainBundle] loadNibNamed:@"GridHead" owner:self options:nil].lastObject;
    }
    headItem.selectionStyle = UITableViewCellSelectionStyleNone;
    [headItem initDelegate:self obj:head event:@"salePack"];
    [headItem initOperateWithAdd:NO edit:NO];
    return headItem;
}

#pragma mark UITableView无section列表

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return (self.headList!=nil?self.headList.count:0);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NameValueItemVO *head = [self.headList objectAtIndex:section];
    if ([ObjectUtil isNotNull:head]) {
        NSMutableArray *temps = [self.detailMap objectForKey:head.itemId];
        if ([ObjectUtil isNotNull:temps]) {
            return temps.count;
        } else {
            return 0;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initHead];
    [self.searchBar initDelagate:self placeholder:@"名称/编号"];
    [self.view addSubview:self.searchBar.view];
    
    self.searchBar.view.frame = CGRectMake(0, 64, 320, 44);
   
    
    __weak ThemeRecommendedStyleViewController* weakSelf = self;
    [weakSelf.mainGrid ls_addHeaderWithCallback:^{
        [weakSelf selectSalePack];
    }];
    
    [self loaddatas];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)save{
    self.IDList=[NSMutableArray array];
    for (id<IMultiNameValueItem> item in self.datas) {
        if ([item obtainCheckVal]) {
            [self.IDList addObject:[item obtainItemId]];
        }
    }
    _shopId = [[Platform Instance] getkey:SHOP_ID];

    __weak ThemeRecommendedStyleViewController* weakSelf = self;
    [_wechatService addSalePacksToSale:self.IDList shopId:_shopId completionHandler:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        [weakSelf.navigationController popViewControllerAnimated:NO];
        [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
    } errorHandler:^(id json) {
        [weakSelf.mainGrid headerEndRefreshing];
        [AlertBox show:json];
    } ];
    
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
