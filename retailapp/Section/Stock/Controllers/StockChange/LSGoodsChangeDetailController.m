//
//  LSGoodsChangeDetailController.m
//  retailapp
//
//  Created by guozhi on 2017/1/10.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSGoodsChangeDetailController.h"
#import "XHAnimalUtil.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "MemberTransactionListVo.h"
#import "SVProgressHUD.h"
#import "DateUtils.h"
#import "SystemUtil.h"
#import "UIHelper.h"
#import "StockChangeLogVo.h"
#import "UIHelper.h"
#import "LSEditItemView.h"
#import "DateUtils.h"

@interface LSGoodsChangeDetailController ()
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *container;       //子view容器

@property (strong, nonatomic) LSEditItemView *itemTxtShopName;
@property (strong, nonatomic) LSEditItemView *itemTxtCode;
@property (strong, nonatomic) LSEditItemView *itemTxtColor;
@property (strong, nonatomic) LSEditItemView *itemTxtSize;
@property (strong, nonatomic) LSEditItemView *itemTxtOptype;
@property (strong, nonatomic) LSEditItemView *itemTxtOpNumber;
@property (strong, nonatomic) LSEditItemView *vewChangeCount;
@property (strong, nonatomic) LSEditItemView *itemTxtOpperson;
@property (strong, nonatomic) LSEditItemView *itemTxtOpTime;
/** <#注释#> */
@property (nonatomic, strong) LSEditItemView *vewOrderNo;
/** <#注释#> */
@property (nonatomic, strong) LSEditItemView *vewOrderTime;
@end

@implementation LSGoodsChangeDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    [self configConstraints];
    [self configContainerViews];
    [self initData];
}


- (void)configViews {
    [self configTitle:self.stockChangeLogVo2.operationType leftPath:Head_ICON_BACK rightPath:nil];
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    //scollVIew
    self.scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    //container
    self.container = [[UIView alloc] init];
    self.container.ls_width = SCREEN_W;
    [self.scrollView addSubview:self.container];
}

- (void)configConstraints {
    //标题
    UIView *superView = self.view;
    __weak typeof(self) wself = self;
    //scrollView
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(superView);
        make.top.equalTo(wself.view.top).offset(kNavH);
    }];
}

- (void)configContainerViews {
    self.itemTxtShopName = [LSEditItemView editItemView];
    self.itemTxtShopName.lblDetail.font = [UIFont systemFontOfSize:15];
    [self.itemTxtShopName initLabel:@"商品名称" withHit:nil];
    [self.container addSubview:self.itemTxtShopName];
    
    self.itemTxtCode = [LSEditItemView editItemView];
    [self.itemTxtCode initLabel:@"店内码" withHit:nil];
    [self.container addSubview:self.itemTxtCode];
    
    self.itemTxtColor = [LSEditItemView editItemView];
    [self.itemTxtColor initLabel:@"颜色" withHit:nil];
    [self.container addSubview:self.itemTxtColor];
    
    self.itemTxtSize = [LSEditItemView editItemView];
    [self.itemTxtSize initLabel:@"尺码" withHit:nil];
    [self.container addSubview:self.itemTxtSize];
    
    if ([[Platform Instance]getkey:SHOP_MODE].integerValue == 101) {
        [self.itemTxtColor visibal:YES];
        [self.itemTxtSize visibal:YES];
    } else {
        self.itemTxtCode.lblName.text = @"条形码";
        [self.itemTxtColor visibal:NO];
        [self.itemTxtSize visibal:NO];
    }
    self.itemTxtOptype = [LSEditItemView editItemView];
    [self.itemTxtOptype initLabel:@"操作类型" withHit:nil];
    [self.container addSubview:self.itemTxtOptype];
    
    self.itemTxtOpNumber = [LSEditItemView editItemView];
    [self.itemTxtOpNumber initLabel:@"数量" withHit:nil];
    [self.container addSubview:self.itemTxtOpNumber];
    
    self.vewChangeCount = [LSEditItemView editItemView];
    [self.vewChangeCount initLabel:@"变更后库存数" withHit:nil];
    [self.container addSubview:self.vewChangeCount];
    if ([ObjectUtil isNull:self.stockChangeLogVo2.stockBalance]) {//兼容以前的版本如果是以前的版本是没有变更后这个概念的
         [self.vewChangeCount visibal:NO];
    }
    if ([ObjectUtil isNotNull:self.stockChangeLogVo2.businessCode]) {
        self.vewOrderNo = [LSEditItemView editItemView];
        [self.vewOrderNo initLabel:@"单号" withHit:nil];
        [self.vewOrderNo initData:[NSString shortStringForOrderID:self.stockChangeLogVo2.businessCode]];
        [self.container addSubview:self.vewOrderNo];
    }
    
    if ([ObjectUtil isNotNull:self.stockChangeLogVo2.businessTime]) {
        self.vewOrderTime = [LSEditItemView editItemView];
        [self.vewOrderTime initLabel:@"单据时间" withHit:nil];
        NSString *businessTime = [DateUtils formateTime4:self.stockChangeLogVo2.businessTime.longLongValue];
        [self.vewOrderTime initData:businessTime];
        [self.container addSubview:self.vewOrderTime];
    }
    self.itemTxtOpperson = [LSEditItemView editItemView];
    [self.itemTxtOpperson initLabel:@"操作人" withHit:nil];
    [self.container addSubview:self.itemTxtOpperson];
    
    self.itemTxtOpTime = [LSEditItemView editItemView];
    [self.itemTxtOpTime initLabel:@"时间" withHit:nil];
    [self.container addSubview:self.itemTxtOpTime];
    
    [UIHelper clearColor:self.container];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

//加载数据
- (void)initData{
    [self.itemTxtShopName initLabel:@"商品名称" withHit:self.stockChangeLogVo1.goodsName];
    if ([[Platform Instance]getkey:SHOP_MODE].integerValue == 101) {
        self.itemTxtCode.lblVal.text = self.stockChangeLogVo1.innerCode;
        self.itemTxtColor.lblVal.text = self.stockChangeLogVo1.goodsColor;
        self.itemTxtSize.lblVal.text = self.stockChangeLogVo1.goodsSize;
        
    } else {
        self.itemTxtCode.lblVal.text = self.stockChangeLogVo1.barCode;
    }
    
    self.itemTxtOptype.lblVal.text = self.stockChangeLogVo2.operationType;
    self.itemTxtOpNumber.lblVal.text = [self.stockChangeLogVo2.adjustNum stringValue];
    
    if ([self.stockChangeLogVo2.stockBalance.stringValue containsString:@"."]) {
        [self.vewChangeCount initData:[NSString stringWithFormat:@"%.3f", [self.stockChangeLogVo2.stockBalance doubleValue]]];
    } else {
        [self.vewChangeCount initData:[NSString stringWithFormat:@"%.f", [self.stockChangeLogVo2.stockBalance doubleValue]]];
    }
    
    NSString* opPerson = ([NSString isNotBlank:self.stockChangeLogVo2.opUser]&&[NSString isNotBlank:self.stockChangeLogVo2.staffId])?[NSString stringWithFormat:@"%@(工号:%@)",self.stockChangeLogVo2.opUser,self.stockChangeLogVo2.staffId]:@" ";
    self.itemTxtOpperson.lblVal.text = opPerson;
    self.itemTxtOpTime.lblVal.text = self.stockChangeLogVo2.opTime;
    
    [UIHelper clearColor:self.container];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}




@end
