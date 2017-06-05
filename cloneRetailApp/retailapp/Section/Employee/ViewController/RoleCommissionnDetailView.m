//
//  RoleCommissionnDetailView.m
//  retailapp
//
//  Created by qingmei on 15/10/16.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "RoleCommissionnDetailView.h"
#import "IEditItemListEvent.h"
#import "OptionPickerClient.h"
#import "IEditItemRadioEvent.h"
//#import "RoleCommissionView.h"
#import "EmployeeService.h"
#import "GoodsAndStyleView.h"
#import "SymbolNumberInputBox.h"
#import "NavigateTitle2.h"
#import "ServiceFactory.h"
#import "LSEditItemText.h"
#import "LSEditItemList.h"
#import "LSEditItemRadio.h"
#import "UIHelper.h"
#import "GoodsChoiceView.h"
#import "StyleChoiceView.h"
#import "XHAnimalUtil.h"
#import "ListStyleVo.h"
#import "GoodsVo.h"
#import "UIView+Sizes.h"
#import "LSEditItemTitle.h"
#import "EmployeeRender.h"
#import "NameItemVO.h"
#import "AlertBox.h"
#import "OptionPickerBox.h"
#import "GoodsAndStyleCell.h"
#import "AddItem.h"

@interface RoleCommissionnDetailView ()<IEditItemListEvent,OptionPickerClient,IEditItemRadioEvent,SymbolNumberInputClient,AddItemDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) LSEditItemText    *itemTxtRoleName;           //角色名称
@property (strong, nonatomic) LSEditItemRadio   *itemRadioIsCommission;     //是否提成
@property (strong, nonatomic) LSEditItemList    *itemListCommissionType;    //提成类型选择
@property (strong, nonatomic) LSEditItemList    *itemTxtInPut;              //提成比例
@property (strong, nonatomic) LSEditItemTitle       *itemTitleGoods;            //是否提成
@property (strong, nonatomic) UITableView     *mainGrid;                  //tableview
@property (strong, nonatomic) UIView          *container;                 //Item 容器
@property (nonatomic, strong) UIView *placeHolderView;/**<占位view>*/
//@property (nonatomic, strong) RoleCommissionView *parent;                            //父view
@property (nonatomic, strong) EmployeeService *service;                           //网络服务
@property (nonatomic, strong) RoleCommissionVo *roleCommissionVo;                  //角色提成信息
@property (nonatomic, strong) RoleCommissionVo *roleCommissionVoUpdate;
@property (nonatomic, strong) NSMutableArray *roleCommissionDetailVoList;        //角色提成详情列表
@property (nonatomic, strong) NSMutableArray *roleCommissionDetailVoListOld;  //角色提成详情修改过的的列表，用于提交更新
//改写RoleCommissionVo数据公用3个地方.1.点击radio 2.点击list选中后
@property (nonatomic, strong)NSString *shopMode; //服鞋 101 商超 102

@property (nonatomic, copy) void(^callBackBlock)();/**<回调block>*/
@end

@implementation RoleCommissionnDetailView
- (instancetype)init {
    self = [super init];
    if (self) {
       _service = [ServiceFactory shareInstance].employeeService;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [self configSubviews];
}

- (void)configSubviews {
    
    //设置导航栏
    [self configTitle:@"" leftPath:Head_ICON_BACK rightPath:nil];
    
    _container = [[UIView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, 300)];
    [self.view addSubview:_container];
    
    //角色名称
    _itemTxtRoleName = [LSEditItemText editItemText];
    [_itemTxtRoleName initLabel:@"角色名称" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    [_itemTxtRoleName editEnabled:NO];
    [_container addSubview:_itemTxtRoleName];
    
    //销售提成
    _itemRadioIsCommission = [LSEditItemRadio editItemRadio];
    [_itemRadioIsCommission initLabel:@"销售提成" withHit:nil delegate:self];
    [_container addSubview:_itemRadioIsCommission];
    
    //提成方式
    _itemListCommissionType = [LSEditItemList editItemList];
    [_itemListCommissionType initLabel:@"▪︎ 提成方式" withHit:nil delegate:self];
    [_container addSubview:_itemListCommissionType];
    
    // 提成比例
    _itemTxtInPut = [LSEditItemList editItemList];
    [_container addSubview:_itemTxtInPut];
    
    // 占位view，高度20，使“提成方式”栏和“提成商品”中间间隔20
    _placeHolderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 20)];
    [_container addSubview:_placeHolderView];
    
    //提成商品
    _itemTitleGoods = [LSEditItemTitle editItemTitle];
    [_itemTitleGoods configTitle:@"提成商品"];
    [_container addSubview:_itemTitleGoods];
    
    AddItem *addItem = [AddItem loadFromNib];
    addItem.ls_height = 88.0;
    [addItem initDelegate:self titleName:@"添加提成商品"];
    
    _mainGrid = [[UITableView alloc] initWithFrame:CGRectMake(0, _container.ls_bottom+20, SCREEN_W, SCREEN_H-_container.ls_bottom) style:UITableViewStylePlain];
    _mainGrid.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainGrid.backgroundColor = [UIColor clearColor];
    _mainGrid.tableFooterView = addItem;
    _mainGrid.delegate = self;
    _mainGrid.dataSource = self;
    _mainGrid.rowHeight = 88.0f;
    [self.view addSubview:_mainGrid];
    //SHOP_MODE实际类型为NSNumber
    NSString *obj = [[Platform Instance] getkey:SHOP_MODE];
    _shopMode = [NSString stringWithFormat:@"%@",obj];
    [self reloadItemsWithVo:_roleCommissionVo isInit:YES];
    [self configHelpButton:HELP_EMPLOYE_ROLE_SETTING];
    
}



#pragma mark - 添加提成商品商品
- (void)addDeductGoods {
    NSString *shopId = _roleCommissionVo.shopId;//选中角色所在的shop
    if ([_shopMode isEqualToString:@"101"]) {//服鞋
        
        StyleChoiceView *vc = [[StyleChoiceView alloc]init];
        [self pushController:vc from:kCATransitionFromRight];
        [vc loaddatas:shopId type:@"1" callBack:^(NSMutableArray *styleList) {
            if (styleList == nil) {
                [self.navigationController popToViewController:self animated:YES];
            } else {
                
                NSMutableArray *goodsOrStyleList = [NSMutableArray array];
                for (ListStyleVo *styles in styleList) {
                    RoleCommissionDetailVo *style = [[RoleCommissionDetailVo alloc]init];
                    style.entityId = _roleCommissionVo.entityId;
                    style.shopId = _roleCommissionVo.shopId;
                    style.goodsId = styles.styleId;
                    style.goodsType = 2;
                    style.goodsName = styles.styleName;
                    style.goodsBar = styles.styleCode;
                    style.operateType = @"add";
                    
                    [goodsOrStyleList addObject:style];
                }
                
                __weak RoleCommissionnDetailView* weakSelf = self;
                [weakSelf setCommissionRatio:goodsOrStyleList isAdd:YES];
            }
        }];
        
    } else if([self.shopMode isEqualToString:@"102"]) { //商超
        GoodsChoiceView *vc = [[GoodsChoiceView alloc] init];
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        [vc loaddatas:shopId callBack:^(NSMutableArray *goodsList) {
            
            if (nil == goodsList) {
                [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
                [self.navigationController popViewControllerAnimated:NO];
            } else {
                NSMutableArray *goodsOrStyleList = [NSMutableArray array];
                for (GoodsVo *goods in goodsList) {
                    RoleCommissionDetailVo *good = [[RoleCommissionDetailVo alloc]init];
                    good.entityId = _roleCommissionVo.entityId;
                    good.shopId = _roleCommissionVo.shopId;
                    good.goodsId = goods.goodsId;
                    good.goodsType = 1;
                    good.goodsName = goods.goodsName;
                    good.goodsBar = goods.barCode;
                    good.operateType = @"add";
                    [goodsOrStyleList addObject:good];
                }
                __weak RoleCommissionnDetailView* weakSelf = self;
               [weakSelf setCommissionRatio:goodsOrStyleList isAdd:YES];
            }
        }];
    }
}

- (void)setCommissionRatio:(NSMutableArray *)goodsOrStyleList isAdd:(BOOL)isAdd{
    
    GoodsAndStyleView *vc = [[GoodsAndStyleView alloc]initWithParent:self];
    if ([_shopMode isEqualToString:@"101"]) {
        [vc setisGood:NO];
    }else if ([_shopMode isEqualToString:@"102"]){
        [vc setisGood:YES];
    }
    vc.roleCommissionId = self.roleCommissionId;
    [vc loadWithGoodsOrStyleList:goodsOrStyleList CommissionVo:_roleCommissionVoUpdate isAdd:isAdd];
    __weak typeof(self) wself = self;
    __block NSMutableArray *roleCommissionDetailVoList = [NSMutableArray arrayWithArray:_roleCommissionDetailVoList];
    [vc onRightSavebBlock:^(NSArray *list, BOOL isDel) {
        if (isDel) {//删除操作
            [roleCommissionDetailVoList enumerateObjectsUsingBlock:^(RoleCommissionDetailVo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [list enumerateObjectsUsingBlock:^(RoleCommissionDetailVo *detailVo, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([detailVo.goodsId isEqualToString:obj.goodsId]) {
                        [_roleCommissionDetailVoList removeObject:detailVo];
                    }
                }];
            }];
            
        } else {//添加操作
            [list enumerateObjectsUsingBlock:^(RoleCommissionDetailVo *detailVo, NSUInteger idx, BOOL * _Nonnull stop) {
                [roleCommissionDetailVoList enumerateObjectsUsingBlock:^(RoleCommissionDetailVo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.goodsId isEqualToString:detailVo.goodsId]) {//编辑
                        [_roleCommissionDetailVoList replaceObjectAtIndex:idx withObject:detailVo];
                    }
                }];
                if (![_roleCommissionDetailVoList containsObject:detailVo]) {
                    [_roleCommissionDetailVoList addObject:detailVo];//添加
                }
            }];
        }
        [wself isUIChange];
        [wself.mainGrid reloadData];
    }];
    [self.navigationController pushViewController:vc animated:NO];
     [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}



#pragma mark - 功能函数
//UI是否变化
- (BOOL)isUIChange {
    
    NSInteger changeCount = 0;

    if (_itemListCommissionType.isChange && !_itemListCommissionType.hidden) {
        changeCount += 1;
    }
    
    if (_itemRadioIsCommission.isChange && !_itemRadioIsCommission.hidden) {
        changeCount += 1;
    }
    
    if (self.itemTxtInPut.isChange && !_itemTxtInPut.hidden) {
        changeCount += 1;
    }
    
    if (_roleCommissionDetailVoList.count != _roleCommissionDetailVoListOld.count) {
        changeCount += 1;
    } else {
        for (NSInteger i=0;i<_roleCommissionDetailVoList.count;i++) {
            RoleCommissionDetailVo *new = _roleCommissionDetailVoList[i];
            RoleCommissionDetailVo *old = _roleCommissionDetailVoListOld[i];
            if(old.commissionRatio != new.commissionRatio) {
                changeCount +=1;
            }
        }
    }
    
    if (changeCount > 0) {
        [self configTitle:_roleCommissionVo.roleName leftPath:Head_ICON_CANCEL rightPath:Head_ICON_OK];
        return YES;
    } else {
        [self configTitle:_roleCommissionVo.roleName leftPath:Head_ICON_BACK rightPath:nil];
        return NO;
    }
}

//布局view
- (void)layoutView {
   
    [UIHelper refreshUI:self.container];
    self.mainGrid.ls_top = self.container.ls_bottom;
    self.mainGrid.ls_height = self.view.ls_bottom - self.container.ls_bottom;
}

/**数据打包*/
- (void)packageData {
    if (!_roleCommissionVoUpdate.isCommission) {
        _roleCommissionVoUpdate.commissionType = 0;
        _roleCommissionVoUpdate.commissionRatio = 0;
        _roleCommissionVoUpdate.commissionPrice = 0;
        _roleCommissionDetailVoListOld = nil;
    } else {
        if (_roleCommissionVoUpdate.commissionType == 2) {
            _roleCommissionVoUpdate.commissionPrice = self.itemTxtInPut.getStrVal.doubleValue;
        } else if (_roleCommissionVoUpdate.commissionType == 3) {
            _roleCommissionVoUpdate.commissionRatio = self.itemTxtInPut.getStrVal.doubleValue;
        }
    }
    _roleCommissionVoUpdate.operateType = @"edit";
}

/**清除控件数据*/
- (void)clearItems {
    [_itemTxtRoleName initData:nil];
    [_itemRadioIsCommission initData:@""];
    [_itemListCommissionType initData:@"请选择" withVal:nil];
    [_itemTxtInPut initData:nil withVal:nil];
}

/**根据RoleCommissionVo加载页面*/
- (void)reloadItemsWithVo:(RoleCommissionVo *)commissionVo isInit:(BOOL)isInit {
    
    self.itemTxtRoleName.txtVal.text = commissionVo.roleName;
    //销售提成
    if (isInit) {
        [self.itemRadioIsCommission initData:commissionVo.isCommission?@"1":@""];
    } else {
        [self.itemRadioIsCommission changeData:commissionVo.isCommission?@"1":@""];
    }
    
    if (commissionVo.isCommission) {
        //销售提成开关打开
        [_itemListCommissionType visibal:YES];
        //提成方式
        NSMutableArray *arr = [EmployeeRender getCommissionTypeListWithshopMode:self.shopMode];
        if (0 == commissionVo.commissionType) {
            [self.itemListCommissionType initData:@"请选择" withVal:nil];
            [self layoutView];
            _mainGrid.hidden = YES;
        }
        for (NameItemVO *temp in arr) {
            if (temp.itemId.integerValue == commissionVo.commissionType) {
                if (isInit) {
                    [self.itemListCommissionType initData:temp.itemName withVal:temp.itemId];
                } else {
                    [self.itemListCommissionType changeData:temp.itemName withVal:temp.itemId];
                }
                
                if (1 == commissionVo.commissionType) {//1、按商品提成比例
                    [_itemTxtInPut visibal:NO];
                    _placeHolderView.hidden = YES;
                    [_itemTitleGoods visibal:NO];
                    [self layoutView];
                    _mainGrid.hidden = YES;
                } else if ( 2 == commissionVo.commissionType) {//2、按单提成
                    [_itemTxtInPut initLabel:@"▪︎ 提成金额(元)"  withHit:nil isrequest:YES delegate:self];
                    [_itemTxtInPut visibal:YES];
                    [_itemTitleGoods visibal:NO];
                    [self layoutView];
                    _mainGrid.hidden = YES;
                   
                    NSString *price = [NSString stringWithFormat:@"%.2f",commissionVo.commissionPrice];
                    if ([ObjectUtil isNotNull:price]) {
                            if (isInit) {
                                [_itemTxtInPut initData:price withVal:price];
                            }else{
                                [_itemTxtInPut changeData:price withVal:price];
                            }
                            
                    }
                } else if (3 == commissionVo.commissionType) { // 3、按销售额提成
                    [_itemTxtInPut initLabel:@"▪︎ 提成比例(%)"  withHit:nil isrequest:YES delegate:self];
                    _placeHolderView.hidden = YES;
                    [_itemTxtInPut visibal:YES];
                    [_itemTitleGoods visibal:NO];
                    [self layoutView];
                    _mainGrid.hidden = YES;
                    
                    NSString *ratio = [NSString stringWithFormat:@"%.2f",commissionVo.commissionRatio];
                    if ([ObjectUtil isNotNull:ratio]) {
                        if (isInit) {
                            [_itemTxtInPut initData:ratio withVal:ratio];
                        }else{
                            [_itemTxtInPut changeData:ratio withVal:ratio];
                        }
                    }
                } else if (4 == commissionVo.commissionType) {//4、按商品设置提成
                    
                    [_itemTxtInPut visibal:NO];
                    _placeHolderView.hidden = NO;
                    [_itemTitleGoods visibal:YES];
                    [self layoutView];
                    _mainGrid.hidden = NO;
                    if ([self.shopMode isEqualToString:@"101"]) {
                        //self.itemTitleGoods.lblName.text = @"提成款式";
                        self.itemTitleGoods.lblName.text = @"提成商品";
                    } else if ([self.shopMode isEqualToString:@"102"]) {
                         self.itemTitleGoods.lblName.text = @"提成商品";
                    }
                }
            }
        }//for
    } else {
        //销售提成开关关闭
        _placeHolderView.hidden = YES;
        [self.itemListCommissionType visibal:NO];
        [_itemTxtInPut visibal:NO];
        [_itemTitleGoods visibal:NO];
        [self layoutView];
        _mainGrid.hidden = YES;
    }
}


#pragma mark - network
- (void)loadData{
    __weak RoleCommissionnDetailView* weakSelf = self;
    if ([ObjectUtil isNotNull:self.roleCommissionId]) {
        [_service roleCommissionByRoleCommissionId:self.roleCommissionId completionHandler:^(id json) {
            if (!weakSelf) return ;
            [weakSelf responseSuccess:json];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }
}

- (void)loadDataWithRoleCommissionId:(NSString *)roleCommissionId block:(void (^)())callBack {
    if ([ObjectUtil isNotNull:roleCommissionId]) {
        self.roleCommissionId = roleCommissionId;
    }
    self.callBackBlock = callBack;
    [self loadData];
}

- (void)responseSuccess:(id)json{
    
    [self clearItems];
    NSDictionary *dicCommission = [json objectForKey:@"roleCommission"];
    NSArray *arrDetails = [json objectForKey:@"roleCommissionDetail"];
    
    _roleCommissionVo = nil;
    _roleCommissionVoUpdate = nil;
    if ([ObjectUtil isNotEmpty:dicCommission]) {
        _roleCommissionVo = [RoleCommissionVo convertToUser:dicCommission];
        _roleCommissionVoUpdate = [RoleCommissionVo convertToUser:dicCommission];
        _roleCommissionVo.operateType = @"edit";
        _roleCommissionVoUpdate.operateType = @"edit";
    }
    [self configTitle:_roleCommissionVo.roleName leftPath:Head_ICON_BACK rightPath:nil];
    
    _roleCommissionDetailVoList = nil;
    _roleCommissionDetailVoListOld = nil;
    _roleCommissionDetailVoList = [[NSMutableArray alloc]init];
    _roleCommissionDetailVoListOld = [[NSMutableArray alloc]init];
    if ([ObjectUtil isNotEmpty:arrDetails]) {
        for (NSDictionary *dic in arrDetails) {
            [_roleCommissionDetailVoList addObject:[RoleCommissionDetailVo convertToUser:dic]];
            [_roleCommissionDetailVoListOld addObject:[RoleCommissionDetailVo convertToUser:dic]];
        }
    }
    
    [_mainGrid reloadData];
    [self reloadItemsWithVo:_roleCommissionVo isInit:YES];
}

- (void)responseSave:(id)json{
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
    [self.navigationController popViewControllerAnimated:NO];
    if (self.callBackBlock) {
        self.callBackBlock();
    }
}

// AddItemDelegate
- (void)showAddItemEvent {
    [self addDeductGoods];
}

#pragma mark - INavigateEvent代理  (导航)
- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event{
    if (event == LSNavigationBarButtonDirectLeft) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    } else {
        if ([self isValid]) {
            [self packageData];
            __weak RoleCommissionnDetailView* weakSelf = self;
            [_service saveRoleCommission:_roleCommissionVoUpdate roleCommissionDetail:_roleCommissionDetailVoList completionHandler:^(id json) {
                if (!weakSelf) return ;
                [weakSelf responseSave:json];
            } errorHandler:^(id json) {
                [AlertBox show:json];
            }];
        }
    }
}

// IEditItemListEvent
- (void)onItemListClick:(LSEditItemList *)obj {
    if (obj == _itemListCommissionType) {
        NSMutableArray *arr = [EmployeeRender getCommissionTypeListWithshopMode:self.shopMode];
        [OptionPickerBox initData:arr itemId:[obj getStrVal]];
        [OptionPickerBox show:@"提成方式" client:self event:1];
    } else if(obj == _itemTxtInPut) {
        NSInteger CommissionType = self.itemListCommissionType.getStrVal.integerValue;
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:YES isSymbol:NO event:CommissionType];
        if (CommissionType == 2) {
            [SymbolNumberInputBox limitInputNumber:6 digitLimit:2];
        }else if(CommissionType == 3){
            [SymbolNumberInputBox limitInputNumber:3 digitLimit:2];
        }
        [SymbolNumberInputBox initData:self.itemTxtInPut.lblVal.text];
    }
}

// IEditItemRadioEvent
- (void)onItemRadioClick:(LSEditItemRadio*)obj {
    BOOL isOpen = [obj getVal];
    if (self.itemRadioIsCommission == obj) {
        _roleCommissionVoUpdate.isCommission = isOpen;
        [self reloadItemsWithVo:_roleCommissionVoUpdate isInit:NO];
    }
    [self isUIChange];
}

#pragma mark - SymbolNumberInputClient代理 (输入提成比例回调)
- (void)numberClientInput:(NSString*)val event:(NSInteger)eventType {
    
    NSString *dot = @".";
    NSString *partInt = nil;//整数部分
    NSString *partFloat = nil;//小数部分
    if ([ObjectUtil isNotNull:val] && ![val isEqualToString:@""]) {
        NSRange foundObj= [val rangeOfString:dot options:NSCaseInsensitiveSearch];
        if (foundObj.length > 0) {
            //含小数点
            partInt = [val substringToIndex:foundObj.location];
            partFloat = [val substringFromIndex:foundObj.location + foundObj.length];
        } else {
            //不含小数点
            partInt = val;
        }

    }
    
    if (![NSString isPositiveNum:partInt] && nil!= partInt) {
        [AlertBox show:@"输入的数字不合法，请重新输入!"];
        return;
    }
    if (eventType == 2) {
        //按单提成
        if (partInt.length > 6 || partFloat.length > 2 ) {
            [AlertBox show:@"提成金额整数位不得大于6,小数位不得大于2,请重新输入!"];
            return;
        }
    } else if(eventType == 3) {
        //按销售额提成
        NSInteger radio = partInt.intValue;
        if (radio > 100 || radio<0 ||partFloat.length > 2 || (radio == 100 &&partFloat.length>0)) {
            [AlertBox show:@"提成比例范围在0~100之间,小数位不得大于2,请重新输入!"];
            return;
        }
    }
    
    [self.itemTxtInPut changeData:val withVal:val];
    [self isUIChange];
}

#pragma mark - OptionPickerClient代理 (选择提成方式回调)
- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType{
    
    NSString *strVal,*name;
    if ([selectObj isKindOfClass:[NameItemVO class]]) {
        NameItemVO *temp = selectObj;
        strVal = temp.itemId;
        name = temp.itemName;
    }
    
    //list展示
    [_itemListCommissionType changeData:name withVal:strVal];
    
    //改写数据
    _roleCommissionVoUpdate.commissionType = strVal.integerValue;
    [self reloadItemsWithVo:_roleCommissionVoUpdate isInit:NO];
    [self isUIChange];
    return YES;
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _roleCommissionDetailVoList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"RoleCommissionnDetailViewCell";
    GoodsAndStyleCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [GoodsAndStyleCell getInstance];
        
    }
    
    if (_roleCommissionDetailVoList.count > 0) {
        RoleCommissionDetailVo *detail = [_roleCommissionDetailVoList objectAtIndex:indexPath.row];
        [cell loadCell:detail];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RoleCommissionDetailVo *detail = [_roleCommissionDetailVoList objectAtIndex:indexPath.row];
    NSMutableArray *list = [NSMutableArray arrayWithObject:detail];
    [self setCommissionRatio:list isAdd:NO];
}

#pragma mark - 参数检查
- (BOOL)isValid {

    if ([ObjectUtil isNull:self.itemListCommissionType.getStrVal] || [self.itemListCommissionType.getStrVal isEqualToString:@""]) {
        [AlertBox show:@"请选择提成方式!"];
        return NO;
    }
    NSInteger CommissionType = self.itemListCommissionType.getStrVal.integerValue;
    if (CommissionType == 2 ) {
        if ([ObjectUtil isNull:self.itemTxtInPut.getStrVal]
            || [self.itemTxtInPut.getStrVal isEqualToString:@""]) {
                [AlertBox show:@"请输入提成金额!"];
                return NO;
        }
    }
    if (CommissionType == 3) {
        if ([ObjectUtil isNull:self.itemTxtInPut.getStrVal]
            || [self.itemTxtInPut.getStrVal isEqualToString:@""]) {
                [AlertBox show:@"请输入提成比例!"];
                return NO;
        }
    }

    return YES;
}
@end
