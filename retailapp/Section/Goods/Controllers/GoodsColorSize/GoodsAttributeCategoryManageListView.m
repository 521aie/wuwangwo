//
//  GoodsStyleCategoryManageListView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/8/11.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GoodsAttributeCategoryManageListView.h"
#import "GoodsCategoryCell.h"
#import "ObjectUtil.h"
#import "GoodsAttributeCategoryManageEditView.h"
#import "AttributeGroupVo.h"
#import "AttributeVo.h"
#import "ServiceFactory.h"
#import "JsonHelper.h"
#import "AlertBox.h"
#import "GoodsSingleAttributeListView.h"
#import "XHAnimalUtil.h"
#import "LSFooterView.h"

@interface GoodsAttributeCategoryManageListView ()<UITableViewDelegate, UITableViewDataSource, LSFooterViewDelegate>

@property (nonatomic, strong) GoodsService* goodsService;

@property (nonatomic, strong) AttributeGroupVo* tempVo;
/** <#注释#> */
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#> */
@property (nonatomic, strong) LSFooterView *footView;
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation GoodsAttributeCategoryManageListView


- (void)viewDidLoad {
    [super viewDidLoad];
     _goodsService = [ServiceFactory shareInstance].goodsService;
    [self initHead];
    [self configViews];
    __weak GoodsAttributeCategoryManageListView* weakSelf = self;
    [weakSelf.tableView ls_addHeaderWithCallback:^{
        [weakSelf relodDatas];
    }];
    [self loadDatas];
}
- (void)configViews {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
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

-(void) loadDatas
{
    [self.tableView reloadData];
    
    self.tableView.ls_show = YES;
}

-(void) loadData:(NSMutableArray *)categoryList attributeVo:(AttributeVo *)attributeVo callBack:(goodsAttributeCategoryManageListBack) callBack
{
    self.goodsAttributeCategoryManageListBack = callBack;
    self.datas = [[NSMutableArray alloc] init];
    self.datas = categoryList;
    self.attributeVo = attributeVo;
    
    if (self.datas != nil && self.datas.count > 0) {
        AttributeGroupVo* vo = [self.datas objectAtIndex:self.datas.count - 1];
        if ([vo.attributeGroupName isEqualToString:@"未分类"]) {
            [self.datas removeObjectAtIndex:self.datas.count - 1];
        }
    }
}

-(void) relodDatas
{
    __weak GoodsAttributeCategoryManageListView* weakSelf = self;
    [_goodsService selectAttributeTypeList:self.attributeVo.attributeId attributeType:self.attributeVo.attributeType completionHandler:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        [weakSelf responseSuccess:json];
        [weakSelf.tableView headerEndRefreshing];
    } errorHandler:^(id json) {
        [AlertBox show:json];
        [weakSelf.tableView headerEndRefreshing];
    }];
}

- (void)responseSuccess:(id)json
{
    self.datas = [NSMutableArray new];
    self.datas = [JsonHelper transList:[json objectForKey:@"attributeGroupList"] objName:@"AttributeGroupVo"];
    
    if (self.datas != nil && self.datas.count > 0) {
        AttributeGroupVo* vo = [self.datas objectAtIndex:self.datas.count - 1];
        if ([vo.attributeGroupName isEqualToString:@"未分类"]) {
            [self.datas removeObjectAtIndex:self.datas.count - 1];
        }
    }
    [self.tableView reloadData];
    
    self.tableView.ls_show = YES;
}


-(void) showAddEvent
{
    GoodsAttributeCategoryManageEditView* vc = [[GoodsAttributeCategoryManageEditView alloc] init];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
    [self.navigationController pushViewController:vc animated:NO];
    __weak GoodsAttributeCategoryManageListView* weakSelf = self;
    [vc loaddatas:nil attributeVo:self.attributeVo action:ACTION_CONSTANTS_ADD callBack:^(AttributeGroupVo* attributeGroupVo, int action) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        if (attributeGroupVo) {
            [weakSelf relodDatas];
        }
        [weakSelf.navigationController popToViewController:weakSelf animated:NO];
    }];
}

#pragma table部分
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsCategoryCell *detailItem = (GoodsCategoryCell *)[self.tableView dequeueReusableCellWithIdentifier:GoodsCategoryCellIndentifier];
    
    if (!detailItem) {
        detailItem = [[NSBundle mainBundle] loadNibNamed:@"GoodsCategoryCell" owner:self options:nil].lastObject;
    }
    
    if ([ObjectUtil isNotEmpty:self.datas]) {
        AttributeGroupVo *item = [self.datas objectAtIndex:indexPath.row];
        detailItem.lblName.text = item.attributeGroupName;
        
    }
    return detailItem;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.datas != nil) {
        [self showEditNVItemEvent:@"goodsAttributeCategoryManage" withObj:[self.datas objectAtIndex:indexPath.row]];
    }
}

-(void) showEditNVItemEvent:(NSString *)event withObj:(id<INameValueItem>)obj
{
    _tempVo = (AttributeGroupVo*) obj;
    GoodsAttributeCategoryManageEditView* vc = [[GoodsAttributeCategoryManageEditView alloc] init];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    [self.navigationController pushViewController:vc animated:NO];
    __weak GoodsAttributeCategoryManageListView* weakSelf = self;
    [vc loaddatas:_tempVo attributeVo:self.attributeVo action:ACTION_CONSTANTS_EDIT callBack:^(AttributeGroupVo* attributeGroupVo, int action) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        if (attributeGroupVo) {
            if (action == ACTION_CONSTANTS_EDIT) {
                _tempVo = attributeGroupVo;
                _tempVo.lastVer ++;
                [weakSelf.tableView reloadData];
            } else if (action == ACTION_CONSTANTS_DEL) {
                [weakSelf.datas removeObject:_tempVo];
                [weakSelf.tableView reloadData];
                
                self.tableView.ls_show = YES;
            }
        }
        
        [weakSelf.navigationController popToViewController:weakSelf animated:NO];
    }];
}

#pragma mark UITableView无section列表

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count == 0 ? 0 :self.datas.count;
}

-(void) initHead
{
    [self configTitle:@"分类管理" leftPath:Head_ICON_CANCEL rightPath:nil];
    [self configNavigationBar:LSNavigationBarButtonDirectLeft title:@"关闭" filePath:Head_ICON_CANCEL];
}

@end
