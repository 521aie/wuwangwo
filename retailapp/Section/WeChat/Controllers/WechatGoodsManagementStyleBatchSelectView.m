//
//  WechatGoodsManagementStyleBatchSelectView.m
//  retailapp
//
//  Created by zhangzt on 15/10/20.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "WechatGoodsManagementStyleBatchSelectView.h"
#import "NavigateTitle2.h"
#import "UIHelper.h"
#import "SearchBar2.h"
#import "ServiceFactory.h"
#import "ViewFactory.h"
#import "AlertBox.h"
#import "WechatGoodsTopSelectView.h"
#import "EditItemList.h"
#import "Wechat_StyleVo.h"
#import "XHAnimalUtil.h"
#import "DateUtils.h"
#import "WeChatWeShopPriceSet.h"
#import "XHAnimalUtil.h"
#import "LSWechatGoodBatchCell.h"

@interface WechatGoodsManagementStyleBatchSelectView ()

@property (nonatomic, strong) WechatService *wechatService;

//@property (nonatomic, strong) ListStyleVo *listStyleVo;

@property (nonatomic, strong) NSString *searchCode;

@property (nonatomic, strong) NSString* createTime;

@property (nonatomic, strong) NSMutableArray* styleList;

@property (nonatomic, strong) NSString *shopId;

@property (nonatomic, strong) NSString *shopName;

//1: 筛选  2: 操作
@property (nonatomic, strong) NSString* showFlg;

//微店商品管理 筛选页面
@property (nonatomic, strong)WechatGoodsTopSelectView *wechatGoodsTopSelectView;
@property (nonatomic, strong)StyleChoiceTopView *styleChoiceTopView;

@property (nonatomic, strong) NSMutableArray* styleIdList;

@end

@implementation WechatGoodsManagementStyleBatchSelectView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initHead];
    [self initNotification];
    [self initGrid];
    [self.searchbar initDelagate:self placeholder:@"名称/款号"];
    [UIHelper clearColor:self.footView];
    [self.footView initDelegate:self];
    
    self.styleList = [NSMutableArray array];
    self.styleIdList=[NSMutableArray array];
    
    _wechatService = [ServiceFactory shareInstance].wechatService;
    __weak WechatGoodsManagementStyleBatchSelectView* weakSelf = self;
    [weakSelf.mainGrid ls_addHeaderWithCallback:^{
        _createTime = nil;
        [weakSelf selectStyleList];
    }];
    
    [weakSelf.mainGrid ls_addFooterWithCallback:^{
        [weakSelf selectStyleList];
    }];
    
    [self loaddata];
}

- (void)initNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Notification:) name:@"Refresh" object:nil];
}

#pragma mark - 通知处理
-(void)Notification:(NSNotification *)notification{
     _createTime = nil;
    [self.mainGrid headerBeginRefreshing];
    [self notCheckAllEvent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loaddata
{
    [self.mainGrid setContentOffset:CGPointMake(0, 0)animated:NO];
    _showFlg = @"1";
    _shopId = [_condition objectForKey:@"shopId"];
    _shopName = [_condition objectForKey:@"shopName"];
    _createTime = [_condition objectForKey:@"createTime"];
    self.searchbar.keyWordTxt.text = [_condition objectForKey:@"searchCode"];
    [self.titleBox.imgMore setImage:[UIImage imageNamed:Head_ICON_CHOOSE]];
    self.titleBox.lblRight.text = @"筛选";
    [self.mainGrid reloadData];
}

-(void) loadDatasFromSelect:(NSMutableDictionary *)condition
{
    _condition = condition;
    _createTime = [_condition objectForKey:@"createTime"];
    [self.mainGrid headerBeginRefreshing];
}

-(void) loadDatasFromOperateView:(int) action
{
    if (action == ACTION_CONSTANTS_DEL) {
        for (Wechat_StyleVo* vo in _styleList) {
            if ([vo.isCheck isEqualToString:@"1"]) {
                [self.datas removeObject:vo];
            }
        }
    }
    [self.mainGrid reloadData];
}

-(void) selectStyleList
{
    __weak WechatGoodsManagementStyleBatchSelectView* weakSelf = self;
    
    [_wechatService selectMicroStyleList:[_condition objectForKey:@"searchType"] shopId:[_condition objectForKey:@"shopId"] searchCode:[_condition objectForKey:@"searchCode"] categoryId:[_condition objectForKey:@"categoryId"] applySex:[_condition objectForKey:@"applySex"] year:[_condition objectForKey:@"year"] seasonValId:[_condition objectForKey:@"season"] minHangTagPrice:[_condition objectForKey:@"minHangTagPrice"] maxHangTagPrice:[_condition objectForKey:@"maxHangTagPrice"] createTime:_createTime != nil? @(_createTime.longLongValue):nil completionHandler:^(id json) {

        [weakSelf responseSuccess:json];
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
    } errorHandler:^(id json) {
        [AlertBox show:json];
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
    }];
}

-(void) responseSuccess:(id)json
{
    NSMutableArray *array = [json objectForKey:@"styleVoList"];
    if (_createTime == nil || [_createTime isEqualToString:@""]) {
        self.datas = [[NSMutableArray alloc] init];
    }
    if ([ObjectUtil isNotNull:array]) {
        for (NSDictionary* dic in array) {
            [self.datas addObject:[Wechat_StyleVo convertToListStyleVo:dic]];
        }
    }
    
    if ([ObjectUtil isNotNull:[json objectForKey:@"createTime"]]) {
        _createTime = [[json objectForKey:@"createTime"] stringValue];
    }
    
    [self.mainGrid reloadData];
}


#pragma navigateTitle.
-(void) initHead
{
    self.titleBox=[NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"选择微店款式" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
    self.titleBox.lblRight.text = @"筛选";
    self.titleBox.lblRight.hidden = NO;
    [self.titleDiv addSubview:self.titleBox];
}

-(void)initGrid
{
    self.mainGrid.opaque=YES;
    UIView* view=[ViewFactory generateFooter:60];
    view.backgroundColor=[UIColor clearColor];
    
    [self.mainGrid setTableFooterView:view];
    [self.mainGrid setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

// 搜索框输入完成方法
- (void)imputFinish:(NSString *)keyWord
{
    self.searchCode = keyWord;
    _searchCode = keyWord;
    NSMutableDictionary* condition = [[NSMutableDictionary alloc] init];
    [condition setValue:@"1" forKey:@"searchType"];
    [condition setValue:_shopId forKey:@"shopId"];
    [condition setValue:_searchCode forKey:@"searchCode"];
    [condition setValue:@"" forKey:@"categoryId"];
    [condition setValue:@"" forKey:@"applySex"];
    [condition setValue:@"" forKey:@"year"];
    [condition setValue:@"" forKey:@"season"];
    [condition setValue:@"" forKey:@"minHangTagPrice"];
    [condition setValue:@"" forKey:@"maxHangTagPrice"];
    [condition setValue:@"" forKey:@"createTime"];
    _condition = condition;
    [self.mainGrid headerBeginRefreshing];
}

-(void) onNavigateEvent:(Direct_Flag)event
{
    if (event==1) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        if ([_showFlg isEqualToString:@"1"]) {
            
            [self loadStyleChoiceTopView];
            self.styleChoiceTopView.delegate = self;
            self.styleChoiceTopView.shopId = _shopId;
            self.styleChoiceTopView.fromViewTag = STYLE_CHOICE_VIEW;
            NSMutableDictionary* condition = [[NSMutableDictionary alloc] init];
            [condition setValue:@"" forKey:@"categoryId"];
            [condition setValue:@"" forKey:@"applySex"];
            [condition setValue:@"" forKey:@"prototypeValId"];
            [condition setValue:@"" forKey:@"auxiliaryValId"];
            [condition setValue:@"" forKey:@"year"];
            [condition setValue:@"" forKey:@"seasonValId"];
            [condition setValue:@"" forKey:@"minHangTagPrice"];
            [condition setValue:@"" forKey:@"maxHangTagPrice"];
            self.styleChoiceTopView.conditionOfInit = condition;
            [self.styleChoiceTopView loaddatas];
            [self.styleChoiceTopView oper];
            
        }
        else{
            UIActionSheet *menu = [[UIActionSheet alloc]
                                   initWithTitle:nil
                                   delegate:self
                                   cancelButtonTitle:@"取消"
                                   destructiveButtonTitle:nil
                                   otherButtonTitles:@"不在微店销售",@"批量设置微店价格",  nil];
            [menu showInView:self.view];
        }
    }
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        
        static UIAlertView *alertView;
        if (alertView != nil) {
            [alertView dismissWithClickedButtonIndex:0 animated:NO];
            alertView = nil;
        }
        alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确认不在微店销售吗?" delegate:self cancelButtonTitle:@"取消"  otherButtonTitles:@"确认", nil];
        alertView.tag=3;
        [alertView show];
        
    } else if (buttonIndex == 1){
        
        WeChatWeShopPriceSet*vc = [[WeChatWeShopPriceSet alloc] initWithNibName:[SystemUtil getXibName:@"WeChatWeShopPriceSet"] bundle:nil];
        [vc loadDate:_styleList];
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    for (Wechat_StyleVo* vo in _styleList) {
        [_styleIdList addObject:vo.styleId];
    }
    __weak WechatGoodsManagementStyleBatchSelectView* weakSelf = self;
    if (buttonIndex==1) {
        if (alertView.tag==1) {
            [_wechatService setMicroStyleUpDownStatus:_styleIdList shopId:_shopId status:@"1" completionHandler:^(id json) {
                if (!(weakSelf)) {
                    return ;
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Refresh" object:nil];
                [AlertBox show:@"批量款式上架成功!"];
            } errorHandler:^(id json) {
                [AlertBox show:json];
            }];

        }else if (alertView.tag==2){
            [_wechatService setMicroStyleUpDownStatus:_styleIdList shopId:_shopId status:@"2" completionHandler:^(id json) {
                if (!(weakSelf)) {
                    return ;
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Refresh" object:nil];
                [AlertBox show:@"批量款式下架成功!"];
            } errorHandler:^(id json) {
                [AlertBox show:json];
            }];

        }else if (alertView.tag==3){
            [_wechatService setNotSaleMicroStyle:_styleIdList shopId:_shopId completionHandler:^(id json) {
                if (!(weakSelf)) {
                    return ;
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Refresh" object:nil];
                [AlertBox show:@"批量删除款式成功!"];
            } errorHandler:^(id json) {
                [AlertBox show:json];
            }];

        }
    }
}

/*加载商品款式筛选页面*/
- (void)loadStyleChoiceTopView
{
    if (self.styleChoiceTopView) {
        self.styleChoiceTopView.view.hidden = NO;
    }else{
        self.styleChoiceTopView = [[StyleChoiceTopView alloc] initWithNibName:[SystemUtil getXibName:@"StyleChoiceTopView"] bundle:nil];
        [self.view addSubview:self.styleChoiceTopView.view];
    }
}

-(void) showStyleListView:(NSMutableDictionary *)condition
{
    self.searchbar.keyWordTxt.text=nil;
    self.condition = condition;
    [self.mainGrid headerBeginRefreshing];
//    [self.searchbar initDelagate:self placeholder:@"名称/款号"];
}


//-(void)btnConfirmclick{
//    self.searchbar.keyWordTxt.text = @"";
//    [self.wechatGoodsTopSelectView.view removeFromSuperview];
//    NSMutableDictionary* condition = [[NSMutableDictionary alloc] init];
//    [condition setValue:@"2" forKey:@"searchType"];
//    [condition setValue:_shopId forKey:@"shopId"];
//    //[condition setValue:_shopName forKey:@"shopName"];
//    [condition setValue:@"" forKey:@"searchCode"];
//    [condition setValue:[self.wechatGoodsTopSelectView.lsCategory getStrVal] forKey:@"categoryId"];
//    [condition setValue:[self.wechatGoodsTopSelectView.lsSex getStrVal] forKey:@"applySex"];
//    [condition setValue:[self.wechatGoodsTopSelectView.lsYear getStrVal] forKey:@"year"];
//    [condition setValue:[self.wechatGoodsTopSelectView.lsSeason getStrVal] forKey:@"season"];
//    [condition setValue:self.wechatGoodsTopSelectView.txtMinHangTagPrice.text forKey:@"minHangTagPrice"];
//    [condition setValue:[self.wechatGoodsTopSelectView.lsMaxHangTagPrice getStrVal] forKey:@"maxHangTagPrice"];
//    [condition setValue:@"" forKey:@"createTime"];
//    
//    self.condition = condition;
//    [self.mainGrid headerBeginRefreshing];
//    //[self loaddata];
//}


-(void) checkAllEvent
{
    _styleList=[[NSMutableArray alloc]init];
    if (self.datas.count>0) {
        for (Wechat_StyleVo *vo in self.datas) {
            vo.isCheck = @"1";
            [_styleList addObject:vo];
        }
        
        _showFlg = @"2";
        [self.titleBox.imgMore setImage:[UIImage imageNamed:Head_ICON_OK]];
        self.titleBox.lblRight.text = @"操作";
        
        [self.mainGrid reloadData];
    }
}

-(void) notCheckAllEvent
{
    for (Wechat_StyleVo *vo in self.datas) {
        vo.isCheck = @"0";
    }
    [_styleList removeAllObjects];
    _showFlg = @"1";
    [self.titleBox.imgMore setImage:[UIImage imageNamed:Head_ICON_CHOOSE]];
    self.titleBox.lblRight.text = @"筛选";
    
    [self.mainGrid reloadData];

}

#pragma table部分
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSWechatGoodBatchCell *cell = [LSWechatGoodBatchCell wechatGoodBatchCellAtTableView:tableView];
    Wechat_StyleVo *styleVo = [self.datas objectAtIndex:indexPath.row];
    cell.styleVo = styleVo;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Wechat_StyleVo *vo = [self.datas objectAtIndex:indexPath.row];
    if ([vo.isCheck isEqualToString:@"1"]) {
        vo.isCheck = @"0";
        [_styleList removeObject:vo];
    }else{
        [_styleList addObject:vo];
        vo.isCheck = @"1";
    }
    
    BOOL isCheck = NO;
    for (Wechat_StyleVo* vo in self.datas) {
        if ([vo.isCheck isEqualToString:@"1"]) {
            _showFlg = @"2";
            [self.titleBox.imgMore setImage:[UIImage imageNamed:Head_ICON_OK]];
            self.titleBox.lblRight.text = @"操作";
            isCheck =YES;
            break ;
        }
    }
    
    if (!isCheck) {
        _showFlg = @"1";
        [self.titleBox.imgMore setImage:[UIImage imageNamed:Head_ICON_CHOOSE]];
        self.titleBox.lblRight.text = @"筛选";
    }
    
    [self.mainGrid reloadData];
}

#pragma mark UITableView无section列表


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54.0;
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}



@end
