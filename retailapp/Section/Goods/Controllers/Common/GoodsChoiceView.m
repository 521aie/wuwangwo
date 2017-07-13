//
//  GoodsChoiceView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/10/28.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GoodsChoiceView.h"
#import "GoodsVo.h"
#import "CommonGoodsSelectCell.h"
#import "ObjectUtil.h"
#import "UIImageView+WebCache.h"
#import "NSString+Estimate.h"
#import "NavigateTitle2.h"
#import "SearchBar.h"
#import "XHAnimalUtil.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "JsonHelper.h"
#import "GoodsSearchBarView.h"
#import "ViewFactory.h"
#import "GoodsGiftVo.h"
#import "GoodsFooterListView.h"
#import "KindMenuView.h"
#import "TreeNode.h"
#import "ScanViewController.h"
#import "MyUILabel.h"
#import "GoodsBatchChoiceView1.h"
#import "ColorHelper.h"

@interface GoodsChoiceView ()<LSScanViewDelegate>

@property (nonatomic, strong) GoodsService* goodsService;
@property (nonatomic, strong) NSMutableArray* categoryList;
/** 1表示为从搜索框搜索，当查询出来为一条信息时，跳转到下一个页面*/
@property (nonatomic) short isJump;
@end

@implementation GoodsChoiceView

- (void)loaddatas {
    [self.mainGrid headerBeginRefreshing];
    [self selectCategory];
}

- (void)loaddatas:(NSString *)shopId callBack:(GoodsChoiceViewSelectBack)callBack {
    self.selectBlock = callBack;
    self.shopId = shopId;
    self.searchType = @"1";
    self.categoryId = @"";
    self.createTime = @"";
    self.barCode = @"";
    
    self.currentPage = 1;
   
}

- (void)selectGoodsList {
        __weak GoodsChoiceView* weakSelf = self;
    [_goodsService selectGoodsList:self.searchType shopId:self.shopId searchCode:self.searchCode barCode:self.barCode categoryId:self.categoryId createTime:self.createTime validTypeList:nil completionHandler:^(id json) {
      
        [weakSelf responseSuccess:json];
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
    } errorHandler:^(id json) {
        [AlertBox show:json];
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
    }];
}

- (void)responseSuccess:(id)json {
    /*searchStatus
     0：商品不存在
     1：在当前店铺找到
     2：基础表中存在该商品（仅适用于商超条形码精确查
     询）门店没有这件商品是从基础库中查询的 门店实际没有这件商品需要特殊处理
     3：在总部找到（当前店铺中不存在）
     */
    NSInteger searchStatus = [[json objectForKey:@"searchStatus"] integerValue];
    //显示的商品列表： 门店或单店且查询到的商品为该门店或单店的；连锁机构查询到且在商品是在总部找到
    if (searchStatus == 1 || ([[Platform Instance] getShopMode] == 3 && searchStatus == 3)) {
        NSArray *array = [json objectForKey:@"goodsVoList"];
        if ([NSString isBlank:self.createTime]) {
            self.datas = [[NSMutableArray alloc] init];
        }
        
        if ([ObjectUtil isNotNull:array] && array.count > 0) {
            for (NSDictionary* dic in array) {
                [self.datas addObject:[GoodsVo convertToGoodsVo:dic]];
            }
        }
        
        if ([ObjectUtil isNotNull:[json objectForKey:@"createTime"]]) {
            self.createTime = [[json objectForKey:@"createTime"] stringValue];
        }
        
        if (self.datas.count == 1 && _isJump == 1) {
            _selectBlock(self.datas);
        }
        _isJump = 0;
        [self.mainGrid reloadData];
    } else if (searchStatus == 0 || searchStatus == 2) {
        self.createTime = nil;
        [self.datas removeAllObjects];
        [self.mainGrid reloadData];
    }
    self.mainGrid.ls_show = YES;
}

- (void)selectCategory {
    __weak typeof(self) weakSelf = self;
    [_goodsService selectLastCategoryInfo:@"1" completionHandler:^(id json) {

        [weakSelf responseSuccess2:json];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

- (void)responseSuccess2:(id)json {
    
    NSMutableArray* list = [JsonHelper transList:[json objectForKey:@"categoryList"] objName:@"CategoryVo"];
    _categoryList = [[NSMutableArray alloc] init];
    TreeNode *vo = [[TreeNode alloc] init];
    vo.itemName = @"全部";
    vo.itemId = @"";
    [_categoryList addObject:vo];
    for (CategoryVo* vo in list) {
        TreeNode *vo1 = [[TreeNode alloc] init];
        vo1.itemName = vo.name;
        vo1.itemId = vo.categoryId;
        [self.categoryList addObject:vo1];
    }
}

#pragma navigateTitle.
- (void)initHead {
    [self configTitle:@"选择商品" leftPath:Head_ICON_BACK rightPath:nil];
    [self configNavigationBar:LSNavigationBarButtonDirectRight title:@"分类" filePath:Head_ICON_CATE];
}

#pragma mark 批量按钮.
- (void)showBatchEvent {
    if (self.datas.count == 0) {
        [AlertBox show:@"请至少选择一件商品进行批量操作！"];
        return;
    }
    GoodsBatchChoiceView1* vc = [[GoodsBatchChoiceView1 alloc] init];
    [self.navigationController pushViewController:vc animated:nil];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
    NSMutableDictionary* condition = [[NSMutableDictionary alloc] init];
    [condition setValue:self.searchType forKey:@"searchType"];
    [condition setValue:self.shopId forKey:@"shopId"];
    [condition setValue:self.categoryId forKey:@"categoryId"];
    [condition setValue:self.searchCode forKey:@"searchCode"];
    [condition setValue:self.barCode forKey:@"barCode"];
    [condition setValue:self.createTime forKey:@"createTime"];
    vc.searchCode = self.searchBar.keyWordTxt.text;
    __weak GoodsChoiceView* weakSelf = self;
    [vc loaddatas:weakSelf.shopId condition:condition goodsList:weakSelf.datas callBack:^(NSMutableArray *goodsList) {
        [weakSelf.navigationController popToViewController:weakSelf animated:nil];
        [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        if (goodsList) {
            _selectBlock(goodsList);
        }
    }];
}


#pragma mark - 扫一扫
// LSScanViewDelegate
- (void)scanSuccess:(ScanViewController *)controller result:(NSString *)scanString {
    _isJump = 1;
    self.searchBar.keyWordTxt.text = scanString;
    self.categoryId = @"";
    self.searchType = @"1";
    self.createTime = @"";
    self.barCode = scanString;
    [self selectGoodsList];
}

- (void)scanFail:(ScanViewController *)controller with:(NSString *)message {
    [AlertBox show:message];
}

// ISearchBarEvent
- (void)scanStart {
    ScanViewController *vc = [ScanViewController shareInstance:self types:LSScannerBarcode];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
}

- (void)showScanEvent {
    [self scanStart];
}

#pragma mark showView方法
- (void)showView:(int)viewTag; {
    if (viewTag == KIND_MENU_VIEW){
        [self.view bringSubviewToFront:self.kindMenuView.view];
        [self loadKindMenuView];
        [self.kindMenuView showMoveIn];
        return;
    }
    [self hideAllView];
}

- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event {
    if (event == LSNavigationBarButtonDirectLeft) {
        _selectBlock(nil);
    } else {
        [self showKindMenuView];
    }
}

#pragma mark 右上角分类按钮
- (void)showKindMenuView {
    [self showView:KIND_MENU_VIEW];
    [self.kindMenuView initDelegate:self event:0 isShowManagerBtn:NO];
    [self.kindMenuView loadData:nil nodes:nil endNodes:_categoryList];
}

- (void)singleCheck:(NSInteger)event item:(id<INameItem>)item {
    TreeNode* node=(TreeNode*)item;
    if ([node.itemId isEqualToString:@"noCategory"]) {
        node.itemId = @"0";
    }
    self.categoryId = node.itemId;
    self.searchCode = @"";
    self.searchType = @"2";
    self.createTime = @"";
    self.barCode = @"";
    self.searchBar.keyWordTxt.text = @"";
    [self selectGoodsList];
}

- (void)closeSingleView:(NSInteger)event {
    
}

#pragma mark 搜索框
- (void)imputFinish:(NSString *)keyWord {
    if (keyWord.length > 50) {
        [AlertBox show:@"检索字数不能超过50字，请重新输入!"];
        return ;
    }
    self.searchCode = keyWord;
    self.categoryId = @"";
    self.searchType = @"1";
    self.createTime = @"";
    self.barCode = @"";
    _isJump = 1;
    [self selectGoodsList];
}

#pragma table部分
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommonGoodsSelectCell *cell = [CommonGoodsSelectCell commonGoodsSelectCellWith:tableView];
    GoodsVo *item = [self.datas objectAtIndex:indexPath.row];
    [cell fillGoodVo:item];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.datas != nil) {
        [self showEditNVItemEvent:@"goods" withObj:[self.datas objectAtIndex:indexPath.row]];
    }
}

- (void)showEditNVItemEvent:(NSString *)event withObj:(id<INameValueItem>)obj {
    GoodsVo* editObj = (GoodsVo*) obj;
    NSMutableArray* list = [[NSMutableArray alloc] init];
    [list addObject:editObj];
    _selectBlock(list);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count == 0 ? 0 :self.datas.count;
}

#pragma mark - 隐藏module下所有初始化的view
// 隐藏视图
- (void)hideAllView {
    // 遍历所有子视图
    for (UIView *view in [self.view subviews]) {
        
        // 隐藏所有子视图
        [view setHidden:YES];
    }
}

#pragma mark - 隐藏module下所有初始化的view
// 显示视图
- (void)showAllView {
    // 遍历所有子视图
    for (UIView *view in [self.view subviews]) {
        
        // 显示所有子视图
        [view setHidden:NO];
    }
}

//-(void) loadGoodsBatchChoiceView
//{
//    if (self.goodsBatchChoiceView) {
//        self.goodsBatchChoiceView.view.hidden = NO;
//    }else{
//        self.goodsBatchChoiceView = [[GoodsBatchChoiceView alloc] initWithNibName:[SystemUtil getXibName:@"GoodsBatchChoiceView"] bundle:nil parent:self];
//        [self.view addSubview:self.goodsBatchChoiceView.view];
//    }
//}

- (void)loadKindMenuView {
    if (self.kindMenuView) {
        self.kindMenuView.view.hidden = NO;
    }else{
        self.kindMenuView = [[KindMenuView alloc] init];
        self.kindMenuView.view.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
        [self.view addSubview:self.kindMenuView.view];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _goodsService = [ServiceFactory shareInstance].goodsService;
    [self initHead];
    [self configViews];
    [self loaddatas];
   
}

- (void)configViews {
    self.searchBar = [SearchBar searchBar];
    [self.searchBar initDeleagte:self placeholder:@"条形码/简码/拼音码"];
    [self.view addSubview:self.searchBar];
    __weak typeof(self) wself = self;
    [self.searchBar makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(wself.view);
        make.top.equalTo(wself.view.top).offset(kNavH);
        make.height.equalTo(44);
    }];
    self.mainGrid = [[UITableView alloc] init];
    self.mainGrid.delegate = self;
    self.mainGrid.dataSource = self;
    self.mainGrid.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainGrid.backgroundColor = [UIColor clearColor];
    self.mainGrid.tableFooterView = [ViewFactory generateFooter:HEIGHT_CONTENT_BOTTOM];
    [self.view addSubview:self.mainGrid];
    
    [self.mainGrid makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself.view);
        make.top.equalTo(wself.searchBar.bottom);
    }];
    
    self.footView = [LSFooterView footerView];
    [self.footView initDelegate:self btnsArray:@[kFootScan, kFootBatch]];
    [self.view addSubview:self.footView];
    [self.footView makeConstraints:^(MASConstraintMaker *make) {
         make.left.right.bottom.equalTo(wself.view);
        make.height.equalTo(60);
    }];
    
    if ([NSString isNotBlank:self.searchCode]) {
        self.searchBar.keyWordTxt.text = self.searchCode;
    } else {
        self.searchBar.keyWordTxt.text = @"";
        self.searchCode = @"";
    }
  
    [self.mainGrid ls_addHeaderWithCallback:^{
        wself.createTime = @"";
        wself.currentPage = 1;
        [wself selectGoodsList];
    }];
    [self.mainGrid ls_addFooterWithCallback:^{
        wself.currentPage ++;
        [wself selectGoodsList];
    }];
    

}

- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootScan]) {
        [self showScanEvent];
    } else if ([footerType isEqualToString:kFootBatch]) {
        [self showBatchEvent];
    }
}

@end
