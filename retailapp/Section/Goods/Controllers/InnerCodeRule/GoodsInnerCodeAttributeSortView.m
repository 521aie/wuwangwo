//
//  GoodsInnerCodeAttributeSortView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/8/14.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GoodsInnerCodeAttributeSortView.h"
#import "UIHelper.h"
#import "ObjectUtil.h"
#import "GoodsInnerCodeRegulationSettingView.h"
#import "BaseAttributeNameVo.h"
#import "ViewFactory.h"
#import "GoodsInnerCodeAttributeSortCell.h"
#import "XHAnimalUtil.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "JsonHelper.h"
#import "SkuRuleVo.h"
#import "AttributeVo.h"

@interface GoodsInnerCodeAttributeSortView ()

@property (nonatomic, strong) GoodsService* goodsService;

@end

@implementation GoodsInnerCodeAttributeSortView


- (void)viewDidLoad {
    [super viewDidLoad];
    _goodsService = [ServiceFactory shareInstance].goodsService;
    [self initHead];
    [self configViews];
    [self initGrid];
    [self loadDatas];
}

- (void)configViews {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    self.tableView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

- (void)loadDatas
{
    [self.tableView setEditing:YES animated:YES];
    [self.tableView reloadData];
}

- (void)loadDatas:(NSMutableArray *)skuList callBack:(goodsInnerCodeAttributeSortBack) callBack
{
    self.goodsInnerCodeAttributeSortBack  = callBack;
    self.datas= [[NSMutableArray alloc] init];
    self.datas = [NSMutableArray arrayWithArray:skuList];
}

#pragma navigateTitle.
-(void) initHead
{
    [self configTitle:@"排序" leftPath:Head_ICON_CANCEL rightPath:Head_ICON_OK];
}

-(void) onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event==LSNavigationBarButtonDirectLeft) {
        self.goodsInnerCodeAttributeSortBack(nil);
    }else{
        __weak GoodsInnerCodeAttributeSortView* weakSelf = self;
        short count = 1;
        for (SkuRuleVo* sku in self.datas) {
            sku.sortCode = count;
            count ++;
        }
        
        [_goodsService saveInnerCodeSetting:self.datas completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [weakSelf.navigationController popViewControllerAnimated:NO];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
        
        self.goodsInnerCodeAttributeSortBack(self.datas);
    }
}

#pragma table部分
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsInnerCodeAttributeSortCell *detailItem = (GoodsInnerCodeAttributeSortCell *)[self.tableView dequeueReusableCellWithIdentifier:GoodsInnerCodeAttributeSortCellIndentifier];
    
    if (!detailItem) {
        detailItem = [[NSBundle mainBundle] loadNibNamed:@"GoodsInnerCodeAttributeSortCell" owner:self options:nil].lastObject;
    }
    
    if ([ObjectUtil isNotEmpty:self.datas]) {
        SkuRuleVo *item = [self.datas objectAtIndex:indexPath.row];
        detailItem.lblName.text = item.attributeName;
        detailItem.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return detailItem;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    id object=[self.datas objectAtIndex:sourceIndexPath.row];
    [self.datas removeObjectAtIndex:sourceIndexPath.row];
    [self.datas insertObject:object atIndex:destinationIndexPath.row];
}

#pragma mark UITableView无section列表

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count == 0 ? 0 :self.datas.count;
}

-(void)initGrid
{
    self.tableView.opaque=YES;
    UIView* view=[ViewFactory generateFooter:88];
    view.backgroundColor=[UIColor clearColor];
    [self.tableView setTableFooterView:view];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

@end
