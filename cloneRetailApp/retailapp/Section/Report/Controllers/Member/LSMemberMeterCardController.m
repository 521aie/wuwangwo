//
//  LSMemberMeterCardController.m
//  retailapp
//
//  Created by wuwangwo on 2017/4/1.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#define TAG_LST_TRANSACTION_TIME 1
#define TAG_LST_TRANSACTION_START_TIME 2
#define TAG_LST_TRANSACTION_END_TIME 3
#define TAG_LST_ORDER_SOURCE 4

#import "LSMemberMeterCardController.h"
#import "IEditItemListEvent.h"
#import "OptionPickerClient.h"
#import "INameItem.h"
#import "DatePickerBox.h"
#import "XHAnimalUtil.h"
#import "LSEditItemList.h"
#import "LSEditItemText.h"
#import "UIHelper.h"
#import "OptionPickerBox.h"
#import "MenuList.h"
#import "DateUtils.h"
#import "NSString+Estimate.h"
#import "SelectShopListView.h"
#import "AlertBox.h"
#import "NSString+Estimate.h"
#import "ServiceFactory.h"
#import "LSMemberMeterCardListController.h"
#import "MobClick.h"
#import "INavigateEvent.h"

@interface LSMemberMeterCardController ()<INavigateEvent,IEditItemListEvent,OptionPickerClient,DatePickerClient>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *container;
/**充值时间*/
@property (strong, nonatomic) LSEditItemList *LstTransactionTime;
/**开始时间*/
@property (strong, nonatomic) LSEditItemList *LstStartTime;
/**结束时间*/
@property (strong, nonatomic) LSEditItemList *LstEndTime;
/**交易门店*/
@property (strong, nonatomic) LSEditItemList *LstTransactionShop;
/**查询条件:会员卡号/手机号*/
@property (nonatomic, strong) LSEditItemText *keyWords;
@property (nonatomic, strong) NSMutableDictionary *param;
/*<门店id>*/
@property (nonatomic ,copy) NSString *shopId;
@property (nonatomic, copy) NSString *shopEntityId;
@end

@implementation LSMemberMeterCardController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self configViews];
    [self configContainerViews];
    [self initData];
}

- (void)configViews {
    
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [self configTitle:@"计次充值记录" leftPath:Head_ICON_BACK rightPath:nil];
    
    //scollVIew
    self.scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view.top).offset(64);
    }];
    
    //container
    self.container = [[UIView alloc] init];
    self.container.ls_width = SCREEN_W;
    [self.scrollView addSubview:self.container];
}

- (void)configContainerViews {
    
    self.LstTransactionTime = [LSEditItemList editItemList];
    [self.LstTransactionTime initLabel:@"充值时间" withHit:nil delegate:self];
    [self.container addSubview:self.LstTransactionTime];
    
    self.LstStartTime = [LSEditItemList editItemList];
    [self.LstStartTime initLabel:@"▪︎ 开始日期" withHit:nil isrequest:NO delegate:self];
    [self.container addSubview:self.LstStartTime];
    
    self.LstEndTime = [LSEditItemList editItemList];
    [self.LstEndTime initLabel:@"▪︎ 结束日期" withHit:nil isrequest:NO delegate:self];
    [self.container addSubview:self.LstEndTime];
    
    self.LstTransactionShop = [LSEditItemList editItemList];
    [self.LstTransactionShop initLabel:@"充值门店" withHit:nil delegate:self];
    [self.container addSubview:self.LstTransactionShop];
    
    self.keyWords = [LSEditItemText editItemText];
    [self.keyWords initLabel:@"查询条件" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    self.keyWords.txtVal.placeholder = @"会员卡号/手机号";
    [self.container addSubview:self.keyWords];
    
    UIButton *btn = [LSViewFactor addGreenButton:self.container title:@"查询" y:0];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
//    NSString *text = @"提示：可以根据上面的条件查询相应的计次充值记录。";
//    [LSViewFactor addExplainText:self.container text:text y:0];
    
    self.LstTransactionTime.tag = TAG_LST_TRANSACTION_TIME;
    self.LstStartTime.tag = TAG_LST_TRANSACTION_START_TIME;
    self.LstEndTime.tag = TAG_LST_TRANSACTION_TIME;
    self.keyWords.tag = 1000;
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

#pragma mark - 导航栏点击事件
- (void)onNavigateEvent:(LSNavigationBarButtonDirect)direct {
    
    if (direct == LSNavigationBarButtonDirectLeft) {
        
        [self popViewController];
    }
}

#pragma mark - 初始化页面数据
- (void)initData {
    
    NSDate *date=[NSDate date];
    NSString *dateStr=[DateUtils formateDate2:date];
    [self.LstTransactionTime initData:@"今天" withVal:@"0"];
    [self.LstStartTime initData:dateStr withVal:dateStr];
    [self.LstStartTime visibal:NO];
    [self.LstEndTime initData:dateStr withVal:dateStr];
    [self.LstEndTime visibal:NO];
    
    [self.LstTransactionShop initData:@"全部" withVal:@""];
    self.LstTransactionShop.imgMore.image = [UIImage imageNamed:@"ico_next"];
    
    //连锁总部只有选择实体门店时才显示门店机构用户都显示
    self.shopEntityId = [[Platform Instance] getkey:RELEVANCE_ENTITY_ID];
    [self showShop];
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void)showShop{
    
    //连锁总部/机构显示（没有门店则不显示），门店隐藏；单店隐藏
    if ([[Platform Instance] getShopMode] == 3) {
        
        [self.LstTransactionShop visibal:YES];
        
    }else{
        
        [self.LstTransactionShop visibal:NO];
    }
}

#pragma mark - 查询会员充值记录所需要的参数
- (NSMutableDictionary *)param {
    
    if (_param == nil) {
        
        _param = [[NSMutableDictionary alloc] init];
    }
    
    [_param removeAllObjects];
    
    if ([NSString isNotBlank:self.keyWords.txtVal.text]) {
        
        [_param setValue:self.keyWords.txtVal.text forKey:@"keyWord"];
    }
    
    if ([self.LstTransactionTime.lblVal.text isEqualToString:@"自定义"]) {
        
        [_param setValue:[NSNumber numberWithLongLong:
                           [DateUtils converStartTime:self.LstStartTime.lblVal.text]] forKey:@"startTime"];
        [_param setValue:[NSNumber numberWithLongLong:
                           [DateUtils converEndTime:self.LstEndTime.lblVal.text]] forKey:@"endTime"];
        
    } else {
        
        [_param setValue:[NSNumber numberWithLongLong:
                           [DateUtils converStartTime:self.LstTransactionTime.lblVal.text]] forKey:@"startTime"];
        [_param setValue:[NSNumber numberWithLongLong:
                           [DateUtils converEndTime:self.LstTransactionTime.lblVal.text]] forKey:@"endTime"];
    }
    
    [_param setValue:self.shopEntityId forKey:@"shopEntityId"];
    [_param setValue:@"false" forKey:@"is_only_search_mobile"];
    
    return _param;
}

#pragma mark - 点击事件弹出下拉框
- (void)onItemListClick:(LSEditItemList *)obj {
    
    if (obj == self.LstStartTime || obj == self.LstEndTime) {
        
        NSDate *date = [NSDate date];
        
        if ([NSString isNotBlank:obj.lblVal.text]) {
            
            date = [DateUtils parseDateTime4:obj.lblVal.text];
        }
        
        [DatePickerBox show:obj.lblName.text date:date client:self event:obj.tag];
        
    }  else if (obj == self.LstTransactionShop) {
        
        SelectShopListView *vc = [[SelectShopListView alloc] init];
        [self pushViewController:vc];
        
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        
        //连锁情况下总部进入显示“全部”，连锁门店进入显示该门店的名称
        if ([[Platform Instance] isTopOrg]) {
            
            [vc loadShopList:[obj getStrVal] withType:3 withViewType:CONTAIN_ALL withIsPush:YES callBack:^(id<ITreeItem>shop) {
                
                [self popViewController];
                
                if (shop) {
                    
                    [self.LstTransactionShop initData:[shop obtainItemName] withVal:[(NSObject *)shop valueForKey:@"entityId"]];
                    self.shopId = [[shop obtainItemId] isEqualToString:@"0"] ? @"" : [shop obtainItemId];
                }
                
                self.shopEntityId = [shop obtainShopEntityId];
                
                [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            }];
        } else {
            
            [vc loadShopList:[obj getStrVal] withType:2 withViewType:NOT_CONTAIN_ALL withIsPush:YES callBack:^(id<ITreeItem>shop) {
                
                [self popViewController];
                
                if (shop) {
                    
                    [self.LstTransactionShop initData:[shop obtainItemName] withVal:[(NSObject *)shop valueForKey:@"entityId"]];
                    self.shopId = [[shop obtainItemId] isEqualToString:@"0"] ? @"" : [shop obtainItemId];
                }
                
                self.shopEntityId = [shop obtainShopEntityId];
                [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];                
            }];
        }
    }  else {
        
        NSArray *listItems;
        
        if (obj == self.LstTransactionTime) {
            
            listItems = @[@"今天",@"昨天",@"本周",@"上周",@"本月",@"上月",@"自定义"];
        }
        
        [OptionPickerBox initData:[MenuList list1FromArray:listItems] itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    }
}

#pragma mark - 选择下拉框某一内容
- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType {
    
    id<INameItem> item = (id<INameItem>)selectObj;
    
    if (eventType == TAG_LST_TRANSACTION_TIME) {
        
        [self.LstTransactionTime initData:[item obtainItemName] withVal:[item obtainItemId]];
        
        if ([[item obtainItemName] isEqualToString:@"自定义"]) {
            
            [self.LstStartTime visibal:YES];
            [self.LstEndTime visibal:YES];
            
        } else {
            
            [self.LstStartTime visibal:NO];
            [self.LstEndTime visibal:NO];
        }
    }
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
   
    return YES;
}

#pragma mark - 选择日期
- (BOOL)pickDate:(NSDate *)date event:(NSInteger)event {
    
    NSString *dateStr = [DateUtils formateDate2:date];
    
    if (event == TAG_LST_TRANSACTION_START_TIME) {
        
        [self.LstStartTime initData:dateStr withVal:dateStr];
        
    } else {
        
        [self.LstEndTime initData:dateStr withVal:dateStr];
    }
    
    return YES;
}

#pragma mark - 点击查询按钮
- (void)btnClick:(UIButton *)sender {
    
    if ([self isValid]) {
        
        [MobClick event:@"Report_ByTimeRechargeRecords_Query"];
        
        LSMemberMeterCardListController *vc = [[LSMemberMeterCardListController alloc] init];
        vc.param = self.param;
        vc.exportParam = [[NSMutableDictionary alloc] initWithDictionary:self.param];
        
        [self pushViewController:vc];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    }
}

#pragma mark - 是否满足查询条件
- (BOOL)isValid {
    
    NSDate *startDate = [DateUtils parseDateTime4:[self.LstStartTime getStrVal]];
    NSDate *endDate = [DateUtils parseDateTime4:[self.LstEndTime getStrVal]];
    
    if (self.LstStartTime.hidden == NO) {
        
        if (![DateUtils daysToNow:startDate]) {
            
            return NO;
        }
        
        if ([startDate compare:endDate] == NSOrderedDescending) {
            
            [AlertBox show:@"开始日期不能大于结束日期!"];
            return NO;
        }
    }
    
    if ([NSString isBlank:self.keyWords.txtVal.text]) {
        
        return YES;
    }
    
    if ([NSString isNotNumAndLetter1:self.keyWords.txtVal.text]) {
        
        [AlertBox show:ALERT_MESSAGE_PHONE];
        return NO;
    }
    
    return YES;
}

@end
