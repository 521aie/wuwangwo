//
//  GoodsAttributeListView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/8/13.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GoodsAttributeListView.h"
#import "GoodsAttributeCell2.h"
#import "ObjectUtil.h"
#import "StyleVo.h"
#import "ViewFactory.h"
#import "GoodsSingleAttributeListView.h"
#import "XHAnimalUtil.h"
#import "AttributeVo.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "JsonHelper.h"

@interface GoodsAttributeListView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;


@property (nonatomic, retain) NSMutableArray *datas;
@property (nonatomic, strong) GoodsService* goodsService;

@end

@implementation GoodsAttributeListView


- (void)viewDidLoad {
    [super viewDidLoad];
    _goodsService = [ServiceFactory shareInstance].goodsService;
    [self initHead];
    [self configViews];
    [self initGrid];
    [self loaddatas];
}
- (void)configViews {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

-(void) loaddatas
{
    __weak GoodsAttributeListView* weakSelf = self;
    [_goodsService selectAttributeList:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        [weakSelf responseSuccess:json];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

- (void)responseSuccess:(id)json
{
    self.datas = [NSMutableArray new];
    self.datas = [JsonHelper transList:[json objectForKey:@"attributeList"] objName:@"AttributeVo"];
    
    [self.tableView reloadData];
}

#pragma navigateTitle.
-(void) initHead
{
    [self configTitle:@"商品属性" leftPath:Head_ICON_BACK rightPath:nil];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.datas != nil) {
        [self showEditNVItemEvent:@"goodsAttribute" withObj:[self.datas objectAtIndex:indexPath.row]];
    }
}

-(void) showEditNVItemEvent:(NSString *)event withObj:(id<INameValueItem>)obj
{
    AttributeVo* editObj = (AttributeVo*) obj;
    GoodsSingleAttributeListView* vc = [[GoodsSingleAttributeListView alloc] init];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    [self.navigationController pushViewController:vc animated:NO];
    __weak GoodsAttributeListView* weakSelf = self;
    [vc loaddatas:editObj fromViewTag:GOODS_ATTRIBUTE_LIST_VIEW callBack:^(BOOL flg) {
        [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [weakSelf loaddatas];
        [weakSelf.navigationController popToViewController:weakSelf animated:NO];
    }];    
}

#pragma table部分
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsAttributeCell2 *detailItem = (GoodsAttributeCell2 *)[self.tableView dequeueReusableCellWithIdentifier:GoodsAttributeCell2Indentifier];
    
    if (!detailItem) {
        detailItem = [[NSBundle mainBundle] loadNibNamed:@"GoodsAttributeCell2" owner:self options:nil].lastObject;
    }
    
    if ([ObjectUtil isNotEmpty:self.datas]) {
        AttributeVo *item = [self.datas objectAtIndex:indexPath.row];
        detailItem.lblName.text = item.name;
        detailItem.lblInfo.text = [NSString stringWithFormat:@"已添加%tu个%@类型，%tu个%@", item.groupCnt, item.name, item.valCnt, item.name];
        detailItem.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return detailItem;
}

#pragma mark UITableView无section列表

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
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
