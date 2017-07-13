//
//  SortView.m
//  retailapp
//
//  Created by qingmei on 15/11/25.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SortView.h"
#import "SortViewCell.h"
#import "NavigateTitle2.h"
#import "XHAnimalUtil.h"
#import "ObjectUtil.h"

@implementation SortObject : NSObject
@end


@interface SortView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) id<SortViewDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *sourceList;
@end

@implementation SortView

- (id)initWithSourceList:(NSArray *)sourceList andDelegate:(id<SortViewDelegate>) delegate
{
    self = [super init];
    if (self) {
        if ([self isSortObjectInSourceList:sourceList]) {
            self.sourceList = [sourceList mutableCopy];
            self.delegate = delegate;
        }
        else{
            self.sourceList = nil;
        }
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMainView];
}

- (void)initMainView{
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    //设置导航栏
    [self configTitle:@"排序" leftPath:Head_ICON_BACK rightPath:nil];
    //设置table编辑状态
   
    
    self.mainGrid = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    self.mainGrid.delegate = self;
    self.mainGrid.dataSource = self;
    self.mainGrid.backgroundColor = [UIColor clearColor];
    self.mainGrid.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.mainGrid];
    [_mainGrid setEditing:YES animated:NO];
}

//判断源数据是否是SortObject
- (BOOL)isSortObjectInSourceList:(NSArray *)sourceList{
    if ([ObjectUtil isNotEmpty:sourceList]) {
        for (id obj in sourceList) {
            if (![obj isKindOfClass:[SortObject class]]) {
                return NO;
            }
        }
    }
    return YES;
}



#pragma mark - INavigateEvent代理  (导航)
-(void) onNavigateEvent:(LSNavigationBarButtonDirect)event{
    if (event==LSNavigationBarButtonDirectLeft) {
        if (_delegate) {
            [_delegate SortViewCancel];
        }
    } else {
         if (_delegate) {
             [_delegate SortViewSave];
         }
    }
}


#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sourceList.count>0?1:0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _sourceList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *cellIdentifier = @"sortViewCell";
    SortViewCell* cell = (SortViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [SortViewCell getInstance];
    }
    
    if ([ObjectUtil isNotEmpty:_sourceList]) {
        SortObject *obj = [_sourceList objectAtIndex:indexPath.row];
        if ([ObjectUtil isNotNull:obj]) {
            [cell loadCell:obj.objectName];
        }
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    //tableView 数据源修改
    NSMutableArray * tempArr = [NSMutableArray arrayWithArray:_sourceList];
    id object=[tempArr objectAtIndex:sourceIndexPath.row];
    [tempArr removeObjectAtIndex:sourceIndexPath.row];
    [tempArr insertObject:object atIndex:destinationIndexPath.row];
    _sourceList = tempArr;

    //更改标题栏
    [self editTitle:YES act:ACTION_CONSTANTS_EDIT];
    
    if (_delegate) {
        [_delegate SortViewMoveRowAtIndexPath:sourceIndexPath.row toIndexPath:destinationIndexPath.row];
    }
}


@end
