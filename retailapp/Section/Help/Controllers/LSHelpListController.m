//
//  LSHelpController.m
//  retailapp
//
//  Created by guozhi on 2017/3/8.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSHelpListController.h"
#import "LSHelpListCell.h"
#import "LSHelpVo.h"
#import "LSVideoVo.h"
#import "LSVideoItemVo.h"
#import "LSVideoPlayController.h"

@interface LSHelpListController ()<UITableViewDelegate, UITableViewDataSource>
/** <#注释#> */
@property (nonatomic, strong) UITableView *tableView;
/** 表头 */
@property (nonatomic, strong) UIView *viewHeader;
/** <#注释#> */
@property (nonatomic, strong) NSArray *datas;
/** <#注释#> */
@property (nonatomic, strong) LSHelpVo *helpVo;
@end

@implementation LSHelpListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    self.helpVo = [LSHelpVo helpVoWithCode:self.code];
    [self configTitle:self.helpVo.title leftPath:Head_ICON_BACK rightPath:nil];
    self.datas = self.helpVo.list;
    [self configTableView];
}

- (void)configTableView {
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = self.viewHeader;
    self.tableView.tableFooterView = [ViewFactory generateFooter:44];
    //设行高为自动计算
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    //预计行高
    self.tableView.estimatedRowHeight = 100;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    __weak typeof(self) wself = self;
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself.view);
        make.top.equalTo(wself.view.top).offset(kNavH);
    }];
}

- (UIView *)viewHeader {
    if (_viewHeader == nil) {
        _viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 88)];
        //视频教程
        UILabel *lbl = [[UILabel alloc] init];
        lbl.textColor = [ColorHelper getTipColor3];
        lbl.font = [UIFont boldSystemFontOfSize:20];
        lbl.text = @"视频教程";
        [_viewHeader addSubview:lbl];
        [lbl makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_viewHeader.left).offset(10);
            make.centerY.equalTo(_viewHeader);
        }];
        //播放图片
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:@"icon_play"];
        [_viewHeader addSubview:imgView];
        [imgView makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_viewHeader.right).offset(-30);
            make.centerY.equalTo(_viewHeader);
            make.size.equalTo(36);
        }];
        //分割线
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        [_viewHeader addSubview:line];
        [line makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_viewHeader).offset(10);
            make.right.equalTo(_viewHeader).offset(-10);
            make.bottom.equalTo(_viewHeader);
            make.height.equalTo(1);
        }];
        [_viewHeader addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerViewClick:)]];
        
    }
    return _viewHeader;
}

- (void)headerViewClick:(UITapGestureRecognizer  *)tapGestureRecognizer {
    NSString *videoUrl = nil;
    NSArray *helpVideoList = [Platform Instance].helpVideoList;
    for (LSVideoVo *videoVo in helpVideoList) {
        for (LSVideoItemVo *videoItemVo in videoVo.vedioItems) {
            if ([videoItemVo.itemCode isEqualToString:self.helpVo.code]) {
                videoUrl = videoItemVo.vedioUrl;
            }
        }
    }
    if (videoUrl == nil) {
        [LSAlertHelper showStatus:@"视频文件录制中，敬请期待！" afterDeny:2 block:nil];
    } else {
        LSVideoPlayController *vc = [[LSVideoPlayController alloc] init];
        vc.url = videoUrl;
        [self pushViewController:vc];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSHelpListCell *cell = [LSHelpListCell helpListCellWithTableView:tableView];
    NSArray *obj = self.datas[indexPath.row];
    cell.obj = obj;
    return cell;
}



@end
