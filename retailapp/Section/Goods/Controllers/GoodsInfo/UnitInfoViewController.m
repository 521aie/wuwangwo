//
//  UtitInfoViewController.m
//  retailapp
//
//  Created by guozhi on 16/7/16.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "UnitInfoViewController.h"
#import "LSFooterView.h"
#import "AlertBox.h"
#import "ObjectUtil.h"
#import "LSGoodsUnitVo.h"
#import "GoodsBrandLibraryManageCell.h"
#import "UnitAddViewController.h"
#import "UIHelper.h"
#import "XHAnimalUtil.h"

@interface UnitInfoViewController ()< LSFooterViewDelegate, UITableViewDelegate, UITableViewDataSource, GoodsBrandLibraryManageCellDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datas;
/**
 *  记录删除单位的对象
 */
@property (nonatomic, strong) LSGoodsUnitVo *goodsUnit;

@end

@implementation UnitInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigate];
    [self configViews];
    [self initFooterView];
    [self loadData];
}

- (void)initNavigate {
    [self configTitle:@"单位库管理"];
    [self configNavigationBar:LSNavigationBarButtonDirectLeft title:@"关闭" filePath:Head_ICON_CANCEL];
}

- (void)configViews {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event {
    if (event == LSNavigationBarButtonDirectLeft) {
        if ([self.delegate respondsToSelector:@selector(unitInfoViewClickClosedBtn)]) {
            [self.delegate unitInfoViewClickClosedBtn];
        }
        [self popViewController];
    }
}

- (void)initFooterView {
    LSFooterView *footerView = [LSFooterView footerView];
    [footerView initDelegate:self btnsArray:@[kFootAdd]];
    [self.view addSubview:footerView];
}

- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootAdd]) {
        UnitAddViewController *vc = [[UnitAddViewController alloc] init];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
        [self.navigationController pushViewController:vc animated:NO];

    }
}

- (void)loadData {
    NSString *url = @"goodsUnit/list";
    [BaseService getRemoteLSDataWithUrl:url param:nil withMessage:nil show:YES CompletionHandler:^(id json) {
        id goodsUnitVoList = json[@"goodsUnitVoList"];
        self.datas = [NSMutableArray array];
        if ([ObjectUtil isNotNull:goodsUnitVoList]) {
            for (NSDictionary *map in goodsUnitVoList) {
                LSGoodsUnitVo *goodsUtitVo = [LSGoodsUnitVo goodsUnitVoWithMap:map];
                [self.datas addObject:goodsUtitVo];
            }
            [self.tableView reloadData];
        }
        
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = GoodsBrandLibraryManageCellIndentifier;
    GoodsBrandLibraryManageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"GoodsBrandLibraryManageCell" owner:self options:nil].lastObject;
    }
    cell.delegate = self;
    LSGoodsUnitVo *goodsUnit = self.datas[indexPath.row];
    cell.index = (int) indexPath.row;
    cell.lblName.text = goodsUnit.unitName;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


- (void)delCell:(int)index {
    self.goodsUnit = self.datas[index];
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:@"确认要删除[%@]吗？", self.goodsUnit.unitName]];
}

//删除确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setValue:self.goodsUnit.goodsUnitId forKey:@"goodsUnitId"];
        [param setValue:self.goodsUnit.lastVer forKey:@"lastVer"];
        NSString *url = @"goodsUnit/delete";
        __weak typeof(self) wself = self;
        [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
            if (wself.delegate && [self.delegate respondsToSelector:@selector(unitInfoViewClickDeleted:)]) {
                [wself.delegate unitInfoViewClickDeleted:wself.goodsUnit];
            }
            [wself loadData];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }
}



@end
