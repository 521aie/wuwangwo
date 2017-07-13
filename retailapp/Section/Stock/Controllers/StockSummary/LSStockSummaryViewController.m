//
//  LSStockSummaryViewController.m
//  retailapp
//
//  Created by guozhi on 2017/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSStockSummaryViewController.h"
#import "IEditItemListEvent.h"
#import "OptionPickerClient.h"
#import "ServiceFactory.h"
#import "LSEditItemList.h"
#import "UIHelper.h"
#import "XHAnimalUtil.h"
#import "OptionPickerBox.h"
#import "MenuList.h"
#import "AlertBox.h"
#import "SelectShopStoreListView.h"
#import "LSStockSummaryListController.h"
#import "DateUtils.h"
#define LS_SELECT_SHOPORWAREHOUSE 1001
#define LS_SELECT_SUMMARYCONDITION 1002
@interface LSStockSummaryViewController ()<IEditItemListEvent,OptionPickerClient>
@property (strong, nonatomic) LSEditItemList *lsShopOrWarehouse;       //门店or仓库
@property (strong, nonatomic) LSEditItemList *lsSummaryCondition;       //汇总条件
/** <#注释#> */
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation LSStockSummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    [self configConstraints];
    [self configSubViews];
    [self initMainView];
}

- (void)configViews {
    //标题
    [self configTitle:@"库存汇总查询" leftPath:Head_ICON_BACK rightPath:nil];
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [self.view addSubview:self.scrollView];
    
}

- (void)configConstraints {
    //配置约束
    __weak typeof(self) wself = self;
    [wself.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(wself.view);
        make.top.equalTo(wself.view.top).offset(kNavH);
        make.bottom.equalTo(wself.view.bottom);
    }];
}

- (void)configSubViews {
    self.lsShopOrWarehouse = [LSEditItemList editItemList];
    [self.scrollView addSubview:self.lsShopOrWarehouse];
    
    self.lsSummaryCondition = [LSEditItemList editItemList];
    [self.scrollView addSubview:self.lsSummaryCondition];
    
    [self.scrollView layoutIfNeeded];
    UIButton *btn = [LSViewFactor addGreenButton:self.scrollView title:@"查询" y:0];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)initMainView {
    //选择门店/仓库
    [self.lsShopOrWarehouse initLabel:@"门店/仓库" withHit:nil delegate:self];
    self.lsShopOrWarehouse.imgMore.image = [UIImage imageNamed:@"ico_next.png"];
    
    if ([[Platform Instance] getShopMode] == 3) {
        [self.lsShopOrWarehouse initData:@"请选择" withVal:@""];
    } else if ([[Platform Instance] getShopMode] == 2) {
        [self.lsShopOrWarehouse visibal:NO];
        [self.lsShopOrWarehouse initData:[[Platform Instance] getkey:SHOP_NAME] withVal:[[Platform Instance] getkey:SHOP_ID]];
    } else {
        [self.lsShopOrWarehouse visibal:NO];
        [self.lsShopOrWarehouse initData:[[Platform Instance] getkey:SHOP_NAME] withVal:[[Platform Instance] getkey:SHOP_ID]];
    }
    self.lsShopOrWarehouse.tag = LS_SELECT_SHOPORWAREHOUSE;
    
    //选择汇总条件
    [self.lsSummaryCondition initLabel:@"汇总条件" withHit:nil delegate:self];
    self.lsSummaryCondition.tag = LS_SELECT_SUMMARYCONDITION;
    [self.lsSummaryCondition initData:@"请选择" withVal:@""];
    
    [UIHelper refreshUI:self.scrollView];
}


#pragma mark - IEditItemListEvent协议
- (void)onItemListClick:(EditItemList *)obj
{
    if(obj.tag == LS_SELECT_SHOPORWAREHOUSE) {
        SelectShopStoreListView* shopStoreListView = [[SelectShopStoreListView alloc] init];
        __weak typeof(self) weakSelf = self;
        [shopStoreListView loadData:[obj getStrVal] checkMode:SINGLE_CHECK isPush:YES callBack:^(id<INameCode> item) {
            if (item) {
                [obj initData:[item obtainItemName] withVal:[item obtainItemId]];
            }
            [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [weakSelf.navigationController popToViewController:weakSelf animated:NO];
        }];
        [self.navigationController pushViewController:shopStoreListView animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        shopStoreListView = nil;
    } else if (obj.tag == LS_SELECT_SUMMARYCONDITION) {
        NSArray *listItems = @[@"中品类",@"性别",@"年份",@"季节"];
        
        [OptionPickerBox initData:[MenuList list1FromArray:listItems] itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    }
}

#pragma mark - OptionPickerClient协议
- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType {
    id<INameItem> item = (id<INameItem>)selectObj;
    if (eventType == LS_SELECT_SUMMARYCONDITION) {
        [self.lsSummaryCondition initData:[item obtainItemName] withVal:[item obtainItemId]];
    }
    [UIHelper refreshUI:self.scrollView];
    return YES;
}

#pragma mark 检查查询条件
- (BOOL)isValid {
    
    if ([[Platform Instance] getShopMode] == 3 && [NSString isBlank:[self.lsShopOrWarehouse getStrVal]]) {
        [AlertBox show:@"请选择门店/仓库!"];
        return NO;
    }
    
    if ([NSString isBlank:[self.lsSummaryCondition getStrVal]]) {
        [AlertBox show:@"请选择汇总条件!"];
        return NO;
    }
    
    return YES;
}


- (void)btnClick:(UIButton *)sender {
    if (![self isValid]){
        return ;
    }
    
    NSMutableDictionary* param = [[NSMutableDictionary alloc] init];
    [param setValue:[self.lsShopOrWarehouse getStrVal] forKey:@"shopId"];
    NSString* findType = nil;
    switch ([self.lsSummaryCondition getStrVal].intValue) {
        case 0:
            findType = @"MIDDLE_CATEGORY";
            break;
        case 1:
            findType = @"SEX";
            break;
        case 2:
            findType = @"YEAR";
            break;
        case 3:
            findType = @"SEASON";
            break;
            
        default:
            break;
    }
    if (findType) {
        [param setValue:findType forKey:@"findType"];
    }
    [param setValue:[NSString stringWithFormat:@"%lld", [DateUtils formateDateTime2:[DateUtils formateDate3:[NSDate date]]]] forKey:@"lastTime"];
    
    if ([findType isEqualToString:@"YEAR"]) {
        [param setValue:@"9999" forKey:@"yearSort"];
    }
    LSStockSummaryListController *vc =[[LSStockSummaryListController alloc] init];
    vc.param = param;
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}


@end
