//
//  SelectOpOrderShopView.m
//  retailapp
//
//  Created by Jianyong Duan on 15/12/16.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SelectOpOrderShopView.h"
#import "ServiceFactory.h"
#import "WechatService.h"
#import "AlertBox.h"
#import "OpOrderShopCell.h"
#import "DateUtils.h"
#import "InstanceVo.h"
#import "OrderDivideVo.h"
#import "UIView+Sizes.h"

@interface SelectOpOrderShopView ()< ISearchBarEvent>

@property (nonatomic, strong) WechatService *wechatService;

@property (nonatomic) BOOL isPush;
@property (nonatomic, copy) NSString *goodsId;
@property (nonatomic, copy) NSString *keyword;
@property (nonatomic) long long lastDateTime;
@property (nonatomic) BOOL isRefresh;
@property (nonatomic, copy) NSString *selectId;

@end

@implementation SelectOpOrderShopView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.wechatService = [ServiceFactory shareInstance].wechatService;
    self.lastDateTime = 0;
    self.isRefresh = YES;
    self.wechatService = [ServiceFactory shareInstance].wechatService;
    [self initNavigate];
    [self.searchBar initDelagate:self placeholder:@"编号"];
    self.footView.hidden = YES;
    self.dataList = [NSMutableArray array];
    [self addHeaderAndFooter];
    
    [self selectOpShopWareList];
}

- (void)addHeaderAndFooter
{
    __weak typeof(self) weakSelf = self;
    [self.mainGrid addHeaderWithCallback:^{
        
        self.lastDateTime = [DateUtils getEndTimeOfDate1:[NSDate date]];
        self.isRefresh = YES;
        [weakSelf selectOpShopWareList];
    }];
    
    [self.mainGrid addFooterWithCallback:^{
        self.isRefresh = NO;
        [weakSelf selectOpShopWareList];
    }];
}

- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event==LSNavigationBarButtonDirectLeft) {
        if (_shopStoreHandele) {
            _shopStoreHandele(nil);
        }
    }
}

- (void)imputFinish:(NSString *)keyWord
{
    self.keyword = keyWord;
    [self.mainGrid headerBeginRefreshing];
}

- (void)initNavigate
{
    [self configTitle:@"选择处理门店" leftPath:Head_ICON_BACK rightPath:nil];
}

- (void)selectOpShopWareList {
    __weak typeof(self) weakSelf = self;
    [self.wechatService selectOpShopWareList:self.goodsId keyword:self.keyword lastCreateTime:self.lastDateTime completionHandler:^(id json) {
        
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
        
        if (self.isRefresh) {
            [weakSelf.dataList removeAllObjects];
        }
        if ([ObjectUtil isNotNull:json[@"opOrderShopList"]]) {
            for (NSDictionary *dict in json[@"opOrderShopList"]) {
                OpOrderShopWare *vo = [OpOrderShopWare mj_objectWithKeyValues:dict];
                if ([vo.opOrderShopId isEqualToString:self.dealShopId]) {
                    continue;
                }
                [weakSelf.dataList addObject:vo];
            }
        }
        if ([ObjectUtil isNotNull:json[@"lastCreateTime"]]) {
            self.lastDateTime = [json[@"lastCreateTime"] longLongValue];
        } else if ([ObjectUtil isNotNull:json[@"lastDateTime"]]) {
            self.lastDateTime = [json[@"lastDateTime"] longLongValue];
        }
                               
        [weakSelf.mainGrid reloadData];
    } errorHandler:^(id json) {
        [AlertBox show:json];
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
    }];
}

- (void)loadData:(NSString *)selectId goodsId:(NSString*)goodsId isPush:(BOOL)isPush callBack:(SelectOpOrderShopHandler)shopStoreHandele {
    self.goodsId = goodsId;
    self.isPush = isPush;
    self.selectId = selectId;
    _shopStoreHandele = shopStoreHandele;
    self.footView.hidden = YES;
    self.keyword = nil;
    if (!isPush) {
        [self selectOpShopWareList];
    }
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* supplierCellId = @"OpOrderShopCell";
    OpOrderShopCell* cell = [tableView dequeueReusableCellWithIdentifier:supplierCellId];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"OpOrderShopCell" bundle:nil] forCellReuseIdentifier:supplierCellId];
        cell = [tableView dequeueReusableCellWithIdentifier:supplierCellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    OpOrderShopWare *item = [self.dataList objectAtIndex:indexPath.row];
    cell.lblName.text = item.name;
//    CGFloat w = 170;
//    UIFont *font = cell.lblName.font;
//    CGSize maxSize = CGSizeMake(w, MAXFLOAT);
//    CGSize sizeName = [NSString sizeWithText:item.name maxSize:maxSize font:font];
//    cell.lblName.ls_size = sizeName;
    if ([self.selectId isEqualToString:item.opOrderShopId]) {
        cell.imgCheck.hidden = NO;
        cell.imgUnCheck.hidden = YES;
    } else {
        cell.imgCheck.hidden = YES;
        cell.imgUnCheck.hidden = NO;
    }
    
    
    
    if (item.shopType == 1) {
        cell.lblCode.text = [NSString stringWithFormat:@"门店编号：%@", item.code];
    } else {
        cell.lblCode.text = [NSString stringWithFormat:@"仓库编号：%@", item.code];
    }
    cell.lblPrice.text = @"";
    cell.lblStock.text = @"";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OpOrderShopCell* cell = (OpOrderShopCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.imgCheck.hidden = NO;
    
    OpOrderShopWare *item = [self.dataList objectAtIndex:indexPath.row];
    if (_shopStoreHandele) {
        _shopStoreHandele(item);
    }
}

@end
