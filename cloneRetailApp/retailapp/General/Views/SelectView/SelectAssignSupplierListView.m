//
//  SelectAssignSupplierListView.m
//  retailapp
//
//  Created by hm on 16/1/29.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "SelectAssignSupplierListView.h"
#import "UIView+Sizes.h"
#import "MutiSelectCell.h"
#import "PurchaseSupplyVo.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "XHAnimalUtil.h"
#import "OrganizationVo.h"
#import "LSFooterView.h"
@interface SelectAssignSupplierListView ()<LSFooterViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) CommonService *commonService;
@property (nonatomic, copy) SelectAssignSupplierBlock completedBlock;
//所属机构id
@property (nonatomic,copy) NSString* orgId;
@property (nonatomic,assign) BOOL isOrg;
@property (nonatomic,copy) NSString* keyWord;
@property (nonatomic, strong) NSMutableDictionary *param;
@property (nonatomic, strong) NSMutableArray *selList;
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *datas;

/**  */
@property (nonatomic, strong) UITableView *mainGrid;
/** <#注释#> */
@property (nonatomic, strong) LSFooterView *footView;
@end

@implementation SelectAssignSupplierListView

- (void)viewDidLoad {
    [super viewDidLoad];
    _commonService = [ServiceFactory shareInstance].commonService;
    [self configTitle:@"选择供应商" leftPath:Head_ICON_BACK rightPath:nil];
    self.datas = [NSMutableArray array];
    [self configViews];
    [self selectParentOrgList];
}

- (void)configViews {
    self.mainGrid = [[UITableView alloc] init];
    self.mainGrid.backgroundColor = [UIColor clearColor];
    self.mainGrid.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainGrid.delegate = self;
    self.mainGrid.dataSource = self;
    self.mainGrid.tableFooterView = [ViewFactory generateFooter:HEIGHT_CONTENT_BOTTOM];
    [self.view addSubview:self.mainGrid];
    __weak typeof(self) wself = self;
    [self.mainGrid makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself.view);
        make.top.equalTo(wself.view.top).offset(kNavH);
    }];
    self.footView = [LSFooterView footerView];
    [self.footView initDelegate:self btnsArray:@[kFootSelectAll, kFootSelectNo]];
    [self.view addSubview:self.footView];
    [self.footView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself.view);
        make.height.equalTo(60);
    }];
    
}


- (void)loadDataByOrgId:(NSString *)orgId completed:(SelectAssignSupplierBlock)completedBlock
{
    self.orgId = orgId;
    self.isOrg = YES;
    self.completedBlock = completedBlock;
    self.selList = [[NSMutableArray alloc] init];
    self.param = [NSMutableDictionary dictionaryWithCapacity:3];
    [self.param setValue:orgId forKey:@"sonId"];
    [self.param setValue:[NSNumber numberWithBool:self.param] forKey:@"isOrg"];
}


- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event==LSNavigationBarButtonDirectLeft) {
        [self popViewController];
    }else{
        for (PurchaseSupplyVo *vo  in self.datas) {
            if (vo.checkVal) {
                [self.selList addObject:vo];
            }
        }
        self.completedBlock(self.selList);
        [self popViewController];
    }
}

#pragma mark - 检索
- (void)imputFinish:(NSString *)keyWord
{
    self.keyWord = keyWord;
    [self.param setValue:keyWord forKey:@"searchKey"];
    [self selectParentOrgList];
}

- (void)selectParentOrgList
{
    __weak typeof(self) wself = self;
    [self.commonService selectParentOrgList:self.param completionHandler:^(id json) {
        NSMutableArray *arr = [OrganizationVo getArrayData:[json objectForKey:@"organizationList"]];
        for (OrganizationVo *vo in arr) {
            PurchaseSupplyVo *purchaseSupplyVo = [[PurchaseSupplyVo alloc] init];
            purchaseSupplyVo.entityId = vo.entityId;
            purchaseSupplyVo.supplyOrgId = vo.organizationId;
            purchaseSupplyVo.supplyName = vo.name;
            purchaseSupplyVo.supplyCode = vo.code;
            purchaseSupplyVo.linkMan = vo.linkman;
            purchaseSupplyVo.phone = vo.mobile;
            [wself.datas addObject:purchaseSupplyVo];
        }
        arr = nil;
        [wself.mainGrid reloadData];
        wself.mainGrid.ls_show = YES;
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootSelectAll]) {
        [self checkAllEvent];
    } else  if ([footerType isEqualToString:kFootSelectNo]) {
        [self notCheckAllEvent];
    }
}
#pragma mark - 多选
- (void)checkAllEvent
{
    for (PurchaseSupplyVo *vo  in self.datas) {
        vo.checkVal = YES;
    }
    [self changeNavigate];
}

- (void)notCheckAllEvent
{
    for (PurchaseSupplyVo *vo  in self.datas) {
        vo.checkVal = NO;
    }
    [self changeNavigate];
}

- (void)changeNavigate
{
    [self.mainGrid reloadData];
    BOOL isChange = NO;
    for (PurchaseSupplyVo *vo  in self.datas) {
        if (vo.checkVal) {
            isChange =YES;
            break;
        }
    }
    [self editTitle:isChange act:ACTION_CONSTANTS_EDIT];
    if (isChange) {
         [self configNavigationBar:LSNavigationBarButtonDirectRight title:@"确认" filePath:Head_ICON_OK];
    }
   
}

#pragma mark UITableView
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
    static NSString* mutiSelectCellId = @"MutiSelectCell";
    MutiSelectCell* cell = [tableView dequeueReusableCellWithIdentifier:mutiSelectCellId];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"MutiSelectCell" bundle:nil] forCellReuseIdentifier:mutiSelectCellId];
        cell = [tableView dequeueReusableCellWithIdentifier:mutiSelectCellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setNeedsDisplay];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    MutiSelectCell* detailItem = (MutiSelectCell*)cell;
    PurchaseSupplyVo *item = [self.datas objectAtIndex:indexPath.row];
    detailItem.lblName.text = item.supplyName;
    detailItem.lblVal.text = [NSString stringWithFormat:@"%@：%@",item.linkMan,item.phone];
    [detailItem.imgCheck setHidden:!item.checkVal];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PurchaseSupplyVo *item = [self.datas objectAtIndex:indexPath.row];
    item.checkVal = !item.checkVal;
    [self changeNavigate];
    [self.mainGrid reloadData];
}
@end
