//
//  SortTableView.m
//  retailapp
//
//  Created by guozhi on 16/2/18.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "SortTableView2.h"
#import "NavigateTitle2.h"
#import "XHAnimalUtil.h"
#import "SortTableViewCell2.h"
#import "UIView+Sizes.h"
#import "MicroShopHomepageVo.h"

@interface SortTableView2 ()<UITableViewDelegate,UITableViewDataSource,INavigateEvent>
@property (weak, nonatomic) IBOutlet UIView *titleDiv;
@property (weak, nonatomic) IBOutlet UITableView *mainGrid;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic,strong) NavigateTitle2* titleBox;
@property (nonatomic, copy) SetCellContext setCellContext;
@property (nonatomic, copy) OnRightClick onRightClick;
@end

@implementation SortTableView2

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil datas:(NSMutableArray *)datas onRightBtnClick:(OnRightClick)onRightBtnClick setCellContext:(SetCellContext)setCellContext {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.setCellContext = setCellContext;
        self.onRightClick = onRightBtnClick;
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
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"排序" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
    self.titleBox.lblRight.text=@"确定";
    [self.titleDiv addSubview:self.titleBox];
}

- (void)onNavigateEvent:(Direct_Flag)event
{
    if (event == DIRECT_LEFT) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        [self.navigationController popViewControllerAnimated:NO];
    } else {
         _onRightClick(self.datas);
    }

}

- (void)initMainGrid {
    [self.mainGrid setEditing:YES animated:NO];
    self.mainGrid.tableFooterView = [ViewFactory generateFooter:0];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    
    SortTableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"SortTableViewCell2" owner:self options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    _setCellContext(cell,indexPath);
    MicroShopHomepageVo *vo=[self.datas objectAtIndex:indexPath.row];
    if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {
        [cell setInitView:vo.filePath styleName:vo.styleName styleCode:vo.styleCode];
    } else {
        [cell setInitView:vo.filePath styleName:vo.goodsName styleCode:vo.goodsBarCode];
    }
    
    cell.line.ls_top = cell.ls_height - 1;
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
    SortTableViewCell2 *cell = (SortTableViewCell2 *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.ls_height;
}





@end
