//
//  LSHelpVideoListController.m
//  retailapp
//
//  Created by guozhi on 2017/2/28.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSHelpVideoListController.h"
#import "LSHelpVideoListCell.h"
#import "DHHeadItem.h"
#import "LSVideoPlayController.h"
#import "LSVideoVo.h"

@interface LSHelpVideoListController ()<UITableViewDelegate, UITableViewDataSource>
/** 数据源 */
@property (nonatomic, strong) NSArray *datas;
/** 表格 */
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation LSHelpVideoListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTitle:@"帮助视频" leftPath:Head_ICON_BACK rightPath:nil];
    [self configViews];
    self.datas = [Platform Instance].helpVideoList;
}

- (void)configViews {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    self.tableView.rowHeight = 88;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    LSVideoVo *obj = self.datas[section];
    return obj.vedioItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSHelpVideoListCell *cell = [LSHelpVideoListCell helpVideoListCellWithTableView:tableView];
    LSVideoVo *videoVo = self.datas[indexPath.section];
    
    LSVideoItemVo *obj = videoVo.vedioItems[indexPath.row];
    cell.obj = obj;
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.datas.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    DHHeadItem* headItem = [[[NSBundle mainBundle] loadNibNamed:@"DHHeadItem" owner:self options:nil] lastObject];
    LSVideoVo *obj = self.datas[section];
    NSString *title = obj.vedioType;
    [headItem initWithTitle:title];
    return headItem;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LSVideoPlayController *vc = [[LSVideoPlayController alloc] init];
    LSVideoVo *obj = self.datas[indexPath.section];
    LSVideoItemVo *itemVo = obj.vedioItems[indexPath.row];
    vc.url = itemVo.vedioUrl;
    [self pushViewController:vc];
}



@end
