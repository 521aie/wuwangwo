//
//  ReturnPackBoxListView.m
//  retailapp
//
//  Created by hm on 15/11/4.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "ReturnPackBoxListView.h"
#import "ServiceFactory.h"
#import "NavigateTitle2.h"
#import "XHAnimalUtil.h"
#import "PaperCell.h"
#import "GridColHead.h"
#import "LRender.h"
#import "GlobalRender.h"
#import "OptionPickerBox.h"
#import "DatePickerBox.h"
#import "DateUtils.h"
#import "AlertBox.h"
#import "ColorHelper.h"
#import "PackGoodsVo.h"
#import "PackBoxEditView.h"
#import "SelectPackBoxListView.h"
#import "PackBoxBatchListView.h"

@interface ReturnPackBoxListView ()

@property (nonatomic, strong) LogisticService *logisticService;
/**装箱单数据列表*/
@property (nonatomic, strong) NSMutableArray *packList;
/**装箱单数据模型*/
@property (nonatomic, strong) PackGoodsVo *packGoodsVo;
/**回调block*/
@property (nonatomic, copy) ReturnPackBoxHandler boxHandler;
/**退货单id*/
@property (nonatomic, copy) NSString *returnGoodsId;
/**分页*/
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation ReturnPackBoxListView
- (void)viewDidLoad {
    [super viewDidLoad];
    self.logisticService = [ServiceFactory shareInstance].logisticService;
    self.packList = [NSMutableArray array];
    [self configViews];
    [self initNavigate];
    [self initSearchBar];
    [self addHeaderAndFooter];
    [self selectPackBoxList];
}

- (void)configViews {
    self.mainGrid = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    self.mainGrid.backgroundColor = [UIColor clearColor];
    self.mainGrid.dataSource = self;
    self.mainGrid.delegate = self;
    self.mainGrid.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.mainGrid];
    
    self.footView = [LSFooterView footerView];
    [self.footView initDelegate:self btnsArray:@[kFootBatch, kFootAdd]];
    [self.view addSubview:self.footView];
}

- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootBatch]) {
        [self showBatchEvent];
    } else if ([footerType isEqualToString:kFootAdd]) {
        [self showAddEvent];
    }
}

- (void)initSearchBar
{
    if (self.paperType==RETURN_PAPER_TYPE) {
        self.footView.hidden = !self.isEdit;
    }else{
        self.footView.hidden = YES;
    }
}

- (void)addHeaderAndFooter
{
    __weak typeof(self) weakSelf = self;
    //下拉刷新
    [self.mainGrid ls_addHeaderWithCallback:^{
        weakSelf.currentPage = 1;
        [weakSelf selectPackBoxList];
    }];
    //上拉加载
    [self.mainGrid ls_addFooterWithCallback:^{
        weakSelf.currentPage ++;
        [weakSelf selectPackBoxList];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 设置页面参数及回调
- (void)loadDataWithEdit:(BOOL)isEdit paperType:(NSInteger)paperType WithPaperId:(NSString*)returnGoodsId callBack:(ReturnPackBoxHandler)handler
{
    self.isEdit = isEdit;
    self.paperType = paperType;
    self.returnGoodsId = returnGoodsId;
    self.boxHandler = handler;
}
#pragma mark - 初始化导航
- (void)initNavigate
{
    [self configTitle:@"装箱单" leftPath:Head_ICON_BACK rightPath:nil];
}

- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event==LSNavigationBarButtonDirectLeft) {
        if (self.boxHandler) {
            self.boxHandler();
        }
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

#pragma mark - 查询装箱单列表
- (void)selectPackBoxList
{
    __weak __typeof(self) weakSelf  = self;
    [self.logisticService selectPackBoxList:0 withPackTime:nil withPage:self.currentPage withId:self.returnGoodsId completionHandler:^(id json) {
        NSMutableArray *packGoodsList = [PackGoodsVo converToArr:[json objectForKey:@"packGoodsList"]];
        if (weakSelf.currentPage==1) {
            [weakSelf.packList removeAllObjects];
        }
        [weakSelf.packList addObjectsFromArray:packGoodsList];
        [weakSelf.mainGrid reloadData];
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
    } errorHandler:^(id json) {
        [AlertBox show:json];
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
    }];
}

#pragma mark - 添加装箱单
- (void)showAddEvent
{
    SelectPackBoxListView *selectView = [[SelectPackBoxListView alloc] init];
    __weak typeof(self) weakSelf = self;
    [selectView loadDataWithId:self.returnGoodsId callBack:^{
        [weakSelf.mainGrid headerBeginRefreshing];
    }];
    [self.navigationController pushViewController:selectView animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
}

#pragma mark - 批量操作装箱单
- (void)showBatchEvent
{
    __weak typeof(self) weakSelf = self;
    PackBoxBatchListView *batchView = [[PackBoxBatchListView alloc] init];
    [batchView loadDataWithList:self.packList withType:DELETE withReturnGoodsId:self.returnGoodsId];
    [batchView batchCallBack:^{
        [weakSelf.mainGrid headerBeginRefreshing];
    }];
    [self.navigationController pushViewController:batchView animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
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
    if (self.packList.count>0) {
        self.packGoodsVo = [self.packList objectAtIndex:indexPath.row];
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
    self.packGoodsVo = [self.packList objectAtIndex:indexPath.row];
    [self showEditViewById:self.packGoodsVo.packGoodsId withEdit:(self.packGoodsVo.billStatus==1) withAction:ACTION_CONSTANTS_EDIT];
}

- (void)showEditViewById:(NSString *)paperId withEdit:(BOOL)isEdit withAction:(NSInteger)action
{
    //查看装箱单详情
    PackBoxEditView *packBoxEditView = [[PackBoxEditView alloc] init];
    __weak typeof(self) weakSelf = self;
    [packBoxEditView loadDataById:paperId withAction:action withEdit:isEdit callBack:^(PackGoodsVo *packGoodsVo, NSInteger action) {
        if (action==ACTION_CONSTANTS_ADD) {
            [weakSelf.mainGrid headerBeginRefreshing];
        }else if (action==ACTION_CONSTANTS_EDIT) {
            self.packGoodsVo.packTimeL = packGoodsVo.packTimeL;
            [weakSelf.mainGrid reloadData];
        }
    }];
    [self.navigationController pushViewController:packBoxEditView animated:NO];
    [XHAnimalUtil animalPush:self.navigationController action:action];
    packBoxEditView = nil;
}

@end
