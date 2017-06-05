//
//  GoodsCommentDetailView.m
//  retailapp
//
//  Created by Jianyong Duan on 15/11/19.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GoodsCommentDetailView.h"
#import "GoodCommentDetailTopCell.h"

#import "CommentService.h"
#import "GoodsCommentVo.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "NavigateTitle2.h"
#import "GoodsCommentDetialCell.h"
#import "DatePickerBox.h"
#import "DateUtils.h"
#import "NameItemVO.h"
#import "TDFComplexConditionFilter.h"

@interface GoodsCommentDetailView () <LSNavigationBarDelegate, IEditItemListEvent, DatePickerClient, TDFConditionFilterDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) CommentService *commentService;
@property (nonatomic, strong) NSMutableArray *reportList;
@property (nonatomic, strong) NSNumber *startTime;
@property (nonatomic, strong) NSNumber *endTime;
@property (nonatomic, strong) NSNumber *lastTime;
@property (nonatomic, strong) NSNumber *commentLevel;

@property (nonatomic ,strong) TDFComplexConditionFilter *filterView;/**<右侧筛选>*/
@property (nonatomic ,strong) NSArray *filterModels;/**<筛选需要的数据>*/

@property (nonatomic, strong) UITableView *mainGrid;
@end

@implementation GoodsCommentDetailView

- (void)viewDidLoad {
    [super viewDidLoad];

    self.commentService = [ServiceFactory shareInstance].commentService;
    self.reportList = [NSMutableArray array];
    
    [self createNav];
    [self initGridView];
    [self addFilterView];
    [self loadData];
    [self configHelpButton:HELP_COMMENT];
}

-(void)createNav
{
    [self configTitle:@"商品评价" leftPath:Head_ICON_BACK rightPath:nil];
}

- (NSArray *)filterModels {
    if (!_filterModels) {
        
        TDFTwiceCellModel *dateModel = [[TDFTwiceCellModel alloc] initWithType:TDF_TwiceFilterCellOneLine optionName:@"评价日期" hideStatus:NO];
        dateModel.arrowImageName = @"ico_next_down";
        dateModel.restName = @"请选择";
        
        NSMutableArray *options = [NSMutableArray arrayWithCapacity:4];
        TDFRegularCellModel *gradeModel = [[TDFRegularCellModel alloc] initWithOptionName:@"评价等级" hideStatus:NO];
        [options addObject:[TDFFilterItem filterItem:@"全部" itemValue:nil]];
        [options addObject:[TDFFilterItem filterItem:@"好评" itemValue:@1]];
        [options addObject:[TDFFilterItem filterItem:@"中评" itemValue:@2]];
        [options addObject:[TDFFilterItem filterItem:@"差评" itemValue:@3]];
        gradeModel.optionItems = [options copy];
        gradeModel.resetItemIndex = 0;
        _filterModels = @[dateModel ,gradeModel];
    }
    return _filterModels;
}

- (void)addFilterView {
    
    self.filterView = [[TDFComplexConditionFilter alloc] initFilter:@"筛选条件" image:@"ico_filter_normal" highlightImage:@"ico_filter_highlighted"];
    self.filterView.delegate = self;
    [self.filterView addToView:self.view withDatas:self.filterModels];
}

- (void)initGridView {
    self.mainGrid= [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_W, SCREEN_H-64) style:UITableViewStylePlain];
    [self.mainGrid registerNib:[UINib nibWithNibName:@"GoodsCommentDetialCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.mainGrid registerNib:[UINib nibWithNibName:@"GoodCommentDetailTopCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
    self.mainGrid.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainGrid.backgroundColor = [UIColor clearColor];
    self.mainGrid.delegate = self;
    self.mainGrid.dataSource = self;
    [self.view addSubview:self.mainGrid];
    __weak typeof(self) weakSelf = self;
    [self.mainGrid ls_addHeaderWithCallback:^{
        weakSelf.lastTime = nil;
        [weakSelf loadData];
    }];
    [self.mainGrid ls_addFooterWithCallback:^{
        [weakSelf loadData];
        }];
}


#pragma mark - 相关代理方法
-(void)navigationBar:(LSNavigationBar *)navigationBar didEndClickedDirect:(LSNavigationBarButtonDirect)event
{
    [self popViewController];
}



// TDFConditionFilterDelegate
- (void)tdf_filter:(TDFComplexConditionFilter *)filter actionWithCellModel:(TDFFilterMoel *)model {
    if (model.type == TDF_TwiceFilterCellOneLine) {
        TDFTwiceCellModel *dateModel = (TDFTwiceCellModel *)model;
        NSDate *date = dateModel.currentValue?:[NSDate date];
        [DatePickerBox showClear:@"评价日期" clearName:@"清空日期" date:date client:self event:11];
    }
}

- (void)tdf_filterCompleted {
    
    TDFTwiceCellModel *date = self.filterModels.firstObject;
    if (date.currentName && ![date.currentName isEqualToString:date.restName]) {
        NSString *time = date.currentName;
        long long date = [DateUtils formateDateTime2:[NSString stringWithFormat:@"%@ 00:00:00", time]];
        self.startTime = [NSNumber numberWithLongLong:date];
        date = [DateUtils formateDateTime2:[NSString stringWithFormat:@"%@ 23:59:59", time]];
        self.endTime = [NSNumber numberWithLongLong:date];
        
    } else {
        self.startTime = nil;
        self.endTime = nil;
    }
    
    TDFRegularCellModel *grade = self.filterModels.lastObject;
    self.commentLevel = grade.currentValue;
    self.lastTime = nil;
    [self.mainGrid headerBeginRefreshing];
}

// DatePickerClient
- (BOOL)pickDate:(NSDate *)date event:(NSInteger)event {
    NSString *time = [DateUtils formateDate2:date];
    TDFTwiceCellModel *dateModel = self.filterModels.firstObject;
    dateModel.currentValue = date;
    dateModel.currentName = time;
    return YES;
}

- (void)clearDate:(NSInteger)eventType {
    TDFTwiceCellModel *dateModel = self.filterModels.firstObject;
    dateModel.currentValue = nil;
    dateModel.currentName = nil;
}


// UITableViewDelegate 、UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.reportList.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != 0) {
        GoodsCommentDetialCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        [cell dataWithGoodsComment:self.reportList[indexPath.row-1]];
        return cell;
    }else{
        GoodCommentDetailTopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        [cell upDataWithModel:self.commentReport];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row != 0) {
        GoodsCommentVo *reportVo = self.reportList[indexPath.row-1];
        return [GoodsCommentDetialCell heightForContent:reportVo.comment];
    }else{
        return 146;
    }
}

#pragma mark - 请求数据
- (void)loadData {
    [self.commentService goodsReportDetail:self.commentReport.shopId
                                  shopType:self.commentReport.shopType
                                    goodId:self.commentReport.goodsId
                                 startTime:self.startTime
                                   endTime:self.endTime
                                  lastTime:self.lastTime
                              commentLevel:self.commentLevel completionHandler:^(id json) {
                                  [self.mainGrid headerEndRefreshing];
                                  [self.mainGrid footerEndRefreshing];
                                  if ([self.lastTime longLongValue] == 0) {
                                      [self.reportList removeAllObjects];
                                  }
                                  for (NSDictionary *obj in json[@"commentDetailList"]) {
                                      GoodsCommentVo *reportVo = [[GoodsCommentVo alloc] initWithDictionary:obj];
                                      [self.reportList addObject:reportVo];
                                  }
                                  self.lastTime = json[@"lastTime"];
                                  [self.mainGrid reloadData];
                                  
                              } errorHandler:^(id json) {
                                  [self.mainGrid headerEndRefreshing];
                                  [self.mainGrid footerEndRefreshing];
                                  [AlertBox show:json];
                              }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
