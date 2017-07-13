//
//  ReturnTypeListView.m
//  retailapp
//
//  Created by hm on 16/2/16.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "ReturnTypeListView.h"
#import "XHAnimalUtil.h"
#import "NameValueCell.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "ReturnTypeVo.h"
#import "ReturnTypeEditView.h"
#import "LSFooterView.h"


@interface ReturnTypeListView ()<UITableViewDataSource, UITableViewDelegate, LSFooterViewDelegate>
@property (nonatomic, strong) LogisticService *logisticService;
@property (nonatomic, strong) NSMutableArray *typeList;
@property (nonatomic, strong) ReturnTypeVo *returnTypeVo;

/** <#注释#> */
@property (nonatomic, strong) UITableView *mainGrid;
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *datas;

/** <#注释#> */
@property (nonatomic, strong) LSFooterView *footView;
@end

@implementation ReturnTypeListView


- (void)viewDidLoad {
    [super viewDidLoad];
    self.logisticService = [ServiceFactory shareInstance].logisticService;
    [self initTittle];
    [self configViews];
    self.datas = [[NSMutableArray alloc] init];
    [self selectReturnTypeList];
}

- (void)configViews {
    self.mainGrid = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    self.mainGrid.delegate = self;
    self.mainGrid.dataSource = self;
    self.mainGrid.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainGrid.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.mainGrid];
    
    self.footView = [LSFooterView footerView];
    [self.footView initDelegate:self btnsArray:@[kFootAdd]];
    [self.view addSubview:self.footView];
    self.footView.ls_bottom = SCREEN_H;
}

- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootAdd]) {
        [self showAddEvent];
    }
}

- (void)initTittle
{
    [self configTitle:@"退货类型" leftPath:Head_ICON_BACK rightPath:nil];
}

#pragma mark - 退货类别一览
- (void)selectReturnTypeList
{
    __weak typeof(self) wself = self;
    [self.logisticService selectReturnTypeList:^(id json) {
        wself.datas = [ReturnTypeVo converToArr:[json objectForKey:@"returnTypeList"]];
        [wself.mainGrid reloadData];
        wself.mainGrid.ls_show = YES;
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];

}

#pragma mark - 添加退货类别
- (void)showAddEvent
{
    [self showEditView:nil withName:nil withAction:ACTION_CONSTANTS_ADD];
}

#pragma mark - 列表
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
    static NSString *nameValeCellId = NameValueCellIdentifier;
    NameValueCell *cell = [tableView dequeueReusableCellWithIdentifier:nameValeCellId];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"NameValueCell" bundle:nil] forCellReuseIdentifier:nameValeCellId];
        cell = [tableView dequeueReusableCellWithIdentifier:nameValeCellId];
    }
    cell.lblVal.hidden = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.datas!=nil&&self.datas.count>0) {
        NameValueCell *detaileItem = (NameValueCell *)cell;
        self.returnTypeVo = [self.datas objectAtIndex:indexPath.row];
        detaileItem.lblName.text = self.returnTypeVo.name;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.returnTypeVo = [self.datas objectAtIndex:indexPath.row];
    [self showEditView:self.returnTypeVo.dicItemId withName:self.returnTypeVo.name withAction:ACTION_CONSTANTS_EDIT];
}

- (void)showEditView:(NSString *)returnTypeId withName:(NSString *)name withAction:(NSInteger)action
{
    ReturnTypeEditView *editView = [[ReturnTypeEditView alloc] init];
    __weak typeof(self) wself = self;
    [editView loadDataWithId:returnTypeId withName:name withAction:action callBack:^(id<INameValue> item, NSInteger action) {
        if (action==ACTION_CONSTANTS_ADD) {
            [wself selectReturnTypeList];
        }else if (action==ACTION_CONSTANTS_EDIT) {
            wself.returnTypeVo.name = [item obtainItemName];
            [wself.mainGrid reloadData];
        }else if (action==ACTION_CONSTANTS_DEL) {
            [wself.datas removeObject:wself.returnTypeVo];
            [wself.mainGrid reloadData];
        }
    }];
    [XHAnimalUtil animalPush:self.navigationController action:action];
    [self.navigationController pushViewController:editView animated:NO];
    editView = nil;
}


@end
