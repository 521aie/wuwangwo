//
//  SelectSupplierListView.m
//  retailapp
//
//  Created by hm on 15/9/29.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SelectSupplierListView.h"
#import "SupplierCell.h"
#import "SupplyVo.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "OptionPickerBox.h"
#import "LSEditItemList.h"
#import "UIView+Sizes.h"
#import "LRender.h"
@interface SelectSupplierListView ()<ISearchBarEvent,IEditItemListEvent,OptionPickerClient>

@property (nonatomic ,copy) SelectSupplierHandler supplierHandler;
@property (nonatomic ,strong) CommonService *commonService;
@property (nonatomic ,strong) LSEditItemList *lstCondition;
@property (nonatomic ,copy) NSString *selectId;
@property (nonatomic ,assign) NSInteger currentPage;
@property (nonatomic ,copy) NSString *keyWord;
@property (nonatomic ,copy) NSString *supplyFlag;
@end

@implementation SelectSupplierListView


- (void)viewDidLoad {
    [super viewDidLoad];
    _commonService = [ServiceFactory shareInstance].commonService;
    self.footView.hidden = YES;
    [self initNavigate];
    [self.searchBar initDelagate:self placeholder:@"名称/手机号"];
    
    /*
    if ([[Platform Instance] getShopMode] != 1) {
            [self initConditionItem];
    } else {
        self.supplyFlag = @"third"; // 标示只显示第三方供应商
    }
    */
    
    if (self.isCondition) {
        [self initConditionItem];
    }
    
    self.currentPage = 1;
    self.keyWord = @"";
    [self selectSupplyList:self.keyWord page:self.currentPage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initNavigate {
    [self configTitle:@"选择供应商" leftPath:Head_ICON_BACK rightPath:nil];
}

- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event {
    if (event == LSNavigationBarButtonDirectLeft) {
        if (_supplierHandler) {
            _supplierHandler(nil);
        }
    }
}

- (void)initConditionItem {
    self.lstCondition = [LSEditItemList editItemList];
    self.lstCondition.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    self.lstCondition.line.hidden = YES;
    [self.view addSubview:self.lstCondition];
    self.lstCondition.ls_top = kNavH;
    [self.lstCondition initLabel:@"供应商类型" withHit:nil delegate:self];
    [self.lstCondition initData:@"内部供应商" withVal:@"self"];
    [self.searchBar setLs_top:self.lstCondition.ls_bottom];
    [self.mainGrid setLs_top:self.searchBar.ls_top+self.searchBar.ls_height];
    [self.mainGrid setLs_height:self.view.ls_height-self.mainGrid.ls_top];
}

- (void)onItemListClick:(LSEditItemList *)obj {
    if (obj == self.lstCondition) {
        [OptionPickerBox initData:[LRender listSupplierType] itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    }
}



- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType
{
    id<INameItem>  item = (id<INameItem>)selectObj;
    [self.lstCondition initData:[item obtainItemName] withVal:[item obtainItemId]];
    _supplyFlag = [item obtainItemId];
    self.keyWord = nil;
    self.searchBar.keyWordTxt.text = nil;
    [self selectSupplyList:self.keyWord page:self.currentPage];
    return YES;
}

- (void)imputFinish:(NSString *)keyWord {
    self.currentPage = 1;
    self.keyWord =keyWord;
    [self selectSupplyList:keyWord page:1];
}

- (void)loadDataBySupplyId:(NSString*)supplierId supplyFlag:(NSString *)supplyFlag handler:(SelectSupplierHandler)handler
{
    _supplierHandler = handler;
    _selectId = supplierId;
    _supplyFlag = supplyFlag;
//    _supplyFlag = @"self";
}

#pragma mark - 获取数据
- (void)selectSupplyList:(NSString *)keyWord page:(NSInteger)currentPage
{
    __weak typeof(self) weakSelf = self;
    [_commonService selectSupplyList:keyWord shopId:_shopId page:currentPage supplyFlag:self.supplyFlag completionHandler:^(id json) {
        NSMutableArray* supplyList = [SupplyVo converToArr:[json objectForKey:@"supplyList"]];
        if (weakSelf.currentPage==1) {
            [weakSelf.dataList removeAllObjects];
            if (weakSelf.isAll&&supplyList.count > 0) {
                SupplyVo *supplyVo = [[SupplyVo alloc] init];
                supplyVo.supplyId = @"0";
                supplyVo.supplyName = @"全部";
                [weakSelf.dataList addObject:supplyVo];
            }
        }
        [weakSelf.dataList addObjectsFromArray:supplyList];
        supplyList = nil;
        [weakSelf.mainGrid reloadData];
        weakSelf.mainGrid.ls_show = YES;
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
    } errorHandler:^(id json) {
        [AlertBox show:json];
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
    }];
    
}

#pragma mark UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* supplierCellId = @"SupplierCell";
    SupplierCell* cell = [tableView dequeueReusableCellWithIdentifier:supplierCellId];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"SupplierCell" bundle:nil] forCellReuseIdentifier:supplierCellId];
        cell = [tableView dequeueReusableCellWithIdentifier:supplierCellId];
    }
    [cell.checkPic setHidden:YES];
    [cell setNeedsDisplay];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    SupplierCell* supplierCell = (SupplierCell*)cell;
    if (self.dataList.count>0&&indexPath.row<self.dataList.count) {
        SupplyVo* vo = [self.dataList objectAtIndex:indexPath.row];
        supplierCell.lblName.text = vo.supplyName;
        supplierCell.lblDetail.text = [vo.supplyId isEqualToString:@"0"]?@"":[NSString stringWithFormat:@"%@：%@",vo.relation,vo.mobile];
        [supplierCell.checkPic setHidden:![_selectId isEqualToString:vo.supplyId]];
        [supplierCell.uncheckPic setHidden:[_selectId isEqualToString:vo.supplyId]];
        if ([vo.supplyId isEqualToString:@"0"]) {//总部
            CGPoint center = supplierCell.lblName.center;
            center.y = 44;
            supplierCell.lblName.center = center;
        } else {
            CGPoint center = supplierCell.lblName.center;
            center.y = 30;
            supplierCell.lblName.center = center;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SupplyVo* vo = [self.dataList objectAtIndex:indexPath.row];
    if (_supplierHandler) {
        _supplierHandler(vo);
    }
}

@end
