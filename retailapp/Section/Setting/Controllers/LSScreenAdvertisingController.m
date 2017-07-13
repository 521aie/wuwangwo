//
//  LSScreenAdvertisingController.m
//  retailapp
//
//  Created by guozhi on 2016/11/10.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSScreenAdvertisingController.h"
#import "XHAnimalUtil.h"
#import "LSScreenAdvertisingCell.h"
#import "LSScreenAdvertisingHeaderView.h"
#import "LSPictureAdvertisingtController.h"
@interface LSScreenAdvertisingController ()<UITableViewDelegate, UITableViewDataSource>
/** 表格 */
@property (nonatomic, strong) UITableView *tableView;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *datas;
/** 头部View */
@property (nonatomic, strong) LSScreenAdvertisingHeaderView *headerView;
@end

@implementation LSScreenAdvertisingController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
}

- (void)configViews {
    self.view.backgroundColor = [UIColor clearColor];
    //标题栏
    [self configTitle:@"店内屏幕广告" leftPath:Head_ICON_BACK rightPath:nil];
    
    //表格
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 95;
    self.tableView.tableHeaderView = self.headerView;
    [self.view addSubview:self.tableView];
}
#pragma mark - 创建头部View
- (LSScreenAdvertisingHeaderView *)headerView {
    if (_headerView == nil) {
        _headerView = [LSScreenAdvertisingHeaderView screenAdvertisingHeaderView];
    }
    return _headerView;
}


- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event {
    if (event == LSNavigationBarButtonDirectLeft) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (NSMutableArray *)datas {
    if (_datas == nil) {
        _datas = [NSMutableArray array];
        NSDictionary *dict = @{@"path" : @"ico_screen_advertising_white",
                               @"name" : @"图片广告",
                               @"detail" : @"上传/删除图片广告"};
        [_datas addObject:dict];
    }
    return _datas;
}

#pragma mark - tableHeadView 



#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSScreenAdvertisingCell *cell = [LSScreenAdvertisingCell screenAdvertisingCellWithTableView:tableView];
    cell.dict = self.datas[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //点击进入图片广告
    LSPictureAdvertisingtController *vc = [[LSPictureAdvertisingtController alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];

}


@end
