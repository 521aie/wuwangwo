//
//  LSRoleInfoController.m
//  retailapp
//
//  Created by guozhi on 2017/2/5.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//
#define ITEM_ROLETYPE @"roletype"
#define ITEM_ROLE @"role"
#import "LSRoleInfoController.h"
#import "LSEditItemRadio.h"
#import "LSEditItemList.h"
#import "UIHelper.h"
#import "NameItemVO.h"
#import "OptionPickerBox.h"
#import "XHAnimalUtil.h"
#import "RoleVo.h"
#import "ModuleVo.h"
#import "SystemInfoVo.h"
#import "ActionVo.h"
#import "LSModuleInfoController.h"
#import "LSEditItemText.h"
#import "RolePermissionView.h"
@interface LSRoleInfoController ()<IEditItemRadioEvent, IEditItemListEvent, OptionPickerClient,UIActionSheetDelegate>
/** <#注释#> */
@property (nonatomic, strong) UIScrollView *scrollView;
/** <#注释#> */
@property (nonatomic, strong) UIView *container;
@property (nonatomic, assign) NSInteger shopMode; //1 单店 2连锁门店 3连锁组织机构
@property (nonatomic, assign) NSInteger roleType; //连锁模式  //1单店模式 2连锁模式
@property (nonatomic, strong) NSMutableArray *systemInfoList;   //系统信息列表
@property (nonatomic, strong) NSMutableDictionary *systemInfoMap; //系统id(key)与系统对象的关系map
@property (nonatomic, strong) NSMutableDictionary *moduleMap; //模块id(key)与模块对象的关系map
@property (nonatomic, strong) RoleVo *roleVo;  //保存的RoleVo
@property (nonatomic, assign) int type;
@property (nonatomic, assign) BOOL isOrg;
/** 判断下个页面是否发生变化 */
@property (nonatomic, assign) BOOL isChange;
/** 红色按钮 */
@property (nonatomic, strong) UIButton *btnDel;

@end

@implementation LSRoleInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    [self configConstraints];
    [self configContainerViews];
    [self configHelpButton:HELP_EMPLOYEE_ROLE_PERMISSION];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
}

- (void)configViews {
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    self.shopMode = [[Platform Instance] getShopMode];
    if (self.shopMode == 3) {
        self.roleType = 2;
    }else{
        self.roleType = 1;
    }
    self.systemInfoMap = [[NSMutableDictionary alloc]init];
    self.moduleMap = [[NSMutableDictionary alloc]init];
    [self registerNotification];

    //标题
    if (self.action == ACTION_CONSTANTS_ADD) {
        [self configTitle:@"添加角色" leftPath:Head_ICON_CANCEL rightPath:Head_ICON_OK];
    } else {
         [self configTitle:@"" leftPath:Head_ICON_BACK rightPath:nil];
    }
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

- (void)dealloc {
    [self removeNotification];
}

- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ModuleInfoChange:) name:Notification_ModuleInfoChange_Change object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ModuleInfoChange:) name:@"changeStatus" object:nil];
}

/**通知处理方法*/
- (void)ModuleInfoChange:(NSNotification*)notification
{
    if ([notification.object isKindOfClass:[ModuleVo class]])
    {
        //当新增一个角色时调用
        if (self.action == ACTION_CONSTANTS_ADD) {
            [UIHelper clearChange:self.container];
        }
        [self refreshUIBySystemInfoList:_systemInfoList isInit:YES];
    }else if ([notification.object isKindOfClass:[RoleVo class]]){
        self.action = ACTION_CONSTANTS_EDIT;
        self.roleVo = notification.object;
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.type && self.roleVo.roleId.length > 0) {
        [self loadDataWithRoleID:self.roleVo.roleId];
    }
}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



- (void)configContainerViews {
    self.btnDel = [LSViewFactor addRedButton:self.container title:@"删除" y:0];
    [self.btnDel addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.btnDel.superview.hidden = self.action == ACTION_CONSTANTS_ADD;
    self.container.hidden = YES;
}

- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event == LSNavigationBarButtonDirectLeft) {
        //返回
        //每次返回都去删除现有item,重新进入时再加载。可能会有性能问题,待优化
        for (NSString *itemid in _systemInfoMap.allKeys) {
            [[_systemInfoMap objectForKey:itemid]removeFromSuperview];
        }
        for (NSString *itemid in _moduleMap.allKeys) {
            [[_moduleMap objectForKey:itemid]removeFromSuperview];
        }
        
        [_systemInfoMap removeAllObjects];
        [_moduleMap removeAllObjects];
        
        /////////////////
        if (self.action == ACTION_CONSTANTS_ADD) {
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        }else{
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        }
        
        [self.navigationController popViewControllerAnimated:NO];
        
    }else {
        //保存
        if (![self isValid]) {
            return;
        }
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
        NSLog(@"%@",param);
        __weak typeof(self) wself = self;
        [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
            [wself responseSave:json];
        } errorHandler:^(id json) {
             [LSAlertHelper showAlert:json];
        }];
        
    }
    
}

// 删除当前"角色权限"
- (void)btnClick:(id)sender {
    
    if ([ObjectUtil isNotNull:self.systemInfoMap]) {
        
        LSEditItemText *item = [self.systemInfoMap objectForKey:ITEM_ROLE];
        NSString *message = [NSString stringWithFormat:@"确认要删除[%@]吗?",item.txtVal.text];
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:message delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确认",nil];
        [actionSheet showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {//确定
        if (self.roleVo.roleId) {
            [self deleteRoleByRoleId:self.roleVo.roleId];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if (self.roleVo.roleId) {
            [self deleteRoleByRoleId:self.roleVo.roleId];
        }
    }
}


#pragma mark - <IEditItemDynamicEvent>
- (void)onItemListClick:(LSEditItemList *)obj {
    //如果有角色id存在则不在考虑名字
    if (self.roleVo.roleId == 0) {
        //如果没有角色id且名字为空
        if (![self isValid]) {
            return;
        }
    }
    if (obj == [_systemInfoMap objectForKey:@"roletype"]) {
        //点击了角色类型
        //            NSLog(@"点击了角色类型");
        NSArray *arr = @[[[NameItemVO alloc] initWithVal:@"门店" andId:@"1"],
                         [[NameItemVO alloc] initWithVal:@"机构" andId:@"2"]];
        [OptionPickerBox initData:arr itemId:[obj getStrVal]];
        [OptionPickerBox show:@"角色类型" client:self event:obj.tag];
        
    } else {
        LSEditItemList *item = [_systemInfoMap objectForKey:ITEM_ROLETYPE];
        self.isOrg = [[item getDataLabel] isEqualToString:@"机构"];
        //找到对应的模块
        for (SystemInfoVo *sysInfo in _systemInfoList)
        {
            for (ModuleVo *module in sysInfo.moduleVoList)
            {
                if (obj.tag == module.moduleId) {
                    self.type = 1;
                    LSModuleInfoController *vc = [[LSModuleInfoController alloc] init];
                    vc.isOrg = self.isOrg;
                    vc.obj = module;
                    vc.systemInfoMap = _systemInfoMap;
                    vc.systemInfoList = _systemInfoList;
                    vc.roleVo = _roleVo;
                    vc.action = _action;
                    [self.navigationController pushViewController:vc animated:NO];
                    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
                }
            }
        }
        
    }
    
}

#pragma mark - <OptionPickerClient>
- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType {
    
    NameItemVO *temp = selectObj;
    self.roleVo.roleType = temp.itemId.integerValue;
    
    //修改对应item的内容
    LSEditItemList *item = [_systemInfoMap objectForKey:ITEM_ROLETYPE];
    if (item) {
        [item changeData:[temp obtainItemName] withVal:[temp obtainItemId]];
    }
    [self dataChange:nil];
    return YES;
}

- (void)onItemRadioClick:(LSEditItemRadio *)obj {
    BOOL isOpen = [obj getVal];
    if (!isOpen)
    {//关闭状态 隐藏内部的module
        for (SystemInfoVo *sysInfo in _systemInfoList) {
            if (obj.tag == sysInfo.systemInfoId) {
                NSLog(@"找到对应的Item,itemID = %ld,%@",(long)obj.tag,sysInfo.systemName);
                for (ModuleVo *module in sysInfo.moduleVoList)
                {
                    LSEditItemList *temp = [self.moduleMap objectForKey:[NSNumber numberWithInteger:module.moduleId]];
                    [temp visibal:NO];//设为不显示
                }
            }
        }
    } else {
        //打开状态 显示内部的module
        for (SystemInfoVo *sysInfo in _systemInfoList) {
            if (obj.tag == sysInfo.systemInfoId) {
                for (ModuleVo *module in sysInfo.moduleVoList)
                {
                    LSEditItemList *temp = [self.moduleMap objectForKey:[NSNumber numberWithInteger:module.moduleId]];
                    if ([Platform Instance].getMicroShopStatus != 2){
                        if([module.moduleName isEqual:@"顾客评价"]){
                            [temp visibal:NO];
                        }else{
                            [temp visibal:YES];
                        }
                    } else {
                        [temp visibal:YES];
                    }
                    
                    //设为显示
                }
            }
        }
    }
    [self dataChange:nil];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
}


#pragma mark - 网络请求
- (void)loadDataWithRoleID:(NSString *)roleID{
    NSString *url = @"roleAction/detail";
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    if ([ObjectUtil isNotNull:roleID]) {
        [param setValue:roleID forKey:@"roleId"];
    }
    __weak typeof(self) wself = self;
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        [wself responseSuccess:json];
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json];
    }];
}
- (void)initDataInAddType{
    __weak typeof(self) wself = self;
    NSString *url = @"roleAction/init";
    [BaseService getRemoteLSDataWithUrl:url param:nil withMessage:nil show:YES CompletionHandler:^(id json) {
        [wself responseSuccess:json];
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json];
    }];
}

- (void)deleteRoleByRoleId:(NSString *)roleId{
    NSString *url = @"roleAction/delete";
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    if ([ObjectUtil isNotNull:roleId]) {
        [param setValue:roleId forKey:@"roleId"];
    }
    __weak typeof(self) wself = self;
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        [wself responseDelete:json];
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json];
    }];
}

- (void)responseSuccess:(id)json {
    self.container.hidden = NO;
    _systemInfoList = [[NSMutableArray alloc]init];
    //json中赋值给_systemInfoList
    NSMutableArray *arrTemp = [json objectForKey:@"systemInfoList"];
    
    self.roleVo = nil;
    if (self.action == ACTION_CONSTANTS_EDIT) {
        NSMutableDictionary *dirRole = [json objectForKey:@"role"];
        self.roleVo = [RoleVo convertToUser:dirRole];
        [self configTitle:self.roleVo.roleName leftPath:Head_ICON_BACK rightPath:nil];
    }
    else{
        self.roleVo = [[RoleVo alloc]init];
        self.roleVo.roleType = self.roleType;
    }
    
    //每次加载都重新单独处理"角色","角色类型"
    //角色
    if ([ObjectUtil isNull:[_systemInfoMap objectForKey:ITEM_ROLE]]) {
        LSEditItemText *item = [LSEditItemText editItemText];
        //添加状态self.roleVo.roleName为空,
        [item initLabel:@"角色" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
        [item initMaxNum:20];
        [item initData:self.roleVo.roleName];
        [self.systemInfoMap setValue:item forKey:ITEM_ROLE];//加入字典
        [self.container addSubview:item];
    }
    //连锁时才显示角色类型
    if (self.roleType != 1) {
        if ([ObjectUtil isNull:[_systemInfoMap objectForKey:ITEM_ROLETYPE]]) {
            LSEditItemList *item = [LSEditItemList editItemList];
            [item initLabel:@"角色类型" withHit:nil delegate:self];
            NameItemVO *name1 = [[NameItemVO alloc]initWithVal:@"门店" andId:@"1"];
            NameItemVO *name2 = [[NameItemVO alloc]initWithVal:@"机构" andId:@"2"];
            NSArray *arrdic = @[name1, name2];
            for (NameItemVO *namevo in arrdic) {
                if (namevo.itemId.integerValue == self.roleVo.roleType) {
                    [item initData:[namevo obtainItemName] withVal:[namevo obtainItemId]];
                }
            }
            [self.systemInfoMap setValue:item forKey:ITEM_ROLETYPE];//加入字典
            [self.container addSubview:item];
        }
        
    }
    
    if ([ObjectUtil isNotEmpty:arrTemp]) {
        for (NSDictionary *systemDic in arrTemp) {
            SystemInfoVo *systemInfo = [SystemInfoVo convertToUser:systemDic];
            [_systemInfoList addObject:systemInfo];
        }
    }
    [self refreshUIBySystemInfoList:_systemInfoList isInit:YES];
    
}
- (void)responseSave:(id)json{
    ////////////
    [self loadLastControllerData];
    if (self.action == ACTION_CONSTANTS_ADD) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
    }else{
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
    }
    [self.navigationController popViewControllerAnimated:NO];
}
- (void)responseDelete:(id)json{
    [self loadLastControllerData];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)loadLastControllerData {
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[RolePermissionView class]]) {
//            [(RolePermissionView *)obj loadData];
        }
    }];
}

#pragma mark - UI刷新
/**根据systeminfoList和使用场景,刷新UI*/
- (void)refreshUIBySystemInfoList:(NSMutableArray *)systeminfoList isInit:(BOOL) isInit{
    LSEditItemRadio *systemItemTemp = nil;
    for (SystemInfoVo *systemInfo in systeminfoList)
    {
        NSInteger actionCount = 0;
        if ([ObjectUtil isNull:[_systemInfoMap objectForKey:[NSNumber numberWithInteger:systemInfo.systemInfoId]]])//字典中无此系统item
        {
            LSEditItemRadio *itemSystem = [LSEditItemRadio editItemRadio];
            [itemSystem initLabel:systemInfo.systemName withHit:nil delegate:self];
            [self.container addSubview:itemSystem];
            itemSystem.tag = systemInfo.systemInfoId;
            systemItemTemp = itemSystem;
            [self.systemInfoMap setValue:itemSystem forKey:[NSNumber numberWithInteger:systemInfo.systemInfoId]];//加入字典
            
            for (ModuleVo *module in systemInfo.moduleVoList) {
                LSEditItemList *itemModule = [LSEditItemList editItemList];
                itemModule.imgMore.image = [UIImage imageNamed:@"ico_next"];
                NSString *moduleName = [NSString stringWithFormat:@"▪︎ %@",module.moduleName];
                itemModule.lblDetail.numberOfLines = 1;
                [itemModule initLabel:moduleName withHit:module.actionNameOfModule delegate:self];
                NSString *val = [NSString stringWithFormat:@"%ld项", (long)module.count];
                if (isInit) {
                    [itemModule initData:val withVal:val];
                }else{
                    [itemModule changeData:val withVal:val];
                }
                [self.container addSubview:itemModule];
                itemModule.tag = module.moduleId;
                [self.moduleMap setValue:itemModule forKey:[NSNumber numberWithInteger:module.moduleId]];//加入字典
                actionCount += module.count;
                if ([Platform Instance].getMicroShopStatus != 2 && [module.moduleName isEqual:@"顾客评价"]){
                    [itemModule visibal:NO];
                }
                if ([module.moduleName isEqualToString:@"商圈设置"]) {
                    if ([[Platform Instance] getScanPayStatus] != 1) {//没有开通商圈
                        [itemModule visibal:NO];
                    }
                }
                
            }
            
        }
        else{//字典中有此系统item
            //只需要更新module里面的数据
            LSEditItemRadio *itemRadio = [_systemInfoMap objectForKey:[NSNumber numberWithInteger:systemInfo.systemInfoId]];
            [itemRadio initLabel:systemInfo.systemName withHit:nil delegate:self];
            itemRadio.tag = systemInfo.systemInfoId;
            systemItemTemp = itemRadio;
            
            
            for (ModuleVo *module in systemInfo.moduleVoList)
            {   //找到该模块的item对象
                LSEditItemList *itemModule = [self.moduleMap objectForKey:[NSNumber numberWithInteger:module.moduleId]];
                NSString *moduleName = [NSString stringWithFormat:@"▪︎ %@",module.moduleName];
                [itemModule initLabel:moduleName withHit:module.actionNameOfModule delegate:self];
                NSString *val = [NSString stringWithFormat:@"%ld项", (long)module.count];
                if (isInit) {
                    [itemModule initData:val withVal:val];
                }else{
                    [itemModule changeData:val withVal:val];
                    
                }
                itemModule.tag = module.moduleId;
                actionCount += module.count;
            }
            
        }
        
        if (0 == actionCount)//如果该系统没有选中的action,则该系统radio默认关闭,该系统下的module不显示
        {
            if (isInit) {
                [systemItemTemp initData:@"0"];
            }else{
                [systemItemTemp changeData:@"0"];
            }
            
            for (ModuleVo *module in systemInfo.moduleVoList)
            {
                LSEditItemList *temp = [self.moduleMap objectForKey:[NSNumber numberWithInteger:module.moduleId]];
                [temp visibal:NO];
            }
            
        }else{//有权限,系统item默认radio打开
            if (isInit) {
                [systemItemTemp initData:@"1"];
            }else{
                [systemItemTemp changeData:@"1"];
            }
            
            for (ModuleVo *module in systemInfo.moduleVoList)
            {
                LSEditItemList *temp = [self.moduleMap objectForKey:[NSNumber numberWithInteger:module.moduleId]];
                [temp visibal:YES];
                if ([Platform Instance].getMicroShopStatus != 2 && [module.moduleName isEqual:@"顾客评价"]){
                    [temp visibal:NO];
                }
                if ([module.moduleName isEqualToString:@"商圈设置"]) {
                    if ([[Platform Instance] getScanPayStatus] != 1) {//没有开通商圈
                        [temp visibal:NO];
                    }
                }

            }
        }
        
    }
    if (self.btnDel.superview.hidden == NO) {
        [self.container bringSubviewToFront:self.btnDel.superview];//把删除按钮移到数组底部
    }
    if (isInit) {
        [self initNotification];
    }
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    
    
}

/**判断数据是否变化,来更新UI的变化*/
#pragma mark - 初始化通知
- (void)initNotification {
    [UIHelper initNotification:self.container event:Notification_UI_KindPayEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_KindPayEditView_Change object:nil];
    
}

#pragma mark - 页面里面的值改变时调用
- (void)dataChange:(NSNotification *)notification {
    [self editTitle:([UIHelper currChange:self.container] || self.isChange) act:self.action];
}

#pragma mark - 参数检查
- (BOOL)isValid {
    
    if ([ObjectUtil isNotNull:self.systemInfoMap]) {
        LSEditItemText*item = [self.systemInfoMap objectForKey:ITEM_ROLE];
        if ([NSString isBlank:item.txtVal.text]) {
            [LSAlertHelper showAlert:@"角色名称不能为空!"];
            return NO;
        }
        self.roleVo.roleName = item.txtVal.text;
    }
    return YES;
}


@end
