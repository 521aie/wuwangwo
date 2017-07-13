//
//  GoodsStyleBatchSelectView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/8/10.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GoodsStyleBatchSelectView.h"
#import "StyleVo.h"
#import "UIHelper.h"
#import "GoodsStyleBatchSelectCell.h"
#import "ObjectUtil.h"
#import "SearchBar2.h"
#import "ViewFactory.h"
#import "ListStyleVo.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "StyleTopSelectView.h"
#import "GoodsStyleListView.h"
#import "XHAnimalUtil.h"
#import "GoodsBatchSaleSettingView.h"
#import "DateUtils.h"

@interface GoodsStyleBatchSelectView ()

@property (nonatomic, strong) GoodsService *goodsService;

@property (nonatomic, strong) ListStyleVo *listStyleVo;

@property (nonatomic, strong) NSString *searchCode;

@property (nonatomic, strong) NSString* createTime;

@property (nonatomic, strong) NSString *shopId;

@property (nonatomic, strong) NSString *shopName;

//1: 筛选  2: 操作
@property (nonatomic, strong) NSString* showFlg;

@property (nonatomic, strong) NSMutableArray* styleIdList;

@property (nonatomic) short type;

@end

@implementation GoodsStyleBatchSelectView


- (void)viewDidLoad {
    [super viewDidLoad];
    _goodsService = [ServiceFactory shareInstance].goodsService;
    [self initHead];
    [self configViews];
    [self initGrid];
    [self loadDatas];
}
- (void)configViews {
    CGFloat y = kNavH;
    self.searchBar = [SearchBar2 searchBar2];
    [self.searchBar initDelagate:self placeholder:@"名称/款号"];
    [self.view addSubview:self.searchBar];
    self.searchBar.ls_top = y;
    y = y + self.searchBar.ls_height;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, y, SCREEN_W, SCREEN_H - kNavH)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    __weak GoodsStyleBatchSelectView* weakSelf = self;
    [weakSelf.tableView ls_addHeaderWithCallback:^{
        _createTime = nil;
        [weakSelf selectStyleList];
    }];
    
    [weakSelf.tableView ls_addFooterWithCallback:^{
        [weakSelf selectStyleList];
    }];
    [self.view addSubview:self.tableView];
    
    self.footView = [LSFooterView footerView];
    [self.footView initDelegate:self btnsArray:@[kFootSelectAll, kFootSelectNo]];
    [self.view addSubview:self.footView];
    self.footView.ls_bottom = SCREEN_H;
}

- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootSelectNo]) {
        [self notCheckAllEvent];
    } else if ([footerType isEqualToString:kFootSelectAll]) {
        [self checkAllEvent];
    }
}


-(void) loadDatas
{
    
    [self.tableView setContentOffset:CGPointMake(0, 0)animated:NO];
    _showFlg = @"1";
    _shopId = [_condition objectForKey:@"shopId"];
    _shopName = [_condition objectForKey:@"shopName"];
    _createTime = [_condition objectForKey:@"createTime"];
    self.searchBar.keyWordTxt.text = [_condition objectForKey:@"searchCode"];
    _styleList = [[NSMutableArray alloc] init];
    [self.tableView reloadData];
    self.tableView.ls_show = YES;
    
}

-(void) loadDatasFromSelect:(NSMutableDictionary *)condition
{
    _condition = condition;
    _createTime = [_condition objectForKey:@"createTime"];
    [self.tableView headerBeginRefreshing];
}

-(void) loadDatasFromOperateView:(int) action
{
    if (action == ACTION_CONSTANTS_DEL) {
        for (ListStyleVo* vo in _styleList) {
            if ([vo.isCheck isEqualToString:@"1"]) {
                [self.datas removeObject:vo];
            }
        }
    }
    [self.tableView reloadData];
    
    self.tableView.ls_show = YES;
}

-(void) selectStyleList
{
    
    __weak GoodsStyleBatchSelectView* weakSelf = self;
    [_condition setValue:@YES forKey:@"needUpDownStatus"];//非必传 如果需要上下架这个参数传
    [_condition setValue:_createTime != nil? _createTime:@"" forKey:@"createTime"];
    [_goodsService selectStyleList:_condition completionHandler:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        [weakSelf responseSuccess:json];
        [weakSelf.tableView headerEndRefreshing];
        [weakSelf.tableView footerEndRefreshing];
    } errorHandler:^(id json) {
        [AlertBox show:json];
        [weakSelf.tableView headerEndRefreshing];
        [weakSelf.tableView footerEndRefreshing];
    }];
}

-(void) responseSuccess:(id)json
{
    if ([[json objectForKey:@"searchStatus"] integerValue] == 1) {
        NSMutableArray *array = [json objectForKey:@"styleVoList"];
        if (_createTime == nil || [_createTime isEqualToString:@""]) {
            self.datas = [[NSMutableArray alloc] init];
        }
        if ([ObjectUtil isNotNull:array]) {
            for (NSDictionary* dic in array) {
                [self.datas addObject:[ListStyleVo convertToListStyleVo:dic]];
            }
        }
        
        if ([ObjectUtil isNotNull:[json objectForKey:@"createTime"]]) {
            _createTime = [[json objectForKey:@"createTime"] stringValue];
        }
    } else if ([[json objectForKey:@"searchStatus"] integerValue] == 0) {
        _createTime = @"";
        [self.datas removeAllObjects];
    }
    
    [self.tableView reloadData];
    
    self.tableView.ls_show = YES;
}

#pragma navigateTitle.
-(void) initHead
{
    [self configTitle:@"选择款式" leftPath:Head_ICON_CANCEL rightPath:nil];
    [self configNavigationBar:LSNavigationBarButtonDirectRight title:@"筛选" filePath:Head_ICON_CHOOSE];
}

#pragma mark 导航栏.
-(void) onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event==LSNavigationBarButtonDirectLeft) {
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[GoodsStyleListView class]]) {
                GoodsStyleListView *goodsVc = (GoodsStyleListView *)vc;
                [goodsVc loadDatasFromBatchSelectView];
                [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
                [self.navigationController popViewControllerAnimated:NO];
            }
        }
    }else{
        if ([_showFlg isEqualToString:@"1"]) {
            [self loadStyleTopSelectView];
            self.styleTopSelectView.delegate = self;
            self.styleTopSelectView.shopId = _shopId;
            self.styleTopSelectView.shopName = _shopName;
            self.styleTopSelectView.fromViewTag = GOODS_STYLE_BATCH_SELECT_VIEW;
            [self.styleTopSelectView oper];
            self.styleTopSelectView.conditionOfInit = self.conditionOfBatchView;
            [self.styleTopSelectView loaddatas];
        }else{
            // 连锁总部，微店开通
            if ([[Platform Instance] getShopMode] == 3 && [[[Platform Instance] getkey:PARENT_ID] isEqualToString:@"0"] && [[Platform Instance] getMicroShopStatus] == 2) {
                UIActionSheet *menu = [[UIActionSheet alloc]
                                       initWithTitle: @"请选择批量操作"
                                       delegate:self
                                       cancelButtonTitle:@"取消"
                                       destructiveButtonTitle:nil
                                       otherButtonTitles: @"删除", @"销售设置", @"上架", @"下架", nil];
                [menu showInView:self.view];
            } else {
                UIActionSheet *menu = [[UIActionSheet alloc]
                                       initWithTitle: @"请选择批量操作"
                                       delegate:self
                                       cancelButtonTitle:@"取消"
                                       destructiveButtonTitle:nil
                                       otherButtonTitles: @"删除", @"销售设置", @"上架", @"下架", nil];
                [menu showInView:self.view];
            }
        }

    }
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    _styleIdList = [[NSMutableArray alloc] init];
    if (_styleList.count > 0) {
        for (ListStyleVo* vo in _styleList) {
            [_styleIdList addObject:vo.styleId];
        }
    }
    if (buttonIndex == 0) {
        //删除
        if ([[Platform Instance] lockAct:ACTION_GOODS_STYLE_DELETE]) {
            [AlertBox show:@"登录用户无该权限!"];
            return ;
        } else {
            static UIAlertView *alertView;
            if (alertView != nil) {
                [alertView dismissWithClickedButtonIndex:0 animated:NO];
                alertView = nil;
            }
            alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确认删除选中的款式吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认" , nil];
            _type = 1;
            [alertView show];
        }
    } else if (buttonIndex == 1) {
        if ([[Platform Instance] lockAct:ACTION_MARKET_SET]) {
            [AlertBox show:@"登录用户无该权限!"];
            return ;
        } else {
            GoodsBatchSaleSettingView* vc = [[GoodsBatchSaleSettingView alloc] initWithIdList:_styleIdList fromView:GOODS_STYLE_BATCH_SELECT_VIEW];
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
            [self.navigationController pushViewController:vc animated:NO];
            __weak GoodsStyleBatchSelectView* weakSelf = self;
            [vc loaddatas:^(BOOL flg) {
                [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
                if (flg) {
                    [weakSelf notCheckAllEvent];
                }
                [weakSelf.navigationController popToViewController:weakSelf animated:NO];
            }];
        }
    } else if (buttonIndex == 2) {
        if ([[Platform Instance] lockAct:ACTION_GOODS_STYLE_EDIT]) {
            [AlertBox show:@"登录用户无该权限!"];
            return ;
        } else {
            __weak GoodsStyleBatchSelectView* weakSelf = self;
            [_goodsService setStyleUpDownStatus:_styleIdList shopId:_shopId status:@"1" completionHandler:^(id json) {
                if (!(weakSelf)) {
                    return ;
                }
                [AlertBox show:@"批量款式上架成功!"];
            } errorHandler:^(id json) {
                [AlertBox show:json];
            }];
        }
        
    } else if (buttonIndex == 3) {
        if ([[Platform Instance] lockAct:ACTION_GOODS_STYLE_EDIT]) {
            [AlertBox show:@"登录用户无该权限!"];
            return ;
        } else {
            //下架
            __weak GoodsStyleBatchSelectView* weakSelf = self;
            [_goodsService setStyleUpDownStatus:_styleIdList shopId:_shopId status:@"2" completionHandler:^(id json) {
                if (!(weakSelf)) {
                    return ;
                }
                [AlertBox show:@"批量款式下架成功!"];
            } errorHandler:^(id json) {
                [AlertBox show:json];
            }];
        }
    } 
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        __weak GoodsStyleBatchSelectView* weakSelf = self;
        switch (_type) {
            case 1:
            {
                //删除
                [_goodsService deleteStyle:_shopId styleIdList:_styleIdList completionHandler:^(id json) {
                    if (!(weakSelf)) {
                        return ;
                    }
                    [AlertBox show:@"批量删除款式成功!"];
                    _showFlg = @"1";
                    [self configNavigationBar:LSNavigationBarButtonDirectRight title:@"筛选" filePath:Head_ICON_CHOOSE];
                    [self loadDatasFromOperateView:ACTION_CONSTANTS_DEL];
                } errorHandler:^(id json) {
                    [AlertBox show:json];
                }];
                break;
            }
            default:
                break;
        }
    }
}

/*加载商品款式筛选页面*/
- (void)loadStyleTopSelectView
{
    if (self.styleTopSelectView) {
        self.styleTopSelectView.view.hidden = NO;
    }else{
        self.styleTopSelectView = [[StyleTopSelectView alloc] initWithNibName:[SystemUtil getXibName:@"StyleTopSelectView"] bundle:nil];
        [self.view addSubview:self.styleTopSelectView.view];
    }
}


-(void) showStyleListView:(NSMutableDictionary *)condition
{
    self.searchBar.keyWordTxt.text = @"";
    [self loadDatasFromSelect:condition];
}

-(void) checkAllEvent
{
    _styleList = [[NSMutableArray alloc] initWithCapacity:self.datas.count];
    for (ListStyleVo *vo in self.datas) {
        vo.isCheck = @"1";
        [_styleList addObject:vo];
    }
    
    
    if (_styleList.count > 0) {
        _showFlg = @"2";
       [self configNavigationBar:LSNavigationBarButtonDirectRight title:@"操作" filePath:Head_ICON_OK];
    }
    
    [self.tableView reloadData];
}

-(void) notCheckAllEvent
{
    for (ListStyleVo *vo in self.datas) {
        vo.isCheck = @"0";
    }
    [_styleList removeAllObjects];
    _showFlg = @"1";
    [self configNavigationBar:LSNavigationBarButtonDirectRight title:@"筛选" filePath:Head_ICON_CHOOSE];
    
    [self.tableView reloadData];
}

-(void) imputFinish:(NSString *)keyWord
{
    [self configNavigationBar:LSNavigationBarButtonDirectRight title:@"筛选" filePath:Head_ICON_CHOOSE];
    _showFlg = @"1";
    [_styleList removeAllObjects];
    
    _searchCode = keyWord;
    [_condition setValue:_searchCode forKey:@"searchCode"];
    [_condition setValue:@"" forKey:@"createTime"];
    [_condition setValue:@"1" forKey:@"searchType"];
    [self.tableView headerBeginRefreshing];
}

#pragma table部分
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsStyleBatchSelectCell *detailItem = (GoodsStyleBatchSelectCell *)[self.tableView dequeueReusableCellWithIdentifier:GoodsStyleBatchSelectCellIndentifier];
    
    if (!detailItem) {
        detailItem = [[NSBundle mainBundle] loadNibNamed:@"GoodsStyleBatchSelectCell" owner:self options:nil].lastObject;
    }
    
    if ([ObjectUtil isNotEmpty:self.datas]) {
        ListStyleVo *item = [self.datas objectAtIndex:indexPath.row];
        detailItem.lblName.text = item.styleName;
        detailItem.lblStyleNo.text = item.styleCode;

        if (item.isCheck == nil || [item.isCheck isEqualToString:@""] || [item.isCheck isEqualToString:@"0"]) {
            detailItem.imgUnCheck.hidden = NO;
            detailItem.imgCheck.hidden = YES;
        }else{
            detailItem.imgUnCheck.hidden = YES;
            detailItem.imgCheck.hidden = NO;
        }
        if (item.upDownStatus == 2) {
            detailItem.img_updown.hidden = NO;
        } else {
            detailItem.img_updown.hidden = YES;
        }
        
        detailItem.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return detailItem;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StyleVo *vo = [self.datas objectAtIndex:indexPath.row];
    if ([vo.isCheck isEqualToString:@"1"]) {
        vo.isCheck = @"0";
        [_styleList removeObject:vo];
    }else{
        [_styleList addObject:vo];
        vo.isCheck = @"1";
    }
    
    BOOL isCheck = NO;
    for (ListStyleVo* vo in self.datas) {
        if ([vo.isCheck isEqualToString:@"1"]) {
            _showFlg = @"2";
             [self configNavigationBar:LSNavigationBarButtonDirectRight title:@"操作" filePath:Head_ICON_OK];
            isCheck =YES;
            break ;
        }
    }
    
    if (!isCheck) {
        _showFlg = @"1";
        [self configNavigationBar:LSNavigationBarButtonDirectRight title:@"筛选" filePath:Head_ICON_CHOOSE];
    }
    
    [self.tableView reloadData];
}

#pragma mark UITableView无section列表

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count == 0 ? 0 :self.datas.count;
}

-(void)initGrid
{
    self.tableView.opaque=YES;
    UIView* view=[ViewFactory generateFooter:88];
    view.backgroundColor=[UIColor clearColor];
    
    [self.tableView setTableFooterView:view];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

@end
