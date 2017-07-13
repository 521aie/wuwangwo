//
//  GoodsCommentView.m
//  retailapp
//
//  Created by Jianyong Duan on 15/11/4.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GoodsCommentView.h"
#import "LSEditItemList.h"
#import "SearchBar.h"
#import "SearchBar2.h"

#import "CommentService.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "GoodsCommentReportVo.h"
#import "GoodsCommentCell.h"

#import "SelectShopListView.h"
#import "ScanViewController.h"
#import "GoodsCommentDetailView.h"
//#import "XHAnimalUtil.h"
@interface GoodsCommentView () <ISearchBarEvent,IEditItemListEvent,LSScanViewDelegate,UITableViewDelegate,UITableViewDataSource,LSNavigationBarDelegate>

@property (nonatomic, strong) CommentService *commentService;

@property (nonatomic, strong) NSMutableArray *reportList;

@property (nonatomic, strong) NSString *shop_id;
@property (nonatomic, strong) NSString *keyword;
@property (nonatomic, strong) NSString *barCode;

@property (nonatomic) NSInteger lastTime;
@property (nonatomic, strong) NSString *modal;

@property (nonatomic, strong) LSEditItemList *lstShopItem;
@property (nonatomic, strong) SearchBar *searchBar;
@property (nonatomic, strong) SearchBar2 *searchBar2;

@property (nonatomic, strong)UITableView *mainGrid;
@end

@implementation GoodsCommentView

-(instancetype)initWithType:(NSInteger)type
{
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.commentService = [ServiceFactory shareInstance].commentService;
    self.modal = @"default";
    
    self.reportList = [NSMutableArray array];
    
    [self createNav];
    [self createViews];
}

-(void)createNav
{
    if (self.type) {
        [self configTitle:@"商品评价(微店)" leftPath:Head_ICON_BACK rightPath:nil];
    }else{
        [self configTitle:@"商品评价(实体)" leftPath:Head_ICON_BACK rightPath:nil];
    }
}

-(void)createViews
{
    self.lstShopItem = [LSEditItemList editItemList];
    self.lstShopItem.imgMore.image = [UIImage imageNamed:@"ico_next"];
    self.lstShopItem.hidden = YES;
    [self.lstShopItem initLabel:@"门店" withHit:nil delegate:self];
    [self.lstShopItem setBackgroundColor:[UIColor whiteColor]];
    self.lstShopItem.alpha = 0.7;
    self.lstShopItem.frame = CGRectMake(0, 64, SCREEN_W, 48);
    [self.view addSubview:self.lstShopItem];
    
    self.searchBar = [SearchBar searchBar];
    [self.view addSubview:self.searchBar];
    
    self.searchBar2 = [SearchBar2 searchBar2];
    [self.view addSubview:self.searchBar2];
    
    self.mainGrid = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.mainGrid.backgroundColor = [UIColor clearColor];
    self.mainGrid.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainGrid.delegate = self;
    self.mainGrid.dataSource = self;
    [self.view addSubview:self.mainGrid];

    //实体
    if (self.type == 0) {
        //        •连锁模式机构用户登录时表示
        //        •连锁模式门店用户登录、单店模式：非表示
        //        •总部用户登录时，默认“全部”
        //        一般机构用户登录时，默认“请选择”
        if ([[Platform Instance] getShopMode] == 1 || [[Platform Instance] getShopMode] == 2) {
            //单店和门店
            self.shop_id = [[Platform Instance] getkey:SHOP_ID];
            self.searchBar.frame = CGRectMake(0, 64, SCREEN_W, 48);
            self.searchBar2.frame = CGRectMake(0, 64, SCREEN_W, 48);
            self.mainGrid.frame = CGRectMake(0, 112, SCREEN_W, SCREEN_H-112);
            [self loadData];
        }else{
            //连锁模式
            self.lstShopItem.hidden = NO;
            self.searchBar.frame = CGRectMake(0, 112, SCREEN_W, 48);
            self.searchBar2.frame = CGRectMake(0, 112, SCREEN_W, 48);
            self.mainGrid.frame = CGRectMake(0, 160, SCREEN_W, SCREEN_H-160);
            if ([[Platform Instance] isTopOrg]) {
                //总部用户
                [self.lstShopItem initData:@"全部" withVal:@"0"];
                self.lstShopItem.tag = 1;
                [self loadData];
            }else{
                //总部以外的用户登陆
                [self.lstShopItem initData:@"请选择" withVal:@""];
                self.lstShopItem.tag =1;
            }
        }

    }else{
        //微店
        // ①、开通微分销的商户：
        // •连锁模式总部用户登录时表示，默认“总部微店”
        if ([[Platform Instance] isTopOrg]) {
            self.lstShopItem.hidden = NO;
            self.searchBar.frame = CGRectMake(0, 112, SCREEN_W, 48);
            self.searchBar2.frame = CGRectMake(0, 112, SCREEN_W, 48);
            self.mainGrid.frame = CGRectMake(0, 160, SCREEN_W, SCREEN_H-160);
            [self.lstShopItem initData:@"全部" withVal:@"0"];
            self.lstShopItem.tag = 1;
            [self loadData];
        }else{
            self.shop_id = [[Platform Instance] getkey:SHOP_ID];
            self.searchBar.frame = CGRectMake(0, 64, SCREEN_W, 48);
            self.searchBar2.frame = CGRectMake(0, 64, SCREEN_W, 48);
            self.mainGrid.frame = CGRectMake(0, 112, SCREEN_W, SCREEN_H-112);
            [self loadData];
        }
    }
    //服鞋 101 商超 102
    if ([[[Platform Instance] getkey:SHOP_MODE] integerValue] == 101) {
        self.searchBar.hidden = YES;
        
        //设置searchbar
        [self.searchBar2 initDelagate:self placeholder:@"名称/款号"];
        
    } else {
        self.searchBar2.hidden = YES;
        
        //设置searchbar
        [self.searchBar initDeleagte:self placeholder:@"条形码/简码/拼音码"];
    }
    [self initGridView];
    [self configHelpButton:HELP_COMMENT];
}


-(void)navigationBar:(LSNavigationBar *)navigationBar didEndClickedDirect:(LSNavigationBarButtonDirect)event
{
    [self popViewController];
}

- (void)initGridView {
    
    [self.mainGrid registerNib:[UINib nibWithNibName:@"GoodsCommentCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.mainGrid.rowHeight = 88.0f;
    __weak typeof(self) weakeSelf = self;
    [self.mainGrid ls_addHeaderWithCallback:^{
        weakeSelf.lastTime = 0;
        [weakeSelf loadData];
    }];
    [self.mainGrid ls_addFooterWithCallback:^{
        [weakeSelf loadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadData {
    
    if ([self.shop_id isEqualToString:@"0"]) {
        self.shop_id = @"";
    }
    
    NSString *url = @"commentReport/goods";
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:6];
    
    if ([NSString isNotBlank:self.shop_id]) {
        [param setValue:self.shop_id forKey:@"shopId"];
    }

    if (self.lastTime > 0) {
        [param setValue:[NSNumber numberWithInteger:self.lastTime] forKey:@"lastTime"];
    }
    if ([NSString isNotBlank:self.keyword]) {
        [param setValue:self.keyword forKey:@"keyWord"];
    }
    if ([NSString isNotBlank:self.barCode]) {
        [param setValue:self.barCode forKey:@"barCode"];
    }
    
    [param setValue:[NSNumber numberWithBool:self.type] forKey:@"isMicroShop"];
    
    if (self.modal) {
        [param setValue:self.modal forKey:@"modal"];
    }
    
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        [self.mainGrid headerEndRefreshing];
        [self.mainGrid footerEndRefreshing];
        if (self.lastTime == 0) {
            [self.reportList removeAllObjects];
        }
        for (NSDictionary *obj in json[@"commentReportList"]) {
            GoodsCommentReportVo *reportVo = [[GoodsCommentReportVo alloc] initWithDictionary:obj];
            [self.reportList addObject:reportVo];
        }
        self.lastTime = [json[@"lastTime"] integerValue];
        [self.mainGrid reloadData];
    } errorHandler:^(id json) {
        [self.mainGrid headerEndRefreshing];
        [self.mainGrid footerEndRefreshing];
        [AlertBox show:json];
    }];
    
}

- (void)onItemListClick:(EditItemList *)obj {
    if (obj.tag == 1) {
        if ([[Platform Instance] getShopMode] == 3 && [[Platform Instance] isTopOrg]) {
            SelectShopListView *vc = [[SelectShopListView alloc] init];
            [self pushController:vc from:kCATransitionFromRight];
            
            [vc loadShopList: [_lstShopItem getStrVal] withType:2 withViewType:CONTAIN_ALL withIsPush:YES callBack:^(id<ITreeItem> shop) {
                [self.navigationController popViewControllerAnimated:YES];
                if ([NSString isBlank:[shop obtainItemName]]) {
                    
                    if ([[Platform Instance] isTopOrg]) {
                        
                        //总部用户
                        [_lstShopItem initData:@"全部" withVal:@""];
                        _lstShopItem.tag = 1;
                        self.shop_id = nil;
                        
                        [self.mainGrid headerBeginRefreshing];
                    }else {
                        
                        //总部以外机构用户登录
                        [_lstShopItem initData:@"请选择" withVal:@""];
                        _lstShopItem.tag = 1;
                        self.shop_id = nil;
                        
                        [self.reportList removeAllObjects];
                        [self.mainGrid reloadData];
                    }
                    
                }else {
                    [self.lstShopItem initData:[shop obtainItemName] withVal:[shop obtainItemId]];
                    self.shop_id = [self.lstShopItem getStrVal];
                    self.barCode = nil;
                    self.modal = @"search";
                    
                    [self.mainGrid headerBeginRefreshing];
                }
            }];
        }else {
            SelectShopListView *vc = [[SelectShopListView alloc] init];
            [self pushController:vc from:kCATransitionFromRight];
            
            [vc loadShopList:[[Platform Instance] getkey:ORG_ID] withType:2 withViewType:NOT_CONTAIN_ALL withIsPush:YES callBack:^(id<ITreeItem> shop) {
                
                [self.navigationController popViewControllerAnimated:YES];
                if ([NSString isBlank:[shop obtainItemName]]) {
                    
                    if ([[Platform Instance] isTopOrg]) {
                        
                        //总部用户
                        [_lstShopItem initData:@"全部" withVal:@""];
                        _lstShopItem.tag = 1;
                        self.shop_id = nil;
                        
                        [self.mainGrid headerBeginRefreshing];
                    } else {
                        
                        //总部以外机构用户登录
                        [_lstShopItem initData:@"请选择" withVal:@""];
                        _lstShopItem.tag = 1;
                        self.shop_id = nil;
                        
                        [self.reportList removeAllObjects];
                        [self.mainGrid reloadData];
                    }
                    
                } else {
                    [self.lstShopItem initData:[shop obtainItemName] withVal:[shop obtainItemId]];
                    self.shop_id = [self.lstShopItem getStrVal];
                    self.barCode = nil;
                    self.modal = @"search";
                    
                    [self.mainGrid headerBeginRefreshing];
                }
            }];
        }
    } 
}


#pragma mark - ISearchBarEvent
// 输入完成
- (void)imputFinish:(NSString *)keyWord {
    self.keyword = keyWord;
    if ([[[Platform Instance] getkey:SHOP_MODE] integerValue] == 101) {
        self.searchBar2.keyWordTxt.text = keyWord;
    } else {
        self.searchBar.keyWordTxt.text = keyWord;
    }

    if (self.type == 0 && [[Platform Instance] getShopMode] == 3 && ![[Platform Instance] isTopOrg] && [NSString isBlank:self.shop_id]) {
        
    } else {
        self.barCode = nil;
        [self.mainGrid headerBeginRefreshing];
    }
}

#pragma  mark - 扫一扫
// ISearchBarEvent
- (void)scanStart {
    ScanViewController *vc = [ScanViewController shareInstance:self types:LSScannerBarcode];
    [self pushController:vc from:kCATransitionFromRight];
}

// LSScanViewDelegate
- (void)scanSuccess:(ScanViewController *)controller result:(NSString *)scanString {
    if ([[[Platform Instance] getkey:SHOP_MODE] integerValue] == 101) {
        self.searchBar2.keyWordTxt.text = scanString;
    } else {
        self.searchBar.keyWordTxt.text = scanString;
    }
    self.barCode = scanString;
    self.keyword = nil;
    [self.mainGrid headerBeginRefreshing];
}

- (void)scanFail:(ScanViewController *)controller with:(NSString *)message {
    [AlertBox show:message];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.reportList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GoodsCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell initWithReport:self.reportList[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GoodsCommentReportVo *commentReport = [self.reportList objectAtIndex:indexPath.row];
    GoodsCommentDetailView *detailView = [[GoodsCommentDetailView alloc] init];
    detailView.commentReport = commentReport;
    [self pushController:detailView from:kCATransitionFromRight];
}

@end
