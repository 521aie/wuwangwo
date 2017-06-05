//
//  LSBarCodeIdentificationController.m
//  retailapp
//
//  Created by guozhi on 2017/1/6.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSBarCodeIdentificationController.h"
#import "NavigateTitle2.h"
#import "LSFooterView.h"
#import "XHAnimalUtil.h"
#import "LSBarCodeIdentificationCell.h"
#import "LSBarCodeMark.h"

@interface LSBarCodeIdentificationController ()<INavigateEvent, LSFooterViewDelegate, UITableViewDelegate, UITableViewDataSource>
/** <#注释#> */
@property (nonatomic, strong) NavigateTitle2 *titleBox;
/** <#注释#> */
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#> */
@property (nonatomic, strong) LSFooterView *footerView;
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *datas;
/** <#注释#> */
@property (nonatomic, copy) CallBlock callBlock;
@end

@implementation LSBarCodeIdentificationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    [self configConstraints];
    
}

- (void)configViews {
    self.view.backgroundColor = [UIColor clearColor];
    //标题栏
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"选择条码标识" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
    self.titleBox.lblRight.text = @"确认";
    [self.view addSubview:self.titleBox];
    //表格
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [ViewFactory generateFooter:HEIGHT_CONTENT_BOTTOM];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 44;
    [self.view addSubview:self.tableView];
    //
    self.footerView = [LSFooterView footerView];
    [self.footerView initDelegate:self btnsArray:@[kFootSelectAll, kFootSelectNo]];
    [self.view addSubview:self.footerView];
}

- (void)configConstraints {
    __weak typeof(self) wself = self;
    UIView *superView = self.view;
    [self.titleBox makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(superView);
        make.height.equalTo(64);
    }];
    
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(superView);
        make.top.equalTo(wself.titleBox.bottom);
    }];
    
    [self.footerView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(superView);
        make.height.equalTo(60);
    }];
}

#pragma mark - <INavigateEvent>
- (void)onNavigateEvent:(Direct_Flag)event {
    if (event == DIRECT_LEFT) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    } else {
        __block BOOL isSelect = NO;
        [self.datas enumerateObjectsUsingBlock:^(LSBarCodeMark *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.flag == 1) {
                isSelect = YES;
            }
        }];
        if (isSelect == NO) {
            [LSAlertHelper showAlert:@"请至少选择一项选择条码标识！"];
            return;
        }
        if (self.callBlock) {
            self.callBlock(self.datas);
        }
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }
    
}
- (void)loadBarCodeList:(NSArray *)barCodeMarks callBlock:(CallBlock)callBlock {
    self.datas = [NSMutableArray arrayWithArray:barCodeMarks];
    self.callBlock = callBlock;
    [self.tableView reloadData];
    
}
#pragma mark - <LSFooterViewDelegate>
- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    [self.datas enumerateObjectsUsingBlock:^(LSBarCodeMark *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([footerType isEqualToString:kFootSelectAll]) {//全选
            obj.flag = 1;
        } else if ([footerType isEqualToString:kFootSelectNo]) {//全不选
            obj.flag = 2;
        }
    }];
    [self.tableView reloadData];
    
    
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSBarCodeIdentificationCell *cell = [LSBarCodeIdentificationCell barCodeIdentificationCellWithTableView:tableView];
    LSBarCodeMark *obj = self.datas[indexPath.row];
    cell.obj = obj;
    return cell;
}

#pragma mark - <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LSBarCodeMark *obj = self.datas[indexPath.row];
    obj.flag = obj.flag == 1 ? 2 : 1;
    [self.tableView reloadData];
    
}




@end
