//
//  PerformanceGoalDetailView.m
//  retailapp
//
//  Created by qingmei on 15/10/19.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "PerformanceGoalDetailView.h"
#import "CalendarView.h"
#import "ColorHelper.h"
#import "IEditItemListEvent.h"
#import "SymbolNumberInputBox.h"
#import "PerformanceGoalView.h"
#import "EmployeeService.h"
#import "ServiceFactory.h"
#import "LSEditItemText.h"
#import "LSEditItemList.h"
#import "UIHelper.h"
#import "DateUtils.h"
#import "AlertBox.h"
#import "XHAnimalUtil.h"
#import "UserPerformanceTargetVo.h"
#import "SelectEmployeeListView.h"

#define THIS_MONTH @"this_month"
#define PREV_MONTH @"prev_month"
#define NEXT_MONTH @"next_month"

@interface PerformanceGoalDetailView ()<CalendarViewDelegate,IEditItemListEvent,SymbolNumberInputClient>

@property (strong, nonatomic) UIScrollView *scroll;
@property (strong, nonatomic) UIView *container;
@property (strong, nonatomic) UIView *tipContainer;

@property (strong, nonatomic) LSEditItemList *itemListName;  //姓名选择，添加时显示
@property (strong, nonatomic) LSEditItemText *itemName;      //姓名展示，编辑时显示
@property (strong, nonatomic) LSEditItemText *itemMobile;    //手机
@property (strong, nonatomic) LSEditItemList *itemGoal;      //目标

/**日历*/
@property (nonatomic, strong) CalendarView *calendarView;
@property (strong, nonatomic) UIView *calendarViewDiv;

@property (nonatomic, strong) PerformanceGoalView *parent; //父view
@property (nonatomic, strong) EmployeeService *service;//网络服务
@property (nonatomic, strong) UserPerformanceTargetVo *userPerformanceTargetVo; //业绩目标Vo
@property (nonatomic, strong) NSString *shopId;//筛选选中的shopId
@property (nonatomic, strong) NSDate *month;//筛选选中的月份
@property (nonatomic, assign) BOOL isAdd; //页面状态 yes：添加 no：编辑
@property (nonatomic, strong) NSMutableArray *performanceDetailVoList;//业绩详情列表
@property (nonatomic, assign) NSInteger performanceIdByMonth; //按月修改的performanceId
@end

@implementation PerformanceGoalDetailView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    [self initMainView];
    [UIHelper refreshUI:self.container scrollview:self.scroll];
    [self configHelpButton:HELP_EMPLOYE_SHOPPING_GUIDE];
    
}

- (id)initWithParent:(id)parentTemp{
    self = [super init];
    if (self) {
        if ([parentTemp isKindOfClass:[PerformanceGoalView class]]) {
            _parent = (PerformanceGoalView *)parentTemp;
        }
        
        _service = [ServiceFactory shareInstance].employeeService;
    }
    return self;
}

- (void)configViews {
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    self.scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    [self.view addSubview:self.scroll];
    
    self.container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scroll.ls_width, self.scroll.ls_height)];
    [self.scroll addSubview:self.container];
    
    self.itemListName = [LSEditItemList editItemList];
    [self.container addSubview:self.itemListName];
    
    self.itemName = [LSEditItemText editItemText];
    [self.container addSubview:self.itemName];
    
    self.itemMobile = [LSEditItemText editItemText];
    [self.container addSubview:self.itemMobile];
    
    self.itemGoal = [LSEditItemList editItemList];
    [self.container addSubview:self.itemGoal];
    
    [LSViewFactor addClearView:self.container y:0 h:20];
    
    self.calendarViewDiv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.container.ls_width, 260)];
    [self.container addSubview:self.calendarViewDiv];
    
    NSString *tip = @"提示：\n1.未选中某一天时修改业绩目标，则日历中当前月份每天的业绩目标自动填充该金额；\n2.今天之前的业绩目标不可修改；\n3.选中某一天可单独修改对应日期的业绩目标；";
    [LSViewFactor addExplainText:self.container text:tip y:0];
    
    
}

- (void)initMainView{
    //设置导航栏
    if (_isAdd) {
        [self configTitle:@"添加业绩目标" leftPath:Head_ICON_BACK rightPath:nil];
    }else{
        [self configTitle:_userPerformanceTargetVo.name leftPath:Head_ICON_BACK rightPath:nil];
    }
    [_itemName initLabel:@"员工姓名" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [_itemName initData:nil];
    [_itemName editEnabled:NO];
    
    [_itemListName initLabel:@"员工姓名" withHit:nil delegate:self];
    [_itemListName initData:nil withVal:nil];
    self.itemListName.imgMore.image = [UIImage imageNamed:@"ico_next"];
    
    [_itemMobile initLabel:@"手机号码" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    [_itemMobile initData:@"-"];
    [_itemMobile editEnabled:NO];
    
    [_itemGoal initLabel:@"业绩目标(元)" withHit:nil isrequest:YES delegate:self];
    NSInteger shopMode = [[Platform Instance] getShopMode];
    if (shopMode == 3) {//机构用户不得修改业绩目标
        [_itemGoal editEnable:NO];
        _itemGoal.lblVal.text = @"-";
    }
    
    //更新日历时间
    self.calendarView = [[CalendarView alloc]initWithNibName:@"CalendarView" bundle:nil delegate:self];
    self.calendarView.monthView.ls_width = self.container.ls_width;
    self.calendarView.monthSelectorView.ls_width = self.container.ls_width;
    self.calendarView.monthSelectorView.backgroundColor = [UIColor brownColor];
    self.calendarView.view.ls_width = self.container.ls_width;
    [self.calendarViewDiv addSubview:self.calendarView.view];
    [self.calendarView initMonth:_month];
   
    //设置业绩目标提示的字体颜色
    for (UILabel *label in self.tipContainer.subviews) {
        label.textColor = [ColorHelper getTipColor6];
    }
    
    [self handleDifferentType];
    [UIHelper refreshPos:self.container scrollview:self.scroll];
}

#pragma mark - 数据加载
- (void)loadDataWithVo:(UserPerformanceTargetVo *)userPerformanceTargetVo
                shopId:(NSString *)shopID
                month:(NSDate *)month {
  
    _isAdd = NO;
    if ([ObjectUtil isNotNull:shopID]) {
        _shopId = shopID;//添加时shopID取哪个
    }
    if ([ObjectUtil isNotNull:month]) {
        _month = month;//添加时默认是这个月还是选中的月
    }
    
    _userPerformanceTargetVo = nil;
    _userPerformanceTargetVo = [[UserPerformanceTargetVo alloc]init];
    if ([ObjectUtil isNotNull:userPerformanceTargetVo]) {
        _userPerformanceTargetVo = userPerformanceTargetVo;
    }
    
}
- (void)initDataInAddType:(NSArray *)userList
            shopId:(NSString *)shopID month:(NSDate *)month {
   
    _isAdd = YES;
    if ([ObjectUtil isNotNull:shopID]) {
        _shopId = shopID;//添加时shopID取哪个
    }
    if ([ObjectUtil isNotNull:month]) {
        _month = month;//添加时默认是这个月还是选中的月
    }

    _userPerformanceTargetVo = nil;
    _userPerformanceTargetVo = [[UserPerformanceTargetVo alloc]init];
}

- (void)handleDifferentType {
    
    if (_isAdd) {
        //name
        [_itemListName initData:@"请选择" withVal:nil];
        
        //mobile
        [_itemMobile initData:@"-"];
        
        [_itemListName visibal:YES];
        [_itemName visibal:NO];
    }else {
        [_itemName initData:_userPerformanceTargetVo.name];
        if ([ObjectUtil isNull:_userPerformanceTargetVo.mobile] || [_userPerformanceTargetVo.mobile isEqualToString:@""]) {
            [_itemMobile initData:@"-"];
        }else
        {
            [_itemMobile initData:_userPerformanceTargetVo.mobile];
        }
        
        [self getPerformanceTargetDetailInMonth:_month];
        
        [_itemListName visibal:NO];
        [_itemName visibal:YES];
    }
}

#pragma mark - netWork
- (void)getPerformanceTargetDetailInMonth:(NSDate *)month {
    
    NSDate *day = month;
    NSInteger beginTime = 0;
    NSInteger endTime = 0;
    if (nil != day) {
        ////计算开始时间和结束时间
        NSDate *beginDate = nil;
        NSDate *endDate = nil;
        beginDate = [[day GetFirstDayInThisMonth] GetlocaleDate];
        endDate = [[day GetLastDayInThisMonth] GetlocaleDate];
        beginTime = [NSNumber numberWithLongLong:([DateUtils getStartTimeOfDate:beginDate]/1000)].integerValue;
        endTime = [NSNumber numberWithLongLong:([DateUtils getEndTimeOfDate:endDate]/1000)].integerValue;
    }
    
    // 请求业绩目标详情
    __weak PerformanceGoalDetailView *weakSelf = self;
    if ([ObjectUtil isNotNull:_userPerformanceTargetVo.userId] && [ObjectUtil isNotNull:_shopId]){

        [_service performanceTargetDetail:_userPerformanceTargetVo.userId shopId:_shopId startDate:beginTime endDate:endTime completionHandler:^(id json) {
            if (!weakSelf) return ;
            [weakSelf responseSuccess:json];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }
}


- (void)responseSuccess:(id)json {
    
    self.performanceIdByMonth = [ObjectUtil getIntegerValue:json key:@"targetDetailId"];
    NSArray *temp = [json objectForKey:@"performanceDetailVoList"];
    if ([ObjectUtil isNotEmpty:temp]) {
        [_calendarView updateGoalbyList:temp];//更新到日历
    }else{
        
        [_calendarView updateGoalbyList:nil];//清空日历
    }
}



- (void)saveGoalList {
    
    NSString *operate =  _isAdd ? @"add" : @"edit";
    //按月
    if ([self.calendarView.monthView isEveryDaySameGoal]) {
        
        NSDictionary *dic = [self.calendarView.monthView getEveryDaySameGoal];
        NSString *saleTargetDay = [dic objectForKey:@"saleTargetDay"];
        NSDateComponents *dateComponents = [dic objectForKey:@"NSDateComponents"];
        NSInteger lastVer = [ObjectUtil getIntegerValue:dic key:@"lastVer"];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate *day = [calendar dateFromComponents:dateComponents];
        NSInteger beginTime = 0;
        NSInteger endTime = 0;
        if (nil != day) {
            ////计算开始时间和结束时间
            NSDate *beginDate = nil;
            NSDate *endDate = nil;
            beginDate = [[day GetFirstDayInThisMonth] GetlocaleDate];
            endDate = [[day GetLastDayInThisMonth] GetlocaleDate];
            beginTime = [NSNumber numberWithLongLong:([DateUtils getStartTimeOfDate:beginDate]/1000)].integerValue;
            endTime = [NSNumber numberWithLongLong:([DateUtils getEndTimeOfDate:endDate]/1000)].integerValue;
        }

        PerformanceDetailVo *detailVo = [[PerformanceDetailVo alloc]init];
        detailVo.startDate = beginTime;
        detailVo.endDate = endTime;
        detailVo.saleTargetDay = saleTargetDay;
        detailVo.performanceId = self.performanceIdByMonth;
        detailVo.collectType = 3;
        detailVo.lastVer = lastVer;
        
        
        __weak PerformanceGoalDetailView *weakSelf = self;
        if ([ObjectUtil isNull:saleTargetDay] || [saleTargetDay isEqualToString:@""]) {
            [AlertBox show:@"该月的业绩目标未发生变化，请修改后再保存！"];
            return;
        }
        if ([ObjectUtil isNotNull:_userPerformanceTargetVo.userId] && [ObjectUtil isNotNull:_shopId]){
            [_service performanceTargetAdd:_userPerformanceTargetVo.userId shopId:_shopId performanceDetailVo:detailVo operateType:operate completionHandler:^(id json) {
                if (!weakSelf) return ;
                [weakSelf responseSave:json];
            } errorHandler:^(id json) {
                [AlertBox show:json];
            }];
        }else{
            if ([ObjectUtil isNull:_userPerformanceTargetVo.userId]) {
                [AlertBox show:@"请选择员工!"];
            }
        }
        
        
    }
    else//按日
    {
        NSArray *arr = [self.calendarView.monthView getGoal];
        _performanceDetailVoList = nil;
        _performanceDetailVoList = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in arr)
        {
            NSString *saleTargetDay = [dic objectForKey:@"saleTargetDay"];
            NSDateComponents *dateComponents = [dic objectForKey:@"NSDateComponents"];
            NSInteger performanceId = [ObjectUtil getIntegerValue:dic key:@"performanceId"];
            NSInteger lastVer = [ObjectUtil getIntegerValue:dic key:@"lastVer"];
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDate *day = [calendar dateFromComponents:dateComponents];
            NSInteger beginTime = 0;
            NSInteger endTime = 0;
            if (nil != day) {
                ////计算开始时间和结束时间
                NSDate *beginDate = nil;
                NSDate *endDate = nil;
                beginDate = [day GetlocaleDate];
                endDate = [day GetlocaleDate];

                beginTime = [NSNumber numberWithLongLong:([DateUtils getStartTimeOfDate:beginDate]/1000)].integerValue;
                endTime = [NSNumber numberWithLongLong:([DateUtils getEndTimeOfDate:endDate]/1000)].integerValue;
            }

            PerformanceDetailVo *detailVo = [[PerformanceDetailVo alloc]init];
            detailVo.startDate = beginTime;
            detailVo.endDate = endTime;
            detailVo.saleTargetDay = saleTargetDay;
            detailVo.performanceId = performanceId;
            detailVo.collectType = 1;
            detailVo.lastVer = lastVer;
            [_performanceDetailVoList addObject:detailVo];
            
            
            
        }//for
        __weak PerformanceGoalDetailView *weakSelf = self;
        if ([ObjectUtil isEmpty:_performanceDetailVoList]) {
            [AlertBox show:@"该月的业绩目标未发生变化，请修改后再保存！"];
            return;
        }
        if ([ObjectUtil isNotNull:_userPerformanceTargetVo.userId] && [ObjectUtil isNotNull:_shopId]) {
            [_service performanceTargetAdd:_userPerformanceTargetVo.userId shopId:_shopId dateAndPerformanceList:_performanceDetailVoList operateType:operate completionHandler:^(id json) {
                if (!weakSelf) return ;
                [weakSelf responseSave:json];
            } errorHandler:^(id json) {
                [AlertBox show:json];
            }];
        }else{
            if ([ObjectUtil isNull:_userPerformanceTargetVo.userId]) {
                [AlertBox show:@"请选择员工!"];
            }
        }

    }//else
    
}

- (void)responseSave:(id)json{
    if (_isAdd) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
    }else{
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
    }
    
    [self.navigationController popViewControllerAnimated:NO];
    [_parent loadData];
}



#pragma mark - IEditItemListEvent代理
- (void)onItemListClick:(LSEditItemList *)obj {
    
    if (obj == _itemListName) {

        //弹出选择员工页面 , 只有“添加”点击EditItemList才有效
        SelectEmployeeListView *vc = [[SelectEmployeeListView alloc]initWithNibName:[SystemUtil getXibName:@"SelectEmployeeListView"] bundle:nil];
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        
        __weak PerformanceGoalDetailView* weakSelf = self;
        vc.selectedUerId = self.itemListName.getStrVal;
        [vc loadDataWithCallBack:^(NSDictionary *selectUser) {
            
            [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [weakSelf.navigationController popViewControllerAnimated:NO];
            
            BOOL isChangeUser = NO;
            if (![[selectUser objectForKey:@"userId"] isEqualToString:_userPerformanceTargetVo.userId]) {
                _userPerformanceTargetVo.userId = [selectUser objectForKey:@"userId"];
                isChangeUser = YES;
            }else{
                _userPerformanceTargetVo.userId = [selectUser objectForKey:@"userId"];
                isChangeUser = NO;
            }
            NSString *userName = [ObjectUtil getStringValue:selectUser key:@"name"];;
            NSString *userMobile = [ObjectUtil getStringValue:selectUser key:@"mobile"];
            self.shopId = [ObjectUtil getStringValue:selectUser key:@"shopid"];
            
            if ([ObjectUtil isNotNull:userMobile] && ![userMobile isEqualToString:@""]) {
                [weakSelf.itemMobile initData:userMobile];
            }else{
                [weakSelf.itemMobile initData:@"-"];
            }
            
            if ([ObjectUtil isNotNull:userName]) {
                [weakSelf.itemListName changeData:userName withVal:_userPerformanceTargetVo.userId];
            }else{//选择为空不处理
                //[weakSelf.itemListName changeData:@"请选择" withVal:nil];
            }
            
            [weakSelf isUIchange];
            
            if (isChangeUser) {
                //选择完员工重新去加载一遍数据
                [weakSelf getPerformanceTargetDetailInMonth:_month];
                [weakSelf.itemGoal initData:nil withVal:nil];
            }
        }];

    }else if (obj == _itemGoal){
        
        if (_isAdd && [ObjectUtil isNull:_userPerformanceTargetVo.userId]) {
            [AlertBox show:@"请先选择员工"];
            return;
        }
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:NO isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:6 digitLimit:0];
        [SymbolNumberInputBox initData:self.itemGoal.lblVal.text];
    }
}

#pragma mark - SymbolNumberInputClient代理 (输入提成比例回调)
- (void)numberClientInput:(NSString *)val event:(NSInteger)eventType{
    
    if (![NSString isPositiveNum:val] || (val.length > 6)) {
        [AlertBox show:@"业绩目标为整数,且不得大于6位,请重新输入。"];
        return;
    }
    
    [self.itemGoal initData:val withVal:val];
    [_calendarView setSaleGoal:val];
    [self isUIchange];
}


#pragma mark - INavigateEvent代理  (导航)
- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event{
   
    if (event == LSNavigationBarButtonDirectLeft) {
        if (_isAdd) {
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        }else{
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        }
        
        [self.navigationController popViewControllerAnimated:NO];
    } else {
        [self saveGoalList];
    }
}


#pragma mark - CalendarViewDelegate methods
- (void)clickPreMonth:(NSDate *)preMonth{
    [self getPerformanceTargetDetailInMonth:preMonth];
    [self isUIchange];
}
- (void)clickNextMonth:(NSDate *)nextMonth{
    [self getPerformanceTargetDetailInMonth:nextMonth];
    [self isUIchange];
}

#pragma mark - UI change
- (BOOL)isUIchange {
    
    NSInteger changeCount = 0;
    if ([self.itemListName isChange]) {
        changeCount += 1;
    }
    
    if ([_calendarView isGoalChange]) {
        changeCount += 1;
    }
    
    if (changeCount > 0) {
        if (_isAdd) {
            [self editTitle:NO act:ACTION_CONSTANTS_ADD];
        }else{
            [self editTitle:YES act:ACTION_CONSTANTS_EDIT];
        }
        return YES;
    }else{
        if (_isAdd) {
            [self configTitle:@"添加" leftPath:Head_ICON_BACK rightPath:nil];
        }else{
            [self editTitle:NO act:ACTION_CONSTANTS_EDIT];
        }
        return NO;
    }
}

#pragma mark - 参数检查
- (BOOL)isValid {
    return YES;
}
@end
