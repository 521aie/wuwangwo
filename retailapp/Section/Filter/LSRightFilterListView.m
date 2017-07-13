//
//  LSRightFilterListView.m
//  retailapp
//
//  Created by guozhi on 2017/2/10.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#define kWidth (SCREEN_W/2 + 40)
#import "LSRightFilterListView.h"
#import "LSRightFilterListCell.h"
#import "UIImage+Resize.h"
#import "SupplyTypeVo.h"
#import "TreeNode.h"

@interface LSRightFilterListView ()<UITableViewDelegate, UITableViewDataSource>
/** 筛选条件标题 */
@property (nonatomic, strong) UILabel *lblTitle;
/** 顶部按钮 */
@property (nonatomic, strong) UIButton *btn;
/** 顶部分割线 */
@property (nonatomic, strong) UIView *topLine;
/** 设置表格 */
@property (nonatomic, strong) UITableView *tableView;
/** 筛选页面右边View */
@property (nonatomic, strong) UIView *rightView;
/** 筛选按钮 */
@property (nonatomic, strong) UIButton *filterBtn;
/** 筛选按钮是否在右边 */
@property (nonatomic, assign) BOOL isRight;
/** <#注释#> */
@property (nonatomic, assign) LSRightFilterListViewType type;

@end
@implementation LSRightFilterListView

+ (instancetype)addFilterView:(UIView *)view delegate:(id<LSRightFilterListViewDelegate>)delegate {
    LSRightFilterListView *filterView = [[LSRightFilterListView alloc] init];
    filterView.isRight = YES;
    filterView.delegate = delegate;
    filterView.hidden = YES;
    [view addSubview:filterView];
    [filterView makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.width.equalTo(view);
        make.left.equalTo(view.right).offset(kWidth - SCREEN_W);
    }];
    //筛选按钮
    filterView.filterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [filterView.filterBtn setBackgroundImage:[UIImage imageNamed:@"filter_category_normal"] forState:UIControlStateNormal];
    [filterView.filterBtn setBackgroundImage:[UIImage imageNamed:@"filter_category_highlighted"] forState:UIControlStateHighlighted];
    [filterView.filterBtn addTarget:filterView action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:filterView.filterBtn];
    //筛选按钮约束
    [filterView.filterBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.centerY);
        make.right.equalTo(view.right);
    }];
    return filterView;
}

+ (instancetype)addFilterView:(UIView *)view type:(LSRightFilterListViewType)type delegate:(id<LSRightFilterListViewDelegate>)delegate {
    LSRightFilterListView *fileterView = [LSRightFilterListView addFilterView:view delegate:delegate];
    fileterView.type = type;
    if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101 && (type == LSRightFilterListViewTypeCategoryFirst)) {//服鞋分类显示品类图片
        [fileterView.filterBtn setBackgroundImage:[UIImage imageNamed:@"filter_category_clothingshoes_normal"] forState:UIControlStateNormal];
        [fileterView.filterBtn setBackgroundImage:[UIImage imageNamed:@"filter_category_clothingshoes_highlighted"] forState:UIControlStateHighlighted];

    }
    if (fileterView.type == LSRightFilterListViewTypeSuppilerCategory) {//类别
        [fileterView.filterBtn setBackgroundImage:[UIImage imageNamed:@"filter_leibie_normal"] forState:UIControlStateNormal];
        [fileterView.filterBtn setBackgroundImage:[UIImage imageNamed:@"filter_leibie_highlighted"] forState:UIControlStateHighlighted];
    }
    
    [fileterView loadData];
    return fileterView;
}

- (void)loadData {
    if (self.type == LSRightFilterListViewTypeCategoryLast || self.type == LSRightFilterListViewTypeCategoryFirst) {
        [self loadCategoryList];
        self.title = @"商品分类";
    } else if (self.type == LSRightFilterListViewTypeSuppilerCategory) {
        self.title = @" 类别管理";
        [self loadSuppilerList];
    }

}

#pragma mark - 加载分类列表
- (void)loadCategoryList {
    NSString *url = self.type == LSRightFilterListViewTypeCategoryFirst ? @"category/firstCategoryInfo" : @"category/lastCategoryInfo";
    NSDictionary *param = self.type == LSRightFilterListViewTypeCategoryFirst ? nil : @{@"hasNoCategory" : @"1"};
    __weak typeof(self) wself = self;
    wself.datas = [NSMutableArray array];
    CategoryVo *categoryVo = [[CategoryVo alloc] init];
    categoryVo.name = @"全部";
    categoryVo.categoryId = @"";
    [self.datas addObject:categoryVo];
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:NO CompletionHandler:^(id json) {
        if ([ObjectUtil isNotNull:json[@"categoryList"]]) {
            NSMutableArray *list = [CategoryVo mj_objectArrayWithKeyValuesArray:json[@"categoryList"]];
            [wself.datas addObjectsFromArray:list];
            [wself.datas enumerateObjectsUsingBlock:^(CategoryVo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.categoryId isEqualToString:@"noCategory"]) {
                    obj.categoryId = @"0";
                }
            }];
            [wself.tableView reloadData];
        }
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json];
    }];

}

#pragma mark - 加载供应商类别
- (void)loadSuppilerList {
    __weak typeof(self) wself = self;
    wself.datas = [NSMutableArray array];
    NSString *url = @"supplyinfoManage/getSupplyType";
    [BaseService getRemoteLSDataWithUrl:url param:nil withMessage:nil show:NO CompletionHandler:^(id json) {
        [wself.datas removeAllObjects];
        TreeNode *treeNode = [[TreeNode alloc] init];
        treeNode.itemId = @"";
        treeNode.itemName = @"全部类别";
        [wself.datas addObject:treeNode];
        NSMutableArray *arr = [SupplyTypeVo converToArr:[json objectForKey:@"listMap"]];
        if (arr!=nil&&arr.count>0) {
            for (SupplyTypeVo *supplyTypeVo in arr) {
                treeNode = [[TreeNode alloc] init];
                treeNode.itemId = supplyTypeVo.typeVal;
                treeNode.itemName = supplyTypeVo.typeName;
                [wself.datas addObject:treeNode];
            }
        }
        [wself.tableView reloadData];
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json];
    }];
    
    
}
- (void)reloadData {
    [self loadData];
}


- (instancetype)init {
    if (self = [super init]) {
        [self configViews];
        [self configConstraints];
    }
    return self;
}

- (void)configViews {
    //右侧筛选页面
    self.rightView = [[UIView alloc] init];
    self.rightView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.95];
    [self addSubview:self.rightView];
    //设置筛选条件标题
    self.lblTitle = [[UILabel alloc] init];
    self.lblTitle.textColor = [ColorHelper getTipColor6];
    self.lblTitle.font = [UIFont boldSystemFontOfSize:16];
    [self.rightView addSubview:self.lblTitle];
    
    //设置顶部按钮
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *pic=[UIImage imageNamed:@"ico_manage"];
    [self.btn setImage:[pic transformWidth:22 height:22] forState:UIControlStateNormal];
    [self.btn setTitleColor:[ColorHelper getBlueColor] forState:UIControlStateNormal];
    self.btn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.btn.layer.masksToBounds = YES;
    self.btn.layer.cornerRadius = 4;
    self.btn.layer.borderWidth = 1;
    self.btn.hidden = YES;
    self.btn.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.1].CGColor;
    [self.btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightView addSubview:self.btn];
    
    //设置顶部分割线
    self.topLine = [[UIView alloc] init];
    self.topLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [self.rightView addSubview:self.topLine];
    //设置表格
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 44;
    [self.rightView addSubview:self.tableView];
}

//设置标题
- (void)setTitle:(NSString *)title {
    _title = title;
    //设置标题
    self.lblTitle.text = title;
    [self.btn setTitle:[NSString stringWithFormat:@"  %@", title] forState:UIControlStateNormal];
}

//设置数据源
- (void)setDatas:(NSMutableArray<id<INameItem>> *)datas {
    _datas = datas;
    [self.tableView reloadData];
}
//设置按钮是否显示
- (void)setIsShowBtn:(BOOL)isShowBtn {
    self.btn.hidden = !isShowBtn;
    self.lblTitle.hidden = isShowBtn;
}


- (void)configConstraints {
    __weak typeof(self) wself = self;
    CGFloat margin = 10;
    //右侧筛选页面
    [self.rightView makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(wself);
        make.right.equalTo(wself);
        make.width.equalTo(kWidth);
    }];
    //设置筛选条件标题
    [self.lblTitle makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.rightView.left).offset(margin);
        make.top.equalTo(wself.rightView.top).offset(30);
    }];
    
    //设置筛选按钮标题
    [self.btn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.rightView.left).offset(margin);
        make.top.equalTo(wself.rightView.top).offset(20);
        make.right.equalTo(wself.rightView.right).offset(- margin);
        make.height.equalTo(40);
    }];
    
    //设置顶部分割线
    [self.topLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.rightView.left).offset(margin);
        make.right.equalTo(wself.rightView.right).offset(-margin);
        make.top.equalTo(wself.rightView.top).offset(63);
        make.height.equalTo(@1);
    }];
    //设置表格
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself.rightView);
        make.top.equalTo(wself.topLine.bottom).offset(margin);
    }];
}

#pragma mark - 按钮点击事件
- (void)btnClick:(UIButton *)btn {
    if (btn == self.filterBtn) {//筛选按钮
        if (self.isRight) {
            [self showMoveIn];
        } else {
            [self showMoveOut];
        }
    } else if (btn == self.btn) {//顶部按钮
        if ([self.delegate respondsToSelector:@selector(rightFilterListViewDidClickTopBtn:)]) {
            [self.delegate rightFilterListViewDidClickTopBtn:self];
        }
        
    }
   
}

#pragma mark - 筛选页面动画
- (void)showMoveIn {
    __weak typeof(self) wself = self;
    self.hidden = NO;
    self.isRight = NO;
    UIView *superView = wself.superview;
    [self.filterBtn updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superView.right).offset(-kWidth);
    }];
    [self updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.right).offset(-SCREEN_W);
    }];
    [UIView animateWithDuration:0.3 animations:^{
        [superView layoutIfNeeded];
    } completion:^(BOOL finished) {
        wself.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    }];
    
}

- (void)showMoveOut {
    self.isRight = YES;
    __weak typeof(self) wself = self;
    UIView *superView = wself.superview;
    wself.backgroundColor = [UIColor clearColor];
    [self.filterBtn updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superView.right);
    }];
    [self updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.right).offset(kWidth - SCREEN_W);
    }];
    [UIView animateWithDuration:0.3 animations:^{
        [superView layoutIfNeeded];
    } completion:^(BOOL finished) {
        wself.hidden = YES;
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint p = [[touches anyObject] locationInView:self];
    if (!CGRectContainsPoint(self.rightView.frame, p)) {
        [self showMoveOut];
    }
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSRightFilterListCell *cell = [LSRightFilterListCell rightFilterListCellWithTableView:tableView];
    id<INameItem> obj = self.datas[indexPath.row];
    cell.obj = obj;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(rightFilterListView:didSelectRow:)]) {
        [self.delegate rightFilterListView:self didSelectRow:indexPath.row];
    }
    
    if ([self.delegate respondsToSelector:@selector(rightFilterListView:didSelectObj:)]) {
        [self.delegate rightFilterListView:self didSelectObj:self.datas[indexPath.row]];
    }
    [self showMoveOut];
}



@end

