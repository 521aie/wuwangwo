//
//  GoodsCategoryListView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/7/27.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GoodsCategoryListView.h"
#import "CategoryVo.h"
#import "GoodsCategoryCell.h"
#import "ObjectUtil.h"
#import "GoodsCategoryEditView.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "JsonHelper.h"
#import "XHAnimalUtil.h"
#import "NSString+Estimate.h"
#import "ExportView.h"
#import "NavigateTitle2.h"
#import "LSGoodsInfoSelectViewController.h"
#import "LSGoodsListViewController.h"
#import "GoodsModuleEvent.h"
#import "GoodsStyleEditView.h"
#import "AlertSettingView.h"
#import "LSFooterView.h"
#import "OptionPickerBox.h"
#import "OptionPickerClient.h"
#import "NameItemVO.h"
#import "SortTableView.h"

@interface GoodsCategoryListView () <LSFooterViewDelegate, OptionPickerClient, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) GoodsService* goodsService;
@property (nonatomic) int fromViewTag;
@property (nonatomic,strong) CategoryVo* tempVo;
@property (nonatomic, strong) NSMutableArray *sortDatas;
/** <#注释#> */
@property (nonatomic, strong) LSFooterView *footView;
/** <#注释#> */
@property (nonatomic, strong) UITableView *mainGrid;
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *datas;
@end

@implementation GoodsCategoryListView

- (id)initWithTag:(int) fromViewTag
{
    self = [super init];
    if (self) {
        _fromViewTag = fromViewTag;
        _goodsService = [ServiceFactory shareInstance].goodsService;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initHead];
    [self configViews];
    [self loadDatas];
    [self configHelpButton:HELP_GOODS_CATEGORY_LIST];
}
- (void)configViews {
    self.mainGrid = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    self.mainGrid.backgroundColor = [UIColor clearColor];
    self.mainGrid.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainGrid.dataSource = self;
    self.mainGrid.delegate = self;
    self.mainGrid.rowHeight = 88;
    __weak typeof(self) wself = self;
    [self.mainGrid ls_addHeaderWithCallback:^{
        [wself selectGoodsCategoryList];
    }];

    [self.view addSubview:self.mainGrid];
    
    
    self.footView = [LSFooterView footerView];
    self.footView.ls_bottom = SCREEN_H;
    [self.footView initDelegate:self btnsArray:@[kFootExport, kFootAdd, kFootSort]];
    [self.view addSubview:self.footView];
}
#pragma mark - LSFooterViewDelegate
- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootExport]) {//点击导出按钮
        [self showExportEvent];
    } else if ([footerType isEqualToString:kFootAdd]) {//点击添加按钮
        [self showAddEvent];
    } else if ([footerType isEqualToString:kFootSort]) {//点击排序按钮
        NSString *footerTitle = nil;
        if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {//服鞋
            footerTitle = @"商品品类排序";
        } else {
            footerTitle = @"商品分类排序";
        }
        __weak typeof(self) weakSelf = self;
        NSString *url = @"category/sortList";
        [BaseService getRemoteLSDataWithUrl:url param:nil withMessage:nil show:NO CompletionHandler:^(id json) {
            weakSelf.sortDatas = [NSMutableArray array];
            NameItemVO *item = [[NameItemVO alloc] initWithVal:@"全部一级分类" andId:@"-1"];
            [weakSelf.sortDatas addObject:item];
            NSMutableArray* list= [JsonHelper transList:[json objectForKey:@"categoryList"] objName:@"CategoryVo"];
            if (list != nil && list.count > 0) {
                [self getCategoryStep:list step:1];
                for (CategoryVo* vo in list) {
                    [self getSortCategoryList:vo];
                }
            }
            [OptionPickerBox initData:self.sortDatas itemId:nil];
            [OptionPickerBox show:footerTitle client:self event:0];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];

    }
    
}
//选择排序方式
- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType {
    id<INameItem> item = (id<INameItem>)selectObj;//选择商品分类排序的方式
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:[item obtainItemId] forKey:@"categoryId"];
    NSString *url = @"category/sortPageList";
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
         NSMutableArray *list= [JsonHelper transList:[json objectForKey:@"categoryVoList"] objName:@"CategoryVo"];
        if (list.count < 2) {
            [AlertBox show:@"请至少添加两条内容，才能进行排序。"];
            return;
        }
        __weak typeof(self) weakself = self;
        SortTableView *vc = [[SortTableView alloc] initWithDatas:[list copy] onRightBtnClick:^(NSMutableArray *datas) {
            NSMutableArray *list = [NSMutableArray array];
            for (CategoryVo *vo in datas) {
                [list addObject:vo.categoryId];
            }
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            [param setValue:list forKey:@"categoryIdList"];
            NSString *url = @"category/saveSortList";
            [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:NO CompletionHandler:^(id json) {
                [weakself.mainGrid headerBeginRefreshing];
            } errorHandler:^(id json) {
                [AlertBox show:json];
            }];
            
        } setCellContext:^(SortTableViewCell *cell, id obj) {
            CategoryVo *vo = (CategoryVo *)obj;
            [cell setTitle:vo.name];
        }];
        if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {
            vc.titleStr = @"商品品类排序";
        } else {
            vc.titleStr = @"商品分类排序";
        }
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:weakself.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
    return YES;
}

-(void) loadDatas
{
    if (_fromViewTag == GOODS_STYLE_EDIT_CATEGORY) {
        [self configTitle:@"商品品类" leftPath:Head_ICON_CANCEL rightPath:nil];
        [self configNavigationBar:LSNavigationBarButtonDirectLeft title:@"关闭" filePath:Head_ICON_CANCEL];
    }
    self.datas = [[NSMutableArray alloc] init];
    [self.mainGrid headerBeginRefreshing];
}


-(void) loadDatasFromStyleEditView:(goodsCategoryListBack)callBack
{
    self.goodsCategoryListBack = callBack;
}

#pragma 点击返回按钮
-(void) loadDataFromEditViewOfReturn
{
    [self.mainGrid headerBeginRefreshing];
}

-(void) loadData:(int)action goodsCategory:(CategoryVo*) goodsCategory
{
    if (action == ACTION_CONSTANTS_EDIT) {
        _tempVo = goodsCategory;
        _tempVo.lastVer ++;
        [self.mainGrid reloadData];
    }else if (action == ACTION_CONSTANTS_DEL){
        [self selectGoodsCategoryList];
    }else{
       [self.mainGrid headerBeginRefreshing];
    }
}

-(void) selectGoodsCategoryList
{
    
    __weak GoodsCategoryListView* weakSelf = self;
    [_goodsService selectCategoryList:^(id json) {
        if (!(weakSelf)) {
            return;
        }
        [weakSelf responseSuccess:json];
        [self.mainGrid headerEndRefreshing];
    }errorHandler:^(id json) {
        [AlertBox show:json];
        [self.mainGrid headerEndRefreshing];
    }];
   
}

- (void)responseSuccess:(id)json
{
    self.datas = [[NSMutableArray alloc] init];
    self.parentCategoryList = [[NSMutableArray alloc] init];
    NSMutableArray* list= [JsonHelper transList:[json objectForKey:@"categoryList"] objName:@"CategoryVo"];
    
    if (list != nil && list.count > 0) {
         [self getCategoryStep:list step:1];
        for (CategoryVo* vo in list) {
            [self getCategoryList:vo];
        }
    }
    
    if (self.datas != nil && self.datas.count > 0) {
        for (CategoryVo* vo in self.datas) {
            if ([[Platform Instance] getkey:SHOP_MODE].integerValue == 101) {
                if (vo.step < 2) {
                    [self.parentCategoryList addObject:vo];
                }
            } else {
                if (vo.step < 4) {
                    [self.parentCategoryList addObject:vo];
                }
            }
        }
    }
    
    [self.mainGrid reloadData];
    
    self.mainGrid.ls_show = YES;
}
-(void) getSortCategoryList:(CategoryVo*) vo
{
    if (![vo.name isEqualToString:@"未分类"]) {
        NSString *name = nil;
        if (vo.step == 4) {
            name = [NSString stringWithFormat:@"▪︎ ▪︎ ▪︎ %@", vo.name];
        }else if (vo.step == 2){
            name = [NSString stringWithFormat:@"▪︎ %@", vo.name];
        }else if (vo.step == 3){
            name = [NSString stringWithFormat:@"▪︎ ▪︎ %@", vo.name];
        }else{
            name = vo.name;
        }
        NameItemVO *item = [[NameItemVO alloc] initWithVal:name andId:vo.categoryId];
        [self.sortDatas addObject:item];
        if (vo.categoryVoList != nil && vo.categoryVoList.count > 0) {
            for (CategoryVo* vo1 in vo.categoryVoList) {
                vo1.parentName = vo.name;
                [self getSortCategoryList:vo1];
            }
        }
    }
}
-(void) getCategoryList:(CategoryVo*) vo
{
    if (![vo.name isEqualToString:@"未分类"]) {
        [self.datas addObject:vo];
        if (vo.categoryVoList != nil && vo.categoryVoList.count > 0) {
            for (CategoryVo* vo1 in vo.categoryVoList) {
                vo1.parentName = vo.name;
                [self getCategoryList:vo1];
            }
        }
    }
}

-(void) getCategoryStep:(NSMutableArray *) categoryList step:(short) step
{
    for (CategoryVo *vo in categoryList) {
        if (vo.categoryVoList != nil) {
            vo.step  = step;
            [self getCategoryStep:vo.categoryVoList step:step + 1];
        }else {
            vo.step = step;
        }
    }
}

-(void) onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event == LSNavigationBarButtonDirectLeft) {
        if (self.fromViewTag == STOCK_ALERT_SETTING_VIEW) {
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[AlertSettingView class]]) {
                    AlertSettingView *listView = (AlertSettingView *)vc;
                    [listView loadSelectCategory];
                    [listView.mainGrid headerBeginRefreshing];
                }
            }
            
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [self.navigationController popViewControllerAnimated:NO];
            return;
        }
        if (self.fromViewTag == GOODS_INFO_SELECT_VIEW) {
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[LSGoodsInfoSelectViewController class]]) {
                    LSGoodsInfoSelectViewController *listView = (LSGoodsInfoSelectViewController *)vc;
                    [listView showKindMenuViewOfClickCateBtn];
                }
            }
            
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [self.navigationController popViewControllerAnimated:NO];
        } else if (self.fromViewTag == GOODS_LIST_VIEW) {
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[LSGoodsListViewController class]]) {
                    LSGoodsListViewController *listView = (LSGoodsListViewController *)vc;
                    [listView showKindMenuViewOfClickCateBtn];
                }
            }
            
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [self.navigationController popViewControllerAnimated:NO];
        } else if (self.fromViewTag == GOODS_STYLE_EDIT_CATEGORY) {
            self.goodsCategoryListBack(GOODS_STYLE_EDIT_CATEGORY);
        } else if (self.fromViewTag == GOODS_EDIT_CATEGORY) {
            self.goodsCategoryListBack(GOODS_EDIT_CATEGORY);
        } else {
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [self.navigationController popViewControllerAnimated:NO];
        }
    }
}

-(void) initHead
{
    if ([[Platform Instance] getkey:SHOP_MODE].integerValue == 101) {
        [self configTitle:@"商品品类" leftPath:Head_ICON_BACK rightPath:nil];
    } else {
        [self configTitle:@"商品分类" leftPath:Head_ICON_BACK rightPath:nil];
    }
}

#pragma table部分
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsCategoryCell *detailItem = (GoodsCategoryCell *)[self.mainGrid dequeueReusableCellWithIdentifier:GoodsCategoryCellIndentifier];
    
    if (!detailItem) {
        detailItem = [[NSBundle mainBundle] loadNibNamed:@"GoodsCategoryCell" owner:self options:nil].lastObject;
    }
    CategoryVo *item = [self.datas objectAtIndex:indexPath.row];
    if (item.step == 4) {
        detailItem.lblName.text = [NSString stringWithFormat:@"▪︎ ▪︎ ▪︎ %@", item.name];
    }else if (item.step == 2){
        detailItem.lblName.text = [NSString stringWithFormat:@"▪︎ %@", item.name];
    }else if (item.step == 3){
        detailItem.lblName.text = [NSString stringWithFormat:@"▪︎ ▪︎ %@", item.name];
    }else{
        detailItem.lblName.text = item.name;
    }
    
    detailItem.selectionStyle = UITableViewCellSelectionStyleNone;
    return detailItem;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.datas != nil) {
        [self showEditNVItemEvent:@"goodsCategory" withObj:[self.datas objectAtIndex:indexPath.row]];
    }
}

-(void) showEditNVItemEvent:(NSString *)event withObj:(id<INameValueItem>)obj
{
     _tempVo = (CategoryVo *) obj;
    GoodsCategoryEditView *vc = [[GoodsCategoryEditView alloc] init];
    vc.categoryVo = _tempVo;
    vc.fromViewTag = _fromViewTag;
    vc.action = ACTION_CONSTANTS_EDIT;
    vc.parentCategoryList = self.parentCategoryList;
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    if (_fromViewTag == GOODS_STYLE_EDIT_CATEGORY || self.fromViewTag == GOODS_EDIT_CATEGORY) {
        __weak GoodsCategoryListView* weakSelf = self;
        [vc loaddatas:^(CategoryVo *categoryVo, int action, BOOL flg) {
            [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            if (flg) {
                [weakSelf loadData:action goodsCategory:categoryVo];
            }
            [weakSelf.navigationController popToViewController:weakSelf animated:NO];
        }];
    }
}

- (void) showAddEvent
{
    GoodsCategoryEditView *vc = [[GoodsCategoryEditView alloc] init];
    vc.categoryVo = nil;
    vc.action = ACTION_CONSTANTS_ADD;
    vc.parentCategoryList = self.parentCategoryList;
    vc.fromViewTag = _fromViewTag;
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
    
    if (_fromViewTag == GOODS_STYLE_EDIT_CATEGORY || self.fromViewTag == GOODS_EDIT_CATEGORY) {
        __weak GoodsCategoryListView* weakSelf = self;
        [vc loaddatas:^(CategoryVo *categoryVo, int action, BOOL flg) {
            [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
            if (flg) {
                [weakSelf loadData:action goodsCategory:categoryVo];
            }
            [weakSelf.navigationController popToViewController:weakSelf animated:NO];
        }];
    }
}

-(void) showExportEvent
{
    ExportView *vc = [[ExportView alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
     NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [vc loadData:dic withPath:@"category/exportGoodsCategory" withIsPush:YES callBack:^{
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        [self.navigationController popViewControllerAnimated:NO];
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

@end
