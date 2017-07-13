//
//  LSSelectCategoryListViewController.m
//  retailapp
//
//  Created by guozhi on 16/10/9.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSSelectCategoryListViewController.h"
#import "NavigateTitle2.h"
#import "XHAnimalUtil.h"
#import "CategoryVo.h"
#import "LSSelectCategoryCell.h"
#import "MJExtension.h"
#import "AlertBox.h"
#import "LSFooterView.h"
#import "LSOneClickView.h"
#import "LSWechatStyleManageViewController.h"
#import "LSWechatGoodManageViewController.h"

@interface LSSelectCategoryListViewController () <INavigateEvent, UITableViewDelegate, UITableViewDataSource, LSFooterViewDelegate>
@property (nonatomic, strong) NavigateTitle2 *titleBox;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) LSFooterView *footView;
@property (nonatomic, strong) NSMutableDictionary *param;
@end

@implementation LSSelectCategoryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMainView];
    [self loadData];
}

- (void)initMainView {
    self.datas = [NSMutableArray array];
    CGFloat y = 0;
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"选择分类" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
    self.titleBox.lblRight.text = @"确认";
    [self.view addSubview:self.titleBox];
    self.titleBox.ls_top = y;
    y = y + self.titleBox.ls_height;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, y, SCREEN_W, SCREEN_H - y) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 60;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 60)];
    [self.view addSubview:self.tableView];
    
    
    self.footView = [LSFooterView footerView];
    [self.footView initDelegate:self btnsArray:@[kFootSelectAll, kFootSelectNo]];
    [self.view addSubview:self.footView];
    self.footView.ls_bottom = SCREEN_H;
    
}


- (void)loadData {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@"1" forKey:@"hasNoCategory"];
    NSString* url = @"category/lastCategoryInfo";
    __weak typeof(self) wself = self;
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        if ([ObjectUtil isNotNull:json[@"categoryList"]]) {
            wself.datas = [CategoryVo mj_objectArrayWithKeyValuesArray:json[@"categoryList"]];
            [wself.tableView reloadData];
        }
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

- (void)onNavigateEvent:(Direct_Flag)event {
    if (event == DIRECT_LEFT) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        [self.navigationController popViewControllerAnimated:NO];
    } else {
        NSMutableArray *categoryIdList = [NSMutableArray array];
        for (CategoryVo *categoryVo in self.datas) {
            if (categoryVo.isSelect) {
                if ([categoryVo.name isEqualToString:@"未分类"]) {//未分类分类Id传0
                    categoryVo.categoryId = @"0";
                }
                [categoryIdList addObject:categoryVo.categoryId];;
            }
        }
        if (categoryIdList.count == 0) {
            [AlertBox show:@"请先选择分类！"];
            return;
        }
        self.param = [NSMutableDictionary dictionary];
        [self.param setValue:categoryIdList forKey:@"categoryIdList"];
        NSString *url = @"microGoods/quickSetCount";
        [BaseService getRemoteLSDataWithUrl:url param:self.param withMessage:nil show:YES CompletionHandler:^(id json) {
            if ([ObjectUtil isNotNull:json[@"count"]]) {//正在一键上架时不返回值
                int count = [json[@"count"] intValue];
                if (count == 0) {
                    [AlertBox show:@"当前所选分类下没有可上架的商品，请重新选择！"];
                } else {
                    [self showOneClickAlert:count];
                }
            }
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];

    }
    
}

- (void)showOneClickAlert:(int)count {
    NSString *tip = @"";
    if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 102) {
        tip = @"（不包含散装称重商品）";
    }
    NSString *str = [NSString stringWithFormat:@"此次共有%d种商品%@按“与零售价相同”的售价策略上架到微店销售！上架需要花费几分钟时间，请耐心等待～～\n为了保证商品数据的一致性，一键上架过程中，将无法添加或修改商品信息，建议此操作在非营业时间进行！", count, tip];
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) wself = self;
    [alertVc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *url = @"microGoods/quickSetSale";
        [BaseService getRemoteLSDataWithUrl:url param:self.param withMessage:nil show:YES CompletionHandler:^(id json) {
            if ([ObjectUtil isNotNull:json[@"quickSetStatus"]]) {
                if ([json[@"quickSetStatus"] intValue] == 1) {//正在一键上架时才返回值1
                    for (UIViewController *vc in wself.navigationController.viewControllers) {
                        if ([vc isKindOfClass:[LSWechatStyleManageViewController class]]) {
                            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
                            [self.navigationController popToViewController:vc animated:NO];
                            LSWechatStyleManageViewController *wechatStyleVc = (LSWechatStyleManageViewController *)vc;
                            wechatStyleVc.oneClickView.hidden = NO;
                        } else if ([vc isKindOfClass:[LSWechatGoodManageViewController class]]) {
                            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
                            [self.navigationController popToViewController:vc animated:NO];
                            LSWechatGoodManageViewController *wechatGoodVc = (LSWechatGoodManageViewController *)vc;
                            wechatGoodVc.oneClickView.hidden = NO;
                        }
                    }
                    
                }
            }
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
        
    }]];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertVc animated:YES completion:nil];
}


- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootSelectAll]) {//点击全选按钮
        for (CategoryVo *categoryVo in self.datas) {
            categoryVo.isSelect = YES;
        }
    } else if ([footerType isEqualToString:kFootSelectNo]) {//点击全不选按钮
        for (CategoryVo *categoryVo in self.datas) {
            categoryVo.isSelect = NO;
        }
    }
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSSelectCategoryCell *cell = [LSSelectCategoryCell selectCategoryCellWithTableView:tableView];
    cell.categoryVo = self.datas[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CategoryVo *categoryVo = self.datas[indexPath.row];
    categoryVo.isSelect = !categoryVo.isSelect;
    [self.tableView reloadData];
}





@end
