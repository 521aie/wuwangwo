//
//  EnterCircleListView.m
//  retailapp
//
//  Created by qingmei on 15/12/15.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "EnterCircleListView.h"
#import "ServiceFactory.h"
#import "NavigateTitle2.h"
#import "XHAnimalUtil.h"

#import "EnterCircleShopCell.h"
#import "ObjectUtil.h"
#import "AlertBox.h"
#import "FooterListView.h"
#import "EnterCircleEditView.h"
#import "ESPSettledMallVo.h"

@interface EnterCircleListView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableDictionary   *param; //网络请求需要的参数
@property (nonatomic, strong) SettingService        *service;
@property (nonatomic, strong) NSMutableArray        *shopList;
@end

@implementation EnterCircleListView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.service = [ServiceFactory shareInstance].settingService;
    [self initMainView];
    [self loadData];
}

- (void)initMainView{
    [self configTitle:@"入驻商圈" leftPath:Head_ICON_BACK rightPath:nil];
    self.mainGrid = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    self.mainGrid.backgroundColor = [UIColor clearColor];
    self.mainGrid.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainGrid.delegate = self;
    self.mainGrid.dataSource = self;
    [self.view addSubview:self.mainGrid];
}

#pragma mark - NetWork
- (void)loadData{
    __weak EnterCircleListView *weakSelf = self;
    [_service settledMallShopList:self.param completionHandler:^(id json) {
        weakSelf.shopList = nil;
        weakSelf.shopList = [[NSMutableArray alloc]init];
        NSArray *arr = [json objectForKey:@"settledMallVoList"];
        if ([ObjectUtil isNotEmpty:arr]) {
            for (NSDictionary *map in arr) {
                ESPSettledMallVo *shopVo = [[ESPSettledMallVo alloc]initWithDictionary:map];
                [weakSelf.shopList addObject:shopVo];
            }
        }
        [weakSelf.mainGrid reloadData];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

- (NSMutableDictionary *)param {
    if (_param == nil) {
        _param = [NSMutableDictionary dictionary];
    }
    [_param setValue:[[Platform Instance] getkey:RELEVANCE_ENTITY_ID] forKey:@"entityId"];
    return _param;
}

#pragma mark - FooterListEvent代理
-(void) showAddEvent{
    EnterCircleEditView *vc = [[EnterCircleEditView alloc] initWithParent:self applyType:State_Apply];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
    
}



#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.shopList!=nil ? self.shopList.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"ESPshopCell";
    EnterCircleShopCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [EnterCircleShopCell getInstance];
        ESPSettledMallVo *temp = [self.shopList objectAtIndex:indexPath.row];
        [cell loadCell:temp];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ESPSettledMallVo *temp = [self.shopList objectAtIndex:indexPath.row];
    NSInteger stateApply = State_Apply;
    if(temp.status.integerValue == 0){
        stateApply = State_Apply;
    }else if (temp.status.integerValue == 1) {
        stateApply = State_Appling;
    }else if (temp.status.integerValue == 2){
        stateApply = State_Success;
    }else if (temp.status.integerValue == 3){
        stateApply = State_Refuse;
    }else if (temp.status.integerValue == 4){
        stateApply = State_Unbind;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:temp.shopId forKey:@"shopId"];
    [params setValue:temp.Id forKey:@"settledMallId"];
    EnterCircleEditView *vc = [[EnterCircleEditView alloc] initWithParent:self applyType:stateApply];
    vc.detailParams = params;
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width,88);
    UIView *view = [[UIView alloc]initWithFrame:rect];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 88;
}
@end
