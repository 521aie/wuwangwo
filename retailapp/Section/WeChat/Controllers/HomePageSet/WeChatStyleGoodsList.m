//
//  WeChatStyleGoodsList.m
//  retailapp
//
//  Created by diwangxie on 16/4/28.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "WeChatStyleGoodsList.h"
#import "XHAnimalUtil.h"
#import "GoodsStyleBatchSelectCell.h"
#import "GoodsStyleBatchSelectCell2.h"
#import "WechatService.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "Wechat_StyleVo.h"
#import "MicroShopHomepageDetailVo.h"
#import "MicroShopHomepageVo.h"

@interface WeChatStyleGoodsList ()
@property (nonatomic) NSMutableArray *datas;
@property (nonatomic) NSMutableArray *styleList;
@property (nonatomic, strong) NSMutableArray *styleListNew;
@property (nonatomic, strong) WechatService* wechatService;
@property (nonatomic, strong) NSMutableDictionary* condition;
@property (nonatomic, strong) NSString* createTime;
@property (nonatomic, retain) NSString *shopId;
@property (nonatomic) bool showFlg;
@property (nonatomic) NSInteger viewType;
@property (nonatomic) BOOL isRemove;
//@property (nonatomic,strong) NSMutableArray *datasNew;

@property (nonatomic,strong) Wechat_StyleVo *item;
@end

@implementation WeChatStyleGoodsList

- (void)viewDidLoad {
    [super viewDidLoad];
    _isRemove =YES;
    if (_check==1 || _mode==0) {
        [self.footerView setHidden:YES];
        [self.bottomView setHidden:YES];
    }else{
        [self.footerView setHidden:NO];
        [self.bottomView setHidden:NO];
        [self.footerView initDelegate:self];
    }
    [self initDate];
    [self initTitleBox];
    [self initGrid];
    [self configHelpButton:HELP_WECHAT_HOME_SETTING];
}
-(void)initDate{
    _condition=[[NSMutableDictionary alloc] init];
    _styleList=[[NSMutableArray alloc] init];
    _styleListNew=[[NSMutableArray alloc] init];
    _wechatService = [ServiceFactory shareInstance].wechatService;
    
    [_condition setValue:@"1" forKey:@"searchType"];
    [_condition setValue:_shopId forKey:@"shopId"];
    [_condition setValue:nil forKey:@"searchCode"];
    [_condition setValue:nil forKey:@"categoryId"];
    [_condition setValue:nil forKey:@"applySex"];
    [_condition setValue:nil forKey:@"year"];
    [_condition setValue:nil forKey:@"season"];
    [_condition setValue:nil forKey:@"minHangTagPrice"];
    [_condition setValue:nil forKey:@"maxHangTagPrice"];
    [_condition setValue:self.createTime forKey:@"createTime"];
    
    
    [self selectStyleList];
}
-(void)initGrid{
    [self.searchBar initDelagate:self placeholder:@"名称/款号"];
    
    [self.mainGrid ls_addHeaderWithCallback:^{
        _createTime = nil;
        [self selectStyleList];
    }];
    [self.mainGrid ls_addFooterWithCallback:^{
        _isRemove=NO;
        [self selectStyleList];
    }];
}
-(void)initTitleBox{
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"选择款式" backImg:Head_ICON_BACK moreImg:Head_ICON_CHOOSE];
    [self.titleDiv addSubview:self.titleBox];
    self.titleBox.lblRight.text=@"筛选";
    _showFlg=NO;
}
- (void)onNavigateEvent:(Direct_Flag)event {
    if (event == DIRECT_LEFT) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        if (_showFlg) {
            _sellStyleGoodsListBlock(self.styleList);
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [self.navigationController popViewControllerAnimated:NO];
        }else{
            [self loadStyleChoiceTopView];
            self.styleChoiceTopView.delegate = self;
            self.styleChoiceTopView.shopId = _shopId;
            self.styleChoiceTopView.fromViewTag = STYLE_CHOICE_VIEW;
            self.styleChoiceTopView.conditionOfInit = self.condition;
            [self.styleChoiceTopView loaddatas];
            [self.styleChoiceTopView oper];
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
{   self.searchBar.keyWordTxt.text=nil;
    self.condition = condition;
    [self.mainGrid headerBeginRefreshing];
}

// 搜索框输入完成方法
- (void)imputFinish:(NSString *)keyWord
{
    NSMutableDictionary* condition = [[NSMutableDictionary alloc] init];
    [condition setValue:@"1" forKey:@"searchType"];
    [condition setValue:_shopId forKey:@"shopId"];
    [condition setValue:keyWord forKey:@"searchCode"];
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

#pragma  mark 全选和全不选
-(void) checkAllEvent
{
    [self.styleList removeAllObjects];
    for (Wechat_StyleVo* editObj in self.datas) {
        editObj.isCheck=@"1";
        [_styleList addObject:editObj];
    }
    
    if (![_styleList isEqualToArray:_styleListNew]) {
        [self.titleBox initWithName:@"选择款式" backImg:Head_ICON_CANCEL moreImg:Head_ICON_CONFIRM];
        self.titleBox.lblRight.text=@"确定";
        _showFlg=YES;
    }else{
        [self.titleBox initWithName:@"选择款式" backImg:Head_ICON_BACK moreImg:Head_ICON_CHOOSE];
        self.titleBox.lblRight.text=@"筛选";
        _showFlg=NO;
        
    }
    
    _showFlg=YES;
    [self.mainGrid reloadData];
}

-(void) notCheckAllEvent
{
    [_styleList removeAllObjects];
    
    for (Wechat_StyleVo* editObj in self.datas) {
        editObj.isCheck=@"0";
    }
    
    if (![_styleList isEqualToArray:_styleListNew]) {
        [self.titleBox initWithName:@"选择款式" backImg:Head_ICON_CANCEL moreImg:Head_ICON_CONFIRM];
        self.titleBox.lblRight.text=@"确定";
        _showFlg=YES;
    }else{
        [self.titleBox initWithName:@"选择款式" backImg:Head_ICON_BACK moreImg:Head_ICON_CHOOSE];
        self.titleBox.lblRight.text=@"筛选";
        _showFlg=NO;
        
    }
    _showFlg=YES;
    [self.mainGrid reloadData];
}


-(void) selectStyleList
{
   _shopId = [[Platform Instance] getkey:SHOP_ID];
    __weak WeChatStyleGoodsList* weakSelf = self;
    [_wechatService selectMicroStyleList:[_condition objectForKey:@"searchType"] shopId:[_condition objectForKey:@"shopId"] searchCode:[_condition objectForKey:@"searchCode"] categoryId:[_condition objectForKey:@"categoryId"] applySex:[_condition objectForKey:@"applySex"] year:[_condition objectForKey:@"year"] seasonValId:[_condition objectForKey:@"seasonValId"] minHangTagPrice:[_condition objectForKey:@"minHangTagPrice"] maxHangTagPrice:[_condition objectForKey:@"maxHangTagPrice"] createTime:_createTime != nil? [NSNumber numberWithLongLong:[_createTime longLongValue]]:nil completionHandler:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        NSMutableArray *array = [json objectForKey:@"styleVoList"];
        if (_createTime == nil || [_createTime isEqualToString:@""]) {
            self.datas = [[NSMutableArray alloc] init];
        }
        if ([ObjectUtil isNotNull:array]) {
            for (NSDictionary* dic in array) {
                [self.datas addObject:[Wechat_StyleVo convertToListStyleVo:dic]];
            }
        }
        _isRemove=YES;
        
        self.styleListNew=[NSMutableArray arrayWithArray:self.styleList];
        
        if ([ObjectUtil isNotNull:[json objectForKey:@"createTime"]]) {
             _createTime = [[json objectForKey:@"createTime"] stringValue];
            [_condition setValue:self.createTime forKey:@"createTime"];
        }
        [self.mainGrid reloadData];
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
    } errorHandler:^(id json) {
        [AlertBox show:json];
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
    }];
}

#pragma mark - 表格
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(_mode==1){
        GoodsStyleBatchSelectCell *detailItem = (GoodsStyleBatchSelectCell *)[self.mainGrid dequeueReusableCellWithIdentifier:GoodsStyleBatchSelectCellIndentifier];
        
        if (!detailItem) {
            detailItem = [[NSBundle mainBundle] loadNibNamed:@"GoodsStyleBatchSelectCell" owner:self options:nil].lastObject;
        }
        
        if ([ObjectUtil isNotEmpty:self.datas]) {
            Wechat_StyleVo *item2 = [self.datas objectAtIndex:indexPath.row];
            detailItem.lblName.text = item2.styleName;
            detailItem.lblStyleNo.text = item2.styleCode;
            if ([item2.isCheck isEqualToString:@"1"]) {
                detailItem.imgUnCheck.hidden = YES;
                detailItem.imgCheck.hidden = NO;
            }else{
                detailItem.imgUnCheck.hidden = NO;
                detailItem.imgCheck.hidden = YES;
            }
            detailItem.selectionStyle = UITableViewCellSelectionStyleNone;
            return detailItem;
        }

    }else{
        GoodsStyleBatchSelectCell2 *detailItem = (GoodsStyleBatchSelectCell2 *)[self.mainGrid dequeueReusableCellWithIdentifier:GoodsStyleBatchSelectCellIndentifier];
        
        if (!detailItem) {
            detailItem = [[NSBundle mainBundle] loadNibNamed:@"GoodsStyleBatchSelectCell2" owner:self options:nil].lastObject;
        }
        
        if ([ObjectUtil isNotEmpty:self.datas]) {
            Wechat_StyleVo *item = [self.datas objectAtIndex:indexPath.row];
            detailItem.lblName.text = item.styleName;
            detailItem.lblStyleNo.text = item.styleCode;
            detailItem.selectionStyle = UITableViewCellSelectionStyleNone;
            return detailItem;
        }

    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat{
    return 64;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(_mode==1){
        if (self.datas != nil) {
            [self showEditNVItemEvent:@"goods" withObj:[self.datas objectAtIndex:indexPath.row]];
        }
    }else{
        
        [_styleList addObject:[_datas objectAtIndex:indexPath.row]];
        _sellStyleGoodsListBlock(_styleList);
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

-(void) showEditNVItemEvent:(NSString *)event withObj:(id<INameValueItem>)obj
{
    
    Wechat_StyleVo* editObj = (Wechat_StyleVo*) obj;
    if ([editObj.isCheck isEqualToString:@"1"]) {
        editObj.isCheck = @"0";
        [_styleList removeObject:editObj];
    }else{
        if (_styleList.count>11 && _check==1) {
            [AlertBox show:@"最多设置12个双列商品!"];
            return;
        }
        editObj.isCheck = @"1";
        
        [_styleList addObject:editObj];
        
    }
    
    if (![_styleList isEqualToArray:_styleListNew]) {
        [self.titleBox initWithName:@"选择款式" backImg:Head_ICON_CANCEL moreImg:Head_ICON_CONFIRM];
        self.titleBox.lblRight.text=@"确定";
        _showFlg=YES;
    }else{
        [self.titleBox initWithName:@"选择款式" backImg:Head_ICON_BACK moreImg:Head_ICON_CHOOSE];
        self.titleBox.lblRight.text=@"筛选";
        _showFlg=NO;
        
    }
    [self.mainGrid reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)loadStyleGoodsList:(NSInteger)viewType callBack:(StyleGoodsList)callBack{
    self.sellStyleGoodsListBlock = callBack;
    self.viewType=viewType;
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
