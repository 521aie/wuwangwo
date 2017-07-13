//
//  GoodsSingleAttributeListView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/8/10.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GoodsSingleAttributeListView.h"
#import "GoodsStyleAttributeVo.h"
#import "NavigateTitle2.h"
#import "NameValueItemVO.h"
#import "ObjectUtil.h"
#import "MultiCheckCell.h"
#import "GridHead.h"
#import "FooterListView.h"
#import "GoodsSingleAttributeCell.h"
#import "KindMenuView.h"
#import "TreeNode.h"
#import "ViewFactory.h"
#import "GoodsAttributeCategoryManageListView.h"
#import "GoodsSingleAttributeEditView.h"
#import "XHAnimalUtil.h"
#import "ServiceFactory.h"
#import "JsonHelper.h"
#import "AlertBox.h"
#import "AttributeVo.h"
#import "AttributeGroupVo.h"
#import "AttributeValVo.h"
#import "GoodsAttributeListView.h"
#import "GoodsAttributeSelectView.h"
#import "OptionPickerBox.h"
#import "NameItemVO.h"
#import "GoodsAttributeGroupSortView.h"
#import "GoodsAttributeValSortView.h"
#import "ColorHelper.h"
#import "GridColHead.h"
#import "HeaderItem.h"

@interface GoodsSingleAttributeListView ()

@property (nonatomic, strong) GoodsService* goodsService;
/** <#注释#> */
@property (nonatomic, strong) GridColHead *infoView;

/**
 右侧属性分类list
 */
@property (nonatomic, strong) NSMutableArray* rightAttributeManageList;

/**
 是否显示右上角分类
 */
//@property(nonatomic, assign) BOOL isShowCate;

@end

@implementation GoodsSingleAttributeListView


- (void)viewDidLoad {
    [super viewDidLoad];
     _goodsService = [ServiceFactory shareInstance].goodsService;
    [self configViews];
    [self initGrid];
    __weak GoodsSingleAttributeListView* weakSelf = self;
    [weakSelf.tableView ls_addHeaderWithCallback:^{
        [weakSelf loaddatas];
    }];
    [self loaddatas];
}

- (void)configViews {
    CGFloat y = kNavH;
    self.infoView = [GridColHead gridColHead];
    self.infoView.frame = CGRectMake(0, y, SCREEN_W, 40);
    [self.view addSubview:self.infoView];
    
    y = self.infoView.ls_bottom;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, y, SCREEN_W, SCREEN_H - y)];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.footView = [LSFooterView footerView];
    [self.footView initDelegate:self btnsArray:@[kFootBatch, kFootAdd, kFootSort]];
    [self.view addSubview:self.footView];
}

- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootBatch]) {
        [self showBatchEvent];
    } else if ([footerType isEqualToString:kFootAdd]) {
        [self showAddEvent];
    } else if ([footerType isEqualToString:kFootSort]) {
        [self showSortEvent];
    }

}


-(void) loaddatas
{
    if (_fromViewTag == GOODS_ATTRIBUTE_SELECT_VIEW) {
        [self configTitle:@"" leftPath:Head_ICON_CANCEL rightPath:Head_ICON_CATE];
    } else{
        [self configTitle:@"" leftPath:Head_ICON_BACK rightPath:Head_ICON_CATE];
    }
    [self configNavigationBar:LSNavigationBarButtonDirectRight title:@"分类" filePath:Head_ICON_CATE];
    __weak GoodsSingleAttributeListView* weakSelf = self;
    if ([weakSelf.attributeVo.name isEqualToString:@"颜色"]) {
        [weakSelf.infoView initColHead:@"色称" col2:@"色号"];
    } else if ([weakSelf.attributeVo.name isEqualToString:@"尺码"]) {
        [weakSelf.infoView initColHead:@"尺码" col2:@"尺码编号"];
    }
    [self configTitle:[NSString stringWithFormat:@"%@库管理", weakSelf.attributeVo.name]];
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

-(void) loaddatas:(AttributeVo *)attributeVo fromViewTag:(int)viewTag callBack:(goodsSingleAttributeListBack) callBack
{
    self.goodsSingleAttributeListBack = callBack;
    self.attributeVo = attributeVo;
    self.fromViewTag = viewTag;
}

-(void) loaddatasFromEditView:(AttributeVo *)attributeVo fromViewTag:(int)viewTag
{
    self.attributeVo = attributeVo;
    __weak GoodsSingleAttributeListView* weakSelf = self;
//    self.lblAttribute.text = [NSString stringWithFormat:@"%@名称", attributeVo.name];
    [_goodsService selectAttributeTypeList:attributeVo.attributeId attributeType:attributeVo.attributeType completionHandler:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        [self responseSuccess:json];
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
    
    NSMutableArray *headList = [[NSMutableArray alloc] init];
    self.attributeGroupList = [[NSMutableArray alloc] init];
    for (AttributeGroupVo* vo in self.datas) {
        [self.attributeGroupList addObject:vo];
        [headList addObject:vo];
    }
    [self initHeadData:headList];
    _rightAttributeManageList = [NSMutableArray arrayWithArray:self.headList];
    
    self.detailMap=[NSMutableDictionary dictionary];
    NSMutableArray* details = nil;
    for (NameValueItemVO* vo in self.headList) {
        details=[NSMutableArray array];
        for (AttributeGroupVo* items in self.datas) {
            for (AttributeValVo* item in items.attributeValVoList) {
                if ([vo.itemId isEqualToString:item.attributeValGroup]) {
                    [details addObject:item];
                }
            }
        }
        
        [self.detailMap setValue:details forKey:vo.itemId];
    }
    
    for (NameValueItemVO* item in self.headList) {
        if ([item.itemName isEqualToString:@"未分类"]) {
            NSMutableArray* noCategoryList = [self.detailMap objectForKey:item.itemId];
            if (noCategoryList.count == 0) {
                [self.detailMap removeObjectForKey:item.itemId];
                [self.headList removeObject:item]; 
                break;
            }
        }
    }
    
    [self.tableView reloadData];

    self.tableView.ls_show = YES;
}

-(void) onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event==LSNavigationBarButtonDirectLeft) {
        if (_fromViewTag == GOODS_ATTRIBUTE_LIST_VIEW) {
            self.goodsSingleAttributeListBack(YES);
        } else if (_fromViewTag == GOODS_ATTRIBUTE_SELECT_VIEW) {
            self.goodsSingleAttributeListBack(YES);
        }
    }else{
        [self showKindMenuView];
    }
}

-(void)showKindMenuView
{
    [self loadKindMenuView];
    self.categoryList = [[NSMutableArray alloc] init];
    for (NameValueItemVO* item in _rightAttributeManageList) {
        TreeNode *vo1 = [[TreeNode alloc] init];
        vo1.itemName = [item obtainItemName];
        vo1.itemId = [item obtainItemId];
        [self.categoryList addObject:vo1];
    }
    
    [self.kindMenuView initDelegate:self event:0 isShowManagerBtn:YES];
    [self.kindMenuView loadData:nil nodes:nil endNodes:self.categoryList];
}

/*加载分类页面*/
- (void)loadKindMenuView
{
    if (self.kindMenuView) {
        self.kindMenuView.view.hidden = NO;
    }else{
        self.kindMenuView = [[KindMenuView alloc] init];
        self.kindMenuView.view.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
        [self.view addSubview:self.kindMenuView.view];
    }
}

-(void) singleCheck:(NSInteger)event item:(id<INameItem>)item
{
    TreeNode* node=(TreeNode*)item;
    if ([node.itemName isEqualToString:@"未分类"]) {
        BOOL existFlg = NO;
        if (self.headList.count > 0) {
            for (NameValueItemVO* item in self.headList) {
                if ([item.itemName isEqualToString:@"未分类"]) {
                    existFlg = YES;
                    break ;
                }
            }
        }
        
        if (!existFlg) {
            [AlertBox show:[NSString stringWithFormat:@"该分类下暂无符合条件的%@!", _attributeVo.name]];
            return ;
        }
    }
    
    [self scrocll:node];
}

-(void) closeSingleView:(NSInteger)event
{
    GoodsAttributeCategoryManageListView* vc = [[GoodsAttributeCategoryManageListView alloc] init];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    [self.navigationController pushViewController:vc animated:NO];
    __weak GoodsSingleAttributeListView* weakSelf = self;
    [vc loadData:self.datas attributeVo:self.attributeVo callBack:^(AttributeVo *attributeVo, int fromViewTag) {
        [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
//        _isShowCate = YES;
        [weakSelf loaddatasFromEditView:attributeVo fromViewTag:fromViewTag];
        [weakSelf.navigationController popToViewController:weakSelf animated:NO];
    }];
}

- (void)scrocll:(TreeNode*)node
{
    if ([ObjectUtil isNotEmpty:self.headList] && [ObjectUtil isNotNull:node]) {
        int index = [GlobalRender getPos:self.headList itemId:node.itemId];
        CGFloat offset = index*DH_HEAD_HEIGHT;
        for (NSUInteger i=0;i<index;++i) {
            TreeNode *nodeTemp = [self.headList objectAtIndex:i];
            if([ObjectUtil isNotNull:nodeTemp]) {
                NSArray *menus = [self.detailMap objectForKey:nodeTemp.itemId];
                if ([ObjectUtil isNotEmpty:menus]) {
                    offset += DH_IMAGE_CELL_ITEM_HEIGHT*menus.count;
                }
            }
        }
        [self.tableView setContentOffset:CGPointMake(0, offset) animated:YES];
    }
}

-(void) initHeadData:(NSMutableArray *) headList
{
    self.headList=[NSMutableArray array];
    for (AttributeGroupVo *vo in headList) {
        NameValueItemVO* item=[[NameValueItemVO alloc] initWithVal:vo.attributeGroupName val:vo.attributeGroupId andId:vo.attributeGroupId];
        [self.headList addObject:item];
    }
}

-(void) showAddEvent
{
    GoodsSingleAttributeEditView* vc = [[GoodsSingleAttributeEditView alloc] init];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
    [self.navigationController pushViewController:vc animated:NO];
    __weak GoodsSingleAttributeListView* weakSelf = self;
    [vc loaddatas:self.attributeVo attributeGroupVoList:self.attributeGroupList attributeValVo:nil action:ACTION_CONSTANTS_ADD callBack:^(AttributeVo *attributeVo, int fromViewTag) {
        [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        if (attributeVo) {
//            _isShowCate = NO;
            [weakSelf loaddatasFromEditView:attributeVo fromViewTag:fromViewTag];
        }
        [weakSelf.navigationController popToViewController:weakSelf animated:NO];
    }];
}

-(void) showBatchEvent
{
    GoodsAttributeSelectView* vc = [[GoodsAttributeSelectView alloc] init];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
    [self.navigationController pushViewController:vc animated:NO];
    __weak GoodsSingleAttributeListView* weakSelf = self;

    [vc loaddatas:GOODS_SINGLE_ATTRIBUTE_LIST_VIEW attributeVo:self.attributeVo attributeValDic:nil callBack:^(NSString *type, NSMutableArray *attributeValList) {
        [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        [weakSelf loaddatasFromEditView:weakSelf.attributeVo fromViewTag:0];
        [weakSelf.navigationController popToViewController:weakSelf animated:NO];
    }];
//    [parent showView:GOODS_ATTRIBUTE_SELECT_VIEW];
////    [parent.goodsAttributeSelectView loaddatas:GOODS_SINGLE_ATTRIBUTE_LIST_VIEW attributeVo:self.attributeVo attributeValDic:nil];
}

-(void) showSortEvent
{
    UIActionSheet *menu = [[UIActionSheet alloc]
                           initWithTitle: @"请选择排序操作"
                           delegate:self
                           cancelButtonTitle:@"取消"
                           destructiveButtonTitle:nil
                           otherButtonTitles: [NSString stringWithFormat:@"%@分类排序",self.attributeVo.name], [NSString stringWithFormat:@"%@排序",self.attributeVo.name], nil];
    [menu showInView:self.view];
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        GoodsAttributeGroupSortView* vc = [[GoodsAttributeGroupSortView alloc] init];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
        [self.navigationController pushViewController:vc animated:NO];
        __weak GoodsSingleAttributeListView* weakSelf = self;
        [vc loadDatas:_attributeGroupList attributeNameId:_attributeVo.attributeId attributeName:_attributeVo.name callBack:^(BOOL flg) {
            [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
            if (YES) {
                [weakSelf loaddatasFromEditView:weakSelf.attributeVo fromViewTag:0];
            }
            [weakSelf.navigationController popToViewController:weakSelf animated:NO];
        }];
    } else if (buttonIndex == 1) {
        NSMutableArray* vos=[NSMutableArray array];
        if (self.headList != nil && self.headList > 0) {
            for (NameValueItemVO* vo in self.headList) {
                NameItemVO *item=[[NameItemVO alloc] initWithVal:[vo obtainItemName] andId:[vo obtainItemId]];
                [vos addObject:item];
            }
        }
        [OptionPickerBox initData:vos itemId:@""];
        [OptionPickerBox show:[NSString stringWithFormat:@"%@分类",self.attributeVo.name] client:self event:1000];
    }
}

-(BOOL) pickOption:(id)selectObj event:(NSInteger)eventType
{
    id<INameItem> item = (id<INameItem>)selectObj;
    NSMutableArray* attributeValList = [self.detailMap objectForKey:[item obtainItemId]];
    GoodsAttributeValSortView* vc = [[GoodsAttributeValSortView alloc] init];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
    [self.navigationController pushViewController:vc animated:NO];
    __weak GoodsSingleAttributeListView* weakSelf = self;
    [vc loadDatas:attributeValList attributeGroupId:[item obtainItemId] attributeName:_attributeVo.name callBack:^(BOOL flg) {
        [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        if (YES) {
            [weakSelf loaddatasFromEditView:weakSelf.attributeVo fromViewTag:0];
        }
        [weakSelf.navigationController popToViewController:weakSelf animated:NO];
    }];
    return YES;
}

#pragma table部分.
#pragma mark UITableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NameValueItemVO *head = [self.headList objectAtIndex:indexPath.section];
    if ([ObjectUtil isNotNull:head]) {
        NSMutableArray *temps = [self.detailMap objectForKey:head.itemId];
        if (temps!=nil ) {
            GoodsSingleAttributeCell *detailItem = (GoodsSingleAttributeCell *)[tableView dequeueReusableCellWithIdentifier:GoodsSingleAttributeCellIndentifier];
            
            if (!detailItem) {
                detailItem = [[NSBundle mainBundle] loadNibNamed:@"GoodsSingleAttributeCell" owner:self options:nil].lastObject;
            }
            if ([ObjectUtil isNotNull:temps]) {
                AttributeValVo* item = [temps objectAtIndex:indexPath.row];
                //                Action* action = (Action*)item.orign;
                //                detailItem.lblName.text = [action obtainItemName];
                //                detailItem.lblVal.text = [action obtainItemValue];
                detailItem.lblName.text = item.attributeVal;
                detailItem.lblCode.text = item.attributeCode;
                [detailItem.lblCode setTextColor:[ColorHelper getTipColor6]];
                detailItem.selectionStyle = UITableViewCellSelectionStyleNone;
                return detailItem;
            }
        }
    }
    abort();
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NameValueItemVO *head = [self.headList objectAtIndex:indexPath.section];
    if ([ObjectUtil isNotNull:head]) {
        NSMutableArray *temps = [self.detailMap objectForKey:head.itemId];
        GoodsStyleAttributeVo *editObj = [temps objectAtIndex:indexPath.row];
        [self showEditNVItemEvent:@"goodsSingleAttribute" withObj:editObj];
    }
}

-(void) showEditNVItemEvent:(NSString *)event withObj:(id<INameValueItem>)obj
{
    AttributeValVo* editObj = (AttributeValVo*) obj;
    GoodsSingleAttributeEditView* vc = [[GoodsSingleAttributeEditView alloc] init];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    [self.navigationController pushViewController:vc animated:NO];
    __weak GoodsSingleAttributeListView* weakSelf = self;
    [vc loaddatas:self.attributeVo attributeGroupVoList:self.attributeGroupList attributeValVo:editObj action:ACTION_CONSTANTS_EDIT callBack:^(AttributeVo *attributeVo, int fromViewTag) {
        [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        if (attributeVo) {
//            _isShowCate = NO;
            [weakSelf loaddatasFromEditView:attributeVo fromViewTag:fromViewTag];
        }
        [weakSelf.navigationController popToViewController:weakSelf animated:NO];
    }];
//    [parent showView:GOODS_SINGLE_ATTRIBUTE_EDIT_VIEW];
//    [parent.goodsSingleAttributeEditView loaddatas:self.attributeVo attributeGroupVoList:self.attributeGroupList attributeValVo:editObj action:ACTION_CONSTANTS_EDIT];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NameValueItemVO *head = [self.headList objectAtIndex:section];
    if ([ObjectUtil isNotNull:head]) {
        NSMutableArray *temps = [self.detailMap objectForKey:head.itemId];
        if ([ObjectUtil isNotNull:temps]) {
            return temps.count;
        } else {
            return 0;
        }
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NameValueItemVO *head = [self.headList objectAtIndex:section];
    HeaderItem *item = [HeaderItem headerItem];
    [item initWithName:[head obtainItemName]];
    return item;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return (self.headList!=nil?self.headList.count:0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(void)initGrid
{
    self.tableView.opaque=YES;
    UIView* view=[ViewFactory generateFooter:88];
    view.backgroundColor=[UIColor clearColor];
    
    [self.tableView setTableFooterView:view];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

@end
