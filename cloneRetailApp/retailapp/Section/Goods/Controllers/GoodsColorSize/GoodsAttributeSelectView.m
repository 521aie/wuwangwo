//
//  GoodsAttributeSelectView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/8/6.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GoodsAttributeSelectView.h"
#import "GoodsAttributeAddListView.h"
#import "NameValueItemVO.h"
#import "ObjectUtil.h"
#import "MultiCheckCell.h"
#import "MultiHeadCell.h"
#import "DicItem.h"
#import "TreeNode.h"
#import "Action.h"
#import "GoodsStyleAttributeVo.h"
#import "GoodsSingleAttributeListView.h"
#import "ViewFactory.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "AttributeGroupVo.h"
#import "AttributeValVo.h"
#import "JsonHelper.h"
#import "GoodsAttributeAddListView.h"
#import "GoodsRender.h"
#import "OptionPickerBox.h"
#import "XHAnimalUtil.h"
#import "ColorHelper.h"

@interface GoodsAttributeSelectView ()

@property (nonatomic,strong) GoodsService* goodsService;

@property (nonatomic,strong) NSString* attributeId;

@property (nonatomic,strong) NSString* attributeType;

@property (nonatomic,strong) NSMutableArray* attributeGroupList;

@property (nonatomic,strong) NSMutableDictionary* attributeValDic;

@property (nonatomic,strong) AttributeVo* attributeVo;

@property (nonatomic) int fromViewTag;
/** <#注释#> */
@property (nonatomic, strong) GridColHead *infoView;

@property (nonatomic,strong) NSMutableArray* operateValList;

@end

@implementation GoodsAttributeSelectView


- (void)viewDidLoad {
    [super viewDidLoad];
    _goodsService = [ServiceFactory shareInstance].goodsService;
    [self configViews];
    [self initHead];
    [self initGrid];
    __weak GoodsAttributeSelectView* weakSelf = self;
    [weakSelf.tableView ls_addHeaderWithCallback:^{
        [self selectAttributeGroupList];
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
    [self.view addSubview:self.footView];
}

- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootSelectAll]) {
        [self checkAllEvent];
    } else if ([footerType isEqualToString:kFootSelectNo]) {
        [self notCheckAllEvent];
    } else if ([footerType isEqualToString:kFootColor] || [footerType isEqualToString:kFootSize]) {
        [self showAttributeView];
    }
    
}


-(void) loaddatas
{
    if (_fromViewTag == GOODS_ATTRIBUTE_COLOUR_LIST_VIEW || _fromViewTag == GOODS_ATTRIBUTE_SIZE_LIST_VIEW) {
        [self configTitle:@"确认"];
    }else if (_fromViewTag == GOODS_SINGLE_ATTRIBUTE_LIST_VIEW){
        [self configTitle:@"操作"];
    }
    [self selectAttributeGroupList];
}

-(void) loaddatas:(int)viewTag attributeVo:(AttributeVo *)attributeVo attributeValDic:(NSMutableDictionary *)attributeValDic callBack:(styleGoodsAttributeSelectBack)callBack
{
    self.styleGoodsAttributeSelectBack = callBack;
    [self.tableView setContentOffset:CGPointMake(0, 0)animated:NO];
    _attributeVo = attributeVo;
    _attributeId = _attributeVo.attributeId;
    _attributeType = _attributeVo.attributeType;
    _fromViewTag = viewTag;
    self.selectIdSet = [[NSMutableArray alloc]init];
    _attributeValDic = attributeValDic;
    
}

-(void) loaddatasFromLibView
{
    [self.tableView headerBeginRefreshing];
}

-(void)selectAttributeGroupList
{
    __weak GoodsAttributeSelectView* weakSelf = self;
    [_goodsService selectAttributeTypeList:_attributeId attributeType:_attributeType completionHandler:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        [self responseSuccess:json];
        [self.tableView headerEndRefreshing];
    } errorHandler:^(id json) {
        [AlertBox show:json];
        [self.tableView headerEndRefreshing];
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
    
    self.detailMap=[NSMutableDictionary dictionary];
    NSMutableArray* details = nil;
    for (NameValueItemVO* vo in self.headList) {
        details=[NSMutableArray array];
        for (AttributeGroupVo* items in self.datas) {
            int count = 0;
            for (AttributeValVo* item in items.attributeValVoList) {
                if ([vo.itemId isEqualToString:item.attributeValGroup]) {
                    if ([ObjectUtil isNotNull:[_attributeValDic objectForKey:item.attributeValId]]) {
                        //已选择的属性值打勾
                        [self.selectIdSet addObject:item.attributeValId];
                        item.isCheck = @"1";
                        count ++;
                    }
                    [details addObject:item];
                }
            }
            //判断该属性分类是否全选
            if (items.attributeValVoList != nil && count > 0 && count == items.attributeValVoList.count) {
                [self.selectIdSet addObject:items.attributeGroupId];
            }
        }
        [self.detailMap setValue:details forKey:vo.itemId];
    }
    NSString *headerLeft = @"";
    NSString *headerRight = @"";
    NSString *title = @"";
    if (_fromViewTag == GOODS_ATTRIBUTE_COLOUR_LIST_VIEW) {
        title = @"选择颜色";
        headerLeft = @"色称";
        headerRight = @"色号";
        [self.footView initDelegate:self btnsArray:@[kFootSelectAll, kFootSelectNo, kFootColor]];
    } else if (_fromViewTag == GOODS_ATTRIBUTE_SIZE_LIST_VIEW) {
        title = @"选择尺码";
        headerLeft = @"尺码";
        headerRight = @"尺码编号";
         [self.footView initDelegate:self btnsArray:@[kFootSelectAll, kFootSelectNo, kFootSize]];
    } else if (_fromViewTag == GOODS_SINGLE_ATTRIBUTE_LIST_VIEW) {
        if ([self.attributeVo.name isEqualToString:@"颜色"]) {
            title = @"选择颜色";
            headerLeft = @"色称";
            headerRight = @"色号";
             [self.footView initDelegate:self btnsArray:@[kFootSelectAll, kFootSelectNo]];
        } else if ([self.attributeVo.name isEqualToString:@"尺码"]) {
            title = @"选择尺码";
            headerLeft = @"尺码";
            headerRight = @"尺码编号";
            [self.footView initDelegate:self btnsArray:@[kFootSelectAll, kFootSelectNo]];
        }
        [self configTitle:title];
        [self.infoView initColHead:headerLeft col2:headerRight];
    }
    
    if (_fromViewTag == GOODS_ATTRIBUTE_COLOUR_LIST_VIEW || _fromViewTag == GOODS_ATTRIBUTE_SIZE_LIST_VIEW) {
        NSMutableArray* dataList = [[NSMutableArray alloc] init];
        for (NameValueItemVO* item in self.headList) {
            NSMutableArray* noCategoryList = [self.detailMap objectForKey:item.itemId];
            if (noCategoryList.count == 0) {
                [self.detailMap removeObjectForKey:item.itemId];
                [dataList addObject:item];
            }
        }
        
        [self.headList removeObjectsInArray:dataList];
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

#pragma mark check-button
-(void) checkAllEvent
{
    //该属性全选
    [self.selectIdSet removeAllObjects];
    for (NameValueItemVO* node in self.headList) {
        NSMutableArray *temps = [self.detailMap objectForKey:node.itemId];
        [self.selectIdSet addObject:node.itemId];
        if (temps != nil && temps.count > 0) {
            for (AttributeValVo* sn in temps) {
                sn.isCheck = @"1";
                [self.selectIdSet addObject:sn.attributeValId];
            }
        }
    }
    [self.tableView reloadData];
}

-(void) notCheckAllEvent
{
    //该属性全不选
    [self.selectIdSet removeAllObjects];
    for (NameValueItemVO* node in self.headList) {
        NSMutableArray *temps = [self.detailMap objectForKey:node.itemId];
        if (temps != nil && temps.count > 0) {
            for (AttributeValVo* sn in temps) {
                sn.isCheck = @"0";
            }
        }
    }
    [self.tableView reloadData];
}

- (void)checkHead:(BOOL)result head:(NameValueItemVO *)head
{
    //该属性分类全选or全不选
    NSMutableArray *temps = [self.detailMap objectForKey:head.itemId];
    if ([ObjectUtil isNotEmpty:temps]) {
        if ([self.selectIdSet containsObject:head.itemId]) {
            [self.selectIdSet removeObject:head.itemId];
            for (AttributeValVo* sn in temps) {
                sn.isCheck = @"0";
                [self.selectIdSet removeObject:sn.attributeValId];
            }
        }else{
            [self.selectIdSet addObject:head.itemId];
            for (AttributeValVo* sn in temps) {
                sn.isCheck = @"1";
                [self.selectIdSet addObject:sn.attributeValId];
            }
        }
    }
    [self.tableView reloadData];
}

-(void) showAttributeView
{
    GoodsSingleAttributeListView* vc = [[GoodsSingleAttributeListView alloc] init];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
    [self.navigationController pushViewController:vc animated:NO];
    __weak GoodsAttributeSelectView* weakSelf = self;
    [vc loaddatas:_attributeVo fromViewTag:GOODS_ATTRIBUTE_SELECT_VIEW callBack:^(BOOL flg) {
        [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
        [weakSelf loaddatasFromLibView];
        [weakSelf.navigationController popToViewController:weakSelf animated:NO];
    }];
}


#pragma navigateTitle.
-(void) initHead
{
    [self configTitle:@"" leftPath:Head_ICON_CANCEL rightPath:Head_ICON_OK];
    [self configNavigationBar:LSNavigationBarButtonDirectRight title:@"确认" filePath:Head_ICON_OK];
}

#pragma mark 导航栏
-(void) onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event==LSNavigationBarButtonDirectLeft) {
        self.styleGoodsAttributeSelectBack(nil, nil);        
    }else{
        
        NSMutableArray* addList = [[NSMutableArray alloc] init];
        for (NameValueItemVO* node in self.headList) {
            NSMutableArray *temps = [self.detailMap objectForKey:node.itemId];
            if (temps != nil && temps.count > 0) {
                for (AttributeValVo* sn in temps) {
                    if ([sn.isCheck isEqualToString:@"1"]) {
                        [addList addObject:sn];
                    }
                }
            }
        }
        
        if (addList.count == 0) {
            [AlertBox show:@"请选择属性值!"];
            return ;
        }
        
        if (_fromViewTag == GOODS_ATTRIBUTE_COLOUR_LIST_VIEW || _fromViewTag == GOODS_ATTRIBUTE_SIZE_LIST_VIEW) {
//            [parent showView:GOODS_ATTRIBUTE_ADD_LIST_VIEW];
            
            if (self.fromViewTag == GOODS_ATTRIBUTE_COLOUR_LIST_VIEW) {
                self.styleGoodsAttributeSelectBack(@"颜色", addList);
//                [parent.goodsAttributeAddListView loadDatasFromAttributeSelectView:@"颜色" attributeValList:addList];
            }else if (self.fromViewTag == GOODS_ATTRIBUTE_SIZE_LIST_VIEW){
                self.styleGoodsAttributeSelectBack(@"尺码", addList);
//                [parent.goodsAttributeAddListView loadDatasFromAttributeSelectView:@"尺码" attributeValList:addList];
            }
        }else if (_fromViewTag == GOODS_SINGLE_ATTRIBUTE_LIST_VIEW){
            _operateValList = addList;
            UIActionSheet *menu = [[UIActionSheet alloc]
                                   initWithTitle: @"请选择批量操作"
                                   delegate:self
                                   cancelButtonTitle:@"取消"
                                   destructiveButtonTitle:nil
                                   otherButtonTitles: @"删除", nil];
            [menu showInView:self.view];
        }
        
    }
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    if (buttonIndex == 0) {
//        [OptionPickerBox initData:[GoodsRender listAttributeGroup:_attributeGroupList]itemId:@""];
//        [OptionPickerBox show:@"属性分类" client:self event:1000];
//    }else
    if (buttonIndex == 0){
        static UIAlertView *alertView;
        if (alertView != nil) {
            [alertView dismissWithClickedButtonIndex:0 animated:NO];
            alertView = nil;
        }
        alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确认删除选中的属性值吗?" delegate:self cancelButtonTitle:@"取消"  otherButtonTitles:@"确认", nil];
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSMutableArray* valList = [[NSMutableArray alloc] init];
        for (AttributeValVo* vo in _operateValList) {
            [valList addObject:[AttributeValVo getDictionaryData:vo]];
        }
        __weak GoodsAttributeSelectView* weakSelf = self;
        [_goodsService delAttributeVal:valList completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            [AlertBox show:@"删除成功!"];
            [weakSelf selectAttributeGroupList];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }
}

- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType
{
    id<INameItem> item = (id<INameItem>)selectObj;
    
    for (AttributeValVo* vo in _operateValList) {
        vo.attributeValGroup = [item obtainItemId];
    }
    
    __weak GoodsAttributeSelectView* weakSelf = self;
    [_goodsService changeAttributeCategory:[AttributeValVo convertToDicListFromArr:_operateValList] completionHandler:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        [self.selectIdSet removeAllObjects];
        [weakSelf selectAttributeGroupList];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
    
    return YES;
}

-(void) initHeadData:(NSMutableArray *) headList
{
    self.headList=[NSMutableArray array];
    for (AttributeGroupVo* vo in headList) {
        NameValueItemVO* item=[[NameValueItemVO alloc] initWithVal:vo.attributeGroupName val:vo.attributeGroupName andId:vo.attributeGroupId];
       [self.headList addObject:item];
    }
}

#pragma table部分.
#pragma mark UITableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NameValueItemVO *head = [self.headList objectAtIndex:indexPath.section];
    if ([ObjectUtil isNotNull:head]) {
        NSMutableArray *temps = [self.detailMap objectForKey:head.itemId];
        if (temps!=nil ) {
            MultiCheckCell *detailItem = (MultiCheckCell *)[tableView dequeueReusableCellWithIdentifier:MultiCheckCellIdentifier];
            
            if (!detailItem) {
                detailItem = [[NSBundle mainBundle] loadNibNamed:@"MultiCheckCell" owner:self options:nil].lastObject;
            }
            if ([ObjectUtil isNotNull:temps]) {
                AttributeValVo* item = [temps objectAtIndex:indexPath.row];
                detailItem.lblName.text = item.attributeVal;
                detailItem.lblVal.text = item.attributeCode;
                [detailItem.lblVal setTextColor:[ColorHelper getTipColor6]];
                detailItem.imgCheck.hidden=![self.selectIdSet containsObject:item.attributeValId];
                detailItem.imgUnCheck.hidden=[self.selectIdSet containsObject:item.attributeValId];
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
        AttributeValVo *editObj = [temps objectAtIndex:indexPath.row];
        if ([editObj.isCheck isEqualToString:@"1"]) {
            editObj.isCheck = @"0";
            [self.selectIdSet removeObject:editObj.attributeValId];
            [self.selectIdSet removeObject:head.itemId];
        }else{
            editObj.isCheck = @"1";
            int count = 0;
            for (AttributeValVo* valVo in temps) {
                if ([valVo.isCheck isEqualToString:@"1"]) {
                    count ++;
                }
            }
            if (temps.count == count) {
                [self.selectIdSet addObject:head.itemId];
            }
            [self.selectIdSet addObject:editObj.attributeValId];
        }
    }
    
    [self.tableView reloadData];
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
    MultiHeadCell *headItem = (MultiHeadCell *)[tableView dequeueReusableCellWithIdentifier:MultiHeadCellIndentifier];
    
    if (!headItem) {
        headItem = [[NSBundle mainBundle] loadNibNamed:@"MultiHeadCell" owner:self options:nil].lastObject;
    }
    headItem.selectionStyle = UITableViewCellSelectionStyleNone;
    [headItem loadData:head delegate:self];
    if (_fromViewTag == GOODS_SINGLE_ATTRIBUTE_LIST_VIEW) {
        headItem.btnCheck.enabled = NO;
        headItem.imgUnCheck.hidden = YES;
        headItem.imgCheck.hidden = YES;
        headItem.lblcheck.hidden = YES;
    } else {
        if ([self.selectIdSet containsObject:head.itemId]) {
            [headItem checked:YES];
        }else{
            [headItem checked:NO];
        }
    }
    
    return headItem;
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
    return 44;
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
