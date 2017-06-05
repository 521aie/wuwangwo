//
//  GoodsAndStyleView.m
//  retailapp
//
//  Created by qingmei on 15/10/17.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GoodsAndStyleView.h"
#import "ColorHelper.h"
#import "Platform.h"
#import "IEditItemListEvent.h"
#import "SymbolNumberInputBox.h"
#import "RoleCommissionnDetailView.h"
#import "ServiceFactory.h"
#import "XHAnimalUtil.h"
#import "AlertBox.h"
#import "LSEditItemList.h"
#import "LSEditItemView.h"
#import "UIView+Sizes.h"
#import "RoleCommissionnDetailView.h"


@interface GoodsAndStyleView ()<IEditItemListEvent,SymbolNumberInputClient>
//buttonView
@property (strong, nonatomic) UIView           *buttonView;                //button

@property (nonatomic, copy  ) SaveBlock saveBlock;              //页面回调block

@property (nonatomic,strong) EmployeeService            *service;           //网络服务
@property (nonatomic,strong) RoleCommissionnDetailView  *parent;            //父veiw
@property (nonatomic,assign) BOOL                       isGoods;            //是否商品
@property (nonatomic,assign) BOOL                       isMul;              //是否批量
@property (nonatomic,assign) BOOL                       isAdd;              //是否添加页面
@property (nonatomic,strong) NSMutableArray             *goodsOrStyleList;  //存储商品或者款式的list
@property (nonatomic,strong) RoleCommissionVo           *roleCommission;    //角色提成
/**  */
@property (nonatomic, strong) LSEditItemView *vewGoodsName;
/** <#注释#> */
@property (nonatomic, strong) LSEditItemView *vewGoodsCode;
/** <#注释#> */
@property (nonatomic, strong) LSEditItemList *lstSale;
/** <#注释#> */
@property (nonatomic, strong) UIScrollView *scrollView;
/** <#注释#> */
@property (nonatomic, strong) UIView *container;
@end

@implementation GoodsAndStyleView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMainView];
}
- (id)initWithParent:(id)parentTemp{
    self = [super init];
    if (self) {
        _service = [ServiceFactory shareInstance].employeeService;
        if ([parentTemp isKindOfClass:[RoleCommissionnDetailView class]]) {
            _parent = parentTemp;
        }
        
    }
    return self;
}


- (void)initMainView {
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    [self.view addSubview:self.scrollView];
    
    self.container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.ls_width, self.scrollView.ls_height)];
    [self.scrollView addSubview:self.container];
    self.vewGoodsName = [LSEditItemView editItemView];
    [self.vewGoodsName initLabel:@"商品名称" withHit:nil];
    [self.container addSubview:self.vewGoodsName];
    
    self.vewGoodsCode = [LSEditItemView editItemView];
    [self.vewGoodsCode initLabel:@"条形码" withHit:nil];
    [self.container addSubview:self.vewGoodsCode];
    
    self.lstSale = [LSEditItemList editItemList];
    [self.lstSale initLabel:@"销售提成比例(%)" withHit:nil isrequest:YES delegate:self];
    [self.container addSubview:self.lstSale];
    
    UIButton *btn = [LSViewFactor addRedButton:self.container title:@"删除" y:0];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.buttonView = btn.superview;
    
    
    RoleCommissionDetailVo *detail = (RoleCommissionDetailVo *)_goodsOrStyleList.lastObject;
    [self.vewGoodsName initLabel:@"商品名称" withHit:detail.goodsName];
    [self.vewGoodsCode initData:detail.goodsBar];

    if (!_isAdd) {
        NSString *strRadio = [NSString stringWithFormat:@"%.2f",detail.commissionRatio];
        [self.lstSale initData:strRadio withVal:strRadio];
    }else {
        if (_goodsOrStyleList.count == 1) {
             [self loadData];
        }
    }
  
    [self reflashUI];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void)loadData {
    
    NSString *shopId = [[Platform Instance] getkey:SHOP_ID];
    RoleCommissionDetailVo *roleDetailVo = _goodsOrStyleList[0];
    NSDictionary *param = @{@"roleCommissionId":_roleCommissionId,
                            @"shopId":shopId,
                            @"goodsId":roleDetailVo.goodsId,
                            @"goodsType":@(roleDetailVo.goodsType)
                            };
    
    NSString *url = @"roleCommission/getRoleCommissionDetail";
    __weak GoodsAndStyleView *weakSelf = self;
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        
        // 设置提成率
        NSNumber *commissionRatio = json[@"commissionRatio"];
        if ([commissionRatio doubleValue] != 0) {
            [weakSelf.lstSale initData:[NSString stringWithFormat:@"%.2f",commissionRatio.doubleValue] withVal:[NSString stringWithFormat:@"%.2f",commissionRatio.doubleValue]];
        }
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}
#pragma mark - IEditItemListEvent代理
// 设置提成比例
- (void)onItemListClick:(LSEditItemList *)obj {
    [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:YES isSymbol:NO event:obj.tag];
    [SymbolNumberInputBox limitInputNumber:3 digitLimit:2];
    [SymbolNumberInputBox initData:self.lstSale.lblVal.text];
}

#pragma mark - SymbolNumberInputClient代理 (输入提成比例回调)
- (void)numberClientInput:(NSString *)val event:(NSInteger)eventType {
    if (val.doubleValue > 100) {
        [AlertBox show:@"提成比例范围在0~100之间,请重新输入!"];
        return;
    }
    // 根据设置的提成数字，更改titleBox状态
    [self.lstSale changeData:val withVal:val];
    [self editTitle:self.lstSale.isChange act:ACTION_CONSTANTS_EDIT];
}


#pragma mark - INavigateEvent代理  (导航)
- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event {
    if (event == LSNavigationBarButtonDirectLeft) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }else {//保存
        
        if ([self isValid]) {
            NSString *ratio = _lstSale.getStrVal;
            for (int i = 0; i < _goodsOrStyleList.count ;i++) {
                RoleCommissionDetailVo *temp = _goodsOrStyleList[i];
                temp.commissionRatio = ratio.doubleValue;
            }
            [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[RoleCommissionnDetailView class]]) {
                    self.saveBlock(_goodsOrStyleList, NO);
                    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
                    [self.navigationController popToViewController:obj animated:NO];
                }
                
            }];

        }
        
    }
}

#pragma mark - click
- (void)btnClick:(id)sender {
    
    RoleCommissionDetailVo *detail = [_goodsOrStyleList lastObject];
    [LSAlertHelper showAlert:[NSString stringWithFormat:@"确认删除[%@]吗？", detail.goodsName] block:nil block:^{
        detail.operateType = @"del";
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[RoleCommissionnDetailView class]]) {
                self.saveBlock(_goodsOrStyleList, YES);
                [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
                [self.navigationController popToViewController:obj animated:NO];
            }
            
        }];
    }];
   
}

- (void)onRightSavebBlock:(SaveBlock)saveBlcok {
    _saveBlock = saveBlcok;
}

#pragma mark - UI
- (void)setisGood:(BOOL)isGood {
    //是商品模式还是款式
      _isGoods = isGood;
}

//根据不同页面状态刷新UI
- (void)reflashUI {
    
    if (_isMul) {
        
         // 批量添加商品
        [self configTitle:@"批量设置提成比例" leftPath:Head_ICON_CANCEL rightPath:Head_ICON_OK];
        _buttonView.hidden = YES;
    }else {
        
        // 添加单个商品或者非添加操作
        if (_isAdd) {
            [self configTitle:@"商品详情" leftPath:Head_ICON_CANCEL rightPath:Head_ICON_OK];
            
        }else {
               [self configTitle:@"商品详情" leftPath:Head_ICON_BACK rightPath:nil];
           
        }
        
        
        if (_isGoods) {
            self.vewGoodsName.lblName.text = @"商品名称";
            self.vewGoodsCode.lblName.text = @"条形码";
           
        }
        else{
            self.vewGoodsName.lblName.text = @"款式名称";
            self.vewGoodsCode.lblName.text = @"款号";
          
        }
        
        if (_isAdd) {
            _buttonView.hidden = YES;
        }else{
            _buttonView.hidden = NO;
        }
    }
}

/**
 *  <#Description#>
 *
 *  @param goodsOrStyleList 商品列表，如果isAdd==YES 表明是添加新商品，可能是单个也可能是批量
 *  @param roleCommission   <#roleCommission description#>
 *  @param isAdd            是否添加新的商品，NO表示是可能修改已添加的商品
 */
- (void)loadWithGoodsOrStyleList:(NSArray *)goodsOrStyleList CommissionVo:(RoleCommissionVo *)roleCommission isAdd:(BOOL)isAdd{
   
    _roleCommission = roleCommission;
    _isAdd = isAdd;
    _goodsOrStyleList = [NSMutableArray arrayWithArray:goodsOrStyleList];
    
    if (goodsOrStyleList.count && isAdd) {
       // 是否是批量添加新的商品
        _isMul = _goodsOrStyleList.count > 1;
    }
    
    if (goodsOrStyleList.count == 0) {
        [XHAnimalUtil animal:_parent type:kCATransitionPush direction:kCATransitionFromLeft];
        [_parent loadDataWithRoleCommissionId:_roleCommission.Id block:nil];
    }

//    [self reflashUI];
}

#pragma mark - 参数检查
- (BOOL)isValid {
    
    if ([ObjectUtil isNull:self.lstSale.getStrVal] || [self.lstSale.getStrVal isEqualToString:@""]) {
        [AlertBox show:@"请输入提成比例!"];
        return NO;
    }
    return YES;
}

@end
