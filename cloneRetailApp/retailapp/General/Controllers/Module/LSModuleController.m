//
//  LSModuleController.m
//  retailapp
//
//  Created by guozhi on 2016/11/9.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSModuleController.h"
#import "LSModuleCell.h"
#import "XHAnimalUtil.h"
#import "AlertBox.h"
#import "HeaderItem.h"

@implementation LSModuleController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavigationBar:LSNavigationBarButtonDirectLeft title:@"返回" filePath:Head_ICON_BACK];
    [self configViews];
    [self configConstraints];
}

- (void)configViews {
    self.view.backgroundColor = [UIColor clearColor];
    //配置表格
    self.tableView = [[UITableView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 95;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [ViewFactory generateFooter:44];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    
}

- (void)configConstraints {
    __weak typeof(self) wself = self;
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself.view);
        make.top.equalTo(wself.view).offset(64);
    }];
    
}



#pragma mark - <UITableView>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.map.count > 0) {//self.map有值时时分组数据这时数据里面存的是标题内容
        return self.datas.count;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.map.count > 0) {//self.map有值时时分组数据这时数据里面存的是标题内容
        return 40;
    } else {
        return 0;
    }

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.map.count > 0) {//self.map有值时时分组数据这时数据里面存的是标题内容
        NSString *head = self.datas[section];
        HeaderItem *headItem = [HeaderItem headerItem];
        [headItem initWithName:head];
        return headItem;
    } else {
        return nil;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.map.count > 0) {//self.map有值时时分组数据这时数据里面存的是标题内容
        NSString *head = self.datas[section];
        NSArray *datas = self.map[head];
        return datas.count;
    } else {//self.map没有值时时不分组的这时self.datas是菜单数据
        return self.datas.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSModuleCell *cell = [LSModuleCell moduleCellWithTableView:tableView];
    if (self.map.count > 0) {//self.map有值时时分组数据这时数据里面存的是标题内容
        NSString *head = self.datas[indexPath.section];
        NSArray *datas = self.map[head];
        cell.model = datas[indexPath.row];
    } else {//self.map没有值时时不分组的这时self.datas是菜单数据
        cell.model = self.datas[indexPath.row];
        
    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LSModuleModel *model = nil;
    if (self.map.count > 0) {//self.map有值时时分组数据这时数据里面存的是标题内容
        NSString *head = self.datas[indexPath.section];
        NSArray *datas = self.map[head];
        model = datas[indexPath.row];
    } else {//self.map没有值时时不分组的这时self.datas是菜单数据
        model = self.datas[indexPath.row];
    }
    BOOL isLockFlag=[[Platform Instance] lockAct:model.code];
    if (isLockFlag) {
        [AlertBox show:[NSString stringWithFormat:@"您没有[%@]的权限",model.name]];
        return;
    }
    [self showActionCode:model.code];
}



- (void)showActionCode:(NSString*)actCode {
    
}




@end
