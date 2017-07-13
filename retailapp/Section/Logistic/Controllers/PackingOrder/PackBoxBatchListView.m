//
//  PackBoxBatchListView.m
//  retailapp
//
//  Created by hm on 15/10/26.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "PackBoxBatchListView.h"
#import "ServiceFactory.h"
#import "FooterMultiView.h"
#import "PackBoxCell.h"
#import "GridColHead.h"
#import "PackGoodsVo.h"
#import "ColorHelper.h"
#import "GlobalRender.h"
#import "XHAnimalUtil.h"
#import "UIHelper.h"
#import "AlertBox.h"
#import "ExportView.h"
#import "DateUtils.h"
#import "UIView+Sizes.h"
#import "DatePickerBox.h"
#import "OptionPickerBox.h"
#import "LRender.h"
#import "LSFilterModel.h"
#import "LSFilterView.h"

@interface PackBoxBatchListView ()<LSFooterViewDelegate, LSFilterViewDelegate, DatePickerClient>

@property (nonatomic, strong) NSMutableArray *paperList;
@property (nonatomic, strong) PackGoodsVo *packGoodsVo;
@property (nonatomic, assign) NSInteger opType;
@property (nonatomic,strong) LogisticService *loginsticService;
@property (nonatomic, copy) NSString *returnGoodsId;
@property (nonatomic, copy) BatchHandler batchBlock;
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, copy) NSString *statusName;
@property (nonatomic, copy) NSString *statusVal;
@property (nonatomic, copy) NSString *date;
/**装箱单状态值*/
@property (nonatomic,assign) short billStatus;
/**装箱日期*/
@property (nonatomic, strong) NSNumber *packTime;

/** <#注释#> */
@property (nonatomic, strong) LSFilterView *viewFilter;

/** 状态 */
@property (nonatomic, strong) LSFilterModel *modelStatus;

/** 要求到货日期 */
@property (nonatomic, strong) LSFilterModel *modelDate;
@end

@implementation PackBoxBatchListView


- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginsticService = [ServiceFactory shareInstance].logisticService;
    [self initNavigate];
    [self configViews];
    [self configFilterView];
    self.mainGrid.tableFooterView = [ViewFactory generateFooter:BOTTOM_HEIGHT];
    if (self.opType==EXPORT) {
        self.isShow = NO;
        self.paperList = [NSMutableArray array];
        [self addHeaderAndFooter];
        [self searchByCondition];
    }
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

- (void)filterViewdidClickModel:(LSFilterModel *)filterModel {
    if (filterModel == self.modelDate) {
        NSDate* date = nil;
        date = [DateUtils parseDateTime4:[filterModel getSelectItemName]];
        [DatePickerBox showClear:filterModel.title clearName:@"清空日期" date:date client:self event:100];
    }
}



- (void)addHeaderAndFooter
{
    __weak typeof(self) weakSelf = self;
    [self.mainGrid ls_addHeaderWithCallback:^{
        weakSelf.currentPage = 1;
        [weakSelf searchByCondition];
    }];
    [self.mainGrid ls_addFooterWithCallback:^{
        weakSelf.currentPage++;
        [weakSelf searchByCondition];
    }];
}


- (void)loadDataWithList:(NSMutableArray *)dataList withType:(OP_TYPE)opType withReturnGoodsId:(NSString *)returnGoodsId
{
    self.paperList = dataList;
    self.opType = opType;
    self.returnGoodsId = returnGoodsId;
}

- (void)batchCallBack:(BatchHandler)handler
{
    self.batchBlock = handler;
}

- (void)initConditionByStatus:(NSString *)statusName withStatusVal:(NSString *)statusVal withDate:(NSString *)date
{
    self.statusName = statusName;
    self.statusVal = statusVal;
    self.date = date;
}

#pragma mark - 初始化导航
- (void)initNavigate
{
    [self configTitle:@"装箱单" leftPath:Head_ICON_CANCEL rightPath:nil];
    if (self.opType==DELETE) {
        [self configNavigationBar:LSNavigationBarButtonDirectRight title:@"删除" filePath:Head_ICON_OK];
    } else {
        [self configNavigationBar:LSNavigationBarButtonDirectRight title:@"操作" filePath:Head_ICON_OK];
    }
}

- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event==LSNavigationBarButtonDirectLeft) {
        //返回
        if (self.opType==DELETE) {
            self.batchBlock();
        }
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        [self.navigationController popViewControllerAnimated:NO];
    }else{

        if (self.opType==EXPORT) {
            //操作
            if ([[self obtainSelPackBox] count]==0) {
                [AlertBox show:@"请选择需要进行操作的装箱单!"];
                return;
            }
            UIActionSheet * alertView = [[UIActionSheet alloc] initWithTitle:@"请选择操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"导出", nil];
            alertView.tag = 100;
            [alertView showInView:[UIApplication sharedApplication].keyWindow];
        }else if(self.opType==DELETE){
            //删除
            if ([[self obtainSelPackBox] count]==0) {
                [AlertBox show:@"请选择需要删除的装箱单!"];
                return;
            }
            [UIHelper alert:self.view andDelegate:self andTitle:@"是否确认删除装箱单?" event:101];
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==100) {
        if (buttonIndex==0) {
            ExportView *exportView = [[ExportView alloc] init];
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            [param setValue:[self obtainSelPackBox] forKey:@"packGoodsIdList"];
            __weak typeof(self) weakSelf = self;
            [exportView loadData:param withPath:@"packGoods/exportExcel" withIsPush:YES callBack:^{
                [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
                [weakSelf.navigationController popToViewController:weakSelf animated:NO];
            }];
            [self.navigationController pushViewController:exportView animated:NO];
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
            exportView = nil;
        }
    }else if (actionSheet.tag==101) {
        if (buttonIndex==0) {
            __weak typeof(self) weakSelf = self;
            [self.loginsticService deletePackFromReturnById:self.returnGoodsId withPackIdList:[self obtainSelPackBox] completionHandler:^(id json) {
                NSMutableArray* arr = [NSMutableArray array];
                for (PackGoodsVo *vo  in weakSelf.paperList) {
                    if (vo.checkVal) {
                        [arr addObject:vo];
                    }
                }
                [weakSelf.paperList removeObjectsInArray:arr];
                [weakSelf.mainGrid reloadData];
            } errorHandler:^(id json) {
                [AlertBox show:json];
            }];
        }
    }
}

#pragma mark - 筛选/操作
- (void)changeNavigate
{
    __block BOOL flg = NO;
    [self.paperList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PackGoodsVo *vo = (PackGoodsVo *)obj;
        if (vo.checkVal) {
            flg = YES;
            *stop = YES;
        }
    }];
    self.isSelect = flg;
   
}


- (BOOL)pickDate:(NSDate *)date event:(NSInteger)event
{
    NSString* datsFullStr=[NSString stringWithFormat:@"%@ 00:00:00",[DateUtils formateDate2:date]];
    [self.modelDate initData:[DateUtils formateDate2:date] withVal:datsFullStr];
    datsFullStr = nil;
    return YES;
}

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
    [self.loginsticService selectPackBoxList:self.billStatus withPackTime:self.packTime withPage:self.currentPage withId:@"" completionHandler:^(id json) {
        NSMutableArray *packGoodsList = [PackGoodsVo converToArr:[json objectForKey:@"packGoodsList"]];
        if (weakSelf.currentPage==1) {
            [weakSelf.paperList removeAllObjects];
        }
        [weakSelf.paperList addObjectsFromArray:packGoodsList];
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

#pragma mark - 获取选中的装箱单id列表
- (NSMutableArray *)obtainSelPackBox
{
    NSMutableArray* arr = [NSMutableArray array];
    for (PackGoodsVo *vo  in self.paperList) {
        if (vo.checkVal) {
            [arr addObject:vo.packGoodsId];
        }
    }
    return arr;
}

#pragma  mark - 全选/全不选
- (void)checkAllEvent
{
    for (PackGoodsVo *vo in self.paperList) {
        vo.checkVal = YES;
    }
    [self.mainGrid reloadData];
    if (self.opType==EXPORT) {
        [self changeNavigate];
    }
}

- (void)notCheckAllEvent
{
    for (PackGoodsVo *vo in self.paperList) {
        vo.checkVal = NO;
    }
    [self.mainGrid reloadData];
    if (self.opType==EXPORT) {
        [self changeNavigate];
    }
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
    return self.paperList.count;
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
    if (self.paperList.count>0) {
        self.packGoodsVo = [self.paperList objectAtIndex:indexPath.row];
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
        detailItem.checkPic.hidden = !self.packGoodsVo.checkVal;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.packGoodsVo = [self.paperList objectAtIndex:indexPath.row];
    self.packGoodsVo.checkVal = !self.packGoodsVo.checkVal;
    [self.mainGrid reloadData];
    if (self.opType==EXPORT) {
        [self changeNavigate];
    }
}


@end
