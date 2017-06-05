//
//  LSMemberCardLossHandViewController.m
//  retailapp
//
//  Created by taihangju on 16/10/6.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberCardLossHandViewController.h"
#import "NavigateTitle2.h"
#import "LSMemberInfoView.h"
#import "LSMemberAccessView.h"
#import "EditItemText.h"
#import "LSMemberInfoVo.h"
#import "LSAlertHelper.h"
#import "LSMemberConst.h"
#import "LSMemberTypeVo.h"
#import "LSMemberCardVo.h"

@interface LSMemberCardLossHandViewController ()<INavigateEvent ,MBAccessViewDelegate ,LSMemberInfoViewDelegate>

@property (nonatomic ,strong) NavigateTitle2 *titleBox;/*<>*/
@property (nonatomic ,strong) LSMemberInfoView *infoView;/* <二维火会员信息*/
@property (nonatomic ,strong) LSMemberAccessView *cardsSummary;/* <会员卡栏*/
@property (nonatomic ,strong) EditItemText *cardStatus;/*<卡状态>*/
@property (nonatomic ,strong) EditItemText *cardBalance;/*<卡余额>*/
@property (nonatomic ,strong) EditItemText *cardIntegral;/*<卡内积分>*/

@property (nonatomic ,strong) UIButton *ensureButton;/*<确认button>*/
@property (nonatomic ,strong) UIScrollView *scrollView;/*<>*/

@property (nonatomic ,strong) NSString *phoneNum;/*<查询手机号>*/
@property (nonatomic ,strong) LSMemberPackVo *memberPackVo;/*<会员相关信息vo>*/
@property (nonatomic ,strong) LSMemberCardVo *memberCardVo;/*<当前选择的 会员卡vo>*/
@property (nonatomic ,strong) NSArray *memberCardTypes;/*<卡类型>*/
@property (nonatomic ,strong) NSArray *memberCards;/*<已发了的会员卡>*/
@end

@implementation LSMemberCardLossHandViewController

- (instancetype)init:(id)obj {
    
    self = [super init];
    if (self) {
        self.memberPackVo = (LSMemberPackVo *)obj;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [self initNavigate];
    [self configSubviews];
    [self loadMemberCards];
    [self configHelpButton:HELP_MEMBER_CARD_LOSS];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - NavigateTitle2 代理
//初始化导航栏
- (void)initNavigate {
    
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    self.titleBox.frame = CGRectMake(0, 0, SCREEN_W, 64.0);
    [self.titleBox initWithName:@"挂失与解挂" backImg:Head_ICON_BACK moreImg:nil];
    [self.view addSubview:self.titleBox];
}

//导航栏点击事件
- (void)onNavigateEvent:(Direct_Flag)event {
    
    if (event == DIRECT_LEFT) {
        [self popToLatestViewController:kCATransitionFromLeft];
    }
}

- (void)configSubviews {
    
    if (!self.scrollView) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:
                           CGRectMake(0, self.titleBox.ls_bottom, SCREEN_W, SCREEN_H - self.titleBox.ls_bottom)];
        self.scrollView.backgroundColor  = [UIColor clearColor];
        [self.view addSubview:self.scrollView];
    }
    
    
    CGFloat topY = 0.0;
    // 会员信息
    if (!self.infoView) {
        self.infoView = [[LSMemberInfoView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 86) delegate:self];
        [self.scrollView addSubview:self.infoView];
    }
    self.infoView.ls_top = topY;
    topY += self.infoView.ls_height;
    
    // 卡信息
    if (!self.cardsSummary) {
        self.cardsSummary = [LSMemberAccessView memberAccessView:MBAccessCardsInfo delegate:self];
        [self.scrollView addSubview:self.cardsSummary];
    }
    self.cardsSummary.ls_top = topY;
    topY += self.cardsSummary.ls_height;
    
    if (!self.cardStatus) {
        
        self.cardStatus = [[EditItemText alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
        [self.cardStatus initLabel:@"卡状态" withHit:@"" isrequest:NO type:0];
        [self.cardStatus initData:@""];
        [self.cardStatus editEnabled:NO];
        [self.scrollView addSubview:self.cardStatus];
    }
    self.cardStatus.ls_top = topY;
    topY += 48.0f;
    
    if (!self.cardBalance) {
        
        self.cardBalance = [[EditItemText alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
        [self.cardBalance initLabel:@"卡内余额(元)" withHit:nil isrequest:NO type:0];
        [self.cardBalance initData:@"0.00"];
        [self.cardBalance editEnabled:NO];
        [self.scrollView addSubview:self.cardBalance];
    }
    self.cardBalance.ls_top = topY;
    topY += 48.0;
    
    if (!self.cardIntegral) {
        self.cardIntegral = [[EditItemText alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
        [self.cardIntegral initLabel:@"卡内积分" withHit:@"" isrequest:NO type:0];
        [self.cardIntegral initData:@"0"];
        [self.cardIntegral editEnabled:NO];
        [self.scrollView addSubview:self.cardIntegral];
    }
    self.cardIntegral.ls_top = topY;
    topY += 48.0f;
    
    
    // button
    if (!self.ensureButton) {
        self.ensureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *title = self.memberCardVo.status.intValue == 2 ? @"解挂" : @"挂失";
        [self.ensureButton setTitle:title forState:0];
        [self.ensureButton setBackgroundColor:[ColorHelper getRedColor]];
        [self.ensureButton.titleLabel setTextColor:RGB(192, 0, 0)];
        [self.ensureButton addTarget:self action:@selector(buttonTapAction) forControlEvents:UIControlEventTouchUpInside];
        self.ensureButton.frame = CGRectMake(12, 0, SCREEN_W - 24, 44);
        self.ensureButton.layer.cornerRadius = 4.0;
        [self.scrollView addSubview:self.ensureButton];
    }
    self.ensureButton.ls_top = topY + 5.0;
    topY = self.ensureButton.ls_bottom + 30.0;
    
    if (self.scrollView.ls_right < topY) {
        [self.scrollView setContentSize:CGSizeMake(SCREEN_W, topY)];
    }
}

- (void)buttonTapAction {
    
    if (self.memberCardVo.status.integerValue == 1) {
        // 正常 -> 去挂失
        
       // [LSAlertHelper showAlert:@"提示" message:@"是否确定挂失？" cancle:@"取消" block:^{
            ;
        ///} ensure:@"确定" block:^{
            [self lossCardHand];
        //}];
    }
    else if (self.memberCardVo.status.integerValue == 2) {
        // 挂失 -> 解挂
        //[LSAlertHelper showAlert:@"提示" message:@"是否确定解挂？" cancle:@"取消" block:^{
          //  ;
        //} ensure:@"确定" block:^{
            [self lossCardHand];
        //}];
    }
}


#pragma mark - 相关协议

/**
 **  MBAccessViewDelegate
 **  滑动选择了要操作的会员卡
 **/
- (void)memberAccessView:(LSMemberAccessView *)view selectdPage:(id)obj {
    LSMemberCardVo *vo = (LSMemberCardVo *)obj;
    if ([self hasChanged] && ![vo isLost]) {
        [LSAlertHelper showAlert:@"换卡后将对另外一张卡进行操作！" block:nil];
    }
    self.memberCardVo = vo;
    [self fillData:NO];
}

// LSMemberInfoViewDelegate
- (void)memberInfoViewHeightChaged {
    [self configSubviews];
}

#pragma mark - 数据填充等处理

- (void)fillData:(BOOL)firstFillData {
    
    if ([NSString isBlank:self.infoView.statusLabel.attributedText.string]) {
        [self.infoView fillMemberInfo:self.memberPackVo cards:self.memberCards cardTypes:self.memberCardTypes phone:self.phoneNum];
    }
    
    if (firstFillData) {
         [self.cardsSummary setCardDatas:self.memberCards initPage:0];
    }
   
    [self.cardBalance initData:[NSString stringWithFormat:@"%.2f",self.memberCardVo.balance.floatValue]];
    [self.cardIntegral initData:[NSString stringWithFormat:@"%.0f",self.memberCardVo.degree.floatValue]];
    
    if (self.memberCardVo.status.integerValue == 1) {
        
        [self.cardStatus initData:@"正常"];
        self.cardStatus.txtVal.textColor = [ColorHelper getTipColor6];
        [self.ensureButton setTitle:@"挂失" forState:0];
        [self.ensureButton setBackgroundColor:[ColorHelper getRedColor]];
    }
    else if (self.memberCardVo.status.integerValue == 2) {
        
        [self.cardStatus initData:@"挂失"];
        self.cardStatus.txtVal.textColor = [ColorHelper getRedColor];
        [self.ensureButton setTitle:@"解挂" forState:0];
        [self.ensureButton setBackgroundColor:[ColorHelper getGreenColor]];
    }
    
    if (firstFillData) {
        [self configSubviews];
    }
   
}


#pragma mark - 网络请求

// 获取会员所有的会员卡信息
- (void)loadMemberCards {
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:_memberPackVo.customerRegisterThirdPartyPojo.customerRegisterId forKey:@"customerRegisterId"];
    [param setValue:_memberPackVo.customer.sId forKey:@"customerId"];
    [param setValue:[[Platform Instance]  getkey:ENTITY_ID] forKey:@"entityId"];
    NSString *url = @"customer/queryCustomerCard";
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        NSMutableArray *types = [[NSMutableArray alloc] init];
        NSMutableArray *cards = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in json[@"data"]) {
            
            LSMemberTypeVo *type = [LSMemberTypeVo getMemberTypeVo:dic[@"kindCard"]];
            LSMemberCardVo *card = [LSMemberCardVo getMemberCardVo:dic[@"card"]];
            card.cardTypeVo = type;
            card.kindCardId = type.sId;
            card.kindCardName = type.name;
            card.filePath = type.filePath;
            [types addObject:type];
            [cards addObject:card];
        }
        self.memberCardTypes = [types copy];
        self.memberCards = [cards copy];
        self.memberCardVo = self.memberCards.firstObject;
        [self fillData:YES];
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json];
    }];
    
}

// 挂失与解挂
- (void)lossCardHand {
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:[[Platform Instance]  getkey:ENTITY_ID] forKey:@"entityId"];
    [param setValue:self.memberCardVo.sId forKey:@"cardId"];
    [param setValue:[[Platform Instance] getkey:USER_ID] forKey:@"userId"];
    [BaseService getRemoteLSOutDataWithUrl:@"card/lost" param:param withMessage:@"" show:YES CompletionHandler:^(id json) {
        if ([json[@"code"] boolValue]) {
            
            if (self.memberCardVo.status.integerValue == 1) {
                [LSAlertHelper showStatus:@" 挂失成功！" afterDeny:2 block:^{
                    [self popToViewControllerNamed:@"LSMemberModule" popDirection:kCATransitionFromLeft];
                }];
            }
            else if (self.memberCardVo.status.integerValue == 2) {
                [LSAlertHelper showStatus:@" 解挂成功！" afterDeny:2 block:^{
                    [self popToViewControllerNamed:@"LSMemberModule" popDirection:kCATransitionFromLeft];
                }];
            }
        }

    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json block:nil];
    }];
}

#pragma mark - related check
- (BOOL)hasChanged {
    
    return NO;
}

@end
