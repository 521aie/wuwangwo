//
//  SalePackStyleBatchView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/11/4.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SalePackStyleBatchView.h"
#import "StyleVo.h"
#import "NavigateTitle2.h"
#import "UIHelper.h"
#import "GoodsStyleBatchSelectCell.h"
#import "ObjectUtil.h"
#import "SearchBar2.h"
#import "ViewFactory.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "XHAnimalUtil.h"
#import "SalePackStyleListView.h"

@interface SalePackStyleBatchView ()

@property (nonatomic, strong) WechatService *wechatService;

@property (nonatomic, strong) StyleVo *styleVo;

@property (nonatomic, retain) NSMutableArray *datas;

@property (nonatomic, strong) NSString* salePackId;

@property (nonatomic, strong) NSString *searchCode;

@property (nonatomic, strong) NSString* createTime;

@property (nonatomic, strong) NSString* lastVer;

@property (nonatomic) int styleCount;

@property (nonatomic, strong) NSMutableArray* styleList;

@end

@implementation SalePackStyleBatchView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil styleList:(NSMutableArray *)styleList salePackId:(NSString *)salePackId lastVer:(NSString *)lastVer createTime:(NSString*) createTime searchCode:(NSString*) searchCode
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _datas = styleList;
        _salePackId = salePackId;
        _lastVer = lastVer;
        _searchCode = searchCode;
        _createTime = createTime;
        _wechatService = [ServiceFactory shareInstance].wechatService;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initHead];
    [self initGrid];
    [self loadDatas];
    [self.searchbar initDelagate:self placeholder:@"名称/款号"];
    [UIHelper clearColor:self.footView];
    [self.footView initDelegate:self];
    __weak SalePackStyleBatchView* weakSelf = self;
    [weakSelf.mainGrid ls_addHeaderWithCallback:^{
        _createTime = nil;
        [weakSelf selectStyleList];
    }];
    
    [weakSelf.mainGrid ls_addFooterWithCallback:^{
        [weakSelf selectStyleList];
    }];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) loadDatas
{
    self.searchbar.keyWordTxt.text = _searchCode;
    _styleList = [[NSMutableArray alloc] init];
    
    if (self.datas != nil && self.datas.count > 0) {
        for (StyleVo *vo in self.datas) {
            vo.isCheck = @"0";
        }
    }
    
    [self.mainGrid reloadData];
}

-(void) selectStyleList
{
    __weak SalePackStyleBatchView* weakSelf = self;
    [_wechatService searchStyleInSalePack:_salePackId searchCode:_searchCode createTime:_createTime completionHandler:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        [self responseSuccess:json];
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
    } errorHandler:^(id json) {
        [AlertBox show:json];
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
        
    }];
}

- (void)responseSuccess:(id)json
{
    NSMutableArray *array = [json objectForKey:@"styleVoList"];
    if (_createTime == nil || [_createTime isEqualToString:@""]) {
        self.datas = [[NSMutableArray alloc] init];
//        [self.titleBox initWithName:@"选择款式" backImg:Head_ICON_BACK moreImg:nil];
    }
    if ([ObjectUtil isNotNull:array]) {
        for (NSDictionary* dic in array) {
            [self.datas addObject:[StyleVo convertToStyleVo:dic]];
        }
    }
    
    if ([ObjectUtil isNotNull:[json objectForKey:@"createTime"]]) {
        _createTime = [[json objectForKey:@"createTime"] stringValue];
    }
    
    _styleCount = [[json objectForKey:@"styleCount"] intValue];
    
    
    [self.mainGrid reloadData];
}

#pragma navigateTitle.
-(void) initHead
{
    self.titleBox=[NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"选择款式" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
    self.titleBox.lblRight.text = @"操作";
    [self.titleDiv addSubview:self.titleBox];
}

-(void) onNavigateEvent:(Direct_Flag)event
{
    if (event==1) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        if(self.styleList.count<=0){
            [AlertBox show:@"请先选择款式！"];
        }else{
            UIActionSheet *menu = [[UIActionSheet alloc]
                                   initWithTitle: @"请选择批量操作"
                                   delegate:self
                                   cancelButtonTitle:@"取消"
                                   destructiveButtonTitle:nil
                                   otherButtonTitles: @"删除", nil];
            [menu showInView:self.view];
        }
    }
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        static UIAlertView *alertView;
        if (alertView != nil) {
            [alertView dismissWithClickedButtonIndex:0 animated:NO];
            alertView = nil;
        }
        alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确认删除所有选中款式吗?" delegate:self cancelButtonTitle:@"取消"  otherButtonTitles:@"确认", nil];
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        __weak SalePackStyleBatchView* weakSelf = self;
        NSMutableArray* styleIdList = [[NSMutableArray alloc] init];
        for (StyleVo* vo in _styleList) {
            [styleIdList addObject:vo.styleId];
        }
        [_wechatService deleteSelectStylesFromPack:_salePackId styleIdList:styleIdList lastVer:_lastVer completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[SalePackStyleListView class]]) {
                    SalePackStyleListView *listView = (SalePackStyleListView *)vc;
                    [listView loadDatasFromBatchViewOrEditView:@"delete"];
                }
            }
            
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
            [self.navigationController popViewControllerAnimated:NO];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }
}

-(void) checkAllEvent
{
    _styleList = [[NSMutableArray alloc] initWithCapacity:self.datas.count];
    for (StyleVo *vo in self.datas) {
        vo.isCheck = @"1";
        [_styleList addObject:vo];
    }
    [self.mainGrid reloadData];
}

-(void) notCheckAllEvent
{
    for (StyleVo *vo in self.datas) {
        vo.isCheck = @"0";
    }
    [_styleList removeAllObjects];
    [self.mainGrid reloadData];
}

-(void) imputFinish:(NSString *)keyWord
{
    _searchCode = keyWord;
    _createTime = nil;
    [self.mainGrid headerBeginRefreshing];
}

#pragma table部分
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsStyleBatchSelectCell *detailItem = (GoodsStyleBatchSelectCell *)[self.mainGrid dequeueReusableCellWithIdentifier:GoodsStyleBatchSelectCellIndentifier];
    
    if (!detailItem) {
        detailItem = [[NSBundle mainBundle] loadNibNamed:@"GoodsStyleBatchSelectCell" owner:self options:nil].lastObject;
    }
    
    if ([ObjectUtil isNotEmpty:self.datas]) {
        StyleVo *item = [self.datas objectAtIndex:indexPath.row];
        detailItem.lblName.text = item.styleName;
        detailItem.lblStyleNo.text = item.styleCode;
        
        if (item.isCheck == nil || [item.isCheck isEqualToString:@""] || [item.isCheck isEqualToString:@"0"]) {
            detailItem.imgUnCheck.hidden = NO;
            detailItem.imgCheck.hidden = YES;
        }else{
            detailItem.imgUnCheck.hidden = YES;
            detailItem.imgCheck.hidden = NO;
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
    for (StyleVo* vo in self.datas) {
        if ([vo.isCheck isEqualToString:@"1"]) {
            if (_styleList.count > 0) {
                [self.titleBox initWithName:@"选择款式" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
                self.titleBox.lblRight.text = @"操作";
            }
            isCheck =YES;
            break ;
        }
    }
    
    if (!isCheck) {
        if (_styleList.count > 0) {
            [self.titleBox initWithName:@"选择款式" backImg:Head_ICON_CANCEL moreImg:nil];
        }
    }
    
    [self.mainGrid reloadData];
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
    self.mainGrid.opaque=YES;
    UIView* view=[ViewFactory generateFooter:88];
    view.backgroundColor=[UIColor clearColor];
    
    [self.mainGrid setTableFooterView:view];
    [self.mainGrid setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}



@end
