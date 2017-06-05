//
//  SelectGoodsList.m
//  retailapp
//
//  Created by guozhi on 16/2/22.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "SelectGoodsList.h"
#import "SearchBar.h"
#import "XHAnimalUtil.h"
#import "ScanViewController.h"
#import "GoodsService.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "GoodsOperationVo.h"
#import "CommonGoodsSelectCell.h"
#import "ColorHelper.h"
#import "GoodsSplitView.h"
#import "SMHeaderItem.h"
#import "SelectGoodsItem.h"
#import "AlertBox.h"
#import "LSFooterView.h"

@interface SelectGoodsList ()<ISearchBarEvent,UITableViewDataSource,UITableViewDelegate,LSScanViewDelegate, LSFooterViewDelegate>
@property (strong, nonatomic) SearchBar *searchBar;
@property (strong, nonatomic) UITableView *tableView;
/** <#注释#> */
@property (nonatomic, strong) LSFooterView *footView;
/**精确查询的code*/
@property (nonatomic, copy) NSString *scanCode;
/**输入框输入的码*/
@property (nonatomic, copy) NSString *inputCode;
/**分页标志*/
@property (nonatomic, assign) NSInteger currentPage;
/**网络请求的参数*/
@property (nonatomic, strong) NSMutableDictionary *param;
/**网络请求*/
@property (nonatomic, strong) GoodsService *service;
/**数据源*/
@property (nonatomic, strong) NSMutableArray *datas;
/**回调商品信息*/
@property (nonatomic, copy) GoodsInfoBlock goodsInfoBlock;
/**已添加的商品用来区分商品是否重复添加*/
@property (nonatomic, strong) NSMutableArray *list;
/*
 *  2  商品拆分
 *  3  商品组装
 *  6  商品加工
 */
@property (nonatomic,assign) NSInteger fileType;
@property (nonatomic,assign) BOOL isBig;
@property (nonatomic, strong) GoodsOperationVo *selectedItem;/**<选中的goodsOperationVo>*/
@end

@implementation SelectGoodsList
- (instancetype)initWithBig:(BOOL)isBig fileType:(int)fileType searchCodeList:(NSMutableArray *)list goodsIndoBlock:(GoodsInfoBlock)goodsInfoBlock {
    self = [super init];
    if (self) {
        self.service = [ServiceFactory shareInstance].goodsService;
        self.isBig = isBig;
        self.fileType = fileType;
        self.goodsInfoBlock = goodsInfoBlock;
        self.list = list;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPage = 1;
    [self initNavigate];
    [self configViews];
    [self initSearchBar];
    [self inittableView];
    [self loadData];
}

#pragma mark - 导航栏
//初始化导航栏
- (void)initNavigate {
    [self configTitle:@"选择商品" leftPath:Head_ICON_BACK rightPath:nil];
}
- (void)configViews {
    CGFloat y = kNavH;
    self.searchBar = [SearchBar searchBar];
    self.searchBar.frame = CGRectMake(0, y, SCREEN_W, 44);
    [self.view addSubview:self.searchBar];
    
    y = self.searchBar.ls_bottom;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, y, SCREEN_W, SCREEN_H - y)];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.footView = [LSFooterView footerView];
    [self.footView initDelegate:self btnsArray:@[kFootScan]];
    [self.view addSubview:self.footView];
    self.footView.ls_bottom = SCREEN_H;

}

#pragma mark - 搜索框
//初始化搜索框
- (void)initSearchBar {
    [self.searchBar initDeleagte:self placeholder:@"条形码/简码/拼音码"];
}

// 输入完成
- (void)imputFinish:(NSString *)keyWord {
    self.inputCode = keyWord;
    [self loadData];
    self.inputCode = nil;
}

#pragma mark - 条形码扫描
// 开始扫描
- (void)scanStart {
    [self showScanView];
}

// LSScanViewDelegate
- (void)scanSuccess:(ScanViewController *)controller result:(NSString *)scanString {
    self.scanCode = scanString;
    [self loadData];
    self.scanCode = nil;
}

- (void)scanFail:(ScanViewController *)controller with:(NSString *)message {
    [AlertBox show:message];
}

// 扫一扫页面
- (void)showScanView {
    ScanViewController *vc = [ScanViewController shareInstance:self types:LSScannerBarcode];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
}

- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootScan]) {
        [self showScanEvent];
    }
}

//底部的扫一扫点击事件
- (void)showScanEvent {
    [self showScanView];
}

#pragma mark - 表格
- (void)inittableView {
    _tableView.tableFooterView = [ViewFactory generateFooter:BOTTOM_HEIGHT];
    _tableView.rowHeight = 88.0f;
    __weak typeof(self) weakSelf = self;
    [self.tableView ls_addHeaderWithCallback:^{
        weakSelf.currentPage = 1;
        [weakSelf loadData];
        
    }];
    [self.tableView ls_addFooterWithCallback:^{
        weakSelf.currentPage++;
        [weakSelf loadData];
        
    }];
}

//数据源
- (NSMutableArray *)datas {
    if (_datas == nil) {
        _datas = [[NSMutableArray alloc] init];
    }
    return _datas;
}
//网络请求的参数
- (NSMutableDictionary *)param {
    if (_param == nil) {
        _param = [[NSMutableDictionary alloc] init];
    }
    [_param removeAllObjects];
    if ([NSString isNotBlank:self.scanCode]) {
        [_param setValue:self.scanCode forKey:@"barCode"];
    }
    if([NSString isNotBlank:self.inputCode]) {
         [_param setValue:self.inputCode forKey:@"searchCode"];
    }
    [_param setValue:[NSNumber numberWithInteger:self.currentPage] forKey:@"currentPage"];
    if (self.isBig) {
        [_param setValue:[NSString stringWithFormat:@"%ld",(long)self.fileType] forKey:@"filtType"];
        [_param setValue:@1 forKey:@"type"];
    }
    return _param;
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    CommonGoodsSelectCell *cell = [CommonGoodsSelectCell commonGoodsSelectCellWith:tableView];
    [cell fillGoodsOperationVo:_datas[indexPath.row]];
    return cell;
}

//判断添加的商品是否重复添加
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    GoodsOperationVo *item = [self.datas objectAtIndex:indexPath.row];
    for (SelectGoodsItem *goodsItem in self.list) {
            if ([goodsItem.goodsVo.goodsId isEqualToString:item.goodsId]) {
                [AlertBox show:[NSString stringWithFormat:@"[%@]已经存在，请重新选择商品！",item.goodsName]];
                return;
            }
     }
#warning "jicika"
//
//    if (item.goodsId.length > 0) {
//        self.selectedItem = item;
//        [self checkEntityHaveGoods:item.goodsId];
//    }

    self.goodsInfoBlock(item);
#warning "jicika"
}

#pragma mark - 网络请求
//加载数据
- (void)loadData {
    NSString *url = @"split/choice";
    __weak typeof(self) weakSelf = self;
    [self.service getGoodsInfo:url param:self.param completionHandler:^(id json) {
        [weakSelf.tableView headerEndRefreshing];
        [weakSelf.tableView footerEndRefreshing];
        if (weakSelf.currentPage == 1) {
            [weakSelf.datas removeAllObjects];
        }
        if ([ObjectUtil isNotNull:json]) {
            NSArray *goodsHandleList = [json objectForKey:@"goodsList"];
            if ([ObjectUtil isNotNull:goodsHandleList]) {
                for (NSDictionary *obj in goodsHandleList) {
                    GoodsOperationVo *vo = [[GoodsOperationVo alloc] initWithDictionary:obj];
                    [weakSelf.datas addObject:vo];
                }
            }
        }
        [weakSelf.tableView reloadData];
        weakSelf.tableView.ls_show = YES;
        if ([NSString isNotBlank:weakSelf.searchBar.keyWordTxt.text] && weakSelf.datas.count == 1) {
            GoodsOperationVo *item = weakSelf.datas[0];
            for (SelectGoodsItem *goodsItem in self.list) {
                if ([goodsItem.goodsVo.goodsId isEqualToString:item.goodsId]) {
                    [AlertBox show:[NSString stringWithFormat:@"[%@]已经存在，请重新选择商品！",item.goodsName]];
                    return;
                }
            }
            self.goodsInfoBlock(item);
            return;
        }
    } errorHandler:^(id json) {
        [weakSelf.tableView headerEndRefreshing];
        [weakSelf.tableView footerEndRefreshing];
        [AlertBox show:json];
    }];
}

// 查看会员卡内有效的计次服务内是否含有选中的商品
- (void)checkCustomerHaveGoods:(NSString *)goodId {
    
    __weak typeof(self) wself = self;
    NSDictionary *param = @{@"goodsId":goodId};
    NSString *path = @"accountcard/checkCustomerHaveGoods";
    [BaseService getRemoteLSDataWithUrl:path param:param withMessage:@"" show:YES CompletionHandler:^(id json) {
        
        if ([[json valueForKey:@"checked"] boolValue]) {
            [LSAlertHelper showAlert:@"该商品存在未消费的计次服务，不能添加为拆分/组装/加工商品！"];
            return ;
        }
        wself.goodsInfoBlock(wself.selectedItem);
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json];
    }];
}

// 查看记次服务设置中是否含有选中的商品
- (void)checkEntityHaveGoods:(NSString *)goodId {
    
    __weak typeof(self) wself = self;
    NSDictionary *param = @{@"goodsId":goodId};
    NSString *path = @"accountcard/checkEntityHaveGoods";
    [BaseService getRemoteLSDataWithUrl:path param:param withMessage:@"" show:YES CompletionHandler:^(id json) {
       
        if ([[json valueForKey:@"checked"] boolValue]) {
            [LSAlertHelper showAlert:@"该商品设置了计次服务，请先在计次服务设置中删除对应设置！"];
            return ;
        }
        [wself checkCustomerHaveGoods:goodId];
        
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json];
    }];
}


@end
