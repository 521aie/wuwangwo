//
//  GoodsBrandManageListView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/8/5.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GoodsAttributeManageListView.h"
#import "UIHelper.h"
#import "GoodsBrandLibraryManageCell.h"
#import "ObjectUtil.h"
#import "GoodsStyleEditView.h"
#import "GoodsModuleEvent.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "GoodsBrandVo.h"
#import "AttributeValVo.h"
#import "GoodsAttributeManageEditView.h"
#import "XHAnimalUtil.h"
#import "FooterListView.h"
#import "EditItemList.h"
#import "LSGoodsEditView.h"
#import "LSEditItemList.h"
#import "LSFooterView.h"

@interface GoodsAttributeManageListView ()<UITableViewDelegate, UITableViewDataSource, LSFooterViewDelegate>

@property (nonatomic, strong) GoodsService* goodsService;

@property (nonatomic) int fromViewTag;

@property (nonatomic, strong) NSString* attributeType;

@property (nonatomic, strong) GoodsBrandVo *goodsBrandVo;

@property (nonatomic, strong) AttributeValVo *attributeValVo;
/** <#注释#> */
@property (nonatomic, strong) UITableView *tableView;

/** <#注释#> */
@property (nonatomic, strong) LSFooterView *footView;
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *datas;
@end

@implementation GoodsAttributeManageListView


- (void)viewDidLoad {
    [super viewDidLoad];
    _goodsService = [ServiceFactory shareInstance].goodsService;
    [self configTitle:@"品牌库管理"];
    [self configNavigationBar:LSNavigationBarButtonDirectLeft title:@"关闭" filePath:Head_ICON_CANCEL];
    
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


    __weak typeof(self) wself = self;
    [self.tableView ls_addHeaderWithCallback:^{
        if (_fromViewTag == GOODS_STYLE_EDIT_BRAND || _fromViewTag == GOODS_EDIT_BRAND) {
            [wself selectBrandList];
        }else if (_fromViewTag == GOODS_STYLE_EDIT_SERIES || _fromViewTag == GOODS_STYLE_EDIT_SEASON || _fromViewTag == GOODS_STYLE_EDIT_FABRIC || _fromViewTag == GOODS_STYLE_EDIT_MATERIAL || _fromViewTag == GOODS_STYLE_EDIT_MAINMODEL || _fromViewTag == GOODS_STYLE_EDIT_AUXILIARYMODEL){
            [wself selectAttributeValList];
        }
    }];
    [self loadDatas];
}

-(void)loadDatas
{
    NSString *title = @"";
    if (_fromViewTag == GOODS_STYLE_EDIT_BRAND || _fromViewTag == GOODS_EDIT_BRAND) {
        title = @"品牌库管理";
        [self selectBrandList];
    } else if (_fromViewTag == GOODS_STYLE_EDIT_SERIES){
        title = @"系列库管理";
        _attributeType = @"1";
        [self selectAttributeValList];
    } else if (_fromViewTag == GOODS_STYLE_EDIT_SEASON){
        title = @"季节库管理";
        _attributeType = @"2";
        [self selectAttributeValList];
    } else if (_fromViewTag == GOODS_STYLE_EDIT_FABRIC || _fromViewTag == GOODS_STYLE_EDIT_MATERIAL){
        title = @"材质库管理";
        _attributeType = @"3";
        [self selectAttributeValList];
    } else if (_fromViewTag == GOODS_STYLE_EDIT_MAINMODEL) {
        title = @"主型库管理";
        _attributeType = @"5";
        [self selectAttributeValList];
    } else if (_fromViewTag == GOODS_STYLE_EDIT_AUXILIARYMODEL) {
        title = @"辅型库管理";
        _attributeType = @"6";
        [self selectAttributeValList];
    }
    [self configTitle:title];
}

- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootAdd]) {
        [self showAddEvent];
    }
}

-(void)loadDatas:(int) fromViewTag callBack:(goodsAttributeManageListBack) callBack
{
    self.goodsAttributeManageListBack = callBack;
    _fromViewTag = fromViewTag;
    
}

-(void)loadDatasFromEditView
{
    [self.tableView headerBeginRefreshing];
}

-(void) selectBrandList
{
    __weak GoodsAttributeManageListView* weakSelf = self;
    [_goodsService selectBrandList:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        NSMutableArray* list = [json objectForKey:@"goodsBrandList"];
        self.datas = [[NSMutableArray alloc] init];
        if (list != nil && list.count > 0) {
            for (NSDictionary* dic in list) {
                [self.datas addObject:[GoodsBrandVo convertToGoodsBrandVo:dic]];
            }
        }
        [self.tableView reloadData];
        
        self.tableView.ls_show = YES;
        
        [self.tableView headerEndRefreshing];
    } errorHandler:^(id json) {
        [AlertBox show:json];
        [self.tableView headerEndRefreshing];
    }];
}

-(void) selectAttributeValList
{
    __weak GoodsAttributeManageListView* weakSelf = self;
    [_goodsService selectBaseAttributeValList:_attributeType completionHandler:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        NSMutableArray* list = [json objectForKey:@"attributeValList"];
        self.datas = [[NSMutableArray alloc] init];
        if (list != nil && list.count > 0) {
            for (NSDictionary* dic in list) {
                [self.datas addObject:[AttributeValVo convertToAttributeValVo:dic]];
            }
        }
        [self.tableView reloadData];
        
        self.tableView.ls_show = YES;
        
        [self.tableView headerEndRefreshing];
    } errorHandler:^(id json) {
        [AlertBox show:json];
        [self.tableView headerEndRefreshing];
    }];
}

- (void)showAddEvent
{
    GoodsAttributeManageEditView* vc = [[GoodsAttributeManageEditView alloc] init];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
    [self.navigationController pushViewController:vc animated:NO];
    __weak GoodsAttributeManageListView* weakSelf = self;
    [vc loaddatas:_fromViewTag callBack:^(BOOL flg) {
        [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        if (flg) {
            [self loadDatasFromEditView];
        }
        [weakSelf.navigationController popToViewController:weakSelf animated:NO];
    }];
}

-(void) onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event==LSNavigationBarButtonDirectLeft) {
        self.goodsAttributeManageListBack(_fromViewTag);
    }
}

#pragma table部分
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsBrandLibraryManageCell *detailItem = (GoodsBrandLibraryManageCell *)[self.tableView dequeueReusableCellWithIdentifier:GoodsBrandLibraryManageCellIndentifier];
    
    if (!detailItem) {
        detailItem = [[NSBundle mainBundle] loadNibNamed:@"GoodsBrandLibraryManageCell" owner:self options:nil].lastObject;
    }
    
    detailItem.delegate = self;
    
    if ([ObjectUtil isNotEmpty:self.datas]) {
        if (_fromViewTag == GOODS_STYLE_EDIT_BRAND || _fromViewTag == GOODS_EDIT_BRAND) {
            GoodsBrandVo *item = [self.datas objectAtIndex:indexPath.row];
            detailItem.lblName.text = item.name;
        }else{
            AttributeValVo *item = [self.datas objectAtIndex:indexPath.row];
            detailItem.lblName.text = item.attributeVal;
        }
        detailItem.index = (int) indexPath.row;
        detailItem.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return detailItem;
}

-(void) delCell:(int)index
{
    
    if (_fromViewTag == GOODS_STYLE_EDIT_BRAND || _fromViewTag == GOODS_EDIT_BRAND) {
        _goodsBrandVo = [self.datas objectAtIndex:index];
        [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:@"确认要删除[%@]吗？", _goodsBrandVo.name]];
        
        
    }else{
        _attributeValVo = [self.datas objectAtIndex:index];
        [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:@"确认要删除[%@]吗？", _attributeValVo.attributeVal]];
    }
}

//删除确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        __weak GoodsAttributeManageListView* weakSelf = self;
        if (_fromViewTag == GOODS_STYLE_EDIT_BRAND || _fromViewTag == GOODS_EDIT_BRAND) {
            
            [_goodsService delBrand:_goodsBrandVo.goodsBrandId lastVer:[NSString stringWithFormat:@"%tu", _goodsBrandVo.lastVer] completionHandler:^(id json) {
                if (!(weakSelf)) {
                    return ;
                }
                [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj isKindOfClass:[GoodsStyleEditView class]]) {
                        GoodsStyleEditView *vc = (GoodsStyleEditView *)obj;
                        if ([[vc.lsBrand getDataLabel] isEqualToString:_goodsBrandVo.name]) {
                            [vc.lsBrand initData:@"请选择" withVal:nil];
                        }
                        
                    }
                    
                    if ([obj isKindOfClass:[LSGoodsEditView class]]) {
                        LSGoodsEditView *vc = (LSGoodsEditView *)obj;
                        if ([[vc.lsBrand getDataLabel] isEqualToString:_goodsBrandVo.name]) {
                            [vc.lsBrand initData:@"请选择" withVal:nil];
                        }
                    }
                }];
                [self.tableView headerBeginRefreshing];
            } errorHandler:^(id json) {
                [AlertBox show:json];
            }];
        }else{
            NSMutableArray* list = [[NSMutableArray alloc] init];
            
            [list addObject:[AttributeValVo getDictionaryData:_attributeValVo]];
            [_goodsService delAttributeVal:list completionHandler:^(id json) {
                if (!(weakSelf)) {
                    return ;
                }
                [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj isKindOfClass:[GoodsStyleEditView class]]) {
                        GoodsStyleEditView *vc = (GoodsStyleEditView *)obj;
                        if (_fromViewTag == GOODS_STYLE_EDIT_SERIES){
                            if ([[vc.lsSeries getDataLabel] isEqualToString: _attributeValVo.attributeVal]) {
                                [vc.lsSeries initData:@"请选择" withVal:nil];
                            }
                        } else if (_fromViewTag == GOODS_STYLE_EDIT_SEASON){
                            if ([[vc.lsSeason getDataLabel] isEqualToString: _attributeValVo.attributeVal]) {
                                [vc.lsSeason initData:@"请选择" withVal:nil];
                            }
                        } else if (_fromViewTag == GOODS_STYLE_EDIT_FABRIC){
                            if ([[vc.lsFabric getDataLabel] isEqualToString: _attributeValVo.attributeVal]) {
                                [vc.lsFabric initData:@"请选择" withVal:nil];
                            }
                        }else if ( _fromViewTag == GOODS_STYLE_EDIT_MATERIAL){
                            if ([[vc.lsMaterial getDataLabel] isEqualToString: _attributeValVo.attributeVal]) {
                                [vc.lsMaterial initData:@"请选择" withVal:nil];
                            }
                        } else if (_fromViewTag == GOODS_STYLE_EDIT_MAINMODEL) {
                            if ([[vc.lsMainModel getDataLabel] isEqualToString: _attributeValVo.attributeVal]) {
                                [vc.lsMainModel initData:@"请选择" withVal:nil];
                            }
                        } else if (_fromViewTag == GOODS_STYLE_EDIT_AUXILIARYMODEL) {
                            if ([[vc.lsAuxiliaryModel getDataLabel] isEqualToString: _attributeValVo.attributeVal]) {
                                [vc.lsAuxiliaryModel initData:@"请选择" withVal:nil];
                            }
                        }
                        
                    }
                    
                }];
                [self.tableView headerBeginRefreshing];
            } errorHandler:^(id json) {
                [AlertBox show:json];
            }];
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ;
}

#pragma mark UITableView无section列表

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count == 0 ? 0 :self.datas.count;
}

@end
