//
//  ShopCommnetView.m
//  retailapp
//
//  Created by Jianyong Duan on 15/11/2.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "ShopCommnetView.h"
#import "ShopCommentTop.h"
#import "ShopCollect.h"
#import "LSEditItemList.h"

#import "CommentService.h"
#import "ServiceFactory.h"
#import "MonthReportView.h"
#import "ShopCommentReportVo.h"
#import "AlertBox.h"
#import "JsonHelper.h"
#import "NameItemVO.h"
#import "OptionPickerBox.h"
#import "SelectShopListView.h"
#import "LevelDescriptionView.h"
#import "DateUtils.h"
#import "XHAnimalUtil.h"

@interface ShopCommnetView ()<IEditItemListEvent ,OptionPickerClient,IEditItemListEvent,LSNavigationBarDelegate>

@property (nonatomic, strong) LSEditItemList *lstShopItem;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *viewContent;
@property (nonatomic, strong) ShopCommentTop *top;
@property (nonatomic, strong) ShopCollect *collect;

@property (nonatomic, strong) CommentService *commentService;
@property (nonatomic, strong) ShopCommentReportVo *totalReport; //该店开店至今综合评价
@property (nonatomic, strong) ShopCommentReportVo *thisMonthReport; //当月综合评价
@property (nonatomic, strong) NSMutableArray *reportHistoryList;
// 0 实体 1 微店
@property (nonatomic) LSShopType type;
@property (nonatomic, strong) NSString *shop_id;
@property (nonatomic, strong) NSString *modal;
@property (nonatomic, assign) BOOL isSelectAll;/*<选择查看全部>*/
@property (nonatomic, strong) NSString *shopEntityId;
@end

@implementation ShopCommnetView


// 排序
- (void)sortViewControl {
    
//    self.lstImgViewGood = [self.lstImgViewGood sortedArrayUsingComparator:^NSComparisonResult(id label1, id label2) {
//        if ([label1 frame].origin.x < [label2 frame].origin.x) return NSOrderedAscending;
//        else if ([label1 frame].origin.x > [label2 frame].origin.x) return NSOrderedDescending;
//        else return NSOrderedSame;
//    }];
}

-(instancetype)initWithType:(LSShopType)type
{
    self = [super init];
    if (self) {
        self.type = type;
        self.commentService = [ServiceFactory shareInstance].commentService;
        self.shopEntityId = [[Platform Instance] getkey:RELEVANCE_ENTITY_ID];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showHisory:) name:@"showTotal" object:nil];
    [self sortViewControl];
    [self configTitle];
    [self createViews];
}


-(void)configTitle
{
    if (self.type == LSShop_Entity) {
        [self configTitle:@"店铺评价(实体)" leftPath:Head_ICON_BACK rightPath:@""];
        [self configNavigationBar:LSNavigationBarButtonDirectRight title:@"等级说明" filePath:@""];
    }else{
        [self configTitle:@"店铺评价(微店)" leftPath:Head_ICON_BACK rightPath:@""];
        [self configNavigationBar:LSNavigationBarButtonDirectRight title:@"等级说明" filePath:@""];
    }
}

-(void)createViews
{
    self.lstShopItem= [LSEditItemList editItemList];
    self.lstShopItem.imgMore.image = [UIImage imageNamed:@"ico_next"];
    self.lstShopItem.line.hidden = YES;
    [self.lstShopItem initLabel:@"门店" withHit:nil delegate:self];
    [self.lstShopItem setBackgroundColor:[UIColor whiteColor]];
    self.lstShopItem.alpha = 0.7;
    self.lstShopItem.frame = CGRectMake(0, 64, SCREEN_W, 48);
    [self.view addSubview:self.lstShopItem];
    
    //实体
    if (self.type == LSShop_Entity) {
        if ([[Platform Instance] getShopMode] == 1) {
            //单店
            self.lstShopItem.hidden = YES;
            self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_W, 150)];
            self.scrollView.backgroundColor = [UIColor whiteColor];
            self.scrollView.alpha = 0.8;
            [self.view addSubview:self.scrollView];
        }else{
            //连锁模式
            if ([[Platform Instance] isTopOrg]) {
                //总部用户
                self.lstShopItem.tag = 1;
                self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 112, SCREEN_W, 150)];
                self.scrollView.backgroundColor = [UIColor whiteColor];
                self.scrollView.alpha = 0.8;
                [self.view addSubview:self.scrollView];
            }else if ([[Platform Instance] getShopMode] == 3){
                //总部以外机构用户登陆
                [self.lstShopItem initData:@"请选择" withVal:nil];
                self.lstShopItem.tag = 1;
                self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 112, SCREEN_W, 150)];
                self.scrollView.backgroundColor = [UIColor whiteColor];
                self.scrollView.alpha = 0.8;
                [self.view addSubview:self.scrollView];
            }else if ([[Platform Instance] getShopMode] == 2){
                //门店用户
                self.lstShopItem.hidden = YES;
                self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_W, 150)];
                self.scrollView.backgroundColor = [UIColor whiteColor];
                self.scrollView.alpha = 0.8;
                [self.view addSubview:self.scrollView];
            }
        }
        self.viewContent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.ls_width, self.scrollView.ls_height)];
        [self.scrollView addSubview:self.viewContent];
        self.top = [[ShopCommentTop alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 110)];
        [self.viewContent addSubview:self.top];
        
        self.collect = [[ShopCollect alloc] initWithFrame:CGRectMake(0, self.viewContent.frame.size.height-30, SCREEN_W, 30)];
        [self.viewContent addSubview:self.collect];
        
        //总部以外机构用户登录时，默认空白表示，只能选择门店查询具体门店的评价数据。
        if (![[Platform Instance] isTopOrg] &&[[Platform Instance] getShopMode]==3) {
            self.top.hidden = YES;
        }else{
            if ([NSString isNotBlank:self.shop_id] || [[Platform Instance] isTopOrg]) {
                [self.lstShopItem initData:@"全部" withVal:@"0"];
            }
            [self requstTotalReport];
        }
    }else{//店铺评价(微店)
        //单店
        if ([[Platform Instance] getShopMode] == 1) {
            self.lstShopItem.hidden = YES;
            self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_W, 150)];
            self.scrollView.backgroundColor = [UIColor whiteColor];
            self.scrollView.alpha = 0.8;
            [self.view addSubview:self.scrollView];
        }else{
            if ([[Platform Instance] isTopOrg]) {
                [self.lstShopItem initData:@"全部" withVal:@"0"];
                self.lstShopItem.tag = 1;
                self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 112, SCREEN_W, 150)];
                self.scrollView.backgroundColor = [UIColor whiteColor];
                self.scrollView.alpha = 0.8;
                [self.view addSubview:self.scrollView];
            }else if ([[Platform Instance] getShopMode] == 3){
                //总部以外用户登陆
                [self.lstShopItem initData:@"请选择" withVal:nil];
                self.lstShopItem.tag = 1;
                self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 112, SCREEN_W, 150)];
                self.scrollView.backgroundColor = [UIColor whiteColor];
                self.scrollView.alpha = 0.8;
                [self.view addSubview:self.scrollView];
            }else{
                self.shop_id = [[Platform Instance] getkey:SHOP_ID];
                self.lstShopItem.hidden = YES;
                self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_W, 150)];
                self.scrollView.backgroundColor = [UIColor whiteColor];
                self.scrollView.alpha = 0.8;
                [self.view addSubview:self.scrollView];
            }
        }
        self.viewContent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.ls_width, self.scrollView.ls_height)];
        [self.scrollView addSubview:self.viewContent];
        self.top = [[ShopCommentTop alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 110)];
        [self.viewContent addSubview:self.top];
        
        self.collect = [[ShopCollect alloc] initWithFrame:CGRectMake(0, self.viewContent.frame.size.height-30, SCREEN_W, 30)];
        [self.viewContent addSubview:self.collect];
        
        [self requstTotalReport];
    }
    
    if (self.type == LSShop_Entity && [[Platform Instance] getShopMode] == 2) {
        [self.top upDataName:[[Platform Instance] getkey:SHOP_NAME]];
    } else if(self.type == LSShop_Wechat && [[Platform Instance] getShopMode] == 2) {
        [self.top upDataName:@""];
    }
    
    [self configHelpButton:HELP_COMMENT];

}

#pragma mark - 相关代理方法
-(void)navigationBar:(LSNavigationBar *)navigationBar didEndClickedDirect:(LSNavigationBarButtonDirect)event
{

    if (event == LSNavigationBarButtonDirectRight) {
        LevelDescriptionView *descView = [[LevelDescriptionView alloc] initWithNibName:[SystemUtil getXibName:@"LevelDescriptionView"] bundle:nil];
        [self pushController:descView from:kCATransitionFromRight];
    }else{
        [self popViewController];
    }
}

- (void)onItemListClick:(EditItemList *)obj {
    
    if (obj.tag == 1) {
            // 单店
            if ([[Platform Instance] getShopMode] == 1) {
                
                if ([[Platform Instance] getMicroShopStatus] == 2) {
                    
                    //微店状态 0未开通 1申请中 2已开通
                    NSMutableArray *nameItems = [[NSMutableArray alloc] init];
                    NameItemVO *nameItemVo = [[NameItemVO alloc] initWithVal:@"微店" andId:[[Platform Instance] getkey:SHOP_ID]];
                    [nameItems addObject:nameItemVo];
                    nameItemVo = [[NameItemVO alloc] initWithVal:@"实体门店" andId:[[Platform Instance] getkey:ENTITY_ID]];
                    [nameItems addObject:nameItemVo];
                    [OptionPickerBox initData:nameItems itemId:[obj getStrVal]];
                    [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
                }
            }
              __weak typeof(self) wself = self;
        
            // 连锁 总部用户
            if ([[Platform Instance] getShopMode] == 3 && [[Platform Instance] isTopOrg])
            {
                SelectShopListView *vc = [[SelectShopListView alloc]init];
                [self pushController:vc from:kCATransitionFromRight];
               
          
                [vc loadShopList: [_lstShopItem getStrVal] withType:2 withViewType:CONTAIN_ALL withIsPush:YES callBack:^(id<ITreeItem> shop) {
                    [self.navigationController popViewControllerAnimated:YES];
                    if (shop) {
                        if ([[shop obtainItemId] isEqualToString:@"0"]) {
                            _isSelectAll = YES;
                            [wself.lstShopItem initData:[shop obtainItemName] withVal:@"0"];
                            wself.shop_id = nil;
                            
                        } else {
                            _isSelectAll = NO;
                            [wself.lstShopItem initData:[shop obtainItemName] withVal:[shop obtainItemId]];
                            wself.shop_id = [self.lstShopItem getStrVal];
                            wself.shopEntityId = [shop obtainShopEntityId];
                        }
                        [self requstTotalReport];
                    }
                }];
            } else {
                // 连锁机构
                SelectShopListView *vc = [[SelectShopListView alloc]init];
                [self pushController:vc from:kCATransitionFromRight];
                
                [vc loadShopList: [[Platform Instance] getkey:ORG_ID] withType:2 withViewType:NOT_CONTAIN_ALL withIsPush:YES callBack:^(id<ITreeItem> shop) {
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    if (shop) {
                        if ([NSString isBlank:[shop obtainItemName]]) {
                            [wself.lstShopItem initData:@"请选择" withVal:@""];
                            wself.shop_id = nil;
                        } else {
                            [wself.lstShopItem initData:[shop obtainItemName] withVal:[shop obtainItemId]];
                            wself.shop_id = [wself.lstShopItem getStrVal];
                            wself.shopEntityId = [shop obtainShopEntityId];
                        }
                         [wself requstTotalReport];
                    }
                }];
            }
    }
}

- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType {
//    id<INameItem> item = (id<INameItem>)selectObj;
//    if (eventType == 1) {
//        [self.lstShop initData:[item obtainItemName] withVal:[item obtainItemId]];
//    }
    return YES;
}

- (void)requstTotalReport {
   
    // NSInteger lastMonth = [self calcMonth:-1];
    __weak typeof(self) weakSelf = self;
    if (self.type == LSShop_Entity) {

        //综合评价:实体
        [self.commentService shopReport:_shop_id shopEntityId:_shopEntityId completionHandler:^(id json) {
            [weakSelf requestSuccess:json];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    } else {
        // 综合评价:微店
        // 微店页面初次进入，self.model = @"default"
        if (!self.modal) {
            self.modal = @"default";
        } else {
            self.modal = @"search";
        }
        
        // 连锁总部用户初期(modal=default)时,shopId传空，查询时选择“全部”时传空，其他情况必须传入32位字符串；
        if ([[Platform Instance] isTopOrg] && (_isSelectAll || [_modal isEqualToString:@"default"])) {
            self.shop_id = @"";
        }
        
        [self.commentService microShopReport:_shop_id modal:_modal completionHandler:^(id json) {
            [weakSelf requestSuccess:json];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }
}

- (void)requestSuccess:(id)json {
    
    self.totalReport = [JsonHelper dicTransObj:[json objectForKey:@"totalReport"] obj:[ShopCommentReportVo new]];
    self.thisMonthReport = [JsonHelper dicTransObj:[json objectForKey:@"thisMonthReport"] obj:[ShopCommentReportVo new]];

    // 显示当前评论机构的名称和用户电话
    NSString *name = [NSString isNotBlank:json[@"name"]]?json[@"name"]:@"";
    NSString *mobile = [NSString isNotBlank:json[@"mobile"]]?json[@"mobile"]:@"";
    if (!_lstShopItem.hidden && [[_lstShopItem getStrVal] isEqualToString:@"0"]) {
        // 连锁总部用户，选择全部时显示总部名称
        [self.top upDataName:[[Platform Instance] getkey:SHOP_NAME]];
    } else {
        [self.top upDataName:[NSString stringWithFormat:@"%@ %@", name, mobile]];
    }
    
    NSString *logoPath = [NSString stringForObject:[json objectForKey:@"logoPath"]];
    [self.top.imgViewShop sd_setImageWithURL:[NSURL URLWithString:logoPath] placeholderImage:[UIImage imageNamed:@"img_default"]];
    [self.top upDataInfo:self.totalReport andType:self.type];
    [self showReport];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


/*
 #pragma mark - Navigation
 */
- (UIImage *)levelImage:(NSInteger)score {
    if (score <=250) {
        return [UIImage imageNamed:@"ico_heart.png"];
    } else if (score > 250 && score <= 10000) {
        return [UIImage imageNamed:@"ico_diamonds.png"];
    } else {
        return [UIImage imageNamed:@"ico_crown.png"];
    }
}

//展示评价界面
- (void)showReport {
    for (UIView *view in self.viewContent.subviews) {
        if (view != self.top && ![view isKindOfClass:[ShopCollect class]]) {
            [view removeFromSuperview];
        }
    }
    self.scrollView.frame = CGRectMake(0, self.scrollView.ls_origin.y, SCREEN_W, 150);
    self.viewContent.frame = CGRectMake(0, 0, self.scrollView.ls_width, self.scrollView.ls_height);
    //当月综合评价
    if (self.thisMonthReport) {
        
        MonthReportView *monthReportView = [[[NSBundle mainBundle] loadNibNamed:@"MonthReportView" owner:self options:nil] lastObject];
        [monthReportView showCommentReport:self.thisMonthReport viewTypeId:(NSInteger) self.type];
        
        monthReportView.frame = CGRectMake(0, self.viewContent.frame.size.height-30,SCREEN_W, 170);
        [self.viewContent addSubview:monthReportView];
        self.viewContent.frame = CGRectMake(0, 0, SCREEN_W, self.viewContent.frame.size.height + 170);
        self.scrollView.frame = CGRectMake(0, self.scrollView.ls_origin.y, SCREEN_W, self.scrollView.ls_height+170);
    }
    self.scrollView.contentSize = CGSizeMake(SCREEN_W, self.viewContent.frame.size.height);
    self.collect.frame = CGRectMake(0, self.viewContent.frame.size.height-30, SCREEN_W, 30);
}

#pragma mark - private
- (NSInteger)calcMonth:(int)months {
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:[NSDate date]];
    
    NSInteger year=[comps year];//获取年对应的长整形字符串
    NSInteger month=[comps month];//获取月对应的长整形字符串
    
    year = year + months / 12;
    month = month + months % 12;
    
    if (month < 1) {
        year--;
        month += 12;
    } else if (month > 12) {
        year++;
        month -= 12;
    }
    
    NSString *calcdate = [NSString stringWithFormat:@"%ld%02ld", (long)year, (long)month];
    return [calcdate integerValue];
}

-(void)showHisory:(NSNotification *)not
{
    int type = [not.object intValue];
    if (!type) {
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i < self.viewContent.subviews.count; i++) {
            if ([[self.viewContent.subviews objectAtIndex:i] isKindOfClass:[MonthReportView class]]) {
                [array addObject:self.viewContent.subviews[i]];
            }
        }
        for (MonthReportView *view in array) {
            if (![view.lblTime.text isEqualToString:@"本月汇总"]) {
                [view removeFromSuperview];
            }
        }
        self.scrollView.frame = CGRectMake(0, self.scrollView.ls_origin.y, SCREEN_W, 320);
        self.scrollView.contentSize = CGSizeMake(SCREEN_W, 320);
        self.viewContent.frame = CGRectMake(0, 0, SCREEN_W, self.scrollView.ls_height);
        self.collect.frame = CGRectMake(0, self.viewContent.ls_height-30, SCREEN_W, 30);
    }else{
        NSInteger startDate = [self calcMonth:-5];
        NSInteger endDate = [self calcMonth:0];
        __weak typeof(self) weakSelf = self;
        if (self.type == LSShop_Entity) {
            //历史汇总
            [self.commentService shopHistoryReportList:self.shop_id
                                                         modal:self.modal
                                                   companionId:@""
                                                     startDate:startDate
                                                       endDate:endDate
                                             completionHandler:^(id json) {
        
                        [weakSelf requestHistorySuccess:json];
                    } errorHandler:^(id json) {
                        [AlertBox show:json];
                    }];
        } else {
            //历史汇总
            [self.commentService microShopHistoryReportList:self.shop_id
                                                              modal:self.modal
                                                        companionId:@""
                                                          startDate:startDate
                                                            endDate:endDate
                                                  completionHandler:^(id json)
            {
                [weakSelf requestHistorySuccess:json];
                
            } errorHandler:^(id json) {
                [AlertBox show:json];
            }];
        }

    }
}

- (void)requestHistorySuccess:(id)json {
    
    //上月评价
    ShopCommentReportVo *lastMonth = [JsonHelper dicTransObj:[json objectForKey:@"lastMonth"] obj:[ShopCommentReportVo new]];
    lastMonth.reportTime=[NSString stringWithFormat:@"%ld",(long)[self calcMonth:-1]];
    
    //上上月评价
    ShopCommentReportVo *lastlastMonth = [JsonHelper dicTransObj:[json objectForKey:@"lastlastMonth"] obj:[ShopCommentReportVo new]];
    lastlastMonth.reportTime=[NSString stringWithFormat:@"%ld",(long)[self calcMonth:-2]];
    //半年汇总
    ShopCommentReportVo *total = [JsonHelper dicTransObj:[json objectForKey:@"total"] obj:[ShopCommentReportVo new]];
    total.reportTime=@"201613";
    self.reportHistoryList = [NSMutableArray array];
    if (lastMonth) {
        [self.reportHistoryList addObject:lastMonth];
    }
    if (lastlastMonth) {
        [self.reportHistoryList addObject:lastlastMonth];
    }
    if (total) {
        [self.reportHistoryList addObject:total];
    }
    
    [self showHistoryReport];
}

- (void)showHistoryReport {
    for (int i = 0; i < self.reportHistoryList.count; i++) {
        ShopCommentReportVo *reportVo = [self.reportHistoryList objectAtIndex:i];
        
        MonthReportView *monthReportView = [[[NSBundle mainBundle] loadNibNamed:@"MonthReportView" owner:self options:nil] lastObject];
        [monthReportView showCommentReport:reportVo viewTypeId:(NSInteger) self.type];
        
        monthReportView.frame = CGRectMake(0, self.viewContent.frame.size.height-30, SCREEN_W, 170);
        [self.viewContent addSubview:monthReportView];
        
        self.viewContent.frame = CGRectMake(0, 0, SCREEN_W, self.viewContent.frame.size.height + 170);
         self.scrollView.contentSize = CGSizeMake(SCREEN_W, self.viewContent.frame.size.height);
        if (i==self.reportHistoryList.count-1) {
            self.collect.frame = CGRectMake(0, self.viewContent.frame.size.height-30, SCREEN_W, 30);
            self.scrollView.frame = CGRectMake(0, self.scrollView.ls_origin.y, SCREEN_W, SCREEN_H-self.scrollView.ls_origin.y);
        }

    }
}

@end
