//
//  GoodsAttributeValSortView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/12/9.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GoodsAttributeValSortView.h"
#import "GoodsInnerCodeAttributeSortCell.h"
#import "AttributeValVo.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "XHAnimalUtil.h"
#import "JsonHelper.h"
#import "ViewFactory.h"

@interface GoodsAttributeValSortView ()

@property (nonatomic, strong) GoodsService* goodsService;

@property (nonatomic, retain) NSMutableArray *datas;

@property (nonatomic, retain) NSString* attributeGroupId;

@property (nonatomic, retain) NSString* attributeName;

@end

@implementation GoodsAttributeValSortView


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
    [self configTitle:[NSString stringWithFormat:@"%@排序", self.attributeName]];
    [self.tableView setEditing:YES animated:YES];
    [self.tableView reloadData];
}

-(void) loadDatas:(NSMutableArray *)attributeValList attributeGroupId:(NSString *)attributeGroupId attributeName:(NSString*) attributeName callBack:(goodsAttributeValSortBack)callBack
{
    self.goodsAttributeValSortBack = callBack;
    self.datas= [[NSMutableArray alloc] init];
    self.datas = [NSMutableArray arrayWithArray:attributeValList];
    _attributeGroupId = attributeGroupId;
    _attributeName = attributeName;
}

#pragma navigateTitle.
-(void) initHead
{
    [self configTitle:@"排序" leftPath:Head_ICON_CANCEL rightPath:Head_ICON_OK];
}

-(void) onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event==LSNavigationBarButtonDirectLeft) {
        self.goodsAttributeValSortBack(NO);
    }else{
        __weak GoodsAttributeValSortView* weakSelf = self;
        short count = 1;
        NSMutableArray* list = [[NSMutableArray alloc] init];
        for (short sort = self.datas.count - 1; sort >= 0; sort --) {
            AttributeValVo* attributeValVo = [self.datas objectAtIndex:sort];
            attributeValVo.sortCode = count;
            count ++;
            [list addObject:[JsonHelper getObjectData:attributeValVo]];
        }
        
        if (list.count == 0) {
            [AlertBox show:[NSString stringWithFormat:@"请先添加%@!", self.attributeName]];
            return ;
        }
        
        [_goodsService sortAttributeVal:_attributeGroupId groupList:list completionHandler:^(id json) {
            if (!weakSelf) {
                return ;
            }
            self.goodsAttributeValSortBack(YES);
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
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
        AttributeValVo *item = [self.datas objectAtIndex:indexPath.row];
        detailItem.lblName.text = item.attributeVal;
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
