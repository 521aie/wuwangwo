//
//  SelectPackBoxListView.m
//  retailapp
//
//  Created by hm on 15/11/4.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SelectPackBoxListView.h"
#import "ServiceFactory.h"
#import "ViewFactory.h"
#import "FooterMultiView.h"
#import "EditItemList.h"
#import "UIView+Sizes.h"
#import "XHAnimalUtil.h"
#import "DatePickerBox.h"
#import "DateUtils.h"
#import "PackGoodsVo.h"
#import "GridColHead.h"
#import "PackBoxCell.h"
#import "ColorHelper.h"
#import "AlertBox.h"
#import "LSFilterModel.h"
#import "LSFilterView.h"

@interface SelectPackBoxListView ()<DatePickerClient, LSFilterViewDelegate>
@property (nonatomic, strong) LogisticService *logisticSevice;
/**页面回调block*/
@property (nonatomic,copy) SelectPackBoxHandler boxHandler;
/**装箱单数据列表*/
@property (nonatomic,strong) NSMutableArray *packList;
/**装箱时间*/
@property (nonatomic, strong) NSNumber *packTime;
/**分页*/
@property (nonatomic,assign) NSInteger currentPage;
/**装箱单状态值*/
@property (nonatomic,assign) short billStatus;
/**是否显示筛选页面*/
@property (nonatomic,assign) BOOL isShow;
/**是否是保存按钮*/
@property (nonatomic,assign) BOOL isSave;
/**装箱单数据模型*/
@property (nonatomic, strong) PackGoodsVo *packGoodsVo;
/**选择的装箱单列表*/
@property (nonatomic,strong) NSMutableArray *selectArr;
/**退货单id*/
@property (nonatomic,copy) NSString *paperId;

/** <#注释#> */
@property (nonatomic, strong) LSFilterView *viewFilter;

/** 状态 */
@property (nonatomic, strong) LSFilterModel *modelStatus;

/** 要求到货日期 */
@property (nonatomic, strong) LSFilterModel *modelDate;
@end

@implementation SelectPackBoxListView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.logisticSevice = [ServiceFactory shareInstance].logisticService;
    self.packList = [NSMutableArray array];
    [self initNavigate];
    [self configViews];
    [self configFilterView];
    self.currentPage = 1;
    [self addHeaderAndFooter];
    [self searchByCondition];
}

- (void)configViews {
    self.mainGrid = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    self.mainGrid.dataSource = self;
    self.mainGrid.delegate = self;
    self.mainGrid.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainGrid.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.mainGrid];
    
    self.footView = [LSFooterView footerView];
    [self.footView initDelegate:self btnsArray:@[kFootSelectAll, kFootSelectNo]];
    [self.view addSubview:self.footView];
    
    self.footView.ls_bottom = SCREEN_H;
}

- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootSelectAll]) {
        [self checkAllEvent];
    } else if ([footerType isEqualToString:kFootSelectNo]) {
        [self notCheckAllEvent];
    }
}

- (void)addHeaderAndFooter
{
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
}

- (void)configFilterView{
    NSMutableArray *list = [NSMutableArray array];
    NSMutableArray *vos = [NSMutableArray array];
    //状态
    LSFilterItem *item = nil;
    item = [LSFilterItem filterItem:@"已装箱" itemId:@"1"];
    [vos addObject:item];
    
    self.modelStatus = [LSFilterModel filterModel:LSFilterModelTypeDefult items:vos selectItem:[LSFilterItem filterItem:@"已装箱" itemId:@"1"] title:@"状态"];
    [list addObject:self.modelStatus];
    
    
    self.modelDate = [LSFilterModel filterModel:LSFilterModelTypeBottom items:nil selectItem:[LSFilterItem filterItem:@"请选择" itemId:nil] title:@"装箱日期"];
    [list addObject:self.modelDate];
    
    
    self.viewFilter = [LSFilterView addFilterViewToView:self.view delegate:self datas:list];
    
}

- (void)filterViewDidClickComfirmBtn {
    [self searchByCondition];
}

- (void)filterViewdidClickModel:(LSFilterModel *)filterModel {
    if (filterModel == self.modelDate) {
        NSDate* date = nil;
        date = [DateUtils parseDateTime4:[filterModel getSelectItemName]];
        [DatePickerBox showClear:filterModel.title clearName:@"清空日期" date:date client:self event:100];
    }
}



- (void)loadDataWithId:(NSString*)returnGoodsId callBack:(SelectPackBoxHandler)handler
{
    self.paperId = returnGoodsId;
    self.boxHandler = handler;
}
#pragma mark - 初始化导航
- (void)initNavigate
{
    [self configTitle:@"选择装箱单" leftPath:Head_ICON_BACK rightPath:Head_ICON_OK];
  
}

- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event==LSNavigationBarButtonDirectLeft) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        [self.navigationController popViewControllerAnimated:NO];
    }else{
       [self save];
    }

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

#pragma mark - 获取筛选条件检索数据
- (void)searchByCondition
{
    if ([NSString isNotBlank:[self.modelDate getSelectItemId]]) {
        self.packTime = [NSNumber numberWithLongLong:[DateUtils formateDateTime2:[self.modelDate getSelectItemId]]];
    }else{
        self.packTime = nil;
    }
    self.billStatus = (short)[[self.modelDate getSelectItemId] intValue];
    [self selectPackBoxList];
}
#pragma mark - 筛选数据
- (void)selectPackBoxList
{
    __weak typeof(self) weakSelf = self;
    [self.logisticSevice selectPackBoxList:[self.modelStatus getSelectItemId].integerValue withPackTime:self.packTime withPage:self.currentPage withId:@"" completionHandler:^(id json) {
        NSMutableArray *packGoodsList = [PackGoodsVo converToArr:[json objectForKey:@"packGoodsList"]];
        if (weakSelf.currentPage==1) {
            [weakSelf.packList removeAllObjects];
        }
        [weakSelf.packList addObjectsFromArray:packGoodsList];
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

#pragma mark - 全选
- (void)checkAllEvent
{
    for (id<IMultiNameValueItem> item in self.packList) {
        [item mCheckVal:YES];
    }
    [self.mainGrid reloadData];
    [self changeUI];
}
#pragma mark - 全不选
- (void)notCheckAllEvent
{
    for (id<IMultiNameValueItem> item in self.packList) {
        [item mCheckVal:NO];
    }
    [self.mainGrid reloadData];
    [self changeUI];
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
    return self.packList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* packBoxCellId = @"PackBoxCell";
    PackBoxCell* cell = [tableView dequeueReusableCellWithIdentifier:packBoxCellId];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"PackBoxCell" bundle:nil] forCellReuseIdentifier:packBoxCellId];
        cell = [tableView dequeueReusableCellWithIdentifier:packBoxCellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setNeedsDisplay];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    PackBoxCell* detailItem = (PackBoxCell*)cell;
    if (self.packList.count>0) {
        self.packGoodsVo = [self.packList objectAtIndex:indexPath.row];
        detailItem.checkPic.hidden = !self.packGoodsVo.checkVal;
        detailItem.lblPaperNo.text = self.packGoodsVo.boxCode;
        detailItem.lblStatus.text = self.packGoodsVo.billStatusName;
        detailItem.lblDetail.text = [NSString stringWithFormat:@"单号:%@",self.packGoodsVo.packCode];
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
    id<IMultiNameValueItem> item = [self.packList objectAtIndex:indexPath.row];
    [item mCheckVal:![item obtainCheckVal]];
    [self.mainGrid reloadData];
    [self changeUI];
}

#pragma mark - 改变导航栏按钮
- (void)changeUI
{
    __block BOOL flag = NO;
    [self.packList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id<IMultiNameValueItem> item = obj;
        if ([item obtainCheckVal]) {
            flag = YES;
            *stop = YES;
        }
    }];
    if (flag) {
        self.isSave = YES;
    }else{
        self.isSave = NO;
    }
}
#pragma mark - 保存选中的装箱单
- (void)save
{
    NSMutableSet *codeList = [NSMutableSet set];
    self.selectArr = [NSMutableArray array];
    for (PackGoodsVo *item in self.packList) {
        if (item.checkVal) {
            [codeList addObject:item.boxCode];
            [self.selectArr addObject:item.packGoodsId];
        }
    }
    
    if (self.selectArr.count == 0) {
        [AlertBox show:@"请选择需要进行操作的装箱单!"];
        return;
        
    }
    if (codeList.count<self.selectArr.count) {
        [AlertBox show:@"选择的装箱单存在相同的箱号，请检查!"];
        return;
    }
  
    __weak __typeof(self) weakSelf =  self;
    [self.logisticSevice addPackToReturn:self.paperId withIds:self.selectArr withMessage:@"正在保存..." completionHandler:^(id json) {
        weakSelf.boxHandler();
        [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        [weakSelf.navigationController popViewControllerAnimated:NO];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}


@end
