//
//  SortTableView.m
//  retailapp
//
//  Created by guozhi on 16/2/18.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "SortTableView.h"
#import "XHAnimalUtil.h"
#import "SortTableViewCell.h"
#import "UIView+Sizes.h"

@interface SortTableView ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *mainGrid;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, copy) OnRightClick onRightClick;
@property (nonatomic ,copy) SetCellContext setCellContext;/* <<#desc#>*/
@end

@implementation SortTableView

- (instancetype)initWithDatas:(NSMutableArray *)datas onRightBtnClick:(OnRightClick)onRightBtnClick setCellContext:(SetCellContext)setCellContext{
    self = [super init];
    if (self) {
        self.onRightClick = onRightBtnClick;
        self.setCellContext = setCellContext;
        self.datas = [[NSMutableArray alloc] initWithArray:datas];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigate];
    [self initMainGrid];
    // Do any additional setup after loading the view.
}

- (void)initNavigate
{
    NSString *title = self.titleStr ? self.titleStr : @"排序";
    [self configTitle:title leftPath:Head_ICON_CANCEL rightPath:Head_ICON_OK];
}
- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event == LSNavigationBarButtonDirectRight) {
        _onRightClick(self.datas);
        
    }
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
    [self.navigationController popViewControllerAnimated:NO];

}

- (void)initMainGrid {
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    self.mainGrid = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    self.mainGrid.backgroundColor = [UIColor clearColor];
    self.mainGrid.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainGrid.delegate = self;
    self.mainGrid.dataSource = self;
    [self.view addSubview:self.mainGrid];
    [self.mainGrid setEditing:YES animated:NO];
    self.mainGrid.tableFooterView = [ViewFactory generateFooter:0];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    
    SortTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"SortTableViewCell" owner:self options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    _setCellContext(cell ,_datas[indexPath.row]);
    UILabel *lblTitle = (UILabel *)[cell viewWithTag:1];
    CGRect rect = [lblTitle.text boundingRectWithSize:CGSizeMake(SCREEN_W  - 70, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    lblTitle.frame = CGRectMake(-25, 16, rect.size.width, rect.size.height);
    cell.frame = CGRectMake(0, 0, SCREEN_W, rect.size.height + 32);
    cell.line.ls_top = cell.ls_height - 1;
    cell.line.ls_width = SCREEN_W - 20;
    return cell;

}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

// 移动单元格的时候调用
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    // 先记录一下要移动的字符串
    id obj = [self.datas objectAtIndex:sourceIndexPath.row];
    
    // 把要移动的字符串从原来的位置删掉
    [self.datas removeObjectAtIndex:sourceIndexPath.row];
    
    // 再把刚才记录的字符串插到你想放的位置
    [self.datas insertObject:obj atIndex:destinationIndexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SortTableViewCell *cell = (SortTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.ls_height;
}





@end
