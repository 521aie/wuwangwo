//
//  LSMemberRechargeViewReportController.m
//  retailapp
//
//  Created by guozhi on 2017/1/9.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//
#define TAG_LST_TRANSACTION_TIME 1
#define TAG_LST_TRANSACTION_START_TIME 2
#define TAG_LST_TRANSACTION_END_TIME 3
#define TAG_LST_ORDER_SOURCE 4
#import "LSMemberRechargeViewReportController.h"
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
#import "LSMemberRechargeReportListController.h"

@interface LSMemberRechargeViewReportController ()<IEditItemListEvent,OptionPickerClient,DatePickerClient>
/**手机号码*/
@property (strong, nonatomic) LSEditItemText *txtPhoneNumber;
/**充值时间*/
@property (strong, nonatomic) LSEditItemList *LstTransactionTime;
/**开始时间*/
@property (strong, nonatomic) LSEditItemList *LstStartTime;
/**结束时间*/
@property (strong, nonatomic) LSEditItemList *LstEndTime;
/**充值方式*/
@property (strong, nonatomic) LSEditItemList *LstOrderSource;
/**交易门店*/
@property (strong, nonatomic) LSEditItemList *LstTransactionShop;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *container;
/**type用来区分是连锁机构还是门店*/
@property (nonatomic ,assign) NSInteger type;
/**查询会员充值记录列表所需要的参数*/
@property (nonatomic, strong) NSMutableDictionary *param;
@property (nonatomic ,strong) NSString *shopId;/*<门店id>*/
@property (nonatomic, copy) NSString *shopEntityId;
@end

@implementation LSMemberRechargeViewReportController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    [self configContainerViews];
    [self initData];
}
- (void)configViews {
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    //标题
    [self configTitle:@"会员充值记录" leftPath:Head_ICON_BACK rightPath:nil];
    
#warning “jicika"
//    [self configTitle:@"储值充值记录" leftPath:Head_ICON_BACK rightPath:nil];
    //scollVIew
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    [self.view addSubview:self.scrollView];
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
    
    self.LstOrderSource = [LSEditItemList editItemList];
    [self.LstOrderSource initLabel:@"充值方式" withHit:nil delegate:self];
    [self.container addSubview:self.LstOrderSource];
    [self showType];
    
    self.txtPhoneNumber = [LSEditItemText editItemText];
    [self.txtPhoneNumber visibal:NO];
    [self.txtPhoneNumber initLabel:@"查询条件" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    self.txtPhoneNumber.isShowStatus = YES;
    self.txtPhoneNumber.txtVal.placeholder = @"会员卡号/手机号";
    [self.container addSubview:self.txtPhoneNumber];
    
    UIButton *btn = [LSViewFactor addGreenButton:self.container title:@"查询" y:0];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *text = @"提示：可以根据上面的条件查询相应的会员充值记录。";
    
#warning “jicika"
//    NSString *text = @"提示：可以根据上面的条件查询相应的储值充值记录。";
    
    [LSViewFactor addExplainText:self.container text:text y:0];
    self.LstTransactionTime.tag = TAG_LST_TRANSACTION_TIME;
    self.LstStartTime.tag = TAG_LST_TRANSACTION_START_TIME;
    self.LstEndTime.tag = TAG_LST_TRANSACTION_TIME;
    self.LstOrderSource.tag = TAG_LST_ORDER_SOURCE;
    self.txtPhoneNumber.tag = 1000;
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void)showShop{
    //连锁机构用户登录时固定显示
    if ([[Platform Instance] getShopMode] == 3) {
        [self.LstTransactionShop visibal:YES];
    }else{
        [self.LstTransactionShop visibal:NO];
    }
}

- (void)showType {
    //连锁机构用户登录时显示；
    if ([[Platform Instance] getShopMode] == 3) {
        [self.LstOrderSource visibal:YES];
    }else{
        if ([[Platform Instance] getMicroShopStatus] == 2) {//开通微店显示
            [self.LstOrderSource visibal:YES];
        }else{
            [self.LstOrderSource visibal:NO];
        }
    }
}


#pragma mark - 初始化页面数据
- (void)initData {
    [self.LstTransactionTime initData:@"今天" withVal:@"0"];
    NSDate *date=[NSDate date];
    NSString *dateStr=[DateUtils formateDate2:date];
    [self.LstStartTime initData:dateStr withVal:dateStr];
    [self.LstStartTime visibal:NO];
    [self.LstEndTime initData:dateStr withVal:dateStr];
    [self.LstEndTime visibal:NO];
    
    [self.LstTransactionShop initData:@"全部" withVal:@""];
    self.LstTransactionShop.imgMore.image = [UIImage imageNamed:@"ico_next"];
    //连锁总部只有选择实体门店时才显示门店机构用户都显示
    self.shopEntityId = [[Platform Instance] getkey:RELEVANCE_ENTITY_ID];
    [self showShop];
    
    [self.LstOrderSource initData:@"全部" withVal:@""];

    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

#pragma mark - 查询储值充值记录所需要的参数
- (NSMutableDictionary *)param {
    if (_param == nil) {
        _param = [[NSMutableDictionary alloc] init];
    }
    [_param removeAllObjects];
    
//    [_param setValue:@"" forKey:@"shopId"];
//    [_param setValue:[NSNull null] forKey:@"shopEntityId"];
//    [_param setValue:@"" forKey:@"mobile"];

    if ([NSString isNotBlank:self.txtPhoneNumber.txtVal.text]) {
        [_param setValue:self.txtPhoneNumber.txtVal.text forKey:@"mobile"];
    }
    
    if ([self.LstTransactionTime.lblVal.text isEqualToString:@"自定义"]) {
        [_param setValue:[NSNumber numberWithLongLong:
                           [DateUtils converStartTime:self.LstStartTime.lblVal.text]] forKey:@"beginDate"];
        [_param setValue:[NSNumber numberWithLongLong:
                           [DateUtils converEndTime:self.LstEndTime.lblVal.text]] forKey:@"endDate"];
    }
    else {
        [_param setValue:[NSNumber numberWithLongLong:
                           [DateUtils converStartTime:self.LstTransactionTime.lblVal.text]] forKey:@"beginDate"];
        [_param setValue:[NSNumber numberWithLongLong:
                           [DateUtils converEndTime:self.LstTransactionTime.lblVal.text]] forKey:@"endDate"];
    }
    if (self.LstOrderSource.hidden == NO) {
        if ([self.LstOrderSource.lblVal.text isEqualToString:@"实体门店"]) {
            [_param setValue:@"1" forKey:@"payType"];
        }
        else if ([self.LstOrderSource.lblVal.text isEqualToString:@"微店"]) {
            [_param setValue:@"2" forKey:@"payType"];
        }
    }
    
    [_param setValue:[[Platform Instance] getkey:ENTITY_ID] forKey:@"entityId"];
    //shopId
    NSString *shopId = nil;
    NSString *saleType = [self.LstOrderSource getDataLabel];
    if (self.LstTransactionShop.hidden == NO) {
        if ([[self.LstTransactionShop getDataLabel] isEqualToString:@"全部"]) {
            shopId =  [[Platform Instance] getkey:SHOP_ID];
        }else{
            shopId = [self.LstTransactionShop getStrVal];
        }
    } else {
        shopId =  [[Platform Instance] getkey:SHOP_ID];
    }
    [_param setValue:shopId forKey:@"shopId"];
    
    if ([[Platform Instance] getShopMode] == 3 && [[self.LstTransactionShop getDataLabel] isEqualToString:@"全部"]) {
        [_param removeObjectForKey:@"shopId"];
        if ([saleType isEqualToString:@"全部"] || [saleType isEqualToString:@"微店"]) {
            [_param removeObjectForKey:@"shopEntityId"];
        } else {
            [_param setValue:shopId forKey:@"shopId"];
            [_param setValue:self.shopEntityId forKey:@"shopEntityId"];
        }
    } else {
        [_param setValue:shopId forKey:@"shopId"];
        [_param setValue:self.shopEntityId forKey:@"shopEntityId"];
    }
    return _param;
}

#pragma mark - 点击事件弹出下拉框
- (void)onItemListClick:(EditItemList *)obj {
    if (obj == self.LstStartTime || obj == self.LstEndTime) {
        NSDate *date = [NSDate date];
        if ([NSString isNotBlank:obj.lblVal.text]) {
            date = [DateUtils parseDateTime4:obj.lblVal.text];
        }
        [DatePickerBox show:obj.lblName.text date:date client:self event:obj.tag];
    }
    else if(obj == self.LstTransactionShop) {
        SelectShopListView *vc = [[SelectShopListView alloc] init];
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        [vc loadShopList:[obj getStrVal] withType:self.type withViewType:CONTAIN_ALL withIsPush:YES callBack:^(id<ITreeItem>shop) {
            [self.navigationController popViewControllerAnimated:NO];
            if (shop) {
                if ([[shop obtainItemId] isEqualToString:@"0"]) {
                    [self.LstTransactionShop initData:[shop obtainItemName] withVal:@"0"];
                } else {
                    [self.LstTransactionShop initData:[shop obtainItemName] withVal:[shop obtainItemId]];
                    self.shopEntityId = [shop obtainShopEntityId];
                }
            }
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        }];
    }
    else {
        NSArray *listItems;
        if (obj == self.LstTransactionTime) {
            listItems = @[@"今天",@"昨天",@"本周",@"上周",@"本月",@"上月",@"自定义"];
        } else if (obj == self.LstOrderSource) {
            listItems = @[@"全部",@"实体门店",@"微店"];
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
    } else if (eventType == TAG_LST_ORDER_SOURCE) {
        [self.LstOrderSource initData:[item obtainItemName] withVal:[item obtainItemId]];
        [self showShop];
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
    if ([self isValid]){
        LSMemberRechargeReportListController *vc = [[LSMemberRechargeReportListController alloc] init];
        vc.param = self.param;
        vc.exportParam = [[NSMutableDictionary alloc] initWithDictionary:self.param];
        [self.navigationController pushViewController:vc animated:NO];
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
    
    if ([NSString isBlank:self.txtPhoneNumber.txtVal.text]) {
        return YES;
    }
    if ([NSString isNotNumAndLetter1:self.txtPhoneNumber.txtVal.text]) {
        [AlertBox show:ALERT_MESSAGE_PHONE];
        return NO;
    }
    return YES;
}


@end
