//
//  LSMemberCardTypeViewController.m
//  retailapp
//
//  Created by taihangju on 16/9/10.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberCardTypeViewController.h"
#import "LSMemberCardBackdropViewController.h"
#import "MemoInputView.h"
#import "ItemTitle.h"
#import "NavigateTitle2.h"
#import "UIView+Sizes.h"
#import "ColorHelper.h"
#import "EditItemRadio.h"
#import "EditItemText.h"
#import "EditItemList.h"
#import "EditItemMemo.h"
#import "NameItemVO.h"
#import "OptionPickerBox.h"
#import "SymbolNumberInputBox.h"
#import "LSMemberCardBackImageBox.h"
#import "LSMemberTypeVo.h"
#import "LSAlertHelper.h"
#import "FormatUtil.h"
#import "NSArray+Extension.h"
#import "LSCardTextFontStyle.h"
#import "LSCardBackgroundImageVo.h"
#import "LSMemberConst.h"
#import "NSNumber+Extension.h"

#define PrimedTypeSelect  11   // 选择优惠方式 - 标识
#define DefaultPrimedRate 12   // 默认折扣率
#define UpgradeNeedingIntergal    13    // 升级所需积分
#define IntergalRule    14     // 积分设置规则
#define NextGradeCardType 15   // 下一级可升级会员卡
#define CardFontColor 16       // 卡片字体颜色
#define DefaultFontColor    @"200,255,255,255"

@interface LSMemberCardTypeViewController ()<INavigateEvent ,OptionPickerClient ,IEditItemListEvent ,IEditItemRadioEvent ,SymbolNumberInputClient ,IEditItemMemoEvent ,MemoInputClient>

@property (nonatomic ,assign) NSInteger type;/*<>*/
@property (nonatomic ,strong) UIScrollView *scrollView;/*<>*/
@property (nonatomic ,strong) NavigateTitle2 *titleBox;/*<>*/
@property (nonatomic, strong) EditItemText *memberCardName;/*<会员卡名称>*/
@property (nonatomic, strong) EditItemRadio *allowWechatUserRequest;/*<是否允许微店用户申领>*/
@property (nonatomic ,strong) EditItemList *primedType;/*<优惠方式>*/
@property (nonatomic ,strong) EditItemList *defaultPrimedRate;/*<默认折扣率>*/
@property (nonatomic ,strong) EditItemRadio *upgradeSet;/*<达到一定积分自动升级>*/
@property (nonatomic ,strong) EditItemList *nextCardType;/*<下一级卡类型>*/
@property (nonatomic ,strong) EditItemList *needIntegral;/*<升级 所需积分>*/
@property (nonatomic ,strong) EditItemList *integralRule;/*<消费得积分规则>*/
@property (nonatomic ,strong) EditItemList *cardTextColor;/*<卡片字体颜色>*/
@property (nonatomic ,strong) EditItemMemo *userNeedKnow;/*<用户须知>*/
@property (nonatomic ,strong) LSMemberCardBackImageBox *cardBackgroundImage;/*<卡片背景图片选择>*/
@property (nonatomic ,strong) ItemTitle *baseSet;/* <基础设置 栏*/
@property (nonatomic ,strong) ItemTitle *cardSet;/* <卡片设置 栏*/
@property (nonatomic ,strong) UIButton *deleteButton;/* <删除button*/
@property (nonatomic ,strong) UILabel *noticeLabel;/* <页面底部提示 文案*/
@property (nonatomic ,strong) NSArray *primedTypeItems;/* <优惠方式，可选方式*/
@property (nonatomic ,strong) NSArray *upgradeCardTypeItems;/* <更高级会员卡 可选种类*/
@property (nonatomic ,strong) NSArray *cardFontColorItems;/* <卡片字体颜色*/
@property (nonatomic ,strong) LSMemberTypeVo *memberTypVo;/* <会员类型model*/
@property (nonatomic ,strong) NSArray *cardTypeList;/* <会员卡类型列表*/
@property (nonatomic ,strong) NSArray *reqFontStyles;/* <请求获取的会员卡字体风格列表*/
@property (nonatomic ,copy) ReloadCallBack callBack;/* <回调刷新block*/
@property (nonatomic ,strong) LSCardBackgroundImageVo *cardBackgroundImageVo;/*<卡片背景图vo>*/
@property (nonatomic ,assign) BOOL hasEditPower;/*<是否有修改会员信息的权限>*/
@end

@implementation LSMemberCardTypeViewController

- (instancetype)initWithType:(NSInteger)type typeVo:(LSMemberTypeVo *)vo cardTypes:(NSArray *)list block:(ReloadCallBack)block {
    
    self = [super init];
    if (self) {
        
        self.primedTypeItems = [LSMemberTypeVo getNameItemsForPrimeType];
        self.type = type;
        // 对vo进行深复制，防止本界面进行的改变，在未保存时影响之前的界面
        self.memberTypVo = [LSMemberTypeVo getMemberTypeVo:[vo memberTypeDictionary]] ? : [[LSMemberTypeVo alloc] init];
        self.cardTypeList = list;
        self.callBack = block;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [self getMemberCardFontColor];
    [self initNavigate];
    [self configScrollViewAndSubItems];
    [self fillData];
    [self registerNotification];
    [self configHelpButton:HELP_MEMBER_CARD_TYPE];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// 下一级可升级会员卡, 不包含当前卡类型
- (NSArray *)upgradeCardTypeItems {
    
    if (!_upgradeCardTypeItems && [ObjectUtil isNotEmpty:self.cardTypeList]) {
        
        NSMutableArray *cardTypes = [[NSMutableArray alloc] initWithCapacity:self.cardTypeList.count];
        if (self.type == ACTION_CONSTANTS_ADD) {
            for (LSMemberTypeVo *obj in self.cardTypeList) {
                NameItemVO *vo = [[NameItemVO alloc] initWithVal:obj.name andId:obj.sId];
                [cardTypes addObject:vo];
                
            }
        }
        else {
            for (LSMemberTypeVo *obj in self.cardTypeList) {
                if ([NSString isNotBlank:self.memberTypVo.sId] && ![self.memberTypVo.sId isEqualToString:obj.sId]) {
                    NameItemVO *vo = [[NameItemVO alloc] initWithVal:obj.name andId:obj.sId];
                    [cardTypes addObject:vo];
                }
            }
        }
        _upgradeCardTypeItems = [cardTypes copy];
        
    }
    return _upgradeCardTypeItems;
}

#pragma mark - NavigateTitle2 代理
//初始化导航栏
- (void)initNavigate {
    
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    self.titleBox.frame = CGRectMake(0, 0, SCREEN_W, 64.0);
    if (self.type == ACTION_CONSTANTS_EDIT)
    {
        [self.titleBox initWithName:self.memberTypVo.name backImg:Head_ICON_BACK moreImg:nil];
    }
    else
    {
        [self.titleBox initWithName:@"添加卡类型" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
    }
    
    [self.view addSubview:self.titleBox];
}

//导航栏点击事件
- (void)onNavigateEvent:(Direct_Flag)event {
    
    if (event == DIRECT_LEFT) {
        // 添加或者编辑状态有未保存信息时，点击“取消按钮”提示是否放弃更改
        if ([self isNeedSaveChange]) {
            [LSAlertHelper showAlert:@"提示" message:@"内容有变更尚未保存，确定要退出吗？" cancle:@"取消" block:nil ensure:@"确定" block:^{
                    [self popToLatestViewController:kCATransitionFromLeft];
            }];
        }
        else {
            [self popToLatestViewController:kCATransitionFromLeft];
        }
    }
    else if (event == DIRECT_RIGHT)
    {
        if (self.type == ACTION_CONSTANTS_EDIT)
        {
            [self updateCurrentCardType];
        }
        else if (self.type == ACTION_CONSTANTS_ADD)
        {
            [self saveNewMemberCardType];
        }
    }
}


// 创建scrollView的子控件，同时根据用户操作调整scrollView 子views的布局
- (void)configScrollViewAndSubItems {
    
    if (!self.scrollView) {
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:
                           CGRectMake(0, self.titleBox.ls_bottom, SCREEN_W, SCREEN_H - self.titleBox.ls_bottom)];
        self.scrollView.backgroundColor  = [UIColor clearColor];
        [self.view addSubview:self.scrollView];
    }
    
    
    CGFloat topY = 0.0;
// 基础设置
    if (!self.baseSet) {
        self.baseSet = [[ItemTitle alloc] init];
        [self.baseSet awakeFromNib];
        self.baseSet.lblName.text = @"基本设置";
        [self.scrollView addSubview:self.baseSet];
    }
    self.baseSet.ls_top = topY;
    topY += 48.0; // 默认每行高度48
    
    // 会员卡名称
    if (!self.memberCardName) {
        self.memberCardName = [[EditItemText alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
        [self.memberCardName initLabel:@"会员卡名称" withHit:nil isrequest:YES type:0];
        self.memberCardName.notificationType = Notification_UI_Change;
        [self.memberCardName initMaxNum:kMemberNameMaxNum];
        [self.scrollView addSubview:self.memberCardName];
    }
    self.memberCardName.ls_top = topY;
    topY += 48;
    
    // 允许微店用户自动申领
    if (!self.allowWechatUserRequest) {
        self.allowWechatUserRequest = [[EditItemRadio alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
        [self.allowWechatUserRequest awakeFromNib];
        [self.allowWechatUserRequest initLabel:@"允许微店用户主动申领" withHit:nil delegate:self];
        [self.allowWechatUserRequest initData:@"0"];
        [self.scrollView addSubview:self.allowWechatUserRequest];
    }
    self.allowWechatUserRequest.ls_top = topY;
    topY += 48;
    
    // 优惠方式
    if (!self.primedType) {
        
        self.primedType = [[EditItemList alloc] initWithFrame:
                           CGRectMake(0, 0, SCREEN_W, 48.0)];
        [self.primedType initLabel:@"优惠方式" withHit:@"" delegate:self];
        NameItemVO *item = [self.primedTypeItems objectAtIndex:[self.memberTypVo getCurrentPrimeTypeNameItemIndex]];
        [self.primedType initData:[item obtainItemName] withVal:[item obtainItemId]];
        [self.scrollView addSubview:self.primedType];

    }
    self.primedType.ls_top = topY;
    topY += 48;
    
    
    // 默认折扣率
    if ([self.primedType.lblVal.text isEqualToString:@"使用折扣率"]) {
        if (!self.defaultPrimedRate) {
            self.defaultPrimedRate = [[EditItemList alloc] initWithFrame:
                                      CGRectMake(0, 0, SCREEN_W, 48.0)];
            [self.defaultPrimedRate initIndent:@"默认折扣率(%)" withHit:@"" isrequest:NO delegate:self];
            [self.defaultPrimedRate initData:@"100" withVal:@"100"];
            [self.scrollView addSubview:self.defaultPrimedRate];
        }
        self.defaultPrimedRate.hidden = NO;
        // 优惠方式选择“使用折扣率”，显示默认折扣率项，其他情况隐藏
        if (self.defaultPrimedRate) {
            
            self.defaultPrimedRate.ls_top = topY;
            topY += 48;
        }
        else {
            [self.defaultPrimedRate setHidden:YES];
        }
    }
    else {
        [self.defaultPrimedRate setHidden:YES];
    }
    

    // 达到一定积分自动升级
    if (!self.upgradeSet) {
        self.upgradeSet = [[EditItemRadio alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
        [self.upgradeSet awakeFromNib];
        if (self.type == ACTION_CONSTANTS_EDIT) {
            NSString *originStatus = ([NSString isNotBlank:self.memberTypVo.upKindCardId]) ? @"1" : @"0";
            [self.upgradeSet initLabel:@"达到一定积分自动升级" withVal:originStatus withHit:@""];
        }
        else {
            [self.upgradeSet initLabel:@"达到一定积分自动升级" withVal:@"0" withHit:@""];
        }
        self.upgradeSet.delegate = self;
        [self.scrollView addSubview:self.upgradeSet];
    }
    self.upgradeSet.ls_top = topY;
    topY += 48;


    if (self.upgradeSet.imgOn.hidden == NO) {
        
        // 下一级卡类型
        if (!self.nextCardType) {
            self.nextCardType = [[EditItemList alloc] initWithFrame:
                                 CGRectMake(0, 0, SCREEN_W, 48.0)];
            [self.nextCardType initIndent:@"下一级卡类型" withHit:@"" isrequest:YES delegate:self];
            self.nextCardType.lblVal.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"必选" attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
            [self.nextCardType initData:@"" withVal:@""];
            [self.scrollView addSubview:self.nextCardType];
        }
        self.nextCardType.hidden = NO;
        self.nextCardType.ls_top = topY;
        topY += 48.0;
        
        
        //  升级所需积分
        if (!self.needIntegral) {
            self.needIntegral = [[EditItemList alloc] initWithFrame:
                                 CGRectMake(0, 0, SCREEN_W, 48.0)];
            [self.needIntegral initIndent:@"升级所需积分" withHit:@"" isrequest:YES delegate:self];
            [self.needIntegral initData:@"" withVal:@""];
            [self.scrollView addSubview:self.needIntegral];
        }
        self.needIntegral.hidden = NO;
        self.needIntegral.ls_top = topY;
        topY += 48.0;
    }
    else
    {
        [self.nextCardType setHidden:YES];
        [self.needIntegral setHidden:YES];
    }
    
    // 消费几元得1个积分
    if (!self.integralRule) {
        self.integralRule = [[EditItemList alloc] initWithFrame:
                             CGRectMake(0, 0, SCREEN_W, 48.0)];
        [self.integralRule initLabel:@"消费几元得1个积分" withHit:@"0表示消费不得积分" isrequest:YES delegate:self];
        [self.integralRule initData:@"" withVal:@""];
        [self.scrollView addSubview:self.integralRule];
    }
    self.integralRule.ls_top = topY;
    topY += self.integralRule.ls_height;
    
// 卡片设置
    if (!self.cardSet) {
        self.cardSet = [[ItemTitle alloc] init];
        [self.cardSet awakeFromNib];
        self.cardSet.lblName.text = @"卡片设置";
        [self.scrollView addSubview:self.cardSet];
    }
    self.cardSet.ls_top = topY;
    topY += 48.0; // 默认每行高度48
    
    // 卡片字体颜色
    if (!self.cardTextColor) {
        self.cardTextColor = [[EditItemList alloc] initWithFrame:
                              CGRectMake(0, 0, SCREEN_W, 48.0)];
        [self.cardTextColor initLabel:@"卡片字体颜色" withHit:nil isrequest:YES delegate:self];
        [self.cardTextColor initData:@"白色" withVal:@"白色"];
        [self.scrollView addSubview:self.cardTextColor];
    }
    self.cardTextColor.ls_top = topY;
    topY += 48.0;
    
    // 选择卡片背景
    if (!self.cardBackgroundImage) {
        
        self.cardBackgroundImage = [[LSMemberCardBackImageBox alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 224.0)];
        [self.cardBackgroundImage initTarget:self method:@selector(selectCardBackdrop)];
        [self.scrollView addSubview:self.cardBackgroundImage];

    }
    self.cardBackgroundImage.ls_top = topY;
    topY += self.cardBackgroundImage.ls_height;
    
    // 用户须知
    if (!self.userNeedKnow) {
        self.userNeedKnow =  [[EditItemMemo alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
        self.userNeedKnow.notificationType = Notification_UI_Change;
        [self.userNeedKnow initLabel:@"用户须知" isrequest:NO delegate:self];
        if ([NSString isNotBlank:self.memberTypVo.memo]) {
            [self.userNeedKnow initData:self.memberTypVo.memo];
        }
        [self.scrollView addSubview:self.userNeedKnow];
    }
    self.userNeedKnow.ls_top = topY;
    topY += self.userNeedKnow.ls_height;
    
    // 提示文案
    if (!self.noticeLabel) {

        self.noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_W-20.0, 55.0)];
        self.noticeLabel.textColor = [ColorHelper getTipColor6];
        self.noticeLabel.font = [UIFont systemFontOfSize:13.0];
        self.noticeLabel.numberOfLines = 0;
        self.noticeLabel.text = MemberCardTypeUseSceneDescribe;
        [self.scrollView addSubview:self.noticeLabel];
    }
    self.noticeLabel.ls_top = topY;
    topY = self.noticeLabel.ls_bottom;
    
    // 删除button
    if (self.type == ACTION_CONSTANTS_EDIT) {
        
        if (!self.deleteButton) {
            
            self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.deleteButton setTitle:@"删除" forState:0];
            [self.deleteButton setBackgroundColor:[ColorHelper getRedColor]];
            [self.deleteButton.titleLabel setTextColor:RGB(192, 0, 0)];
            [self.deleteButton addTarget:self action:@selector(deleteMember:) forControlEvents:UIControlEventTouchUpInside];
            self.deleteButton.frame = CGRectMake(12, 0, SCREEN_W - 24, 44);
            self.deleteButton.layer.cornerRadius = 4.0;
            [self.scrollView addSubview:self.deleteButton];
        }
        self.deleteButton.ls_top = topY + 5.0;
        topY = self.deleteButton.ls_bottom;
    }

    self.scrollView.contentSize = CGSizeMake(SCREEN_W ,topY + 30);
}

// 填充model数据到界面
- (void)fillData {
    
    if (self.type == ACTION_CONSTANTS_EDIT) {
        
        // 会员卡名称
        [self.memberCardName initData:self.memberTypVo.name];
        
        // 允许微店用户自动申领
        [self.allowWechatUserRequest initData:@(self.memberTypVo.isApply).stringValue];
        
        // 优惠方式
        NameItemVO *vo = [self.primedTypeItems objectAtIndex:[self.memberTypVo getCurrentPrimeTypeNameItemIndex]];
        [self.primedType initData:[vo obtainItemName] withVal:[vo obtainItemId]];
        
        //默认折扣率
        NSString *ratioStr = [self.memberTypVo.ratio convertToStringWithFormat:@"##0.##"];
        [self.defaultPrimedRate initData:ratioStr withVal:ratioStr];
        
        //自动升级
        if ([NSString isNotBlank:self.memberTypVo.upKindCardId]) {
            [self.upgradeSet initData:@"1"];
        }
        
         // 下一级卡类型
        if ([NSString isNotBlank:self.memberTypVo.upKindCardId]) {
            
            NSArray *array = [self.upgradeCardTypeItems filterWithFormatString:[NSString stringWithFormat:@"itemId=='%@'" ,self.memberTypVo.upKindCardId]];
            NameItemVO *vo = [array lastObject];
            [self.nextCardType initData:vo.itemName withVal:vo.itemId];
        }

        // 升级所需积分
        //NSString *needIntegral = [FormatUtil formatDouble4:self.memberTypVo.upDegree];
        NSString *needIntegral = [FormatUtil formatDouble4:self.memberTypVo.upDegree];
        [self.needIntegral initData:needIntegral withVal:needIntegral];
        
        // 消费多少金额兑换1积分
        NSString *integralRuleStr = [@(self.memberTypVo.exchangeDegree) convertToStringWithFormat:@"###,##0.00"];
        [self.integralRule initData:integralRuleStr withVal:integralRuleStr];
        
        // 卡片字体颜色
        NSArray *colors = [self.memberTypVo.style componentsSeparatedByString:@"|"];
        if ([NSString isNotBlank:self.memberTypVo.style] && [ObjectUtil isNotEmpty:colors]) {
            
            [self.cardTextColor initData:self.memberTypVo.fontStyle withVal:[colors firstObject]];
        }
        
        // 卡片背景
        // attachmentId 不为空才说明指定了卡片背景
        if ([NSString isNotBlank:self.memberTypVo.attachmentId]) {
            if ([NSString isNotBlank:self.memberTypVo.filePath]) {
                [self.cardBackgroundImage initFontColor:colors.firstObject imagePath:self.memberTypVo.filePath];
            }
            [self.cardBackgroundImage set:[[Platform Instance] getkey:SHOP_NAME] cardTypeName:self.memberTypVo.name cardNum:@""];
        }
       
        // 卡片使用场景说明
        [self.userNeedKnow initData:self.memberTypVo.memo ? : @""];
    }
}

// 点击删除
- (void)deleteMember:(UIButton *)sender {
    
    [LSAlertHelper showSheet:[NSString stringWithFormat:@"确认要删除[%@]吗?" ,self.memberTypVo.name] cancle:@"取消" cancleBlock:nil selectItems:@[@"确认"] selectdblock:^(NSInteger index) {
        [self deleteCurrentMemberCardType];
    }];

}

#pragma mark - 通知
- (void)registerNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UIDataChanged:) name:Notification_UI_Change object:nil];
}

- (void)UIDataChanged:(NSNotification *)not {
 
    if ([not.object isEqual:self.memberCardName]) {
        // 会员卡名称更改
        self.memberTypVo.name = self.memberCardName.txtVal.text ? : @"";
        // 编辑模式，cardBackgroundImage上会员卡显示的名称可以跟随着会员卡名的修改而改变
        if (self.type == ACTION_CONSTANTS_EDIT) {
            self.cardBackgroundImage.cardTypeName.text = self.memberTypVo.name;
        }
        
    }
    else if ([not.object isEqual:self.userNeedKnow]) {
        // 用户须知
        self.memberTypVo.memo = self.userNeedKnow.currentVal;
    }
    [self isNeedSaveChange];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - 选择会员卡片背景
- (void)selectCardBackdrop {
    
    if ([NSString isBlank:self.memberCardName.txtVal.text]) {
        [LSAlertHelper showAlert:@"会员卡名称不能为空！" block:nil];
        return;
    }
    
    NSDictionary *dic = @{@"shop":[[Platform Instance] getkey:SHOP_NAME],
                          @"cardType":self.memberTypVo.name,
                          @"cardNum":@"NO.00000000000",
                          @"fontColor":self.cardTextColor.currentVal};
    LSMemberCardBackdropViewController *vc = [[LSMemberCardBackdropViewController alloc] init:dic];
    vc.selectImage = ^(UIImage *image ,NSString *imagePath ,id obj) {
      
        if (image && [ObjectUtil isEmpty:obj]) {
            self.cardBackgroundImage.imageView.image = image;
            self.memberTypVo.selfCoverPath = imagePath;
            self.memberTypVo.coverType = CoverTypeSelf;
            [self.cardBackgroundImage set:dic[@"shop"] cardTypeName:dic[@"cardType"] cardNum:dic[@"cardNum"]];
            [self.cardBackgroundImage changeFontColor:self.cardTextColor.currentVal imagePath:imagePath];
        }
        else {
            self.cardBackgroundImageVo = (LSCardBackgroundImageVo *)obj;
            self.memberTypVo.attachmentId = self.cardBackgroundImageVo.attachmentId;
            self.memberTypVo.coverType = CoverTypeOffical;
            [self.cardBackgroundImage set:dic[@"shop"] cardTypeName:dic[@"cardType"] cardNum:dic[@"cardNum"]];
            [self.cardBackgroundImage changeFontColor:self.cardTextColor.currentVal imagePath:[obj valueForKey:@"filePath"]];
        }
        
        [self isNeedSaveChange];
        [self popToLatestViewController:kCATransitionFromLeft];
       
    };
    [self pushController:vc from:kCATransitionFromRight];
}

#pragma mark - 协议等状态变更回调方法

// OptionPickerClient
- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType {
    
    NameItemVO *vo = (NameItemVO *)selectObj;
    if (eventType == PrimedTypeSelect) {
        
        self.memberTypVo.mode = [vo.itemId intValue];
        [self.primedType changeData:[vo obtainItemName] withVal:[vo obtainItemId]];
        [self configScrollViewAndSubItems];
    }
    else if (eventType == NextGradeCardType)
    {
        [self.nextCardType changeData:[vo obtainItemName] withVal:[vo obtainItemId]];
        if (self.upgradeSet.imgOn.hidden == NO) {
            self.memberTypVo.upKindCardId = vo.itemId;
            self.memberTypVo.upKindCardName = vo.itemName;
        }
    }
    else if (eventType == CardFontColor)
    {
        self.memberTypVo.style = [NSString stringWithFormat:@"%@|%@" ,vo.itemId ,vo.itemName];
        [self.cardTextColor changeData:[vo obtainItemName] withVal:[vo obtainItemId]];
        [self.cardBackgroundImage changeFontColor:vo.itemId];
    }
    [self isNeedSaveChange];
    return YES;
}

// IEditItemListEvent
- (void)onItemListClick:(EditItemList *)obj {
    
    if ([obj isEqual:self.primedType]) {
        [OptionPickerBox initData:self.primedTypeItems itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:PrimedTypeSelect];
    }
    else if ([obj isEqual:self.defaultPrimedRate])
    {
        [SymbolNumberInputBox initData:obj.lblVal.text];
        [SymbolNumberInputBox limitInputNumber:3 digitLimit:0];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:NO isSymbol:YES event:DefaultPrimedRate];
    }
    else if ([obj isEqual:self.nextCardType])
    {
        NSString *initString = [obj getStrVal];
        NSString *itemId = obj.currentVal;
        if ([NSString isBlank:itemId] && [ObjectUtil isNotEmpty:self.upgradeCardTypeItems]) {
            
            NameItemVO *vo = [self.upgradeCardTypeItems firstObject];
            if ([NSString isNotBlank:initString]) {
                NSArray *array = [self.upgradeCardTypeItems filterWithFormatString:[NSString stringWithFormat:@"itemName=='%@'" ,initString]];
                vo = [array firstObject];
            }
            itemId = vo.itemId;
        }
        [OptionPickerBox initData:self.upgradeCardTypeItems itemId:itemId];
        [OptionPickerBox show:obj.lblName.text client:self event:NextGradeCardType];
    }
    else if ([obj isEqual:self.needIntegral])
    {
        NSString *initString = obj.lblVal.text ? : @"";
        [SymbolNumberInputBox initData:initString];
        [SymbolNumberInputBox limitInputNumber:8 digitLimit:0];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:NO isSymbol:YES event:UpgradeNeedingIntergal];
    }
    else if ([obj isEqual:self.integralRule])
    {
        NSString *initString = obj.lblVal.text ? : @"";
        [SymbolNumberInputBox initData:initString];
        [SymbolNumberInputBox limitInputNumber:6 digitLimit:2];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:YES isSymbol:YES event:IntergalRule];
    }
    else if ([obj isEqual:self.cardTextColor])
    {
        NameItemVO *vo = [[NameItemVO alloc] initWithVal:@"白色" andId:DefaultFontColor];
        if ([ObjectUtil isNotEmpty:self.cardFontColorItems]) {
            
            NSArray *array = [self.cardFontColorItems filterWithFormatString:[NSString stringWithFormat:@"itemName='%@'" ,self.cardTextColor.lblVal.text]];
            vo = (NameItemVO *)[array lastObject];
        }
        [OptionPickerBox initData:self.cardFontColorItems itemId:vo.itemId];
        [OptionPickerBox show:obj.lblName.text client:self event:CardFontColor];
    }
}

// SymbolNumberInputClient
- (void)numberClientInput:(NSString *)val event:(NSInteger)eventType {
    
    if (eventType == DefaultPrimedRate) {
        
        if (val.integerValue > 100) {
            
            [LSAlertHelper showAlert:@"默认折扣率最大值为100！" block:nil];
            return;
        }
        [self.defaultPrimedRate changeData:val withVal:val];
        self.memberTypVo.ratio = [val convertToNumber];
    }
    else if (eventType == UpgradeNeedingIntergal)
    {
        
        [self.needIntegral changeData:val withVal:val];
        if (self.upgradeSet.imgOn.hidden == NO) {
            self.memberTypVo.upDegree = [val doubleValue];
        }
        
    }
    else if (eventType == IntergalRule)
    {
        [self.integralRule changeData:[val formatWith2FractionDigits] withVal:[val formatWith2FractionDigits]];
        // 应后台要求，下面两个字段保持值一致
        self.memberTypVo.exchangeDegree = [val doubleValue];
        self.memberTypVo.ratioExchangeDegree = [val doubleValue];
    }
    [self isNeedSaveChange];
}


// IEditItemRadioEvent
- (void)onItemRadioClick:(id)obj {
    
    if ([obj isEqual:self.upgradeSet]) {
        
        // 本身值不会被保存，子类型会保存
        if (self.upgradeSet.imgOn.hidden == YES) {
            
            self.memberTypVo.upKindCardName = nil;
            self.memberTypVo.upKindCardId = nil;
        }
        else {
            
            self.memberTypVo.upKindCardName = self.nextCardType.lblVal.text;
            self.memberTypVo.upKindCardId = self.nextCardType.currentVal;
        }
        [self configScrollViewAndSubItems];
    }
    else if ([obj isEqual:self.allowWechatUserRequest])
    {
        self.memberTypVo.isApply = self.allowWechatUserRequest.imgOn.hidden ? 0 : 1;
    }
    [self isNeedSaveChange];
}

// IEditItemMemoEvent
- (void)onItemMemoListClick:(EditItemMemo *)obj {
//    [MemoInputBox show:1 delegate:self title:@"用卡须知" val:[self.userNeedKnow getStrVal]];
    MemoInputView *vc = [[MemoInputView alloc] init];
    [vc limitShow:0 delegate:self title:@"用卡须知" val:[self.userNeedKnow getStrVal] limit:250];
    [self pushController:vc from:kCATransitionFromRight];
}


// MemoInputClient
- (void)finishInput:(int)event content:(NSString *)content {
    [self.userNeedKnow changeData:content];
    [self configScrollViewAndSubItems];
}


#pragma mark - 网络请求
// 获取会员卡上字体颜色
- (void)getMemberCardFontColor {
    
    NSDictionary *param = @{@"code" : @"CARD_STYLE"};
    [BaseService getRemoteLSOutDataWithUrl:@"kindCard/queryDicSysItemByDicCode" param:[param mutableCopy] withMessage:@"" show:YES CompletionHandler:^(id json) {
        if ([json[@"code"] boolValue]) {
            
            self.reqFontStyles = [LSCardTextFontStyle getObjectsFrom:json[@"data"]];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [self.reqFontStyles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                LSCardTextFontStyle *fontStyle = (LSCardTextFontStyle *)obj;
                NameItemVO *vo = [[NameItemVO alloc] initWithVal:fontStyle.name andId:fontStyle.val];
                [array addObject:vo];
            }];
            self.cardFontColorItems = [array copy];
        }

    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json block:nil];
    }];
}

// 新增的会员卡类型
- (void)saveNewMemberCardType {
    
    if ([self checkRequiredItems]) {
        
        NSString *entityId = [[Platform Instance] getkey:ENTITY_ID];
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setValue:entityId forKey:@"entityId"];
        [param setValue:@"" forKey:@"planId"];
        [param setValue:@"" forKey:@"attachmentUrl"];
        [param setValue:[self.memberTypVo jsonString] forKey:@"kindCardStr"];
        
        [BaseService getRemoteLSOutDataWithUrl:@"kindCard/save" param:param withMessage:@"" show:YES CompletionHandler:^(id json) {
            if (self.callBack) {
                self.callBack();
            }
        } errorHandler:^(id json) {
            [LSAlertHelper showAlert:json block:nil];
        }];
    }
}

// 更新当前会员卡类型
- (void)updateCurrentCardType {
    
    if ([self checkRequiredItems]) {
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        NSString *entityId = [[Platform Instance] getkey:ENTITY_ID];
        [param setValue:entityId forKey:@"entityId"];
        [param setValue:@"" forKey:@"planId"];
        [param setValue:@"" forKey:@"attachmentUrl"];
        [param setValue:[self.memberTypVo jsonString] forKey:@"kindCardStr"];
       
        [BaseService getRemoteLSOutDataWithUrl:@"kindCard/update" param:param withMessage:@"" show:YES CompletionHandler:^(id json) {
            if (self.callBack) {
                self.callBack();
            }
        } errorHandler:^(id json) {
            [LSAlertHelper showAlert:json block:nil];
        }];
    }
}

// 删除当前的会员卡类型
- (void)deleteCurrentMemberCardType {
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    NSString *entityId = [[Platform Instance] getkey:ENTITY_ID];
    [param setValue:entityId forKey:@"entityId"];
    [param setValue:self.memberTypVo.sId forKey:@"kindCardId"];//@"kindCard/delete"
    NSString *url = @"kindCard/delete";
   
    [BaseService getRemoteLSOutDataWithUrl:url param:param withMessage:@"" show:YES CompletionHandler:^(id json) {
        if (self.callBack) {
            self.callBack();
        }
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json block:nil];
    }];
}

#pragma mark - 相关校验
// 状态是否发生了改变，如果改变提示需要保存更改
- (BOOL)isNeedSaveChange {
 
    if (self.memberCardName.baseChangeStatus || self.allowWechatUserRequest.baseChangeStatus || self.primedType.baseChangeStatus || self.defaultPrimedRate.baseChangeStatus || self.upgradeSet.baseChangeStatus || self.nextCardType.baseChangeStatus || self.needIntegral.baseChangeStatus || self.integralRule.baseChangeStatus || self.cardTextColor.baseChangeStatus || self.userNeedKnow.baseChangeStatus || self.cardBackgroundImage.baseChangeStatus) {
        
        if (self.type == ACTION_CONSTANTS_EDIT) {
            [self.titleBox editTitle:YES act:ACTION_CONSTANTS_ADD];
        }
        return YES;
    }
    else {
        if (self.type == ACTION_CONSTANTS_EDIT) {
            [self.titleBox editTitle:NO act:0];
        }
        return NO;
    }
}

// 检测必填项
- (BOOL)checkRequiredItems {
    
    NSString *alertString = nil;
    
    // 会员卡名称
    if ([NSString isBlank:self.memberCardName.txtVal.text]) {
        alertString = @"会员卡名称不能为空！";
    }
    else if (!self.upgradeSet.imgOn.hidden) {
        
        if ([NSString isBlank:self.needIntegral.lblVal.text] || [self.needIntegral.lblVal.text integerValue] <= 0) {
            // 升级所需积分
            alertString = @"积分必须大于0！";
        }
        else if (![self.nextCardType.lblVal.text length]) {
         
            alertString = @"请选择下一级卡类型！";
        }
    }
    else if ([NSString isBlank:self.integralRule.lblVal.text]) {
        // 消费几元得1个积分
        alertString = @"请设置消费得积分规则！";
    }
    
    if (alertString) {
       
        [LSAlertHelper showAlert:@"提示" message:alertString cancle:@"我知道了" block:nil];
        return NO;
    }
    
    return YES;
}

@end
