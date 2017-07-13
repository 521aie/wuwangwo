//
//  GoodsAttributeListView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/8/5.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GoodsAttributeAddListView.h"
#import "NameValueItemVO.h"
#import "ObjectUtil.h"
#import "GridHead.h"
#import "GridFooter.h"
#import "GoodsAttributeCell.h"
#import "DicItem.h"
#import "GoodsAttributeSelectView.h"
#import "GoodsStyleEditView.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "AttributeVo.h"
#import "XHAnimalUtil.h"
#import "GoodsSkuVo.h"
#import "GoodsStyleGoodsListView.h"
#import "AttributeAddCell.h"
#import "HeaderItem.h"
@interface GoodsAttributeAddListView ()

@property (nonatomic, strong) GoodsService* goodsService;

@property (nonatomic, strong) NSMutableArray* attributeList;

@property (nonatomic, strong) AttributeVo* colourAttribute;

@property (nonatomic, strong) AttributeVo* sizeAttribute;

@property (nonatomic, strong) NSMutableDictionary* attributeValDic;

@property (nonatomic, strong) NSMutableArray* addColorVoList;

@property (nonatomic, strong) NSMutableArray* addSizeVoList;

@property (nonatomic, strong) NSString* lastVer;

@property (nonatomic, strong) NSString* styleId;

@property (nonatomic, strong) NSString* shopId;

@property (nonatomic, strong) NSString* synShopId;

@property (nonatomic) int fromViewTag;
/** <#注释#> */
@property (nonatomic, assign) int action;

@end

@implementation GoodsAttributeAddListView

- (id)initWithShopId:(NSString *)shopId styleId:(NSString *)styleId lastVer:(NSString *)lastVer synShopId:(NSString *)synShopId action:(int)action fromViewTag:(int)fromViewTag {
    self = [super init];
    if (self) {
        _shopId = shopId;
        _synShopId = synShopId;
        _styleId = styleId;
        _lastVer = lastVer;
        _fromViewTag = fromViewTag;
        self.action = action;
        _goodsService = [ServiceFactory shareInstance].goodsService;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self confgViews];
    [self initHead];
}

- (void)confgViews {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}


- (void)loadDatas:(attributeAddBack)callBack
{
    self.addBack = callBack;
    self.detailMap=[NSMutableDictionary dictionary];
    _attributeValDic = [[NSMutableDictionary alloc] init];
    [self initHeadData];
}

#pragma mark 从批量页面返回
- (void)loadDatasFromAttributeSelectView:(NSString *)type attributeValList:(NSMutableArray *)attributeValList
{
    //_attributeValDic = [[NSMutableDictionary alloc] init];
    AttributeValVo* tempVo = [attributeValList objectAtIndex:0];
    NSArray* allKeys = [_attributeValDic allKeys];
    if (allKeys != nil && allKeys.count > 0) {
        for (NSString* key in allKeys) {
            AttributeValVo* obj = (AttributeValVo*)[_attributeValDic objectForKey:key];
            if ([obj.attributeNameId isEqualToString:tempVo.attributeNameId]) {
                [_attributeValDic removeObjectForKey:key];
            }
        }
    }
    
    NSMutableArray *details = nil;
    for (NameValueItemVO* vo in self.headList) {
        if ([vo.itemName isEqualToString:type]) {
            details=[NSMutableArray array];
            for (AttributeValVo* item in attributeValList) {
                [_attributeValDic setValue:item forKey:item.attributeValId];
                [details addObject:item];
            }
            [self.detailMap setValue:details forKey:vo.itemId];
        }
        
    }
    
    [self.tableView reloadData];
}

- (void)initHeadData
{
    __weak GoodsAttributeAddListView* weakSelf = self;
    [_goodsService selectAttributeList:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        [weakSelf responseSuccess:json];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
    
}

- (void)responseSuccess:(id)json
{
    _attributeList = [AttributeVo converToArr:[json objectForKey:@"attributeList"]];
    
    self.headList=[NSMutableArray array];
    NameValueItemVO* item = nil;
    for (AttributeVo* vo in _attributeList) {
        if ([vo.name isEqualToString:@"颜色"]) {
            _colourAttribute = vo;
            item=[[NameValueItemVO alloc] initWithVal:vo.name val:vo.name andId:vo.attributeId];
            [self.headList addObject:item];
        }
    }
    
    for (AttributeVo* vo in _attributeList) {
        if ([vo.name isEqualToString:@"尺码"]) {
            _sizeAttribute = vo;
            item=[[NameValueItemVO alloc] initWithVal:vo.name val:vo.name andId:vo.attributeId];
            [self.headList addObject:item];
        }
    }
    
    [self.tableView reloadData];
}

- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event==LSNavigationBarButtonDirectLeft) {
        self.addBack(NO, @"0");
    }else{
        if (_attributeValDic.count == 0) {
            [AlertBox show:@"请先添加颜色属性!"];
            return;
        }else{
            _addColorVoList = [[NSMutableArray alloc] init];
            _addSizeVoList = [[NSMutableArray alloc] init];
            for (NameValueItemVO* vo in self.headList) {
                if ([vo.itemName isEqualToString:@"颜色"]) {
                    NSMutableArray* tempList = [self.detailMap objectForKey:vo.itemId];
                    if (tempList != nil && tempList.count > 0) {
                        for (AttributeValVo* valVo in tempList) {
                            GoodsSkuVo* skuVo = [[GoodsSkuVo alloc] init];
                            skuVo.attributeNameId = vo.itemId;
                            skuVo.attributeName = vo.itemName;
                            skuVo.attributeValId = valVo.attributeValId;
                            skuVo.attributeVal = valVo.attributeVal;
                            skuVo.skuVal = valVo.attributeCode;
                            skuVo.attributeType = valVo.attributeType;
                            skuVo.attributeCode=valVo.attributeCode;
                            [_addColorVoList addObject:skuVo];
                        }
                    }
                }
                
                if ([vo.itemName isEqualToString:@"尺码"]) {
                    NSMutableArray* tempList = [self.detailMap objectForKey:vo.itemId];
                    if (tempList != nil && tempList.count > 0) {
                        for (AttributeValVo* valVo in tempList) {
                            GoodsSkuVo* skuVo = [[GoodsSkuVo alloc] init];
                            skuVo.attributeNameId = vo.itemId;
                            skuVo.attributeName = vo.itemName;
                            skuVo.attributeValId = valVo.attributeValId;
                            skuVo.attributeVal = valVo.attributeVal;
                            skuVo.skuVal = valVo.attributeCode;
                            skuVo.attributeType = valVo.attributeType;
                            skuVo.attributeCode=valVo.attributeCode;
                            [_addSizeVoList addObject:skuVo];
                        }
                    }
                }
                
            }
            
            if (_addColorVoList == nil || _addColorVoList.count == 0) {
                [AlertBox show:@"请先添加颜色属性!"];
                return ;
            }
            
            if (_addSizeVoList == nil || _addSizeVoList.count == 0) {
                [AlertBox show:@"请先添加尺码属性!"];
                return ;
            }
            
            int total = (int)_addSizeVoList.count * (int)_addColorVoList.count;
            if (total > 50) {
                [AlertBox show:@"一次最多只能添加50个商品!"];
                return;
            }
            
            [self save];
        }
    }
}

- (void)save
{
    __weak GoodsAttributeAddListView* weakSelf = self;
    [_goodsService saveStyleGoods:_styleId lastVer:_lastVer addColorVoList:[GoodsSkuVo convertToDicListFromArr:_addColorVoList] addSizeVoList:[GoodsSkuVo convertToDicListFromArr:_addSizeVoList] completionHandler:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        NSString *message = json[@"message"];
        if ([NSString isNotBlank:message]) {
            message = [NSString stringWithFormat:@"以下商品由系统生成的店内码重复，无法添加！\n%@",message];
            [AlertBox show:message];
        }
        _lastVer = [json objectForKey:@"lastVer"];
        self.addBack(YES, _lastVer);
        //        [parent showView:GOODS_STYLE_GOODS_LIST_VIEW];
        //        [parent.goodsStyleGoodsListView loaddatas:_shopId styleId:_styleId lastVer: _lastVer synShopId:_synShopId styleGoodsList:nil fromViewTag:GOODS_STYLE_EDIT_VIEW];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

#pragma mark 添加属性
- (void)showAddEvent:(NSString*)event title:(NSString*)title code:(NSString*)code
{
    GoodsAttributeSelectView* vc = [[GoodsAttributeSelectView alloc] init];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    [self.navigationController pushViewController:vc animated:NO];
    
    int action = 0;
    AttributeVo* tempVo = nil;
    if ([code isEqualToString:@"颜色"]) {
        action = GOODS_ATTRIBUTE_COLOUR_LIST_VIEW;
        tempVo = _colourAttribute;
    }else {
        action = GOODS_ATTRIBUTE_SIZE_LIST_VIEW;
        tempVo = _sizeAttribute;
    }
    __weak GoodsAttributeAddListView* weakSelf = self;
    [vc loaddatas:action attributeVo:tempVo attributeValDic:_attributeValDic callBack:^(NSString *type, NSMutableArray *attributeValList) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        if (type) {
            [weakSelf loadDatasFromAttributeSelectView:type attributeValList:attributeValList];
        }
        [self.navigationController popToViewController:weakSelf animated:NO];
    }];
}

- (void)delObjEvent:(NSString *)event obj:(id)obj
{
    AttributeValVo* delObj = (AttributeValVo*) obj;
    NameValueItemVO *head = [self.headList objectAtIndex:event.integerValue];
    NSMutableArray *temps = [self.detailMap objectForKey:head.itemId];
    [temps removeObject:delObj];
    [_attributeValDic removeObjectForKey:delObj.attributeValId];
    
    [self.tableView reloadData];
}

-(void) showAddEvent:(NSString *)event obj:(id)obj
{
    
}

-(void) showHelpEvent
{
    
}

#pragma navigateTitle.
-(void) initHead
{
    [self configTitle:@"商品属性" leftPath:Head_ICON_CANCEL rightPath:Head_ICON_OK];
}

#pragma table部分.
#pragma mark UITableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NameValueItemVO *head = [self.headList objectAtIndex:indexPath.section];
    if ([ObjectUtil isNotNull:head]) {
        NSMutableArray *temps = [self.detailMap objectForKey:head.itemId];
        if (temps==nil || indexPath.row==temps.count) {
            AttributeAddCell *footerItem = (AttributeAddCell *)[tableView dequeueReusableCellWithIdentifier:AttributeAddCellIndentifier];
            
            if (!footerItem) {
                footerItem = [[NSBundle mainBundle] loadNibNamed:@"AttributeAddCell" owner:self options:nil].lastObject;
            }
            footerItem.selectionStyle = UITableViewCellSelectionStyleNone;
            footerItem.lblName.text=[NSString stringWithFormat:@"添加%@...",head.itemName];
            footerItem.tag =head.itemId.intValue;
            return footerItem;
        } else {
            GoodsAttributeCell *detailItem = (GoodsAttributeCell *)[tableView dequeueReusableCellWithIdentifier:GoodsAttributeCellIndentifier];
            
            if (!detailItem) {
                detailItem = [[NSBundle mainBundle] loadNibNamed:@"GoodsAttributeCell" owner:self options:nil].lastObject;
            }
            detailItem.delegate = self;
            if ([ObjectUtil isNotNull:temps]) {
                AttributeValVo* item=[temps objectAtIndex: indexPath.row];
                detailItem.attributeValVo = item;
                detailItem.event = [NSString stringWithFormat:@"%ld", indexPath.section];
                detailItem.lblName.text = item.attributeVal;
                NSString *code = [NSString stringWithFormat:@"编号:%@",item.attributeCode];
                detailItem.lblCode.text = code;
                detailItem.selectionStyle = UITableViewCellSelectionStyleNone;
                return detailItem;
            }
        }
    }
    abort();
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NameValueItemVO *head = [self.headList objectAtIndex:section];
    if ([ObjectUtil isNotNull:head]) {
        NSMutableArray *temps = [self.detailMap objectForKey:head.itemId];
        if ([ObjectUtil isNotNull:temps]) {
            return temps.count+1;
        } else {
            return 1;
        }
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NameValueItemVO *head = [self.headList objectAtIndex:section];
    HeaderItem *view = [HeaderItem headerItem];
    [view initWithName:[head obtainItemName]];
    return view;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NameValueItemVO *head = [self.headList objectAtIndex:indexPath.section];
    self.dicCode=head.itemVal;
    self.currTitleName=head.itemName;
    if ([ObjectUtil isNotNull:head]) {
        NSMutableArray *temps = [self.detailMap objectForKey:head.itemId];
        if ([ObjectUtil isNull:temps] || indexPath.row==temps.count) {
            [self showAddEvent:head.itemVal title:head.itemName code:head.itemVal];
        }
    }
}


@end
