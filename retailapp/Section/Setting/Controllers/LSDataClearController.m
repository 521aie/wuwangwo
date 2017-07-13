//
//  LSDataClearController.m
//  retailapp
//
//  Created by guozhi on 2017/1/6.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//
#define TAG_LST_CLEAT_TYPE 1
#define TAG_LST_START_TIME 2
#define TAG_LST_END_TIME 3
#import "LSDataClearController.h"
#import "XHAnimalUtil.h"
#import "UIHelper.h"
#import "LSEditItemList.h"
#import "OptionPickerBox.h"
#import "SelectShopListView.h"
#import "NameItemVO.h"
#import "DateUtils.h"
#import "DatePickerBox.h"
#import "SignUtil.h"
@interface LSDataClearController () <IEditItemListEvent, DatePickerClient>

@property (nonatomic,strong) UIScrollView* scrollView;
@property (nonatomic,strong) UIView* container;
/** 门店仓库 */
@property (nonatomic, strong) LSEditItemList *lstShop;
/** 开始时间 */
@property (nonatomic, strong) LSEditItemList *lstStartTime;
/** 结束时间 */
@property (nonatomic, strong) LSEditItemList *lstEndTime;
/** <#注释#> */
@property (nonatomic, strong) UILabel *lblExplain;
/** 判断连锁选择的是门店还是仓库 如果是仓库是不显示清理模块的 */
@property (nonatomic, assign) BOOL isShop;
/** <#注释#> */
@property (nonatomic, copy) NSString *shopEntityId;
@end

@implementation LSDataClearController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    [self configConstraints];
    [self initMainView];
    [self configViewsVisibal];
    [self configHelpButton:HELP_SETTING_DATA_CLEAR];
    
}

- (void)configViews {
    //设置背景透明度
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    //设置标题
    [self configTitle:@"营业数据清理" leftPath:Head_ICON_BACK rightPath:nil];
    //设置scrollView
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.scrollView];
}

- (void)configConstraints {
    __weak typeof(self) wself = self;
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself.view);
        make.top.equalTo(wself.view.top).offset(kNavH);
    }];
}

- (void)initMainView {
    self.container = [[UIView alloc] init];
    self.container.ls_width = SCREEN_W;
    [self.scrollView addSubview:self.container];
    //清理图片
    UIView *viewDaraClear = [self createDataClearImage];
    [self.container addSubview:viewDaraClear];
    //门店/仓库
    self.lstShop = [LSEditItemList editItemList];
    [self.lstShop initLabel:@"门店" withHit:nil delegate:self];
    if ([[Platform Instance] getShopMode] != 1) {
        [self.lstShop initData:@"请选择" withVal:nil];
    } else {
        [self.lstShop initData:[[Platform Instance] getkey:SHOP_NAME] withVal:[[Platform Instance] getkey:SHOP_ID]];
        self.shopEntityId = [[Platform Instance] getkey:RELEVANCE_ENTITY_ID];
    }
    self.lstShop.imgMore.image = [UIImage imageNamed:@"ico_next"];
    [self.container addSubview:self.lstShop];

    //开始时间
    /*当清理模块为营业数据时
     显示：显示【开始时间】和【结束时间】两栏，默认都为当日日期，营业数据可以根据时间清理*/
    self.lstStartTime = [LSEditItemList editItemList];
    if ([[Platform Instance] getShopMode] == 1) {
        [self.lstStartTime initLabel:@"开始时间" withHit:nil delegate:self];
    } else {
        [self.lstStartTime initLabel:@"▪︎ 开始时间" withHit:nil delegate:self];
    }
    
    self.lstStartTime.tag = TAG_LST_START_TIME;
    NSDate *date = [[NSDate date] dateByAddingTimeInterval:-24*60*60];
    NSString *dateStr = [DateUtils formateDate2:date];
    [self.lstStartTime initData:dateStr withVal:dateStr];
    [self.container addSubview:self.lstStartTime];
    //结束时间
    self.lstEndTime = [LSEditItemList editItemList];
    if ([[Platform Instance] getShopMode] == 1) {
        [self.lstEndTime initLabel:@"结束时间" withHit:nil delegate:self];
    } else {
         [self.lstEndTime initLabel:@"▪︎ 结束时间" withHit:nil delegate:self];
    }
   
    self.lstEndTime.tag = TAG_LST_END_TIME;
     [self.lstEndTime initData:dateStr withVal:dateStr];
    [self.container addSubview:self.lstEndTime];
    //数据清理按钮
    UIButton *btn = [LSViewFactor addRedButton:self.container title:@"清理账单、报表等营业数据" y:0];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    //说明文字
    NSString *text = @"系统仅清理指定日期范围内在销售、退货过程中产生的数据，如：交易流水、交接班、报表等。（交易进行中的销售、退货数据不会被清理。）数据清理后不可再恢复，请谨慎使用！";
    self.lblExplain =  [LSViewFactor addExplainText:self.container text:text y:0];
    
}

#pragma 控制显示模块
- (void)configViewsVisibal {
    //数据清理模块连s锁只有总部用户才有连锁门店没有数据清理
    //单店有数据清理
    if ([[Platform Instance] getShopMode] == 3) {//连锁总部
        [self.lstShop visibal:YES];
        //当【门店/仓库】选择的对象为门店时，在下方显示【清理模块】一栏
    } else if ([[Platform Instance] getShopMode] == 1) {//单店
        [self.lstShop visibal:NO];
    }
    if ([[self.lstShop getDataLabel] isEqualToString:@"请选择"]) {
        [self.lstStartTime visibal:NO];
        [self.lstEndTime visibal:NO];
    } else {
        [self.lstStartTime visibal:YES];
        [self.lstEndTime visibal:YES];
    }
    /*当清理模块为营业数据时
    显示：显示【开始时间】和【结束时间】两栏，默认都为当日日期，营业数据可以根据时间清理*/
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

//数据清理图片
- (UIView *)createDataClearImage {
    UIView *view = [[UIView alloc] init];
    //数据清理
    UIImageView *imgDataClear = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"setting_dataclear"]];
    [view addSubview:imgDataClear];
    [imgDataClear makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(view);
    }];
    view.frame = CGRectMake(0, 0, SCREEN_W, imgDataClear.ls_width + 60);
    //分割线
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [view addSubview:line];
    CGFloat margin = 10;
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(margin);
        make.right.equalTo(view).offset(-margin);
        make.bottom.equalTo(view);
        make.height.equalTo(1);
    }];
    
    
    return view;
}


#pragma mark - <IEditItemListEvent>
- (void)onItemListClick:(LSEditItemList *)obj {
    if (obj == self.lstShop) {//门店
        //选择门店
        SelectShopListView *vc = [[SelectShopListView alloc] init];
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        __weak typeof(self) wself = self;
        [vc loadShopList:[obj getStrVal] withType:0 withViewType:NOT_CONTAIN_ALL withIsPush:YES callBack:^(id<ITreeItem> shop) {
            [wself.navigationController popViewControllerAnimated:NO];
            if (shop) {
                [wself.lstShop initData:[shop obtainItemName] withVal:[shop obtainItemId]];
                wself.shopEntityId = [shop obtainShopEntityId];
                wself.isShop = YES;
                [wself configViewsVisibal];
            }
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        }];


    } else if (obj == self.lstStartTime || obj == self.lstEndTime) {//开始时间 结束时间
        NSDate *date = [DateUtils parseDateTime4:obj.lblVal.text];
        [DatePickerBox show:obj.lblName.text date:date client:self event:obj.tag];
        if (obj == self.lstEndTime) {
            //结束时间仅能清理前一天之前的数据
            [DatePickerBox setMaximumDate:[[NSDate date] dateByAddingTimeInterval:-24*60*60]];
        } else if (obj == self.lstStartTime) {
             //开始日期小于结束日期
            NSDate *endDate = [DateUtils parseDateTime4:self.lstEndTime.lblVal.text];
            [DatePickerBox setMaximumDate:endDate];
        }
    }
}


#pragma mark - <DatePickerClient>
- (BOOL)pickDate:(NSDate *)date event:(NSInteger)event {
    NSString *dateStr = [DateUtils formateDate2:date];
    if (event == TAG_LST_START_TIME) {
        [self.lstStartTime initData:dateStr withVal:dateStr];
    } else {
        [self.lstEndTime initData:dateStr withVal:dateStr];
    }
    return YES;
}
#pragma mark - 清理记录点击事件
- (void)btnClick:(UIButton *)btn {
    if ([self isVaild]) {
        //弹出密码框
        __weak typeof(self) wself = self;
        [LSAlertHelper showAlertTextInput:@"登录密码" message:nil block:^(NSString *text) {
            if ([NSString isBlank:text]) {
                [LSAlertHelper showAlert:@"请输入登录密码!"];
                return;
            }
            text = [text uppercaseString];
            NSString *password = [SignUtil convertPassword:text];
            [wself checkPassword:password];
            
        }];
    }
    
}

#pragma mark - 密码check
- (void)checkPassword:(NSString *)password {
    __weak typeof(self) wself = self;
    NSString *url = @"shop/v1/shopClearCheck";
    NSString *shopId = [self.lstShop getStrVal];
    NSDictionary *param = @{@"shopId" : shopId,
                            @"password" : password,
                            @"shopEntityId" : self.shopEntityId};
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
       [wself businessDataClear:password];
        
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json];
    }];
}

#pragma mark - 数据清理(全部)
- (void)dataClear:(NSString *)password {
    NSString *url = @"shop/v1/shopClear";
    NSString *shopId = [self.lstShop getStrVal];
    NSDictionary *param = @{@"shopId" : shopId,
                            @"password" : password,
                            @"shopEntityId" : self.shopEntityId};
    __weak typeof(self) wself = self;
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        [wself dataClearSucess];
        
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json];
    }];
}
#pragma mark - 数据清理(营业数据)
- (void)businessDataClear:(NSString *)password {
    NSString *url = @"shop/clearBusinessData";
    long long startTime = [DateUtils getStartTime:[self.lstStartTime getDataLabel]];
    long long endTime = [DateUtils getEndTime:[self.lstEndTime getDataLabel]];
    NSString *shopId = [self.lstShop getStrVal];
    NSDictionary *param = @{@"shopId" : shopId,
                            @"password" : password,
                            @"dateFrom" : @(startTime),
                            @"dateTo" : @(endTime),
                            @"shopEntityId" : self.shopEntityId};
    __weak typeof(self) wself = self;
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        [wself dataClearSucess];
        
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json];
    }];

}

#pragma mark - 数据清理成功
- (void)dataClearSucess {
     [LSAlertHelper showAlert:@"数据正在清理中，大概用时十到二十分钟，为确保数据准确，在数据清理时，请不要对店铺进行操作。"];
}


- (BOOL)isVaild {
    if (self.lstShop.hidden == NO && [[self.lstShop getDataLabel] isEqualToString:@"请选择"]) {
        [LSAlertHelper showAlert:@"请选择需要清理数据的门店!"];
        return NO;
    }
    NSDate *startDate = [DateUtils parseDateTime4:[self.lstStartTime getStrVal]];
    if (![DateUtils daysToNow:startDate]) {
        return NO;
    }
    if (self.lstStartTime.hidden == NO) {
        NSString *startDate = [self.lstStartTime getDataLabel];
        NSString *endDate = [self.lstEndTime getDataLabel];
        if ([startDate compare:endDate] == NSOrderedDescending) {
            [LSAlertHelper showAlert:@"开始日期不能大于结束日期!"];
            return NO;
        }
    }
    return YES;
}
@end
