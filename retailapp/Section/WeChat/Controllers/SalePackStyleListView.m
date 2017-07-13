//
//  SalePackStyleListView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/11/2.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SalePackStyleListView.h"
#import "NavigateTitle2.h"
#import "GoodsStyleListCell.h"
#import "ObjectUtil.h"
#import "GoodsFooterListView.h"
#import "SearchBar2.h"
#import "MyUILabel.h"
#import "GoodsStyleEditView.h"
#import "GoodsStyleBatchSelectView.h"
#import "EditItemList.h"
#import "StyleTopSelectView.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "StyleVo.h"
#import "DateUtils.h"
#import "XHAnimalUtil.h"
#import "GoodsStyleInfoView.h"
#import "SearchBar.h"
#import "ViewFactory.h"
#import "GridColHead5.h"
#import "WechatSalePackStyleSelectView.h"
#import "StyleBatchChoiceView2.h"
#import "Platform.h"
#import "SalePackStyleVo.h"
#import "ListStyleVo.h"
#import "WechatSalePackManageEditView.h"
#import "SalePackStyleBatchView.h"
#import "SalePackStyleImageView.h"

@interface SalePackStyleListView ()

@property (nonatomic, strong) WechatService* wechatService;

@property (nonatomic, strong) NSMutableDictionary* condition;

@property (nonatomic, strong) NSString* createTime;

@property (nonatomic, strong) NSString* shopId;

@property (nonatomic, strong) StyleVo* tempVo;

@property (nonatomic, retain) NSString *searchCode;

@property (nonatomic, retain) NSString *salePackId;

@property (nonatomic, retain) NSMutableArray * datas;

@property (nonatomic, retain) NSString *lastVer;

@property (nonatomic) int styleCount;

@property (nonatomic) BOOL tipFlg;

@property (nonatomic) int showViewCount;

@property (nonatomic) int oldStyleCount;

@property (nonatomic) BOOL editFlg;

@property (nonatomic) BOOL deleteFlg;

@end

@implementation SalePackStyleListView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil salePackId:(NSString*) salePackId lastVer:(NSString*) lastVer {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _salePackId = salePackId;
        _lastVer = lastVer;
        _tipFlg = NO;
        _editFlg = NO;
        _deleteFlg = NO;
        _wechatService = [ServiceFactory shareInstance].wechatService;
    }
    return self;
}

-(void) loaddatas
{
    _createTime = nil;
    _searchBar.keyWordTxt.text = @"";
    
    [self selectStyleListBySalePackId];
}

-(void) loadDatasFromEditView:(StyleVo*) styleVo action:(int)action
{
    if (action == ACTION_CONSTANTS_DEL) {
        [self.datas removeObject:_tempVo];
        [self.mainGrid reloadData];
    }else if (action == ACTION_CONSTANTS_EDIT){
        _tempVo.styleName = styleVo.styleName;
        _tempVo.styleCode = styleVo.styleCode;
        _tempVo.filePath = styleVo.filePath;
        [self.mainGrid reloadData];
    }else if (action == ACTION_CONSTANTS_ADD){
        [self.mainGrid headerBeginRefreshing];
    }
}

-(void) loadDatasFromAddView
{
    _editFlg = YES;
    _createTime = nil;
    [self selectStyleListBySalePackId];
}

-(void) loadDatasFromBatchViewOrEditView:(NSString*) viewTag
{
    if ([viewTag isEqualToString:@"edit"]) {
        _editFlg = YES;
    } else if ([viewTag isEqualToString:@"delete"]){
        _deleteFlg = YES;
        _lastVer = [NSString stringWithFormat:@"%d", [_lastVer intValue] + 1];
    }
    
    _createTime = nil;
    [self selectStyleListBySalePackId];
}

-(void) loadDatasFromBatchSelectView
{
    _createTime = nil;
    [self.mainGrid headerBeginRefreshing];
}

-(void) selectStyleListBySalePackId
{
    __weak SalePackStyleListView* weakSelf = self;
    
    [_wechatService selectSalePackStyleList:_salePackId completionHandler:^(id json) {
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

-(void) selectStyleList
{
    __weak SalePackStyleListView* weakSelf = self;
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

    if (_deleteFlg) {
        _oldStyleCount = [[json objectForKey:@"styleCount"] intValue];
        _deleteFlg = NO;
    }
    
    if (!_editFlg) {
        if (_showViewCount == 0) {
            //第一次进入页面_showViewCount为0。保留原先的款式数量，设置_showViewCount为1
            _oldStyleCount = [[json objectForKey:@"styleCount"] intValue];
            //未保存 字段不显示
            _tipFlg = NO;
            _showViewCount = 1;
        }else{
            // 不是第一次进入页面，比较初始的款式数量和现在的对比
            if (_oldStyleCount == _styleCount) {
                //未保存 字段不显示
                _tipFlg = NO;
            }else{
                //未保存 字段显示
                _tipFlg = YES;
                [self.titleBox initWithName:@"款式管理" backImg:Head_ICON_BACK moreImg:Head_ICON_OK];
                self.titleBox.lblRight.text = @"保存";
            }
        }
    }else{
        //未保存 字段显示
        _tipFlg = YES;
        [self.titleBox initWithName:@"款式管理" backImg:Head_ICON_BACK moreImg:Head_ICON_OK];
        self.titleBox.lblRight.text = @"保存";
    }
    
    
    [self.mainGrid reloadData];
}

#pragma navigateTitle.
-(void) initHead
{
    self.titleBox=[NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"款式管理" backImg:Head_ICON_BACK moreImg:nil];
    self.titleBox.lblRight.text = @"保存";
    [self.titleDiv addSubview:self.titleBox];
}

- (void) showAddEvent
{
    UIActionSheet *menu = [[UIActionSheet alloc]
                           initWithTitle:nil
                           delegate:self
                           cancelButtonTitle:@"取消"
                           destructiveButtonTitle:nil
                           otherButtonTitles: @"选择条件添加", @"选择款式添加", nil];
    [menu showInView:self.view];
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        WechatSalePackStyleSelectView* wechatSalePackStyleSelectView = [[WechatSalePackStyleSelectView alloc] initWithNibName:[SystemUtil getXibName:@"WechatSalePackStyleSelectView"] bundle:nil salePackId:_salePackId];
        [self.navigationController pushViewController:wechatSalePackStyleSelectView animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
    }else if (buttonIndex == 1){
        StyleBatchChoiceView2* styleBatchChoiceView2 = [[StyleBatchChoiceView2 alloc] initWithNibName:[SystemUtil getXibName:@"StyleBatchChoiceView2"] bundle:nil];
        [self.navigationController pushViewController:styleBatchChoiceView2 animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
        [styleBatchChoiceView2 loaddatas:[[Platform Instance] getkey:SHOP_ID] type:@"1" callBack:^(NSMutableArray *styleList) {
            if (styleList) {
                __weak SalePackStyleListView* weakSelf = self;
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
                [_wechatService addSelectStylesToSalePack:_salePackId styleVoList:list completionHandler:^(id json) {
                    if (!(weakSelf)) {
                        return ;
                    }
                    [weakSelf loadDatasFromAddView];
                } errorHandler:^(id json) {
                    [AlertBox show:json];
                }];
                
            }
            [styleBatchChoiceView2.navigationController popViewControllerAnimated:YES];
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        }];        
    }
}

-(void) onNavigateEvent:(Direct_Flag)event
{
    if (event==1) {
        __weak SalePackStyleListView* weakSelf = self;
        [_wechatService deleteTempSelectStyles:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[WechatSalePackManageEditView class]]) {
                WechatSalePackManageEditView *listView = (WechatSalePackManageEditView *)vc;
                [listView loaddatasFromStyleListView];
            }
        }
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        __weak SalePackStyleListView* weakSelf = self;
        NSMutableArray* styleIdList = [[NSMutableArray alloc] init];
        for (StyleVo* vo in _datas) {
            [styleIdList addObject:vo.styleId];
        }
        [_wechatService saveSalePackStyleList:_salePackId styleIdList:styleIdList lastVer:_lastVer completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[WechatSalePackManageEditView class]]) {
                    WechatSalePackManageEditView *listView = (WechatSalePackManageEditView *)vc;
                    [listView loaddatasFromStyleListView];
                }
            }
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [self.navigationController popViewControllerAnimated:NO];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }
}

-(void) showBatchEvent
{
    SalePackStyleBatchView* salePackStyleBatchView = [[SalePackStyleBatchView alloc] initWithNibName:[SystemUtil getXibName:@"SalePackStyleBatchView"] bundle:nil styleList:self.datas salePackId:_salePackId lastVer:_lastVer createTime:_createTime searchCode:_searchCode];
    [self.navigationController pushViewController:salePackStyleBatchView animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
}



-(void) imputFinish:(NSString *)keyWord
{
    _searchCode = keyWord;
    _createTime = nil;
    [self.mainGrid headerBeginRefreshing];
}

#pragma table head
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GridColHead5 *headItem = (GridColHead5 *) [self.mainGrid dequeueReusableCellWithIdentifier:GridColHead2Indentifier];
    if (!headItem) {
        headItem = [[NSBundle mainBundle] loadNibNamed:@"GridColHead5" owner:self options:nil].lastObject;
    }
    
    [headItem initColHead:[NSString stringWithFormat:@"合计%d款", self.styleCount]];
    headItem.lblTip.layer.cornerRadius = 2;
    if (_tipFlg) {
        headItem.lblTip.hidden = NO;
        self.titleBox.imgMore.hidden = NO;
        self.titleBox.lblRight.hidden = NO;
    }else{
        headItem.lblTip.hidden = YES;
        self.titleBox.imgMore.hidden = YES;
        self.titleBox.lblRight.hidden = YES;
        
    }
    
    return headItem;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.datas != nil) {
        [self showEditNVItemEvent:@"goodsStyle" withObj:[self.datas objectAtIndex:indexPath.row]];
    }
}

-(void) showEditNVItemEvent:(NSString *)event withObj:(id<INameValueItem>)obj
{
    _tempVo = (StyleVo*) obj;
    SalePackStyleImageView* salePackStyleImageView = [[SalePackStyleImageView alloc] initWithNibName:[SystemUtil getXibName:@"SalePackStyleImageView"] bundle:nil styleId:_tempVo.styleId];
    [self.navigationController pushViewController:salePackStyleImageView animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

#pragma table部分
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsStyleListCell *detailItem = (GoodsStyleListCell *)[self.mainGrid dequeueReusableCellWithIdentifier:GoodsStyleListCellIndentifier];
    
    if (!detailItem) {
        detailItem = [[NSBundle mainBundle] loadNibNamed:@"GoodsStyleListCell" owner:self options:nil].lastObject;
    }
    
    if ([ObjectUtil isNotEmpty:self.datas]) {
        StyleVo *item = [self.datas objectAtIndex:indexPath.row];
        detailItem.lblName.text = item.styleName;
        detailItem.lblStyleNo.text = [NSString stringWithFormat:@"款号：%@", item.styleCode];
        
        [detailItem.lblName setVerticalAlignment:VerticalAlignmentTop];
        //暂无图片
        UIImage* placeholder = [UIImage imageNamed:@"img_default.png"];
        
        if (item.filePath != nil && ![item.filePath isEqualToString:@""]) {
            [detailItem.img.layer setMasksToBounds:YES];
            
            [detailItem.img.layer setCornerRadius:PANEL_OUTTER_CORNER_RADIUS];
            
            NSURL* url = [NSURL URLWithString:[NSString urlFilterRan:item.filePath]];
            
            [detailItem.img sd_setImageWithURL:url placeholderImage:placeholder];
            
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

-(void)initGrid
{
    self.mainGrid.opaque=YES;
    UIView* view=[ViewFactory generateFooter:88];
    view.backgroundColor=[UIColor clearColor];
    
    [self.mainGrid setTableFooterView:view];
    [self.mainGrid setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initGrid];
    [self initHead];
    [self loaddatas];
    [self.searchBar initDelagate:self placeholder:@"名称/款号"];
    [self.view addSubview:self.searchBar.view];
    
    self.searchBar.view.frame = CGRectMake(0, 64, 320, 44);
    NSArray* arr=[[NSArray alloc] initWithObjects:@"add", @"batch", nil];
    [self.footView initDelegate:self btnArrs:arr];
    
    __weak SalePackStyleListView* weakSelf = self;
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


@end
