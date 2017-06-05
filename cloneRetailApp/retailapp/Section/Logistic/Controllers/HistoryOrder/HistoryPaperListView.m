//
//  HistoryPaperListView.m
//  retailapp
//
//  Created by hm on 15/9/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "HistoryPaperListView.h"
#import "ServiceFactory.h"
#import "PaperCheckCell.h"
#import "DateUtils.h"
#import "XHAnimalUtil.h"
#import "ColorHelper.h"
#import "GridColHead.h"
#import "OptionPickerBox.h"
#import "DatePickerBox.h"
#import "LRender.h"
#import "GlobalRender.h"
#import "PaperVo.h"
#import "AlertBox.h"
#import "SelectSupplierListView.h"
#import "DicItemConstants.h"
#import "LSFilterModel.h"
#import "LSFilterView.h"

@interface HistoryPaperListView ()<OptionPickerClient,DatePickerClient, LSFilterViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic,strong) LogisticService* logisticService;
/**单据类型*/
@property (nonatomic) HistoryPaperListViewType paperType;
/**单据id*/
@property (nonatomic,copy) NSString* paperId;
/**回调block*/
@property (nonatomic,copy) SelectPaperHandler paperHandler;
/**单据状态列表*/
@property (nonatomic,strong) NSMutableArray* statusList;
/**分页*/
@property (nonatomic) NSInteger currentPage;
/**单据状态*/
@property (nonatomic,copy) NSString* billStatus;
/**供应商id*/
@property (nonatomic,copy) NSString* supplyId;
/**检索日期*/
@property (nonatomic,copy) NSNumber* sendEndTime;
/**店铺模式 101 服鞋 102 商超*/
@property (nonatomic,assign) NSInteger shopMode;
/**单据数据模型*/
@property (nonatomic,strong) PaperVo* paper;
/** <#注释#> */
@property (nonatomic, strong) UITableView *mainGrid;

/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *datas;

/** <#注释#> */
@property (nonatomic, strong) LSFilterView *viewFilter;
/** 状态 */
@property (nonatomic, strong) LSFilterModel *modelStatus;

/** 供应商 */
@property (nonatomic, strong) LSFilterModel *modelSuppiler;

/** 要求到货日期 */
@property (nonatomic, strong) LSFilterModel *modelDate;
@end

@implementation HistoryPaperListView



- (void)viewDidLoad {
    [super viewDidLoad];
    self.logisticService = [ServiceFactory shareInstance].logisticService;
    [self initTittle];
    self.shopMode = [[[Platform Instance] getkey:SHOP_MODE] integerValue];
    [self configViews];
    [self configFilterView];
    self.datas = [NSMutableArray array];
    [self loadPaperType:_paperType];
    
    //初始化筛选项、重置筛选条件
    [self searchByCondition];
}

- (void)configViews {
    self.mainGrid = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    self.mainGrid.backgroundColor = [UIColor clearColor];
    self.mainGrid.delegate = self;
    self.mainGrid.dataSource = self;
    self.mainGrid.separatorStyle = UITableViewCellSeparatorStyleNone;
    __weak typeof(self) weakSelf = self;
    //下拉刷新
    [self.mainGrid ls_addHeaderWithCallback:^{
        weakSelf.currentPage = 1;
        [weakSelf selectPaperList];
    }];
    //上拉加载
    [self.mainGrid ls_addFooterWithCallback:^{
        weakSelf.currentPage++;
        [weakSelf selectPaperList];
    }];

    [self.view addSubview:self.mainGrid];
    
}

- (void)initTittle
{
    [self configTitle:@"" leftPath:Head_ICON_BACK rightPath:nil];
    [self configNavigationBar:LSNavigationBarButtonDirectLeft title:@"关闭" filePath:Head_ICON_BACK];
}


//设置页面参数及回调block
- (void)loadPaperId:(NSString*)paperId withType:(HistoryPaperListViewType)paperType callBack:(SelectPaperHandler)callBack
{
    _paperId = paperId;
    _paperType = paperType;
    _paperHandler = callBack;
}

- (void)configFilterView {
    NSString *title = nil;
    NSMutableArray *list = [NSMutableArray array];
    //状态
    
   
    NSMutableArray *vos=[NSMutableArray array];
    if (self.paperType == HistoryPaperListViewTypeHistoryPurchase) {//采购单
        LSFilterItem *item = [LSFilterItem filterItem:@"全部" itemId:@"0"];
        [vos addObject:item];
        item = [LSFilterItem filterItem:@"未提交" itemId:@"4"];
        [vos addObject:item];
        item = [LSFilterItem filterItem:@"待确认" itemId:@"1"];
        [vos addObject:item];
        item = [LSFilterItem filterItem:@"已确认" itemId:@"2"];
        [vos addObject:item];
        item = [LSFilterItem filterItem:@"已拒绝" itemId:@"3"];
        [vos addObject:item];
    } else if (self.paperType == HistoryPaperListViewTypeHistoryIn || self.paperType == HistoryPaperListViewTypeHistoryFromInToReturn) {//收货入库单
        LSFilterItem *item = [LSFilterItem filterItem:@"全部" itemId:@"0"];
        [vos addObject:item];
        
        item = [LSFilterItem filterItem:@"未提交" itemId:@"4"];
        [vos addObject:item];
        
        if ([[Platform Instance] getShopMode] == 1 || [[Platform Instance] isTopOrg]) {
            item = [LSFilterItem filterItem:@"已收货" itemId:@"2"];
            [vos addObject:item];
            // 商超单店没有该项
//            if ([[[Platform Instance] getkey:SHOP_MODE] integerValue] == CLOTHESHOES_MODE) {
//                item = [LSFilterItem filterItem:@"已拒绝" itemId:@"3"];
//                [vos addObject:item];
//            }
            
        }else{
            item = [LSFilterItem filterItem:@"配送中" itemId:@"1"];
            [vos addObject:item];
            item = [LSFilterItem filterItem:@"已收货" itemId:@"2"];
            [vos addObject:item];
            item = [LSFilterItem filterItem:@"已拒绝" itemId:@"3"];
            [vos addObject:item];
        }
    } else if (self.paperType == HistoryPaperListViewTypeHistoryReturn) {//退货出库单
        LSFilterItem *item = [LSFilterItem filterItem:@"全部" itemId:@"0"];
        [vos addObject:item];
        
        item = [LSFilterItem filterItem:@"未提交" itemId:@"4"];
        [vos addObject:item];
        
        if ([[Platform Instance] getShopMode]==1 || [[Platform Instance] isTopOrg]) {
            
            item = [LSFilterItem filterItem:@"已退货" itemId:@"2"];
            [vos addObject:item];
            
        } else {
            item = [LSFilterItem filterItem:@"待确认" itemId:@"1"];
            [vos addObject:item];
            item = [LSFilterItem filterItem:@"已退货" itemId:@"2"];
            [vos addObject:item];
            item = [LSFilterItem filterItem:@"已拒绝" itemId:@"3"];
            [vos addObject:item];
        }
    }
    self.modelStatus = [LSFilterModel filterModel:LSFilterModelTypeDefult items:vos selectItem:[LSFilterItem filterItem:@"全部" itemId:@"0"] title:@"状态"];
    [list addObject:self.modelStatus];
    
    
    
    //供应商
    self.modelSuppiler = [LSFilterModel filterModel:LSFilterModelTypeRight items:nil selectItem:[LSFilterItem filterItem:@"全部" itemId:@"0"] title:@"供应商"];
    [list addObject:self.modelSuppiler];
    
    //要求到货日
    if (self.paperType == HistoryPaperListViewTypeHistoryPurchase || self.paperType == HistoryPaperListViewTypeHistoryIn || self.paperType == HistoryPaperListViewTypeHistoryFromInToReturn) {
        title = @"要求到货日";
    } else if (self.paperType == HistoryPaperListViewTypeHistoryReturn) {
        title = @"退货日期";
    }
    self.modelDate = [LSFilterModel filterModel:LSFilterModelTypeBottom items:nil selectItem:[LSFilterItem filterItem:@"请选择" itemId:nil] title:title];
    [list addObject:self.modelDate];
    
    
    self.viewFilter = [LSFilterView addFilterViewToView:self.view delegate:self datas:list];
    
    
}

- (void)filterViewDidClickComfirmBtn {
    [self searchByCondition];
}


//显示标题和状态列表
- (void)loadPaperType:(HistoryPaperListViewType)paperType
{
    NSString *title = nil;
    if (paperType==HistoryPaperListViewTypeHistoryPurchase) {
//        self.titleBox.lblTitle.text = (self.shopMode==CLOTHESHOES_MODE)?@"历史采购单":@"历史叫货单";
        title = @"历史采购单";
        self.statusList = [LRender listOrderStatus];
    }else if (paperType==HistoryPaperListViewTypeHistoryIn || paperType == HistoryPaperListViewTypeHistoryFromInToReturn){
//        self.titleBox.lblTitle.text = @"历史收货单";
        title = @"历史入库单";
        self.statusList = [LRender listStockInStatus];
    }else if (paperType==HistoryPaperListViewTypeHistoryReturn){
        title = @"历史退货单";
        self.statusList = [LRender listReturnStatus];
    }
    [self configTitle:title];
}

#pragma mark - 列表条件选择

- (void)filterViewdidClickModel:(LSFilterModel *)filterModel {
    if (filterModel == self.modelSuppiler) {
            //供应商选择
            SelectSupplierListView* selectSupplierListView = [[SelectSupplierListView alloc] init];
            __weak typeof(self) weakSelf = self;
            NSString *supplyFlag =nil;
            if (_paperType==HistoryPaperListViewTypeHistoryPurchase) {
                supplyFlag = @"self";
                selectSupplierListView.isCondition = NO;
            } else if (_paperType == HistoryPaperListViewTypeHistoryIn) {
                supplyFlag = @"third";
                selectSupplierListView.isCondition = NO;
            }else if (_paperType == HistoryPaperListViewTypeHistoryFromInToReturn) {
                if ([[Platform Instance] getShopMode] != 1 && ![[Platform Instance] isTopOrg]) {
                    supplyFlag = @"self";
                    selectSupplierListView.isCondition = YES;
                } else {
                    supplyFlag = @"third";
                    selectSupplierListView.isCondition = NO;
                }
                
            }else{
                if ([[Platform Instance] getShopMode] !=1 && ![[Platform Instance] isTopOrg]) {
                    supplyFlag = @"self";
                    selectSupplierListView.isCondition = YES;
                } else {
                    supplyFlag = @"third";
                    selectSupplierListView.isCondition = NO;
                }
            }
            selectSupplierListView.isAll = YES;
            [selectSupplierListView loadDataBySupplyId:[filterModel getSelectItemId] supplyFlag:supplyFlag handler:^(id<INameValue> supplier) {
                if (supplier) {
                    [weakSelf.modelSuppiler initData:[supplier obtainItemName] withVal:[supplier obtainItemId]];
                }
                [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
                [weakSelf.navigationController popToViewController:weakSelf animated:NO];
            }];
            [self.navigationController pushViewController:selectSupplierListView animated:NO];
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
            selectSupplierListView = nil;
    } else if (filterModel == self.modelDate) {
        //日期选择
        //        NSDate* date = [NSDate date];
        NSDate *date = [DateUtils parseDateTime4:[filterModel getSelectItemName]];
        [DatePickerBox showClear:filterModel.title clearName:@"清空日期" date:date client:self event:100];
    }
}


- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType
{
    id<INameItem> vo = (id<INameItem>)selectObj;
    if (eventType==100) {
        self.modelStatus.selectItem = [LSFilterItem filterItem:[vo obtainItemName] itemId:[vo obtainItemId]];
    }
    return YES;
}

- (BOOL)pickDate:(NSDate *)date event:(NSInteger)event
{
    [self.modelDate initData:[DateUtils formateDate2:date] withVal:[DateUtils formateDate2:date]];
    return YES;
}

- (void)clearDate:(NSInteger)eventType
{
    [self.modelDate initData:@"请选择" withVal:nil];
}

#pragma mark - 条件查询数据（重写父类方法）
- (void)searchByCondition
{
    self.billStatus = [self.modelStatus getSelectItemId];
    
    if ([NSString isNotBlank:[self.modelDate getSelectItemId]]) {
        self.sendEndTime = [NSNumber numberWithLongLong:[DateUtils formateDateTime3:[self.modelDate getSelectItemId]]];
    }else{
        self.sendEndTime = nil;
    }
    self.currentPage = 1;
    
    self.supplyId = [[self.modelSuppiler getSelectItemId] isEqualToString:@"0"]?nil:[self.modelSuppiler getSelectItemId];
    [self selectPaperList];
}

#pragma mark - 查询历史单据列表
- (void)selectPaperList
{
    if (self.paperType==HistoryPaperListViewTypeHistoryPurchase) {
        [self selectOrderPaperList];
    }else if (self.paperType==HistoryPaperListViewTypeHistoryIn || self.paperType == HistoryPaperListViewTypeHistoryFromInToReturn){
        [self selectPurchasePaperList];
    }else if (self.paperType==HistoryPaperListViewTypeHistoryReturn) {
        [self selectReturnPaperList];
    }
}
#pragma mark -历史叫货单列表
- (void)selectOrderPaperList
{
    __weak typeof(self) weakSelf = self;
    [_logisticService selectOrderPaperList:[[Platform Instance] getkey:SHOP_ID] status:(short)[self.billStatus intValue] supplyId:self.supplyId date:self.sendEndTime page:self.currentPage type:1 isNeedDel:@"1" completionHandler:^(id json) {
        NSMutableArray* orderGoodsList = [PaperVo converToArr:[json objectForKey:@"orderGoodsList"] paperType:ORDER_PAPER_TYPE];
        [weakSelf reloadMainView:orderGoodsList];
    } errorHandler:^(id json) {
        [AlertBox show:json];
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
    }];
}

#pragma mark - 历史收货单列表
- (void)selectPurchasePaperList
{
    __weak typeof(self) weakSelf = self;
    int history = 1;
    if (self.paperType == HistoryPaperListViewTypeHistoryIn) {
        history = 1;
    } else if (self.paperType == HistoryPaperListViewTypeHistoryFromInToReturn) {
        history = 0;
    }
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:6];
    [param setValue:[[Platform Instance] getkey:SHOP_ID] forKey:@"shopId"];
    [param setValue:@(self.billStatus.intValue) forKey:@"billStatus"];
    [param setValue:self.supplyId forKey:@"supplyId"];
    [param setValue:@(self.currentPage) forKey:@"currentPage"];
    [param setValue:self.sendEndTime forKey:@"sendEndTime"];
    [param setValue:@(history) forKey:@"isHistory"];
    //是否获取供应商删除信息
    [param setValue:@"1" forKey:@"isNeedDel"];
    NSString* url = @"purchase/list";
    
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        NSMutableArray* stockInList = [PaperVo converToArr:[json objectForKey:@"stockInList"] paperType:PURCHASE_PAPER_TYPE];
        [weakSelf reloadMainView:stockInList];;
    } errorHandler:^(id json) {
        [AlertBox show:json];
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
    }];
}

#pragma mark - 历史退货单列表
- (void)selectReturnPaperList
{
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:7];
    [param setValue:@"" forKey:@"shopId"];
    [param setValue:@(self.billStatus.intValue) forKey:@"billStatus"];
    [param setValue:self.supplyId forKey:@"supplyId"];
    [param setValue:[NSNumber numberWithInteger:self.currentPage] forKey:@"currentPage"];
    //是否获取供应商删除信息
    [param setValue:@"1" forKey:@"isNeedDel"];
    [param setValue:self.sendEndTime forKey:@"sendendtime"];
    [param setValue:DIC_CHAIN_RETURN_STATUS forKey:@"dicCode"];
    [param setValue:[NSNumber numberWithShort:1] forKey:@"type"];
    NSString* url = @"returnGoods/list";

    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        NSMutableArray* returnGoodsList = [PaperVo converToArr:[json objectForKey:@"returnGoodsList"] paperType:RETURN_PAPER_TYPE];
        [weakSelf reloadMainView:returnGoodsList];;
        [weakSelf.mainGrid footerEndRefreshing];
    } errorHandler:^(id json) {
        [AlertBox show:json];
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
    }];
}

//刷新页面
- (void)reloadMainView:(NSMutableArray *)dataArr
{
    if (self.currentPage == 1) {
        [self.datas removeAllObjects];
    }
    [self.datas addObjectsFromArray:dataArr];
    [self.mainGrid reloadData];
    self.mainGrid.ls_show = YES;
    [self.mainGrid headerEndRefreshing];
    [self.mainGrid footerEndRefreshing];
}

#pragma mark - UITableView
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString* gridColHeadId = @"GridColHead";
    GridColHead *headItem = (GridColHead *)[self.mainGrid dequeueReusableCellWithIdentifier:gridColHeadId];
    if (!headItem) {
        [tableView registerNib:[UINib nibWithNibName:@"GridColHead" bundle:nil] forCellReuseIdentifier:gridColHeadId];
        headItem = [tableView dequeueReusableCellWithIdentifier:gridColHeadId];
    }
    
    [headItem initColHead:@"供应商" col2:@"状态"];
    [headItem initColLeft:15 col2:137];
    return headItem;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count == 0 ? 0 :self.datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* paperCellId = @"PaperCheckCell";
    PaperCheckCell* cell = [tableView dequeueReusableCellWithIdentifier:paperCellId];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"PaperCheckCell" bundle:nil] forCellReuseIdentifier:paperCellId];
        cell = [tableView dequeueReusableCellWithIdentifier:paperCellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setNeedsDisplay];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    PaperCheckCell* detailItem = (PaperCheckCell*)cell;
    detailItem.checkPic.hidden = YES;
    if (self.datas.count>0 && indexPath.row<self.datas.count) {
        self.paper = [self.datas objectAtIndex:indexPath.row];
        detailItem.lblPaperNo.text = [NSString stringWithFormat:@"单号:%@",self.paper.paperNo];
        detailItem.lblStatus.text = [GlobalRender obtainItem:self.statusList itemId:[NSString stringWithFormat:@"%tu",self.paper.billStatus]];
        detailItem.lblDetail.text = self.paper.supplyName;
        if (self.paperType==HistoryPaperListViewTypeHistoryIn||self.paperType==HistoryPaperListViewTypeHistoryPurchase || self.paperType == HistoryPaperListViewTypeHistoryFromInToReturn) {
            detailItem.lblDate.text = [NSString stringWithFormat:@"要求到货日:%@",[DateUtils formateTime2:self.paper.sendEndTime]];
        }else{
            detailItem.lblDate.text = [NSString stringWithFormat:@"退货日期:%@",[DateUtils formateTime2:self.paper.sendEndTime]];
        }
        if (self.paper.billStatus==4) {
            //未提交 蓝色
            detailItem.lblStatus.textColor = [ColorHelper getBlueColor];
        }else if (self.paper.billStatus==1) {
            //待确认 绿色
            detailItem.lblStatus.textColor = [ColorHelper getGreenColor];
        }else if (self.paper.billStatus==2) {
            //已确认 灰色
            detailItem.lblStatus.textColor = [ColorHelper getTipColor6];
        }else{
            //已拒绝 红色
            detailItem.lblStatus.textColor = [ColorHelper getRedColor];
        }
        [detailItem.checkPic setHidden:![self.paperId isEqualToString:self.paper.paperId]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.paper = [self.datas objectAtIndex:indexPath.row];
    
    if (self.paper.supplyCheck) {//供应商被删除
        [LSAlertHelper showAlert:@"该单据的供应商已被删除，不支持导入！"];
        return;
    }
    if (self.shopMode==CLOTHESHOES_MODE) {
        //服鞋版选择历史单导入提示信息
        self.paperId = self.paper.paperId;
        [self.mainGrid reloadData];
        if (self.paperType==HistoryPaperListViewTypeHistoryPurchase) {
            [self alertMessage:@"导入后将生成一张新的采购单!"];
        }else if (self.paperType==HistoryPaperListViewTypeHistoryIn) {
            [self alertMessage:@"导入后将生成一张新的收货入库单!"];
        }else if (self.paperType==HistoryPaperListViewTypeHistoryReturn || self.paperType == HistoryPaperListViewTypeHistoryFromInToReturn) {
            [self alertMessage:@"导入后将生成一张新的退货出库单!"];
        }
    }else{
        //商超版历史单导入
        if (_paperHandler) {
            _paperHandler(self.paper.paperId, self.paper.recordType, nil);
        }
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)alertMessage:(NSString *)message
{
    UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alert1 show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {
            if (self.paperType == HistoryPaperListViewTypeHistoryPurchase) {
                [self.logisticService importOrderPaperById:self.paperId completionHandler:^(id json) {
                    [self createOrder:json];
                } errorHandler:^(id json) {
                    [AlertBox show:json];
                }];
                
            } else if (self.paperType == HistoryPaperListViewTypeHistoryIn) {
                [self.logisticService importPurchasePaperById:self.paperId completionHandler:^(id json) {
                    [self createOrder:json];
                } errorHandler:^(id json) {
                    [LSAlertHelper showAlert:json];
                }];
                
            } else if (self.paperType == HistoryPaperListViewTypeHistoryReturn) {
                [self.logisticService importReturnPaperById:self.paperId completionHandler:^(id json) {
                    [self createOrder:json];
                } errorHandler:^(id json) {
                    [LSAlertHelper showAlert:json];
                }];
                
            } else if (self.paperType == HistoryPaperListViewTypeHistoryFromInToReturn) {
                NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:1];
                [param setValue:self.paperId forKey:@"historyId"];
                [param setValue:@"1" forKey:@"isNeedDel"];
                //从历史入库单导入生成退货单
                NSString *url = @"returnGoods/importReturnGoodsPurchase";
                [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
                    [self createOrder:json];
                } errorHandler:^(id json) {
                    [LSAlertHelper showAlert:json];
                }];
                
            }
            
        } else {
            [self createOrder:nil];
        }

    }
}

- (void)createOrder:(id)json{
    if (_paperHandler) {
        _paperHandler(self.paperId, self.paper.recordType, json);
    }
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
    [self.navigationController popViewControllerAnimated:NO];

}

@end
