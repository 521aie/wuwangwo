//
//  LSFilterView.m
//  retailapp
//
//  Created by guozhi on 2016/10/25.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#define kWidth (SCREEN_W/2 + 40)
#import "LSFilterView.h"
#import "LSFilterCell.h"
#import "LSFilterModel.h"
@interface LSFilterView () <UITableViewDelegate, UITableViewDataSource, LSFilterCellDelegate>
/** 筛选条件标题 */
@property (nonatomic, strong) UILabel *filterTitleLbl;
/** 顶部分割线 */
@property (nonatomic, strong) UIView *topLine;
/** 底部部分割线 */
@property (nonatomic, strong) UIView *bottomLine;
/** 重置按钮 */
@property (nonatomic, strong) UIButton *resetBtn;
/** 确认按钮 */
@property (nonatomic, strong) UIButton *confirmBtn;
/** 设置表格 */
@property (nonatomic, strong) UITableView *tableView;
/** 筛选按钮 */
@property (nonatomic, strong) UIButton *filterBtn;
/** 筛选页面的父视图 */
@property (nonatomic, weak) UIView *view;
/** 筛选按钮是否在右边 */
@property (nonatomic, assign) BOOL isRight;
/** 筛选页面右边View */
@property (nonatomic, strong) UIView *rightView;
/** 代理 */
@property (nonatomic, weak) id<LSFilterViewDelegate> delegate;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray<LSFilterModel *> *datas;

@end
@implementation LSFilterView
+ (instancetype)addFilterViewToView:(UIView *)view delegate:(id<LSFilterViewDelegate>)delegate datas:(NSMutableArray<LSFilterModel *> *)datas{
    
    //筛选页面
    LSFilterView *filterView = [[LSFilterView alloc] init];
    filterView.isRight = YES;
    filterView.hidden = YES;
    [view addSubview:filterView];
    filterView.delegate = delegate;
    filterView.view = view;
    filterView.datas = datas;
    [filterView makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.width.equalTo(filterView.superview);
        make.left.equalTo(filterView.superview.right).offset(kWidth - SCREEN_W);
    }];
    
    //设置筛选按钮
    filterView.filterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [filterView.filterBtn setBackgroundImage:[UIImage imageNamed:@"ico_filter_normal"] forState:UIControlStateNormal];
    [filterView.filterBtn setBackgroundImage:[UIImage imageNamed:@"ico_filter_highlighted"] forState:UIControlStateHighlighted];
    [filterView.filterBtn addTarget:filterView action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:filterView.filterBtn];

    //筛选按钮约束
    [filterView.filterBtn makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(38, 67));
        make.centerY.equalTo(view.centerY);
        make.right.equalTo(view.right);
    }];
    
    
    
    return filterView;
}

- (void)refreshData {
    [self.tableView reloadData];
}
- (instancetype)init {
    if (self = [super init]) {
        [self configViews];
        [self configConstraints];
    }
    return self;
}
#pragma mark - 配置页面
- (void)configViews {
    //右侧筛选页面
    self.rightView = [[UIView alloc] init];
    self.rightView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.95];
    [self addSubview:self.rightView];
    //设置筛选条件标题
    self.filterTitleLbl = [[UILabel alloc] init];
    self.filterTitleLbl.text = @"筛选条件";
    self.filterTitleLbl.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    self.filterTitleLbl.font = [UIFont boldSystemFontOfSize:16];
    [self.rightView addSubview:self.filterTitleLbl];
    
    
    //设置顶部分割线
    self.topLine = [[UIView alloc] init];
    self.topLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [self.rightView addSubview:self.topLine];
    
    //设置底部部分割线
    self.bottomLine = [[UIView alloc] init];
    self.bottomLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [self.rightView addSubview:self.bottomLine];
    
    //设置重置按钮
    self.resetBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.resetBtn.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
    [self.resetBtn setTitle:@"重置" forState:UIControlStateNormal];
    [self.resetBtn setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] forState:UIControlStateNormal];
    self.resetBtn.layer.cornerRadius = 4;
    [self.resetBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightView addSubview:self.resetBtn];
    
    //设置确认按钮
    self.confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.confirmBtn.backgroundColor = [ColorHelper getRedColor];
    [self.confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [self.confirmBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightView addSubview:self.confirmBtn];
    self.confirmBtn.layer.cornerRadius = 4;
    
    //设置表格
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.rightView addSubview:self.tableView];
    
    
    
}

#pragma mark - 配置约束
- (void)configConstraints {
    CGFloat margin = 10;
     __weak typeof(self) wself = self;
    //右侧View约束
    //右侧筛选页面约束
    [self.rightView makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(wself);
        make.right.equalTo(wself);
        make.width.equalTo(kWidth);
    }];
    
    //设置筛选条件标题
    [self.filterTitleLbl makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.rightView.left).offset(margin);
        make.top.equalTo(wself.rightView.top).offset(30);
    }];
    //设置顶部分割线
    [self.topLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.rightView.left).offset(margin);
        make.right.equalTo(wself.rightView.right).offset(-margin);
        make.top.equalTo(wself.rightView.top).offset(63);
        make.height.equalTo(@1);
    }];
    //设置底部分割线
    [self.bottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.rightView.left).offset(margin);
        make.right.equalTo(wself.rightView.right).offset(-margin);
        make.bottom.equalTo(wself.rightView.bottom).offset(-63);
        make.height.equalTo(@1);
    }];
    
    //设置重置按钮
    CGFloat resetBtnH = 30;
    CGFloat resetBtnBottomH = (64 - resetBtnH)/2;
    [self.resetBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.rightView.left).offset(margin);
        make.height.equalTo(@(resetBtnH));
        make.bottom.equalTo(wself.rightView.bottom).offset(-resetBtnBottomH);
        make.width.equalTo(wself.confirmBtn.width);
        make.height.equalTo(wself.confirmBtn.height);
        make.right.equalTo(wself.confirmBtn.left).offset(-15);
    }];
    //设置完成按钮
    [self.confirmBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wself.rightView.right).offset(-margin);
        make.top.equalTo(wself.resetBtn.top);
    }];
    
    //设置表格
    UIEdgeInsets padding = UIEdgeInsetsMake(64, margin, 64, margin);
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(wself.rightView).insets(padding);
    }];
    

    
}

- (void)btnClick:(UIButton *)btn {
    if (btn == self.filterBtn) {//点击筛选按钮
        if (self.isRight) {
            [self showMoveIn];
        } else {
            [self showMoveOut];
        }
         self.isRight = !self.isRight;
    } else if (btn == self.resetBtn) {//点击重置按钮
        if ([self.delegate respondsToSelector:@selector(filterViewDidClickResetBtm)]) {
            self.datas = [self.delegate filterViewDidClickResetBtm];
        }
        [self.datas enumerateObjectsUsingBlock:^(LSFilterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.selectItem = obj.oldSelectItem;
        }];
        [self.tableView reloadData];
    } else if (btn == self.confirmBtn) {//点击确认按钮
        [self showMoveOut];
        self.isRight = !self.isRight;
        if ([self.delegate respondsToSelector:@selector(filterViewDidClickComfirmBtn)]) {
            [self.delegate filterViewDidClickComfirmBtn];
        }
    }
}


#pragma mark - 筛选页面动画
- (void)showMoveIn {
    __weak typeof(self) wself = self;
    self.hidden = NO;
    [self.filterBtn updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wself.view.right).offset(-kWidth);
    }];
    [self updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.view.right).offset(-SCREEN_W);
    }];
  
    [UIView animateWithDuration:0.3 animations:^{
         [wself.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        wself.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    }];

}

- (void)showMoveOut {
    __weak typeof(self) wself = self;
    [self.filterBtn updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wself.view.right);
    }];
    [self updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.view.right).offset(kWidth - SCREEN_W);
    }];
    wself.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.3 animations:^{
        [wself.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        wself.hidden = YES;
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint p = [[touches anyObject] locationInView:self.view];
    if (!CGRectContainsPoint(self.rightView.frame, p)) {
        [self showMoveOut];
        self.isRight = !self.isRight;
    }
}



#pragma mark - <UITableViewDelegate>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSFilterCell *cell = [LSFilterCell filterCellWithTableView:tableView delegate:self];
    cell.model = self.datas[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSFilterModel *model = self.datas[indexPath.row];
    return model.height;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}
#pragma mark - <LSFilterCellDelegate>
- (void)filterCellDidClickModel:(LSFilterModel *)filterModel {
    if ([self.delegate respondsToSelector:@selector(filterViewdidClickModel:)]) {
        [self.delegate filterViewdidClickModel:filterModel];
    }
}

@end
