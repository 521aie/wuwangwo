//
//  LSMemberBestowIntegralViewController.m
//  retailapp
//
//  Created by taihangju on 16/10/8.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberBestowIntegralViewController.h"
#import "NavigateTitle2.h"
#import "SymbolNumberInputBox.h"
#import "EditItemList.h"
#import "LSMemberInfoView.h"
#import "LSMemberAccessView.h"
#import "LSMemberInfoVo.h"
#import "LSMemberCardVo.h"
#import "LSMemberTypeVo.h"
#import "LSAlertHelper.h"

@interface LSMemberBestowIntegralViewController ()<INavigateEvent ,MBAccessViewDelegate ,LSMemberInfoViewDelegate ,IEditItemListEvent ,SymbolNumberInputClient>

@property (nonatomic ,strong) NavigateTitle2 *titleBox;/*<>*/
@property (nonatomic ,strong) LSMemberInfoView *infoView;/*<二维火会员信息>*/
@property (nonatomic ,strong) LSMemberAccessView *cardsSummary;/*<会员卡横向滑动列表>*/
@property (nonatomic ,strong) EditItemList *presentIntegral;/*<赠送积分>*/
@property (nonatomic ,strong) UIButton *ensureButton;/*<确定button>*/
@property (nonatomic ,strong) UIScrollView *scrollView;/*<>*/

@property (nonatomic ,strong) LSMemberPackVo *memberPackVo;/*<>*/
@property (nonatomic ,strong) LSMemberCardVo *memberCardVo;/*<当前选择的 会员卡vo>*/
@property (nonatomic ,strong) NSArray *memberCardTypes;/*<卡类型>*/
@property (nonatomic ,strong) NSArray *memberCards;/*<已发了的会员卡>*/
@property (nonatomic ,strong) NSString *selectCardId;/*<指定初始化要操作的卡id>*/
@end

@implementation LSMemberBestowIntegralViewController

- (instancetype)init:(LSMemberPackVo *)vo cardId:(NSString *)sId {
    
    self = [super init];
    if (self) {
        
        self.memberPackVo = vo;
        self.selectCardId = sId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [self configSubViews];
    [self initNavigate];
    [self loadMemberCards];
    [self configHelpButton:HELP_MEMBER_MEMBER_SEND_INTERGAL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)configSubViews {
    
    if (!self.scrollView) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:
                           CGRectMake(0, 64.0, SCREEN_W, SCREEN_H - 64)];
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
    
    if (!self.presentIntegral) {
        self.presentIntegral = [[EditItemList alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
        [self.presentIntegral initLabel:@"赠送积分" withHit:nil isrequest:YES delegate:self];
        self.presentIntegral.tag = 11;
        [self.scrollView addSubview:self.presentIntegral];
    }

    
    if (!self.ensureButton) {
        self.ensureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.ensureButton setTitle:@"确认" forState:0];
        [self.ensureButton setBackgroundColor:RGB(0, 170, 34)];// 屎绿色#00AA22
        [self.ensureButton.titleLabel setTextColor:RGB(192, 0, 0)];
        [self.ensureButton addTarget:self action:@selector(ensureAction) forControlEvents:UIControlEventTouchUpInside];
        self.ensureButton.frame = CGRectMake(12, 0, SCREEN_W - 24, 44);
        self.ensureButton.layer.cornerRadius = 4.0;
        [self.scrollView addSubview:self.ensureButton];
    }
    
    if ([self.memberCardVo isLost]) {
        self.presentIntegral.hidden = YES;
        self.ensureButton.hidden = YES;
        topY = self.cardsSummary.ls_bottom;
    }
    else {
        self.presentIntegral.hidden = NO;
        self.ensureButton.hidden = NO;
        self.presentIntegral.ls_top = topY;
        topY += 48.0;
        
        self.ensureButton.ls_top = topY + 25.0;
        topY = self.ensureButton.ls_bottom + 10.0;
        
        }
    if (self.scrollView.ls_height < topY) {
        [self.scrollView setContentSize:CGSizeMake(SCREEN_W, topY)];
    }
}

- (void)fillData {
    
    // 会员信息
    if ([NSString isBlank:self.infoView.statusLabel.attributedText.string]) {
        [self.infoView fillMemberInfo:self.memberPackVo cards:self.memberCards cardTypes:self.memberCardTypes phone:@""];
//        NSUInteger index = 0;
        [self.cardsSummary setCardDatas:self.memberCards initPage:[self.memberCards indexOfObject:self.memberCardVo]];
    }
    [self.presentIntegral initData:@"" withVal:@""];
    
//    if ([self.memberCardVo isLost]) {
        [self configSubViews];
//    }
}

// 确认action
- (void)ensureAction {
    
    [self.view endEditing:YES];
    if ([self isValid]) {
        [self memberDegreeSend];
    }
}


#pragma mark - 相关协议方法
// 滑动选择会员卡
- (void)memberAccessView:(LSMemberAccessView *)view selectdPage:(id)obj {
    LSMemberCardVo *vo = (LSMemberCardVo *)obj;
    if ([self hasChanged] && ![vo isLost]) {
        [LSAlertHelper showAlert:@"换卡后将对另外一张卡进行操作！" block:nil];
    }
    
    if (![vo.status isEqual:self.memberCardVo.status]) {
        self.memberCardVo = vo;
        [self configSubViews];
    }
    else {
        self.memberCardVo = vo;
    }
}


// LSMemberInfoViewDelegate
- (void)memberInfoViewHeightChaged {
    [self configSubViews];
}


// IEditItemListEvent
- (void)onItemListClick:(EditItemList *)obj {
    
    [SymbolNumberInputBox initData:obj.lblVal.text];
    [SymbolNumberInputBox limitInputNumber:8 digitLimit:0];
    [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:NO isSymbol:YES event:0];
}

// SymbolNumberInputClient
- (void)numberClientInput:(NSString *)val event:(NSInteger)eventType {
    self.presentIntegral.lblVal.text = val;
    [self.presentIntegral changeData:val withVal:val];
}

#pragma mark - NavigateTitle2 代理

- (void)initNavigate {
    
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    self.titleBox.frame = CGRectMake(0, 0, SCREEN_W, 64.0);
    [self.titleBox initWithName:@"会员赠分" backImg:Head_ICON_BACK moreImg:nil];
    [self.view addSubview:self.titleBox];
}

//导航栏点击事件
- (void)onNavigateEvent:(Direct_Flag)event {
    if (event == DIRECT_LEFT) {
        [self popToLatestViewController:kCATransitionFromLeft];
    }
}


#pragma mark - 网络请求

// 获取会员所有的会员卡信息
- (void)loadMemberCards {
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:_memberPackVo.customerRegisterThirdPartyPojo.customerRegisterId forKey:@"customerRegisterId"];
    [param setValue:_memberPackVo.customer.sId forKey:@"customerId"];
    [param setValue:[[Platform Instance]  getkey:ENTITY_ID] forKey:@"entityId"];
    [BaseService getRemoteLSDataWithUrl:@"customer/queryCustomerCard" param:param withMessage:@"" show:YES CompletionHandler:^(id json) {
        //        if ([json[@"code"] boolValue]) {
        
        NSMutableArray *types = [[NSMutableArray alloc] init];
        NSMutableArray *cards = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in json[@"data"]) {
            
            LSMemberTypeVo *type = [LSMemberTypeVo getMemberTypeVo:dic[@"kindCard"]];
            LSMemberCardVo *card = [LSMemberCardVo getMemberCardVo:dic[@"card"]];
            card.kindCardName = type.name;
            card.mode = @(type.mode);
            card.filePath = type.filePath;
            card.cardTypeVo = type;
            //                card.rechargeVo = [[LSMemberRechargeVo alloc] init];
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


// 会员赠分
- (void)memberDegreeSend {
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:[[Platform Instance] getkey:ENTITY_ID] forKey:@"entityId"];
    [param setValue:self.memberCardVo.sId forKey:@"cardId"];
    [param setValue:[[Platform Instance] getkey:USER_ID] forKey:@"operatorId"];
    [param setValue:@(self.presentIntegral.currentVal.integerValue) forKey:@"num"];
    
    [BaseService getRemoteLSDataWithUrl:@"customer/degreeSend" param:param withMessage:@"" show:YES CompletionHandler:^(id json) {
        if ([json[@"returnCode"] isEqualToString:@"success"]) {
            [LSAlertHelper showStatus:@" 赠分成功！" afterDeny:2 block:^{
                if (self.selectCardId) {
                    // 有selectCardId，成功后返回详情页。
                    [self popToLatestViewController:kCATransitionFromLeft];
                }
                else {
                    [self popToViewControllerNamed:@"LSMemberModule" popDirection:kCATransitionFromLeft];
                }
            }];
        }
    } errorHandler:^(id json) {
         [LSAlertHelper showAlert:json block:nil];
    }];
}

#pragma mark - check
- (BOOL)hasChanged {
    return self.presentIntegral.baseChangeStatus;
}

- (BOOL)isValid {
    // 必填项check
    if ([NSString isBlank:self.presentIntegral.currentVal]) {
        [LSAlertHelper showAlert:@"赠送积分不能为空！" block:nil];
        return NO;
    }
    else {
        
        if ([self.presentIntegral.currentVal integerValue] == 0) {
            [LSAlertHelper showAlert:@"赠分不能为0, 赠分只能为整数！" block:nil];
            return NO;
        }
    }
    return YES;
}
@end
