//
//  StockQueryView.m
//  retailapp
//
//  Created by guozhi on 15/9/8.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "ReturnGuideList.h"
#import "XHAnimalUtil.h"
#import "UIView+Sizes.h"
#import "EditItemList.h"
#import "Platform.h"
#import "UIHelper.h"
#import "SelectShopStoreListView.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
//#import "VirtualStockCell.h"
#import "DHHeadItem.h"
#import "SearchBar2.h"
#import "Platform.h"
#import "MJRefresh.h"
#import "StockInfoVo.h"
#import "NSString+Estimate.h"
#import "UIView+Sizes.h"
#import "NSString+Estimate.h"
#import "DateUtils.h"
#import "ReturnGoodsGuideVo.h"
#import "ReturnGuideCell.h"
#import "ReturnGuideDetail.h"
@implementation ReturnGuideList


- (void)viewDidLoad {
    [super viewDidLoad];
    service = [ServiceFactory shareInstance].logisticService;
    [self initNavigate];
    [self initMainView];
    [self initMainGrid];
    [self initData];
    self.isClicked = NO;
    [self loadData];
    
   
}

- (void)initNavigate {
    [self configTitle:@"退货指导管理" leftPath:Head_ICON_BACK rightPath:Head_ICON_CHOOSE];
}

- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event {
    if (event==LSNavigationBarButtonDirectLeft) {
        self.selectView.hidden = YES;
         [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    } else {
        self.selectView.hidden = NO;
    }
}


- (void)initMainView {
    self.datas = [[NSMutableArray alloc] init];
}
- (void)initData {
    [self.searchBar initDelagate:self placeholder:@"名称/编号"];
}

- (void)initMainGrid {
    __weak typeof(self) weakself = self;
    [self.mainGrid registerNib:[UINib nibWithNibName:@"ReturnGuideCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.mainGrid.rowHeight = 88;
    [self.mainGrid ls_addHeaderWithCallback:^{
        [ViewFactory clearTableView:weakself.mainGrid];
        weakself.lastDateTime = nil;
        [weakself loadData];
    }];
    [self.mainGrid ls_addFooterWithCallback:^{
        [ViewFactory clearTableView:weakself.mainGrid];
        [weakself loadData];
    }];
}


- (void)loadData {
     __weak typeof(self) weakself = self;
    [service guideList:self.param completionHandler:^(id json) {
        [weakself.mainGrid headerEndRefreshing];
        [weakself.mainGrid footerEndRefreshing];
        if (weakself.lastDateTime == nil) {
            [weakself.datas removeAllObjects];
        }
         weakself.lastDateTime = json[@"lastDateTime"];
        NSArray *arr = json[@"returnGoodsGuideVoList"];
        if (arr.count != 0) {
            for (NSMutableDictionary *obj in arr) {
                ReturnGoodsGuideVo *returnGoodsGuidoVo = [[ReturnGoodsGuideVo alloc] initWithDictionary:obj];
                [weakself.datas addObject:returnGoodsGuidoVo];
            }
        }
        [weakself.mainGrid reloadData];
        weakself.mainGrid.ls_show = YES;
        
    } errorHandler:^(id json) {
        [weakself.mainGrid headerEndRefreshing];
        [weakself.mainGrid footerEndRefreshing];
    }];
}

- (NSMutableDictionary *)param {
    if (_param == nil) {
        _param = [[NSMutableDictionary alloc] init];
    }
    [_param removeAllObjects];
    if ([[Platform Instance] getShopMode] == 3) {
        [_param setValue:[[Platform Instance] getkey:ORG_ID] forKey:@"shopId"];
    } else {
        [_param setValue:[[Platform Instance] getkey:SHOP_ID] forKey:@"shopId"];
    }
    if ([NSString isNotBlank:self.searchBar.keyWordTxt.text]) {
        [_param setValue:self.searchBar.keyWordTxt.text forKey:@"keyWord"];
    }
    if (self.lastDateTime == nil) {
        [_param setValue:[NSNull null] forKey:@"lastDateTime"];
    } else {
         [_param setValue:self.lastDateTime forKey:@"lastDateTime"];
    }
    if (self.isClicked) {
        [_param setValue:[NSNumber numberWithLongLong:[DateUtils converStartTime:self.selectView.lstStart.lblVal.text]/1000] forKey:@"startTime"];
        [_param setValue:[NSNumber numberWithLongLong:[DateUtils converEndTime:self.selectView.lstEnd.lblVal.text]/1000] forKey:@"endTime"];
    }
    return _param;
}


//筛选页面

- (ReturnGuideSelectView *)selectView {
    if (_selectView == nil) {
         _selectView = [[NSBundle mainBundle] loadNibNamed:@"ReturnGuideSelectView" owner:nil options:nil].firstObject;
        self.selectView.delegate = self;
         self.selectView.ls_top = 64;
        [self.view addSubview:_selectView];
        [_selectView initView];
        _selectView.hidden = YES;

    }
    return _selectView;
}


//点击完成按钮
- (void)selectViewWithCompleteButtonClickParam:(NSMutableDictionary *)param {
    if ([self.selectView isValid]) {
        self.selectView.hidden = YES;
        self.searchBar.keyWordTxt.text = @"";
        self.lastDateTime = nil;
        self.isClicked = YES;
        [self loadData];
    }
}
//点击重置按钮
- (void)selectViewWithResetButtonClickParam:(NSMutableDictionary *)param {
    [self.selectView initView];
    self.selectView.hidden = NO;
}

// 输入完成
- (void)imputFinish:(NSString *)keyWord {
    self.lastDateTime = nil;
    self.isClicked = NO;
    [self loadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    ReturnGuideCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    ReturnGoodsGuideVo *returnGoodsGuideVo = self.datas[indexPath.row];
    [cell initWithReturnGoodsGuidoVo:returnGoodsGuideVo];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ReturnGuideDetail *vc = [[ReturnGuideDetail alloc] init];
     ReturnGoodsGuideVo *returnGoodsGuideVo = self.datas[indexPath.row];
    vc.guideId = returnGoodsGuideVo.guideId;
    [self.navigationController pushViewController:vc animated:NO];
     [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];

}
@end
