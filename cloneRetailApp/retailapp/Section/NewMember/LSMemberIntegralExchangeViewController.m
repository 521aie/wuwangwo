//
//  LSMemberIntegralExchangeViewController.m
//  retailapp
//
//  Created by taihangju on 16/10/8.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberIntegralExchangeViewController.h"
#import "LSMemberSaveDetailViewController.h"
#import "NavigateTitle2.h"
#import "LSMemberInfoView.h"
#import "LSMemberAccessView.h"
#import "SMHeaderItem.h"
#import "LSMemberIntegralExchangeCell.h"
#import "LSAlertHelper.h"
#import "LSMemberInfoVo.h"
#import "LSMemberCardVo.h"
#import "LSMemberTypeVo.h"
#import "LSMemberGoodsGiftVo.h"
#import "NSNumber+Extension.h"


static NSString *integralExchangeCellId = @"LSMemberIntegralExchangeCell";
@interface LSMemberIntegralExchangeViewController ()<INavigateEvent ,UITableViewDelegate ,UITableViewDataSource ,MBAccessViewDelegate ,LSMemberIntegralExchangeCellDelegate ,LSMemberInfoViewDelegate>

@property (nonatomic ,strong) NavigateTitle2 *titleBox;/*<>*/
@property (nonatomic ,strong) UITableView *tableView;/*<>*/
@property (nonatomic ,strong) UIView *tabHeaderView;/*<>*/
@property (nonatomic ,strong) UIView *tabFooterView;/*<>*/
@property (nonatomic ,strong) UILabel *needIntegral;/*<兑换合计需要积分>*/
@property (nonatomic ,strong) LSMemberInfoView *infoView;/*<二维火会员信息>*/
@property (nonatomic ,strong) LSMemberAccessView *cardsSummary;/*<会员卡横向滑动列表>*/
@property (nonatomic ,strong) LSMemberPackVo *memberPackVo;/*<>*/
@property (nonatomic ,strong) LSMemberCardVo *memberCardVo;/*<当前选择的 会员卡vo>*/
@property (nonatomic ,strong) NSString *selectCardId;/*<指定初始化要操作的卡id>*/
@property (nonatomic ,strong) NSArray *memberCardTypes;/*<卡类型>*/
@property (nonatomic ,strong) NSArray *memberCards;/*<已发了的会员卡>*/
@property (nonatomic ,strong) NSArray *goodsGiftList;/*<兑换商品列表>*/
@property (nonatomic ,strong) NSMutableArray *exchangeList;/*<选择兑换的商品列表数组>*/
@property (nonatomic ,assign) double sumIntegral;/*<兑换所选商品所需积分>*/
@property (nonatomic ,assign) BOOL canExchange;/*<是否可以兑换: 连锁总部和机构登录，隐藏可兑换商品、兑换卡余额和兑换按钮>*/
@end

@implementation LSMemberIntegralExchangeViewController

- (instancetype)init:(id)obj cardId:(NSString *)sId {
    self = [super init];
    if (self) {
        self.memberPackVo = (LSMemberPackVo *)obj;
        self.selectCardId = sId;
        self.canExchange = !([[Platform Instance] isTopOrg] || [[Platform Instance] getShopMode] == 3);
    }
    return self;
}

- (NSMutableArray *)exchangeList {
    if (!_exchangeList) {
        _exchangeList = [[NSMutableArray alloc] init];
    }
    return _exchangeList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [self initNavigate];
    [self initTableView];
    [self setTableFooterView];
    [self getGiftGoodList];
    [self configHelpButton:HELP_MEMBER_INTERGAL_EXCHANGE];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self queryMemberInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)fillData {
    
    // 会员信息
    [self.infoView fillMemberInfo:self.memberPackVo cards:self.memberCards cardTypes:self.memberCardTypes phone:@""];
    [self.cardsSummary setCardDatas:self.memberCards initPage:[self.memberCards indexOfObject:self.memberCardVo]];
    
    // 第一张卡为已挂失卡的情况下，隐藏底部兑换栏
    if (self.tabFooterView && [self.memberCardVo isLost]) {
        self.tabFooterView.hidden = YES;
    }

    [self setTableHeaderView];
}

// 点击兑换
- (void)depositButtonClick:(UIButton *)sender {
    
    if (!self.canExchange) {
        [LSAlertHelper showAlert:@"非门店用户不允许进行积分兑换操作!" block:nil];
        return;
    }
    
    if (self.sumIntegral > self.memberCardVo.degree.doubleValue) {
        [LSAlertHelper showAlert:@"积分不够，无法兑换！" block:nil];
        return;
    }
    
    if ([ObjectUtil isNotEmpty:self.exchangeList]) {
        [self exchangeGiftGoods];
    }
    else {
        [LSAlertHelper showAlert:@"没有选择兑换商品！" block:nil];
    }
}

#pragma mark - NavigateTitle2

- (void)initNavigate {
    
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    self.titleBox.frame = CGRectMake(0, 0, SCREEN_W, 64.0);
    [self.titleBox initWithName:@"积分兑换" backImg:Head_ICON_BACK moreImg:nil];
    self.titleBox.btnUser.hidden = NO;
    self.titleBox.imgMore.hidden = NO;
    self.titleBox.imgMore.image = [UIImage imageNamed:@"ico_integralDetail"];
    [self.view addSubview:self.titleBox];
    
    
    NSMutableArray *removeLayouts = [[NSMutableArray alloc] init];
    [removeLayouts addObjectsFromArray:self.titleBox.imgMore.constraints];
    [removeLayouts addObjectsFromArray:self.titleBox.lblRight.constraints];
    
    for (NSLayoutConstraint *layout in self.titleBox.constraints) {
        if ([layout.secondItem isEqual:self.titleBox.imgMore]) {
            [removeLayouts addObject:layout];
        }
    }
    [NSLayoutConstraint deactivateConstraints:removeLayouts];
    UIImageView *_imgMore = self.titleBox.imgMore;
    NSDictionary *views = NSDictionaryOfVariableBindings(_imgMore);
    NSArray *xLayoutArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_imgMore(88)]-10-|" options:0 metrics:nil views:views];
    NSArray *yLayoutArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_imgMore(16)]-16-|" options:0 metrics:nil views:views];
    [self.titleBox addConstraints:xLayoutArray];
    [self.titleBox addConstraints:yLayoutArray];
}

//导航栏点击事件
- (void)onNavigateEvent:(Direct_Flag)event {
    
    if (event == DIRECT_LEFT) {
        [self popToLatestViewController:kCATransitionFromLeft];
    }
    else if (event == DIRECT_RIGHT) {
        LSMemberSaveDetailViewController *vc = [[LSMemberSaveDetailViewController alloc] init:MBDetailIntegralType cards:self.memberCards selectCard:self.memberCardVo];
        [self pushController:vc from:kCATransitionFromRight];
    }
}

#pragma mark - 相关协议方法
// 滑动选择会员卡
- (void)memberAccessView:(LSMemberAccessView *)view selectdPage:(id)obj {
   
    LSMemberCardVo *vo = (LSMemberCardVo *)obj;
    if ([ObjectUtil isNotEmpty:self.exchangeList] && ![vo isLost]) {
        [LSAlertHelper showAlert:@"换卡后将对另外一张卡进行操作！" block:nil];
    }

    // 如果卡挂失了，刷新tableView ，隐藏兑换商品
    if (![vo.status isEqualToNumber:self.memberCardVo.status]) {
        
        if ([vo isLost]) {
            self.tabFooterView.hidden = YES;
        }
        else {
            self.tabFooterView.hidden = NO;
        }
        self.memberCardVo = vo;
        [self.tableView reloadData];
    }
    else {
        self.memberCardVo = vo;
    }
    self.selectCardId = self.memberCardVo.sId;
}

// LSMemberIntegralExchangeCellDelegate
- (void)countChange:(LSMemberGoodsGiftVo *)vo cell:(LSMemberIntegralExchangeCell *)cell {
    
    if ([self.exchangeList containsObject:vo] && vo.number.integerValue == 0) {
        [self.exchangeList removeObject:vo];
    }
    else if (![self.exchangeList containsObject:vo]) {
        [self.exchangeList addObject:vo];
    }
    [self computeNumAndIntegral];
}

// 计算总的兑换数量和积分
- (void)computeNumAndIntegral {
    
    if ([ObjectUtil isNotEmpty:self.exchangeList]) {
        NSInteger count = 0; // 所有的商品数
        NSInteger allScore = 0;
        for (LSMemberGoodsGiftVo *vo in self.exchangeList) {
            allScore = allScore + vo.number.integerValue * vo.point.integerValue;
            count += vo.number.integerValue;
        }
        self.sumIntegral = allScore;
        [self exchangeStatisticsWith:count allIntegral:allScore];
    }
    else {
        self.sumIntegral = 0.0;
        [self exchangeStatisticsWith:0 allIntegral:0];
    }
}

// LSMemberInfoViewDelegate
- (void)memberInfoViewHeightChaged {
    [self setTableHeaderView];
    [self.tableView reloadData];
}

#pragma mark - UITableView
- (void)initTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64.0, SCREEN_W, SCREEN_H-64.0) style:UITableViewStylePlain];
    [self.tableView registerClass:[LSMemberIntegralExchangeCell class] forCellReuseIdentifier:integralExchangeCellId];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.rowHeight = 78.0f;
    self.tableView.sectionHeaderHeight = 40.0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self setTableHeaderView];
    [self.view addSubview:self.tableView];
}

- (void)setTableHeaderView {
    
    if (!_tabHeaderView) {
        _tabHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 500.0)];
    }
    
    CGFloat topY = 0.0;
    // 会员信息
    if (!self.infoView) {
        self.infoView = [[LSMemberInfoView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 86) delegate:self];
        [self.tabHeaderView addSubview:self.infoView];
    }
    self.infoView.ls_top = topY;
    topY += self.infoView.ls_height;
    
    // 卡信息
    if (!self.cardsSummary) {
        self.cardsSummary = [LSMemberAccessView memberAccessView:MBAccessCardsInfo delegate:self];
        [self.tabHeaderView addSubview:self.cardsSummary];
    }
    self.cardsSummary.ls_top = topY;
    topY += self.cardsSummary.ls_height;

    _tabHeaderView.ls_height = topY;
    self.tableView.tableHeaderView = _tabHeaderView;
}

- (void)setTableFooterView {
    
    self.tabFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, self.tableView.ls_bottom - 44, SCREEN_W, 44)];
    self.tabFooterView.backgroundColor = RGBA(243, 243, 242, 1);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10.0, 240, 24.0)];
    label.backgroundColor =[UIColor clearColor];
    label.adjustsFontSizeToFitWidth = YES;
    self.needIntegral = label;
    [self.tabFooterView addSubview:label];
    [self exchangeStatisticsWith:0 allIntegral:0];
    
    UIButton *bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomButton.frame = CGRectMake(label.ls_right, 7.0, 60, 30);
    bottomButton.backgroundColor = RGBA(200, 38, 38, 1);
    bottomButton.layer.cornerRadius = 5;
    [bottomButton setTitle:@"兑换" forState:UIControlStateNormal];
    [bottomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bottomButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [bottomButton addTarget:self action:@selector(depositButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.tabFooterView addSubview:bottomButton];
    [self.view addSubview:self.tabFooterView];
}

// 兑换商品数和所需积分提示文字生成
- (void)exchangeStatisticsWith:(NSInteger)count allIntegral:(NSInteger)allScore {
    
    NSString *string = [NSString stringWithFormat:@"共 %ld 项   合计 %ld 积分", (long)count,  (long)allScore];
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f],NSForegroundColorAttributeName:[UIColor blackColor]}];
    NSRange range1 = [string rangeOfString:[@(count) stringValue]];
    NSRange range2 = [string rangeOfString:[NSString stringWithFormat:@"合计 %ld" ,allScore]];
    range2.location += 2;
    range2.length -= 2;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16.0f],NSForegroundColorAttributeName:[ColorHelper getWhiteColor1]};
    [attriStr setAttributes:attributes range:range1];
    [attriStr setAttributes:attributes range:range2];
    self.needIntegral.attributedText = attriStr;
}

// 生成sectionHeader
- (SMHeaderItem *)getHeader:(NSString *)string {
    
    SMHeaderItem *item = [SMHeaderItem loadFromNib];
    item.lblVal.text = string ? :@"";
    item.lblVal.textColor = [ColorHelper getTipColor6];
    item.panel.backgroundColor = [ColorHelper getTipColor9];
    item.bottomLine.hidden = NO;
    return item;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if ([self.memberCardVo isLost]) {
        return 0;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.goodsGiftList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LSMemberIntegralExchangeCell *cell = [tableView dequeueReusableCellWithIdentifier:integralExchangeCellId];
    cell.delegate = self;
    [cell fillData:self.goodsGiftList[indexPath.row]];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (self.goodsGiftList.count) {
        return [self getHeader:@"可兑换商品"];
    }
    return [self getHeader:@"无可兑换商品"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - 网络请求

// 查询会员基本信息
- (void)queryMemberInfo {
    
    NSString *entityId = [[Platform Instance] getkey:ENTITY_ID];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithCapacity:3];
    [param setValue:entityId forKey:@"entityId"];
    [param setValue:[_memberPackVo getMemberPhoneNum] forKey:@"keyword"];
    [param setValue:@(NO) forKey:@"isOnlySearchMobile"];
    [param setValue:_memberPackVo.customerRegisterId forKey:@"twodfireMemberId"];
    [param setValue:_memberPackVo.customer.sId forKey:@"customerId"];
    
    [BaseService getRemoteLSOutDataWithUrl:@"card/v2/queryCustomerInfo" param:param withMessage:@"" show:YES CompletionHandler:^(id json) {
        if ([json[@"code"] boolValue]) {
            
            NSArray *customerList = json[@"data"][@"customerList"];
            if ([ObjectUtil isNotEmpty:customerList]) {
                
                if (customerList.count == 1) {
                    self.memberPackVo = [LSMemberPackVo getMemberPackVo:customerList[0]];
                    [self loadMemberCards];
                }
            }
        }
        
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json block:nil];
    }];
    
}

// 获取会员所有的会员卡信息
- (void)loadMemberCards {
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:_memberPackVo.customerRegisterThirdPartyPojo.customerRegisterId forKey:@"customerRegisterId"];
    [param setValue:_memberPackVo.customer.sId forKey:@"customerId"];
    [param setValue:[[Platform Instance]  getkey:ENTITY_ID] forKey:@"entityId"];
    
    [BaseService getRemoteLSDataWithUrl:@"customer/v1/queryCustomerCard" param:param withMessage:@"" show:YES CompletionHandler:^(id json) {
        //        if ([json[@"code"] boolValue]) {
        
        NSMutableArray *types = [[NSMutableArray alloc] init];
        NSMutableArray *cards = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in json[@"data"]) {
            
            LSMemberTypeVo *type = [LSMemberTypeVo getMemberTypeVo:dic[@"kindCard"]];
            LSMemberCardVo *card = [LSMemberCardVo getMemberCardVo:dic[@"card"]];
            card.cardTypeVo = type;
            card.kindCardName = type.name;
            card.filePath = type.filePath;
            card.mode = @(type.mode);
            [types addObject:type];
            [cards addObject:card];
        }
        self.memberCardTypes = [types copy];
        self.memberCards = [cards copy];
        if ([NSString isNotBlank:self.selectCardId]) {
            [self.memberCards enumerateObjectsUsingBlock:^(LSMemberCardVo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.sId isEqualToString:self.selectCardId]) {
                    self.memberCardVo = obj;
                    *stop = YES;
                }
            }];
        }
        else {
            self.memberCardVo = self.memberCards.firstObject;
        }
        [self fillData];
        //        }

    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json block:nil];
    }];
}

// 获取积分兑换商品列表
- (void)getGiftGoodList {
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
//    [param setValue:@"" forKey:@"searchType"];
//    [param setValue:@"" forKey:@"searchCode"];
    [BaseService getRemoteLSDataWithUrl:@"customer/v1/giftList" param:param withMessage:@"" show:YES CompletionHandler:^(id json) {
        if ([ObjectUtil isNotEmpty:json[@"goodsGiftList"]]) {
            self.goodsGiftList = [LSMemberGoodsGiftVo voListFromJsonArray:json[@"goodsGiftList"]];
            [self.tableView reloadData];
        }
        else {
            // 没有积分商品时，隐藏self.tabFooterView
            self.tabFooterView.hidden = YES;
        }
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json block:nil];
    }];
}


// 积分兑换
- (void)exchangeGiftGoods {

    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:[[Platform Instance] getkey:SHOP_ID] forKey:@"shopId"];
    [param setValue:self.memberCardVo.sId forKey:@"cardId"];
    [param setValue:[LSMemberGoodsGiftVo jsonStringFromVoList:self.exchangeList] forKey:@"goodsGiftList"];
    
    [BaseService getRemoteLSDataWithUrl:@"customer/v1/exchange" param:param withMessage:@"" show:YES CompletionHandler:^(id json) {
        if ([json[@"returnCode"] isEqualToString:@"success"]) {
            [LSAlertHelper showStatus:@" 兑换成功！" afterDeny:2 block:^{
                if (self.selectCardId) {
                    // 有selectCardId，成功后返回详情页。
                    [self popToLatestViewController:kCATransitionFromLeft];
                }
                else {
                    [self popToViewControllerNamed:@"LSMemberModule" popDirection:kCATransitionFromLeft];
                }
            }];
        }
        else {
            [LSAlertHelper showAlert:json[@"exceptionMsg"] block:nil];
        }

    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json block:nil];
    }];
}

@end
