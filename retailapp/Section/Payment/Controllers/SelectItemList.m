//
//  SelectItemList.m
//  retailapp
//
//  Created by guozhi on 16/5/15.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "SelectItemList.h"
#import "XHAnimalUtil.h"
#import "SearchBar2.h"
#import "ISearchBarEvent.h"
#import "SelectItemCell.h"
#import "INameItem.h"
#import "AlertBox.h"


@interface SelectItemList ()<ISearchBarEvent,UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) SearchBar2 *searchBar;
@property (strong, nonatomic) UITableView *mainGrid;
@property (nonatomic, copy) NSString *txtPlaceHolder;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) id<INameItem> selectItem;
@property (nonatomic, copy) NSString *selectId;
@property (nonatomic, copy) NSString *txtTitle;
@property (nonatomic, copy) CallBlock callBlock;
@property (nonatomic, strong) NSMutableArray *searchDatas;
@end

@implementation SelectItemList

- (instancetype)initWithtxtTitle:(NSString *)txtTitle txtPlaceHolder:(NSString *)txtPlaceHolder {
    self = [super init];
    if (self) {
        self.txtTitle = txtTitle;
        self.txtPlaceHolder = txtPlaceHolder;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    [self setupSearchBar];
    [self setupMainGrid];
    [self configHelpButton:HELP_PAYMENT_ACCOUNT];
}

- (void)setupNavigationBar {
    [self configNavigationBar:LSNavigationBarButtonDirectLeft title:@"关闭" filePath:Head_ICON_CANCEL];
    [self configTitle:self.txtTitle];
    [self configNavigationBar:LSNavigationBarButtonDirectRight title:@"保存" filePath:Head_ICON_OK];
}

- (void)setupSearchBar {
    __weak typeof(self) wself = self;
    self.searchBar = [SearchBar2 searchBar2];
    [self.searchBar initDelagate:self placeholder:self.txtPlaceHolder];
    [self.view addSubview:self.searchBar];
    [self.searchBar makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(wself.view);
        make.top.equalTo(wself.view.top).offset(kNavH);
        make.size.equalTo(44);
    }];
}

- (void)setupMainGrid {
    __weak typeof(self) wself = self;
    self.mainGrid = [[UITableView alloc] init];
    self.mainGrid.backgroundColor = [UIColor clearColor];
    self.mainGrid.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainGrid.rowHeight = 88;
    self.mainGrid.delegate = self;
    self.mainGrid.dataSource = self;
    [self.view addSubview:self.mainGrid];
    [self.mainGrid makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself.view);
        make.top.equalTo(wself.searchBar.bottom);
    }];
}

- (void)selectId:(NSString *)selectId list:(NSMutableArray *)list callBlock:(CallBlock)callBlock {
    self.selectId = selectId;
    self.datas = list;
    self.searchDatas = [list mutableCopy];
    self.callBlock = callBlock;
}

- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event {
    if (event == LSNavigationBarButtonDirectLeft) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
        
    } else {
        if (self.selectItem == nil && !self.selectId) {
             [AlertBox show:@"请选择一个选项哦!"];
        } else {
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [self.navigationController popViewControllerAnimated:NO];
            if (self.callBlock != nil) {
                  _callBlock(self.selectItem);
            }
          
            
        }
    }
}


-(void)imputFinish:(NSString *)keyWord {
    if ([NSString isBlank:keyWord]) {
        self.datas = [self.searchDatas mutableCopy];
    } else {
        [self.datas removeAllObjects];
        for (id<INameItem>data in self.searchDatas) {
            if ([[data obtainItemName] rangeOfString:keyWord].location != NSNotFound) {
                [self.datas addObject:data];
            }
        }
    }
    [self.mainGrid reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"SelectItemCell" owner:self options:nil].lastObject;
    }
    id<INameItem> data = (id<INameItem>)[self.datas objectAtIndex:indexPath.row];
    BOOL isSelected = NO;
    if ([[data obtainItemId] isEqualToString:self.selectId]) {
        isSelected = YES;
    }
    [cell initWithData:data isSelected:isSelected];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectItem = (id<INameItem>)[self.datas objectAtIndex:indexPath.row];
    self.selectId = [self.selectItem obtainItemId];
    [self.mainGrid reloadData];
}



@end
