//
//  LSWechatGoodSortController.m
//  retailapp
//
//  Created by taihangju on 2017/3/13.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSWechatGoodSortController.h"
#import "NavigateTitle2.h"
#import "SearchBar2.h"
#import "ServiceFactory.h"
#import "CategoryVo.h"
#import "LSWechatGoodsSortCell.h"

@interface LSWechatGoodSortController ()<INavigateEvent , ISearchBarEvent ,UITableViewDelegate ,UITableViewDataSource> {
    
    BOOL isCloth;
    NSString *originOptionName;
}
@property (nonatomic, strong) NavigateTitle2 *titleBox;/**<导航栏>*/
@property (nonatomic, strong) SearchBar2 *searchBar;/**<搜索框>*/
@property (nonatomic, strong) UITableView *tableView;/**<>*/
@property (nonatomic, strong) NSArray *sortList;/**<分类列表>*/
@property (nonatomic, copy) void (^callBackBlock)();/**<选择分类后回调>*/
@property (nonatomic, assign) LSWechatGoodSortNameType sortNameType;/**<>*/
@end

@implementation LSWechatGoodSortController

- (instancetype)initWith:(NSString *)option sortNameType:(LSWechatGoodSortNameType)type  block:(void(^)())block {
    self = [super init];
    if (self) {
        originOptionName = option;
        isCloth = [[[Platform Instance] getkey:SHOP_MODE] integerValue] == 101;
        self.callBackBlock = block;
        self.sortNameType = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSubviews];
    if (isCloth) {
        [self getClothSortList];
    } else {
        [self getSuperMarketSortList];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)configSubviews {
    
    //配置导航栏
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    NSString *title = isCloth ? @"选择中品类" : @"选择分类";
    [self.titleBox initWithName:title backImg:Head_ICON_BACK moreImg:nil];
    [self.view addSubview:self.titleBox];
    
    //搜索框
    _searchBar = [SearchBar2 searchBar2];
    _searchBar.ls_top = _titleBox.ls_bottom;
    NSString *placeHolder = isCloth ? @"中品类名称" : @"分类名称";
    [_searchBar initDelagate:self placeholder:placeHolder];
    [self.view addSubview:_searchBar];
    
    // 列表
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _searchBar.ls_bottom, SCREEN_W, SCREEN_H-_searchBar.ls_bottom) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.rowHeight = 44.0;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

#pragma mark - 相关协议 -
// INavigateEvent ,
- (void)onNavigateEvent:(Direct_Flag)event {
    if (event == DIRECT_LEFT) {
        [self popToLatestViewController:kCATransitionFromLeft];
    }
}

// ISearchBarEvent ,
- (void)imputFinish:(NSString *)keyWord {
    if (isCloth) {
        [self getClothSortList];
    } else {
        [self getSuperMarketSortList];
    }
}

//UITableViewDelegate ,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sortList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LSWechatGoodsSortCell *cell = [LSWechatGoodsSortCell wechatGoodsSortCellWith:tableView];
    CategoryVo *vo = _sortList[indexPath.row];
    BOOL optStatus = vo.isSelect;
    if (self.sortNameType == LSWechatGoodSortName) {
        
        if ([vo.name isEqualToString:originOptionName]) { optStatus = YES; }
        [cell setOptionName:vo.name optStatus:optStatus];
        
    } else if (self.sortNameType == LSWechatGoodSortMicroname) {
        
        if ([vo.microname isEqualToString:originOptionName]) { optStatus = YES; }
        [cell setOptionName:vo.microname optStatus:optStatus];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CategoryVo *vo = _sortList[indexPath.row];
    vo.isSelect = !vo.isSelect;
    LSWechatGoodsSortCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *name = self.sortNameType == LSWechatGoodSortName ? vo.name : vo.microname;
    [cell setOptionName:name optStatus:vo.isSelect];
    if (self.callBackBlock) {
        self.callBackBlock(vo);
    }
    [self popToLatestViewController:kCATransitionFromLeft];
}

#pragma mark - 网络请求 -

// 服鞋中品类列表获取
- (void)getClothSortList {
    __weak typeof(self) wself = self;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@2,@"searchType", nil];
    if ([NSString isNotBlank:wself.searchBar.keyWordTxt.text]) {
        [params setValue:wself.searchBar.keyWordTxt.text forKey:@"searchKey"];
    }
    [BaseService getRemoteLSDataWithUrl:@"category/firstCategoryInfo" param:params
                            withMessage:@"" show:YES CompletionHandler:^(id json) {
                                NSMutableArray *categoryList = [[NSMutableArray alloc] init];
                                if (wself.searchBar.keyWordTxt.text.length == 0) {
                                    CategoryVo *itemVo = [[CategoryVo alloc] init];
                                    itemVo.name = @"全部";
                                    itemVo.microname = @"全部";
                                    itemVo.categoryId = @"";
                                    [categoryList addObject:itemVo];
                                }
                                NSArray *list = [CategoryVo converToArr:json[@"categoryList"]];
                                [categoryList addObjectsFromArray:list];
                                wself.sortList = [categoryList copy];
                                [wself.tableView reloadData];
                            } errorHandler:^(id json) {
                                [LSAlertHelper showAlert:json];
                            }];
}

// 商超分类列表获取
- (void)getSuperMarketSortList {
    
    __weak typeof(self) wself = self;
    NSMutableDictionary *params = [[NSMutableDictionary alloc]
                                   initWithObjectsAndKeys:@2,@"searchType",@(NO),@"hasNoCategory", nil];
    if ([NSString isNotBlank:wself.searchBar.keyWordTxt.text]) {
        [params setValue:wself.searchBar.keyWordTxt.text forKey:@"searchKey"];
    }
    [BaseService getRemoteLSDataWithUrl:@"category/lastCategoryInfo" param:params
                            withMessage:@"" show:YES CompletionHandler:^(id json) {
     
                                NSMutableArray *categoryList = [[NSMutableArray alloc] init];
                                if (wself.searchBar.keyWordTxt.text.length == 0) {
                                    CategoryVo *itemVo = [[CategoryVo alloc] init];
                                    itemVo.name = @"全部";
                                    itemVo.microname = @"全部";
                                    itemVo.categoryId = @"";
                                    [categoryList addObject:itemVo];
                                }
                                
                                NSArray *list = [CategoryVo converToArr:json[@"categoryList"]];
                                [categoryList addObjectsFromArray:list];
                                wself.sortList = [categoryList copy];
                                [wself.tableView reloadData];
                            } errorHandler:^(id json) {
                                [LSAlertHelper showAlert:json];
                            }];
}

@end
