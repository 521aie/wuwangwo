//
//  PackBoxListView.m
//  retailapp
//
//  Created by hm on 15/10/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "PackBoxListView.h"
#import "ServiceFactory.h"
#import "ViewFactory.h"
#import "XHAnimalUtil.h"
#import "LSFooterView.h"
#import "GridColHead.h"
#import "PaperCell.h"
#import "LRender.h"
#import "GlobalRender.h"
#import "OptionPickerBox.h"
#import "DatePickerBox.h"
#import "DateUtils.h"
#import "AlertBox.h"
#import "ColorHelper.h"
#import "PackGoodsVo.h"
#import "PackBoxEditView.h"
#import "PackBoxBatchListView.h"
#import "LSFilterModel.h"
#import "LSFilterView.h"

@interface PackBoxListView ()<OptionPickerClient,DatePickerClient, LSFooterViewDelegate, UITableViewDelegate, UITableViewDataSource, LSFilterViewDelegate>

@property (nonatomic, strong) LogisticService *logisticSevice;
/**状态列表*/
@property (nonatomic,strong) NSMutableArray *statusList;
/**分页*/
@property (nonatomic,assign) NSInteger currentPage;
/**装箱单状态值*/
@property (nonatomic,assign) short billStatus;
/**装箱日期*/
@property (nonatomic, strong) NSNumber *packTime;
/**装箱单vo*/
@property (nonatomic, strong) PackGoodsVo *packGoodsVo;

/** <#注释#> */
@property (nonatomic, strong) UITableView *mainGrid;
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *datas;

/** <#注释#> */
@property (nonatomic, strong) LSFilterView *viewFilter;

/** <#注释#> */
@property (nonatomic, strong) LSFooterView *footView;

/** 状态 */
@property (nonatomic, strong) LSFilterModel *modelStatus;

/** 要求到货日期 */
@property (nonatomic, strong) LSFilterModel *modelDate;

@end

@implementation PackBoxListView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     self.logisticSevice = [ServiceFactory shareInstance].logisticService;
    self.datas = [NSMutableArray array];
    [self configTitle:@"装箱单" leftPath:Head_ICON_BACK rightPath:nil];
    [self configViews];
    [self configFilterView];
    self.statusList = [LRender listPackBoxStatus];
    self.currentPage = 1;
    [self searchByCondition];
}

- (void)configViews {
    self.mainGrid = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    self.mainGrid.delegate = self;
    self.mainGrid.dataSource = self;
    self.mainGrid.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainGrid.backgroundColor = [UIColor clearColor];
    self.mainGrid.tableFooterView = [ViewFactory generateFooter:BOTTOM_HEIGHT];
    __weak typeof(self) weakSelf = self;
    [self.mainGrid ls_addHeaderWithCallback:^{
        weakSelf.currentPage = 1;
        [weakSelf selectPackBoxList];
    }];
    
    [self.mainGrid ls_addFooterWithCallback:^{
        weakSelf.currentPage ++;
        [weakSelf selectPackBoxList];
    }];
    [self.view addSubview:self.mainGrid];
    
    self.footView = [LSFooterView footerView];
    [self.footView initDelegate:self btnsArray:@[kFootBatch, kFootAdd]];
    [self.view addSubview:self.footView];
    self.footView.ls_bottom = SCREEN_H;
}

- (void)configFilterView{
    NSMutableArray *list = [NSMutableArray array];
    NSMutableArray *vos = [NSMutableArray array];
    //状态
    LSFilterItem *item = [LSFilterItem filterItem:@"全部" itemId:@"0"];
    [vos addObject:item];
    item = [LSFilterItem filterItem:@"已装箱" itemId:@"1"];
    [vos addObject:item];
    item = [LSFilterItem filterItem:@"待发货" itemId:@"2"];
    [vos addObject:item];
    item = [LSFilterItem filterItem:@"已发货" itemId:@"3"];
    [vos addObject:item];

    self.modelStatus = [LSFilterModel filterModel:LSFilterModelTypeDefult items:vos selectItem:[LSFilterItem filterItem:@"全部" itemId:@"0"] title:@"状态"];
    [list addObject:self.modelStatus];
    
    
    self.modelDate = [LSFilterModel filterModel:LSFilterModelTypeBottom items:nil selectItem:[LSFilterItem filterItem:@"请选择" itemId:nil] title:@"装箱日期"];
    [list addObject:self.modelDate];
    
    
    self.viewFilter = [LSFilterView addFilterViewToView:self.view delegate:self datas:list];

}

- (void)filterViewDidClickComfirmBtn {
    [self searchByCondition];
}

- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootAdd]) {
        [self showAddEvent];
    } else if ([footerType isEqualToString:kFootBatch]) {
        [self showBatchEvent];
    }
}


- (void)filterViewdidClickModel:(LSFilterModel *)filterModel {
    if (filterModel == self.modelDate) {
        NSDate* date = nil;
        date = [DateUtils parseDateTime4:[filterModel getSelectItemName]];
        [DatePickerBox showClear:filterModel.title clearName:@"清空日期" date:date client:self event:100];
    }
}

- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType
{
    id<INameItem> vo = (id<INameItem>)selectObj;
    if (eventType==100) {
        [self.modelStatus initData:[vo obtainItemName] withVal:[vo obtainItemId]];
    }
    return YES;
}

- (BOOL)pickDate:(NSDate *)date event:(NSInteger)event
{
    NSString* datsFullStr=[NSString stringWithFormat:@"%@ 00:00:00",[DateUtils formateDate2:date]];
    [self.modelDate initData:[DateUtils formateDate2:date] withVal:datsFullStr];
    datsFullStr = nil;
    return YES;
}

- (void)clearDate:(NSInteger)eventType
{
    [self.modelDate initData:@"请选择" withVal:nil];
}

#pragma mark -数据处理
- (void)searchByCondition
{
    self.currentPage = 1;
    self.billStatus = [[self.modelStatus getSelectItemId] integerValue];
    if ([NSString isNotBlank:[self.modelDate getSelectItemId]]) {
        self.packTime = [NSNumber numberWithLongLong:[DateUtils formateDateTime2:[self.modelDate getSelectItemId]]];
    }else{
        self.packTime = nil;
    }
    [self selectPackBoxList];
}

#pragma mark - 获取装箱单列表
- (void)selectPackBoxList
{
    __weak typeof(self) weakSelf = self;
    [self.logisticSevice selectPackBoxList:self.billStatus withPackTime:self.packTime withPage:self.currentPage withId:@"" completionHandler:^(id json) {
        NSMutableArray *packGoodsList = [PackGoodsVo converToArr:[json objectForKey:@"packGoodsList"]];
        if (weakSelf.currentPage==1) {
            [weakSelf.datas removeAllObjects];
        }
        [weakSelf.datas addObjectsFromArray:packGoodsList];
        [weakSelf.mainGrid reloadData];
        weakSelf.mainGrid.ls_show = YES;
        packGoodsList = nil;
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
    } errorHandler:^(id json) {
        [AlertBox show:json];
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
    }];
}

#pragma mark - footlistevent协议
//添加
- (void)showAddEvent
{
    [self showEditViewById:nil withEdit:YES withAction:ACTION_CONSTANTS_ADD];
}

//批量
- (void)showBatchEvent{
    PackBoxBatchListView* batchListView = [[PackBoxBatchListView alloc] init];
    [batchListView loadDataWithList:nil withType:EXPORT withReturnGoodsId:nil];
    [batchListView initConditionByStatus:[self.modelStatus getSelectItemName] withStatusVal:[self.modelStatus getSelectItemId] withDate:[self.modelDate getSelectItemId]];
    [self.navigationController pushViewController:batchListView animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
    batchListView = nil;
}

#pragma mark UITableView
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
    
    [headItem initColHead:@"箱号" col2:@"状态"];
    [headItem initColLeft:15 col2:137];
    return headItem;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* paperCellId = @"PaperCell";
    PaperCell* cell = [tableView dequeueReusableCellWithIdentifier:paperCellId];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"PaperCell" bundle:nil] forCellReuseIdentifier:paperCellId];
        cell = [tableView dequeueReusableCellWithIdentifier:paperCellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setNeedsDisplay];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    PaperCell* detailItem = (PaperCell*)cell;
    if (self.datas.count>0) {
        self.packGoodsVo = [self.datas objectAtIndex:indexPath.row];
        detailItem.lblSupplier.text = self.packGoodsVo.boxCode;
        detailItem.lblStatus.text = self.packGoodsVo.billStatusName;
        detailItem.lblPaperNo.text = [NSString stringWithFormat:@"单号:%@",self.packGoodsVo.packCode];
        detailItem.lblDate.text = [NSString stringWithFormat:@"装箱日期:%@",[DateUtils formateTime2:self.packGoodsVo.packTimeL]];
        if (self.packGoodsVo.billStatus==1) {
            detailItem.lblStatus.textColor = [ColorHelper getBlueColor];;
        }else if (self.packGoodsVo.billStatus==2) {
            detailItem.lblStatus.textColor = [ColorHelper getGreenColor];
        }else{
            detailItem.lblStatus.textColor = [ColorHelper getTipColor6];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.packGoodsVo = [self.datas objectAtIndex:indexPath.row];
    [self showEditViewById:self.packGoodsVo.packGoodsId withEdit:(self.packGoodsVo.billStatus==1) withAction:ACTION_CONSTANTS_EDIT];
}

#pragma mark - 装箱单详情
- (void)showEditViewById:(NSString *)paperId withEdit:(BOOL)isEdit withAction:(NSInteger)action
{
    PackBoxEditView *packBoxEditView = [[PackBoxEditView alloc] init];
    __weak typeof(self) weakSelf = self;
    [packBoxEditView loadDataById:paperId withAction:action withEdit:isEdit callBack:^(PackGoodsVo *packGoodsVo, NSInteger action) {
        if (action==ACTION_CONSTANTS_ADD) {
            [weakSelf.mainGrid headerBeginRefreshing];
        }else if (action==ACTION_CONSTANTS_EDIT) {
            weakSelf.packGoodsVo.packTimeL = packGoodsVo.packTimeL;
            weakSelf.packGoodsVo.boxCode = packGoodsVo.boxCode;
            [weakSelf.mainGrid reloadData];
        }else if (ACTION_CONSTANTS_DEL==action) {
            [weakSelf.mainGrid headerBeginRefreshing];
        }
    }];
    [self.navigationController pushViewController:packBoxEditView animated:NO];
    [XHAnimalUtil animalPush:self.navigationController action:action];
    packBoxEditView = nil;
}

@end
