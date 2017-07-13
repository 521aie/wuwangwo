//
//  LSGoodsBatchViewController.m
//  retailapp
//
//  Created by guozhi on 16/9/13.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSGoodsBatchViewController.h"
#import "GoodsVo.h"
#import "GoodsBatchSelectCell.h"
#import "ObjectUtil.h"
#import "LSFooterView.h"
#import "UIHelper.h"
#import "AlertBox.h"
#import "LSGoodsListViewController.h"
#import "ViewFactory.h"
#import "XHAnimalUtil.h"
#import "GoodsBatchSaleSettingView.h"
#import "ServiceFactory.h"
#import "ISampleListEvent.h"
#import "LSGoodsListViewController.h"
@interface LSGoodsBatchViewController ()<ISampleListEvent,UIActionSheetDelegate, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, UIActionSheetDelegate, LSFooterViewDelegate>
@property (nonatomic, strong) GoodsService* goodsService;

@property (nonatomic,strong) NSMutableArray *goodsList;

@property (nonatomic, strong) NSMutableArray* goodsIdList;

@property (nonatomic) short type;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) LSFooterView *footerView;

@property (nonatomic, strong) NSMutableArray *datas;

@property (nonatomic, strong) GoodsVo *goodsVo;
@property (nonatomic, copy) NSString *createTime;


@end

@implementation LSGoodsBatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMainView];
    [self selectGoodsList];
}

- (void)initMainView {
    //标题栏
    [self configTitle:@"商品" leftPath:Head_ICON_CANCEL rightPath:nil];
    [self configNavigationBar:LSNavigationBarButtonDirectRight title:@"操作" filePath:Head_ICON_OK];
    
    CGFloat y = kNavH;
    
    //表格
    CGFloat tableViewX = 0;
    CGFloat tableViewY = y;
    CGFloat tableViewW = self.view.ls_width;
    CGFloat tableViewH = self.view.ls_height - y;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(tableViewX, tableViewY, tableViewW, tableViewH) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UIView* view=[ViewFactory generateFooter:88];
    view.backgroundColor=[UIColor clearColor];
    [self.tableView setTableFooterView:view];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    __weak typeof(self) wself = self;
    [self.tableView ls_addHeaderWithCallback:^{
        wself.createTime = nil;
        [wself selectGoodsList];
    }];
    [self.tableView ls_addFooterWithCallback:^{
        [wself selectGoodsList];
    }];
    
    //工具栏
    self.footerView = [LSFooterView footerView];
    [self.footerView initDelegate:self btnsArray:@[kFootSelectAll, kFootSelectNo]];
    [self.view addSubview:self.footerView];
    
    _goodsService = [ServiceFactory shareInstance].goodsService;
    _goodsList = [[NSMutableArray alloc] init];
    self.datas = [NSMutableArray array];
    
}

#pragma 查询商品一览
- (void)selectGoodsList
{
    __weak typeof(self) wself = self;
    [_goodsService selectGoodsList:self.searchType shopId:self.shopId searchCode:self.searchCode barCode: self.barCode categoryId:self.categoryId createTime:self.createTime validTypeList:nil completionHandler:^(id json) {
        [wself responseSuccess:json];
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
    } errorHandler:^(id json) {
        [AlertBox show:json];
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
    }];
}
- (void)responseSuccess:(id)json
{
    if ([[json objectForKey:@"searchStatus"] integerValue] == 1) {
        NSMutableArray *array = [json objectForKey:@"goodsVoList"];
        if (self.createTime == nil) {
            [self.datas removeAllObjects];
        }
        for (NSDictionary* dic in array) {
            [self.datas addObject:[GoodsVo convertToGoodsVo:dic]];
        }
        
        if ([ObjectUtil isNotNull:[json objectForKey:@"createTime"]]) {
            self.createTime = [[json objectForKey:@"createTime"] stringValue];
        }
    }
    
    [self.tableView reloadData];
    self.tableView.ls_show = YES;
}

-(void) loadDatasFromOperateView:(int) action
{
    if (action == ACTION_CONSTANTS_DEL) {
        for (GoodsVo* vo in _goodsList) {
            [self.datas removeObject:vo];
        }
    }
    [self.tableView reloadData];
}


-(void) onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event==LSNavigationBarButtonDirectLeft) {
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[LSGoodsListViewController class]]) {
                LSGoodsListViewController*listView = (LSGoodsListViewController *)vc;
                [listView loadDatasFromBatchSelectView];
            }
        }
        [self.navigationController popViewControllerAnimated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
    }else{
        if (_goodsList.count == 0) {
            [AlertBox show:@"请先选择商品!"];
            return;
        }
        // 连锁总部，微店开通
        if ([[Platform Instance] getShopMode] == 3 && [[[Platform Instance] getkey:PARENT_ID] isEqualToString:@"0"] && [[Platform Instance] getMicroShopStatus] == 2) {
            UIActionSheet *menu = [[UIActionSheet alloc]
                                   initWithTitle: @"请选择批量操作"
                                   delegate:self
                                   cancelButtonTitle:@"取消"
                                   destructiveButtonTitle:nil
                                   otherButtonTitles: @"删除", @"销售设置", @"上架", @"下架", nil];
            [menu showInView:self.view];
        } else {
            UIActionSheet *menu = [[UIActionSheet alloc]
                                   initWithTitle: @"请选择批量操作"
                                   delegate:self
                                   cancelButtonTitle:@"取消"
                                   destructiveButtonTitle:nil
                                   otherButtonTitles: @"删除", @"销售设置", @"上架", @"下架", nil];
            [menu showInView:self.view];
        }
    }
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    _goodsIdList = [[NSMutableArray alloc] init];
    if (_goodsList.count > 0) {
        for (GoodsVo* vo in _goodsList) {
            [_goodsIdList addObject:vo.goodsId];
        }
    }
    if (buttonIndex == 0) {
        //删除
        if ([[Platform Instance] lockAct:ACTION_GOODS_DELETE]) {
            [AlertBox show:@"登录用户无该权限!"];
            return ;
        } else {
            //删除
            static UIAlertView *alertView;
            if (alertView != nil) {
                [alertView dismissWithClickedButtonIndex:0 animated:NO];
                alertView = nil;
            }
            alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确认删除选中的商品吗?" delegate:self cancelButtonTitle:@"取消"  otherButtonTitles:@"确认", nil];
            _type = 1;
            [alertView show];
        }
    } else if (buttonIndex == 1) {
        //销售设置
        if ([[Platform Instance] lockAct:ACTION_MARKET_SET]) {
            [AlertBox show:@"登录用户无该权限!"];
            return ;
        } else {
            GoodsBatchSaleSettingView* vc = [[GoodsBatchSaleSettingView alloc] initWithIdList:_goodsIdList fromView:GOODS_BATCH_SELECT_VIEW];
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
            [self.navigationController pushViewController:vc animated:NO];
            __weak typeof(self) wself = self;
            [vc loaddatas:^(BOOL flg) {
                [XHAnimalUtil animal:wself.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
                if (flg) {
                    [wself notCheckAllEvent];
                }
                [wself.navigationController popToViewController:wself animated:NO];
            }];
        }
    } else if (buttonIndex == 2) {
        // 上架
        if ([[Platform Instance] lockAct:ACTION_GOODS_EDIT]) {
            [AlertBox show:@"登录用户无该权限!"];
            return ;
        } else {
            //上架
            __weak typeof(self) wself = self;
            [_goodsService setUpDownStatus:_goodsIdList shopId:_shopId status:@"1" completionHandler:^(id json) {
                [AlertBox show:@"批量商品上架成功!"];
                [wself.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj isKindOfClass:[LSGoodsListViewController class]]) {
                        LSGoodsListViewController *vc = nil;
                        vc =(LSGoodsListViewController *)obj;
                        [vc.tableView headerBeginRefreshing];
                        [XHAnimalUtil animal:wself.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
                        [wself.navigationController popToViewController:vc animated:NO];
                    }
                }];
            } errorHandler:^(id json) {
                [AlertBox show:json];
            }];
        }
    } else if (buttonIndex == 3) {
        // 下架
        if ([[Platform Instance] lockAct:ACTION_GOODS_EDIT]) {
            [AlertBox show:@"登录用户无该权限!"];
            return ;
        } else {
            //下架
            __weak typeof(self) wself = self;
            [_goodsService setUpDownStatus:_goodsIdList shopId:_shopId status:@"2" completionHandler:^(id json) {
                [AlertBox show:@"批量商品下架成功!"];
                [wself.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj isKindOfClass:[LSGoodsListViewController class]]) {
                        LSGoodsListViewController *vc = nil;
                        vc =(LSGoodsListViewController *)obj;
                        [vc.tableView headerBeginRefreshing];
                        [XHAnimalUtil animal:wself.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
                        [wself.navigationController popToViewController:vc animated:NO];
                    }
                }];
               
            } errorHandler:^(id json) {
                [AlertBox show:json];
            }];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
         __weak typeof(self) wself = self;
        switch (_type) {
            case 1:
            {
                //删除
                for (GoodsVo* vo in _goodsList) {
                    if ([vo.number longValue] != 0) {
                        [AlertBox show:@"该商品信息已被使用到库存和交易信息中，不能被删除!"];
                        return ;
                    }
                }
                
                [_goodsService deleteGoods:_goodsIdList shopId:_shopId completionHandler:^(id json) {
                    [AlertBox show:@"批量删除商品成功!"];
                    [wself.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj isKindOfClass:[LSGoodsListViewController class]]) {
                            LSGoodsListViewController *vc = nil;
                            vc =(LSGoodsListViewController *)obj;
                            [vc.tableView headerBeginRefreshing];
                            [XHAnimalUtil animal:wself.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
                            [wself.navigationController popToViewController:vc animated:NO];

                        }
                    }];
                   
//                    [wself loadDatasFromOperateView:ACTION_CONSTANTS_DEL];
                } errorHandler:^(id json) {
                    [AlertBox show:json];
                }];
                break;
            }
            default:
                break;
        }
    }
}

-(void) delFinish
{
    
}

#pragma  mark 全选和全不选
- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootSelectAll]) {
        [self checkAllEvent];
    } else if ([footerType isEqualToString:kFootSelectNo]) {
        [self notCheckAllEvent];
    }
}
-(void) checkAllEvent
{
    [_goodsList removeAllObjects];
    if (self.datas.count > 0) {
        for (NSDictionary *data in self.datas) {
            GoodsVo *vo = (GoodsVo *)data;
            vo.isCheck =@"1";
            [_goodsList addObject:vo];
        }
    }
    
    [self.tableView reloadData];
}

-(void) notCheckAllEvent
{
    if (self.datas.count > 0) {
        for (NSDictionary *data in self.datas) {
            GoodsVo *vo = (GoodsVo *)data;
            vo.isCheck =@"0";
        }
    }
    
    [_goodsList removeAllObjects];
    
    [self.tableView reloadData];
}

#pragma mark table部分
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsBatchSelectCell *detailItem = (GoodsBatchSelectCell *)[self.tableView dequeueReusableCellWithIdentifier:MemberTypeCellIndentifier];
    
    if (!detailItem) {
        detailItem = [[NSBundle mainBundle] loadNibNamed:@"GoodsBatchSelectCell" owner:self options:nil].lastObject;
    }
    if ([ObjectUtil isNotEmpty:self.datas]) {
        GoodsVo *item = [self.datas objectAtIndex:indexPath.row];
        detailItem.lblName.text = item.goodsName;
        detailItem.lblBarcode.text = item.barCode;
        if (item.type == 1) {
            detailItem.lblType.text = @"普通商品";
        }else if (item.type == 2){
            detailItem.lblType.text = @"拆分商品";
        }else if (item.type == 3){
            detailItem.lblType.text = @"组装商品";
        }else if (item.type == 4){
            detailItem.lblType.text = @"称重商品";
        }else if (item.type == 5){
            detailItem.lblType.text = @"原料商品";
        }
        if ([item.isCheck isEqualToString:@"0"] || item.isCheck == nil) {
            detailItem.imgUnCheck.hidden = NO;
            detailItem.imgCheck.hidden = YES;
        }else{
            detailItem.imgUnCheck.hidden = YES;
            detailItem.imgCheck.hidden = NO;
        }
        if (item.upDownStatus == 2) {
            detailItem.imgUpDown.hidden = NO;
        } else {
            detailItem.imgUpDown.hidden = YES;
        }
        
        
        detailItem.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return detailItem;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsVo *vo = [self.datas objectAtIndex:indexPath.row];
    if ([vo.isCheck isEqualToString:@"1"]) {
        vo.isCheck = @"0";
        [_goodsList removeObject:vo];
    }else{
        vo.isCheck = @"1";
        [_goodsList addObject:vo];
    }
    
    [self.tableView reloadData];
}

#pragma mark UITableView无section列表

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}




@end
