//
//  LSModuleInfoController.m
//  retailapp
//
//  Created by guozhi on 2017/2/4.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSModuleInfoController.h"
#import "ModuleVo.h"
#import "ActionVo.h"
#import "LSEditItemRadio.h"
#import "LSEditItemList.h"
#import "UIHelper.h"
#import "NameItemVO.h"
#import "OptionPickerBox.h"
#import "XHAnimalUtil.h"
#import "SystemInfoVo.h"
#import "RoleVo.h"
#import "LSRoleInfoController.h"
@interface LSModuleInfoController ()< IEditItemRadioEvent, IEditItemListEvent, OptionPickerClient>
/** <#注释#> */
@property (nonatomic, strong) UIScrollView *scrollView;
/** <#注释#> */
@property (nonatomic, strong) UIView *container;
@property (nonatomic,strong) ModuleVo               *updateModuleVo;//模块信息vo
@property (nonatomic,strong) NSMutableDictionary    *itemMap;       //动态Item指针和其ID的map
@end

@implementation LSModuleInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    [self configConstraints];
    [self configContainerViews:self.updateModuleVo];
    [self configHelpButton:HELP_EMPLOYEE_ROLE_PERMISSION];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
}

- (void)configViews {
    _itemMap = [[NSMutableDictionary alloc]init];
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    //标题
    //scollVIew
    self.scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    //container
    self.container = [[UIView alloc] init];
    self.container.ls_width = SCREEN_W;
    [self.scrollView addSubview:self.container];
    
}

- (void)configConstraints {
    //标题
    UIView *superView = self.view;
    __weak typeof(self) wself = self;
    //scrollView
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(superView);
        make.top.equalTo(wself.view.top).offset(kNavH);
    }];
}

- (void)setObj:(ModuleVo *)obj {
    _obj = obj;
    self.updateModuleVo = [obj copy];
    self.updateModuleVo.isActionChange = NO;
}

- (void)configContainerViews:(ModuleVo*)moduleVo {
    for (ActionVo *obj  in moduleVo.actionList) {
        if (obj.actionType == 1) {
            LSEditItemRadio *item = [LSEditItemRadio editItemRadio];
            item.tag = obj.actionId;
            [item initLabel:obj.actionName withHit:nil delegate:self];
            [item initData:@(obj.choiceFlag).stringValue];
            [self.container addSubview:item];
            
            
            if (([[Platform Instance] getShopMode] == 1 || self.isOrg) && [obj.actionCode isEqualToString:ACTION_BANK_BINDING]) {//绑定银行卡
                [item visibal:NO];
            }
            if (self.isOrg && [obj.actionCode isEqualToString:ACTION_STORE_COST_PRICE_SET]) {//始库存及成本价设置
                [item visibal:NO];
            }
            [_itemMap setValue:item forKey:obj.actionCode];
            
            if ([moduleVo.moduleName isEqualToString:@"微店模块"]) {
//                if ([Platform Instance].getMicroShopStatus != 2){
//                    if([obj.actionCode isEqual:ACTION_OPEN_WEISHOP]){
//                        [item visibal:YES];
//                    }else{
//                        [item visibal:NO];
//                    }
//                }else{
//                    if([obj.actionCode isEqual:ACTION_OPEN_WEISHOP]){
//                        [item visibal:NO];
//                    }else{
//                        [item visibal:YES];
//                    }
//                }
            }
            if ([moduleVo.moduleName isEqualToString:@"报表中心"]) {
                if([obj.actionCode isEqual:ACTION_SUPPLY_GOODS]){//商品供货明细表 供货日报表
                    [item visibal:NO];
                }else{
                    [item visibal:YES];
                }
            }
            
            if ([moduleVo.moduleName isEqualToString:@"营业设置"] && [[Platform Instance] getShopMode] == 3 && self.isOrg) {
                if([obj.actionCode isEqual:ACTION_PAYMENT_TYPE]){
                    [item visibal:NO];
                }else{
                    [item visibal:YES];
                }
            }
            if ([moduleVo.moduleName isEqualToString:@"店家设置"]) {
                if ([obj.actionCode isEqualToString:ACTION_SETTLED_MALL]) {//入驻商圈
                    if ([[Platform Instance] getScanPayStatus] != 1) {//没有开通商圈
                        [item visibal:NO];
                    } else {
                        [item visibal:YES];
                    }
                }
            }
        } else if (obj.actionType == 2) {
            LSEditItemRadio *itemRadio = [LSEditItemRadio editItemRadio];
            itemRadio.tag = obj.actionId;
            [self.container addSubview:itemRadio];
            LSEditItemList *itemList = [LSEditItemList editItemList];
            itemList.tag = obj.actionId;
            [self.container addSubview:itemList];
            
            [itemRadio initLabel:obj.actionName withHit:nil delegate:self];
            [itemRadio initData:@(obj.choiceFlag).stringValue];
            if (!obj.choiceFlag) {
                [itemList visibal:NO];
            }
            [_itemMap setValue:itemRadio forKey:obj.actionCode];
            
            NSString *name = nil;
            NSString *strval = nil;
            for (NSDictionary *dic in obj.dicVoList) {
                NSInteger val = [ObjectUtil getIntegerValue:dic key:@"val"];
                if(obj.actionDataType == val) {
                    name = [dic objectForKey:@"name"];
                    strval = [NSString stringWithFormat:@"%ld",(long)val];
                }
                
            }
            if ([ObjectUtil isNull:strval]) {//没有默认的值
                //默认选中字典中第一个
                NSDictionary *dic = obj.dicVoList[0];
                NSInteger val = [ObjectUtil getIntegerValue:dic key:@"val"];
                name = [dic objectForKey:@"name"];
                strval = [NSString stringWithFormat:@"%ld",(long)val];
                obj.actionDataType = val;
                
            }
            NSString *actionName = [NSString stringWithFormat:@"▪︎  %@权限",obj.actionName];
            [itemList initLabel:actionName withHit:nil delegate:self];
            [itemList initData:name withVal:strval];

            [_itemMap setValue:itemList forKey:@(obj.actionId).stringValue];
        }
        
    }
    //
    [self configTitle:moduleVo.moduleName leftPath:Head_ICON_BACK rightPath:nil];
    [self isUIChange];
    
}

- (void)onItemListClick:(LSEditItemList *)obj {
    [self.updateModuleVo.actionList enumerateObjectsUsingBlock:^(ActionVo *actionVo, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.tag == actionVo.actionId) {
            NSMutableArray *arr = [self getItemVoListByDicVoList:actionVo.dicVoList];
            [OptionPickerBox initData:arr itemId:[obj getStrVal]];
            [OptionPickerBox show:actionVo.actionName client:self event:obj.tag];
        }
    }];
}

- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType {
    id<INameItem> item = (id<INameItem>)selectObj;
    for (int i = 0; i < self.updateModuleVo.actionList.count; i++) {
        ActionVo *tempVo = [_updateModuleVo.actionList objectAtIndex:i];
        if (tempVo.actionId == eventType) {
            tempVo.actionDataType = [[item obtainItemId] integerValue];//修改数据结构中默认选中对应的值
            //修改对应item的内容
            LSEditItemList *itemList = [_itemMap objectForKey:@(tempVo.actionId).stringValue];
            [itemList changeData:[item obtainItemName] withVal:[item obtainItemId]];
        }
    }
    [self isUIChange];
    
    return YES;
}

- (void)onItemRadioClick:(LSEditItemRadio *)obj {
    BOOL isOpen = [obj getVal];
    for (int i = 0; i<self.updateModuleVo.actionList.count; i++) {
        ActionVo *tempVo = [_updateModuleVo.actionList objectAtIndex:i];
        if ( tempVo.actionId == obj.tag){
            tempVo.choiceFlag = isOpen;
            if (isOpen) {
                _updateModuleVo.count += 1;
            }else{
                _updateModuleVo.count -= 1;
            }
            if (2 == tempVo.actionType) {
                //找到radio下的list,并设置可见状态
                LSEditItemList *itemList = [_itemMap objectForKey:@(tempVo.actionId).stringValue];
                [itemList visibal:isOpen];
                [UIHelper refreshUI:self.container scrollview:self.scrollView];
            }
            
            /*               “进货价/退货价修改” 与 “进货价/退货价查看” 为联动开关
             当 “进货价/退货价查看”处于打开状态时，可操作“进货价/退货价修改” 打开或关闭；
             当打开“进货价/退货价修改”时，若“进货价/退货价查看”处于关闭状态则联动打开；
             当关闭“进货价/退货价查看”时，“进货价/退货价修改”处于打开状态则联动关闭；*/
            LSEditItemRadio *itemRadioEdit= _itemMap[ACTION_PURCHASE_RETURN_PRICE_EDIT];//进货价/退货价修改
            LSEditItemRadio *itemRadioSearch = _itemMap[ACTION_PURCHASE_RETURN_PRICE_SEARCH];//进货价/退货价修改
            if (obj == itemRadioSearch) {//当操作进货价/退货价查看
                if (!isOpen) {//当关闭“进货价/退货价查看”时，“进货价/退货价修改”处于打开状态则联动关闭；
                    if ([itemRadioEdit getVal]) {
                        [itemRadioEdit changeData:@"0"];
                        _updateModuleVo.count -= 1;
                        [_updateModuleVo.actionList enumerateObjectsUsingBlock:^(ActionVo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            if (obj.actionId == itemRadioEdit.tag) {
                                obj.choiceFlag = false;
                                *stop = YES;
                            }
                            
                        }];
                    }
                    
                    
                }
                
            }
            if (obj == itemRadioEdit) {//当操作进货价/退货价修改
                if (isOpen) {//当打开“进货价/退货价修改”时，若“进货价/退货价查看”处于关闭状态则联动打开；
                    if (![itemRadioSearch getVal]) {
                        [itemRadioSearch changeData:@"1"];
                        _updateModuleVo.count += 1;
                    }
                    [_updateModuleVo.actionList enumerateObjectsUsingBlock:^(ActionVo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (obj.actionId == itemRadioSearch.tag) {
                            obj.choiceFlag = true;
                            *stop = YES;
                        }
                        
                    }];
                    
                    
                }
                
            }
            
            
        }
        
    }

     [self isUIChange];
}

- (BOOL)isUIChange{
    
    NSInteger changeCount = 0;
    for (EditItemBase *item in _itemMap.allValues) {
        if (item.isChange) {
            changeCount += 1;
        }
    }
    if (changeCount > 0) {
        [self configTitle:_updateModuleVo.moduleName leftPath:Head_ICON_CANCEL rightPath:Head_ICON_OK];
        return YES;
    }else{
        [self configTitle:_updateModuleVo.moduleName leftPath:Head_ICON_BACK rightPath:nil];
        return NO;
    }
    
}

- (void)onNavigateEvent:(LSNavigationBarButtonDirect)direct {
    if (direct == LSNavigationBarButtonDirectLeft) {
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[LSRoleInfoController class]]) {
                [(LSRoleInfoController *)obj setType:0];
                *stop = YES;
            }
            
        }];
        [self popViewController];
    } else {
        //点击保存时,权限名称的拼接
        NSMutableString *strActions = [NSMutableString string];
        for (ActionVo *actionvo in _updateModuleVo.actionList)
        {
            if (1 == actionvo.choiceFlag) {
                [strActions appendFormat:@"%@,",actionvo.actionName];
            }
        }
        if (strActions.length != 0) {
            _updateModuleVo.actionNameOfModule = [strActions substringToIndex:strActions.length-1];//去掉最后一个逗号
        }
        
        if ([self isUIChange]) {
            _updateModuleVo.isActionChange = YES;
        }
        [self upDataSystemInfo];
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_ModuleInfoChange_Change object:_updateModuleVo];
    }
    
}


//替换被改变的模块
-(void)upDataSystemInfo
{
    for (SystemInfoVo *tempVo in _systemInfoList)
    {
        for (int i= 0 ; i<tempVo.moduleVoList.count; i++)
        {
            ModuleVo *temp = tempVo.moduleVoList[i];
            if (_updateModuleVo.moduleId == temp.moduleId) {
                tempVo.moduleVoList[i] = _updateModuleVo;
            }
        }
    }
    [self resaveData];
}

//模块信息保存上传
-(void)resaveData
{
    NSMutableArray *actionList = [[NSMutableArray alloc]init];
    NSString *strOperateType;
    if (self.action == ACTION_CONSTANTS_ADD) {
        strOperateType = @"add";
        //把选中的action加入list
        for (SystemInfoVo *systemInfo in _systemInfoList) {
            LSEditItemRadio *item = [_systemInfoMap objectForKey:[NSNumber numberWithInteger:systemInfo.systemInfoId]];
            if ([item getVal]) {
                for (ModuleVo *module in systemInfo.moduleVoList) {
                    if (0 != module.count) {
                        for (ActionVo *action in module.actionList) {
                            if (1 == action.choiceFlag) {
                                [actionList addObject:action];
                            }
                        }
                    }
                }
            }
        }
    } else {
        strOperateType = @"edit";
        //所有的action加入list
        for (SystemInfoVo *systemInfo in _systemInfoList) {
            LSEditItemRadio *item = [_systemInfoMap objectForKey:[NSNumber numberWithInteger:systemInfo.systemInfoId]];
            if (![item getVal]) {//如果系统变成关闭状态,把内部所有的状态置为非选中
                for (ModuleVo *module in systemInfo.moduleVoList) {
                    for (int i = 0; i < module.actionList.count;i++) {
                        ActionVo *action = module.actionList[i];
                        action.choiceFlag = 0;
                    }
                }
            }
            for (ModuleVo *module in systemInfo.moduleVoList) {
                for (ActionVo *action in module.actionList) {
                    if (action.isChange) {//只有改变得开关才传给后台
                        [actionList addObject:action];
                    }
                    
                }
            }
        }
    }


    NSString *url = @"roleAction/v1/save";
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:4];
    if ([ObjectUtil isNotNull:self.roleVo]) {
        
        [param setValue:[self.roleVo getDic:self.roleVo] forKey:@"role"];
    }
    if ([ObjectUtil isNotEmpty:actionList]) {
        NSMutableArray *list = [[NSMutableArray alloc]init];
        for (ActionVo *action in actionList) {
            [list addObject:[action getDic:action]];
        }
        [param setValue:list forKey:@"actionList"];
    }
    if ([ObjectUtil isNotNull:strOperateType]) {
        [param setValue:strOperateType forKey:@"operateType"];
    }
    
    __weak typeof(self) wself = self;
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        [wself responseSave:json];
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json];
    }];
}

- (void)responseSave:(id)json{
    if (self.action == ACTION_CONSTANTS_ADD) {
        NSMutableDictionary *dirRole = [json objectForKey:@"role"];
        self.roleVo = [RoleVo convertToUser:dirRole];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeStatus" object:self.roleVo];
    }
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
    [self.navigationController popViewControllerAnimated:NO];
}



- (NSMutableArray *)getItemVoListByDicVoList:(NSArray *)dicVoList{
    NSMutableArray *vos=[NSMutableArray array];
    if (dicVoList != nil && dicVoList.count > 0) {
        for (NSDictionary *dic in dicVoList) {
            NSString *name = [dic objectForKey:@"name"];
            NSNumber *numberval = [dic objectForKey:@"val"];
            NSString *val = [NSString stringWithFormat:@"%ld",[numberval longValue]];
            NameItemVO *item=[[NameItemVO alloc] initWithVal:name andId:val];
            [vos addObject:item];
        }
    }
    
    return vos;
}

@end
