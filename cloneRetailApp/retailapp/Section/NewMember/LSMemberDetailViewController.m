//
//  LSMemberDetailViewController.m
//  retailapp
//
//  Created by byAlex on 16/9/17.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberDetailViewController.h"
#import "LSMemberRechargeViewController.h"
#import "LSMemberIntegralExchangeViewController.h"
#import "LSMemberBestowIntegralViewController.h"
#import "LSMemberChangeCardViewController.h"
#import "LSMemberRescindCardViewController.h"
#import "LSMemberChangePwdViewController.h"
#import "LSMemberSaveDetailViewController.h"
#import "LSMemberElectronicCardSendViewController.h"
#import "LSMemberConsumeDetailController.h" // 会员消费记录详情
#import "LSMemberByTimeRechargeNotesListController.h"
#import "LSByTimeServiceListController.h" // 计次服务
#import "NavigateTitle2.h"
#import "LSMemberExpenseInfoCell.h"
#import "EditItemText.h"
#import "EditItemList.h"
#import "LSMemberAccessView.h"
#import "LSMemberInfoView.h"
#import "ItemTitle.h"
#import "UIView+Sizes.h"
#import "LSMemberSubmenus.h"
#import "ItemValue.h"
#import "DatePickerBox.h"
#import "NameItemVO.h"
#import "OptionPickerBox.h"
#import "DateUtils.h"
#import "LSAlertHelper.h"
#import "SMHeaderItem.h"
#import "LSMemberInfoVo.h"
#import "LSMemberCardVo.h"
#import "LSMemberTypeVo.h"
#import "LSMemberExpandRecordVo.h"
#import "LSMemberOrderRecordVo.h"
#import "DateUtils.h"
#import "LSMemberConst.h"
//#import "AFHTTPRequestOperation.h"
#import "MobClick.h"

static NSString *expenseInfoCellId = @"LSMemberExpenseInfoCell";
//#define kMBInfoEvent 1
#define kMBCardDetailEvent 2
#define kMBShopInfoEvent 3
#define kMBExpenseInfoEvent 4
#define MemberBirthday 5
#define MemberSexType 6
#define ExpandIcon      @"ico_fold"
#define CompactIcon     @"ico_fold_up"

@interface LSMemberDetailViewController ()<INavigateEvent ,IItemTitleEvent ,IEditItemListEvent ,DatePickerClient ,OptionPickerClient ,MBAccessViewDelegate ,UITableViewDelegate ,UITableViewDataSource ,LSMemberInfoViewDelegate>

@property (nonatomic ,strong) NavigateTitle2 *titleBox;/*<>*/
@property (nonatomic ,strong) UITableView *tableView;/* <*/
@property (nonatomic ,strong) UIView *tabHeaderView;/* <tableview headerView*/

// 二维火会员信息
@property (nonatomic ,strong) ItemTitle *memberInfoTitle;/* <二维火会员信息 栏*/
@property (nonatomic ,strong) LSMemberInfoView *memberInfoView;/* <*/

// 卡详情，部分
@property (nonatomic ,strong) ItemTitle *cardDetailTitle;/* <卡详情*/
@property (nonatomic ,strong) UIView *wrapper1;/* <*/
@property (nonatomic ,strong) LSMemberAccessView *cardsSummary;/* <会员卡栏*/
@property (nonatomic ,strong) LSMemberAccessView *cardFunctions;/* <卡相关功能*/
@property (nonatomic ,strong) ItemValue *cardStatus;/* <卡状态*/
@property (nonatomic ,strong) ItemValue *primedType;/* <优惠方式*/
@property (nonatomic ,strong) EditItemList *savingDetail;/* <储值明细*/
@property (nonatomic ,strong) EditItemList *integralDetail;/* <积分明细*/
@property (nonatomic ,strong) ItemValue *sendTime;/* <发卡日期*/
@property (nonatomic, strong) ItemValue *sendType;/* <发卡方式>*/
@property (nonatomic ,strong) ItemValue *sendShop;/* <发卡门店*/
@property (nonatomic ,strong) ItemValue *sendPeople;/* <发卡人*/
@property (nonatomic, strong) EditItemList *byTimeCard;/**<计次卡>*/
@property (nonatomic, strong) EditItemList *byTimeRechargeRecord;/**<计次充值记录>*/

// 店铺会员信息，部分
@property (nonatomic ,strong) ItemTitle *shopMemberInfoTitle;/* <店铺会员信息 栏*/
@property (nonatomic ,strong) UIView *wrapper2;/* <*/
@property (nonatomic ,strong) EditItemText *memberName;/* <会员名*/
@property (nonatomic ,strong) EditItemList *memberSex;/* <会员性别*/
@property (nonatomic ,strong) EditItemList *memberBirthday;/* <会员生日*/
@property (nonatomic ,strong) EditItemText *memberIDNumber;/* <身份证*/
@property (nonatomic ,strong) EditItemText *wechatNumber;/* <微信*/
@property (nonatomic ,strong) EditItemText *email;/* <邮箱*/
@property (nonatomic ,strong) EditItemText *contactAddress;/* <联系地址*/
@property (nonatomic ,strong) EditItemText *postNumber;/* <邮编*/
@property (nonatomic ,strong) EditItemText *jobType;/* <职业*/
@property (nonatomic ,strong) EditItemText *company;/* <公司*/
@property (nonatomic ,strong) EditItemText *duty;/* <职务*/
@property (nonatomic ,strong) EditItemText *carPlateNumber;/* <车牌号*/
@property (nonatomic ,strong) EditItemText *remark;/* <备注*/

// 消费记录 栏
@property (nonatomic ,strong) ItemTitle *expenseInfoTitle;/* <消费记录*/

@property (nonatomic ,assign) BOOL showExpenseInfo;/* <是否展示消费记录*/
@property (nonatomic ,strong) LSMemberPackVo *memberPackVo;/*<页面对应的model>*/
@property (nonatomic ,strong) LSMemberCardVo *memberCardVo;/*<当前选择的 会员卡vo>*/
@property (nonatomic ,strong) NSNumber *lastTime;/*<消费记录查询分页标记>*/

// 页面相关数据源
@property (nonatomic ,strong) NSMutableDictionary *orderRemarkDic;/*<消费信息 数据源>*/
@property (nonatomic ,strong) NSArray *allKeys;/*<消费记录分组titles>*/

@property (nonatomic ,strong) NSArray *memberCards;/*<当前会员拥有的会员卡>*/
@property (nonatomic ,strong) NSArray *memberCardTyps;/*<会员卡所对应的会员类型数组>*/
@property (nonatomic ,assign) BOOL hasEditPower;/*<是否有修改会员信息的权限>*/
@property (nonatomic ,strong) NSString *phoneNum;/*<查询的会员手机号>*/
@property (nonatomic ,assign) BOOL hasChangeContent;/*<页面有编辑项，发生了变化>*/
@end

@implementation LSMemberDetailViewController

- (instancetype)initWithPhoneNum:(NSString *)phoneNum {
    
    self = [super init];
    if (self) {
        _phoneNum = phoneNum;
        _showExpenseInfo = YES;
        _hasEditPower = ![[Platform Instance] lockAct:ACTION_CARD_EDIT];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [self initNavigate];
    [self initTableView];
    [self registerNotification];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self queryMemberInfo];
//    [self querySmsNumAndKindCardAndQueryCard];
    if (_showExpenseInfo) {
        [self getMemberExpendRecords];
    }
}

#pragma mark - NavigateTitle2 代理
//初始化导航栏
- (void)initNavigate {
    
    _titleBox = [NavigateTitle2 navigateTitle:self];
    _titleBox.frame = CGRectMake(0, 0, SCREEN_W, 64.0);
    [_titleBox initWithName:@"会员信息" backImg:Head_ICON_BACK moreImg:nil];
    [self.view addSubview:_titleBox];
}

//导航栏点击事件
- (void)onNavigateEvent:(Direct_Flag)event {
    
    if (event == DIRECT_LEFT) {
        
        if (_hasChangeContent) {
            [LSAlertHelper showAlert:@"提示" message:@"内容有变更尚未保存，确定要退出吗？" cancle:@"取消" block:nil ensure:@"确定" block:^{
                [self popToLatestViewController:kCATransitionFromLeft];
            }];
            return;
        }
        [self popToLatestViewController:kCATransitionFromLeft];
    }
    else {
        [self updateCustomerInfo];
    }
}

#pragma mark - 通知
- (void)registerNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UIDataChanged:)
                                                 name:Notification_UI_Change object:nil];
}

- (void)UIDataChanged:(NSNotification *)not {
    
    if (_memberName.baseChangeStatus || _memberSex.baseChangeStatus || _memberBirthday.baseChangeStatus || _memberIDNumber.baseChangeStatus || _wechatNumber.baseChangeStatus || _email.baseChangeStatus || _contactAddress.baseChangeStatus || _postNumber.baseChangeStatus || _jobType.baseChangeStatus || _company.baseChangeStatus || _duty.baseChangeStatus || _carPlateNumber.baseChangeStatus || _remark.baseChangeStatus) {
        
        [_titleBox editTitle:YES act:ACTION_CONSTANTS_ADD];
        _hasChangeContent = YES;
    }
    else {
        [_titleBox editTitle:NO act:ACTION_CONSTANTS_VIEW];
        _hasChangeContent = NO;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 数据填充/存储

// 填充数据到UI界面
- (void)fillData {
    
    // 二维火会员信息
    [_memberInfoView fillMemberInfo:_memberPackVo cards:_memberCards cardTypes:_memberCardTyps phone:_phoneNum];
    
    // 卡详情信息
    if (self.memberCardVo.sellerId.length == 0) {
        _sendType .valueLable.text = @"微店申领";
    }else{
        _sendType.valueLable.text = @"实体发卡";
    }
    
    [_cardsSummary setCardDatas:_memberCards initPage:[_memberCards indexOfObject:_memberCardVo]];
    if ([ObjectUtil isNotEmpty:_memberCards]) {
        [_cardFunctions setCardDatas:[LSMemberSubmenus memberCardFunctions] initPage:0];
    }
    
    _cardStatus.valueLable.text = [_memberCardVo getCardStatusString];
    if (_memberCardVo.status.integerValue == 2) {
        _cardStatus.valueLable.textColor = [ColorHelper getRedColor];
    }

    _primedType.valueLable.text = [_memberCardVo getPrimeTypeName];
    if ([ObjectUtil isNotNull:_memberCardVo.activeDate]) {
        _sendTime.valueLable.text = [DateUtils formateChineseTime3:_memberCardVo.activeDate.longLongValue];
    }
    
    // 计次充值记录
    if ([[Platform Instance]  getShopMode] == 1 && [[[Platform Instance] getkey:SHOP_MODE] integerValue] == 102) {
      
        [_byTimeRechargeRecord initData:@"" withVal:@""];
        _byTimeCard.lblVal.hidden = YES;
        if (_memberCardVo.byTimeServiceTimes.integerValue >= 0) {
             [_byTimeCard initData:[NSString stringWithFormat:@"%@项",_memberCardVo.byTimeServiceTimes] withVal:@"1"];
             _byTimeCard.lblVal.hidden = NO;
        }
    }

    
    // 发卡门店
    _sendShop.valueLable.text = [NSString isNotBlank:_memberCardVo.shopEntityName] ? _memberCardVo.shopEntityName : @"";
    _sendPeople.valueLable.text = [NSString isNotBlank:_memberCardVo.operatorName] ? _memberCardVo.operatorName : @"-";
    
    // 店铺会员信息(即会员补充信息)
    LSMemberInfoVo *customer = _memberPackVo.customer;
    [_memberName initData:customer.name];
    [_memberSex initData:(customer.sex.intValue == 2 ? @"女" : @"男") withVal:customer.sex.stringValue];
    if ([NSString isNotBlank:customer.birthdayStr] && customer.birthdayStr > 0) {
        NSString *birthdayString = [DateUtils formateChineseTime3:customer.birthday.longLongValue];
        [_memberBirthday initData:birthdayString withVal:birthdayString];
    }
    
    [_memberIDNumber initData:customer.certificate];
    [_wechatNumber initData:customer.weixin];
    [_email initData:customer.email];
    [_contactAddress initData:customer.address];
    [_postNumber initData:customer.zipcode];
    [_jobType initData:customer.job];
    [_company initData:customer.company];
    [_duty initData:customer.pos];
    [_carPlateNumber initData:customer.carNo];
    [_remark initData:customer.memo];
    
    
    if ([_memberCardVo isLost] || [ObjectUtil isEmpty:_memberPackVo.cardNames]) {
        // 会员卡如果是挂失或者未领卡(未领卡有两种情况：1，从来没有领卡 2，领过卡但是又都退了)
        _cardFunctions.hidden = YES;
        [self tableViewReload];
    } else if (_cardFunctions.hidden) {
        // 对应本页面：从功能入口进行退卡(退卡成功后，卡功能入口已经隐藏)，回到本页面点击发卡(成功后，该会员有卡，且卡为非挂失，但此时卡功能入口页还是会隐藏，所有此处添加该情况的处理)
        _cardFunctions.hidden = NO;
        [self tableViewReload];
    }
    
}

// check邮箱等“店铺会员信息”，并保存到model
- (BOOL)checkAndSaveCustomInfo {
    
    // 保存 店铺会员信息
    if ([NSString isBlank:[_memberName getStrVal]]) {
        [LSAlertHelper showAlert:@"会员名不能为空！" block:nil];
        return NO;
    }
    
    // 检查卡号是否重复，已发正常状态、挂失的卡是否有同名的存在，有则显示提示信息
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF in %@" ,_memberPackVo.cardNames];
    if ([predicate evaluateWithObject:[_memberName getStrVal]]) {
        [LSAlertHelper showAlert:@"该卡号已存在，请重新输入！" block:nil];
         return NO;
    }
    
    LSMemberInfoVo *customer = _memberPackVo.customer;
    customer.name = [_memberName getStrVal];
    customer.sex = @(_memberSex.currentVal.integerValue);
    if ([NSString isNotBlank:[_memberBirthday getStrVal]]) {
        customer.birthdayStr = [_memberBirthday getStrVal];
        customer.birthday = @([[DateUtils getDate:[_memberBirthday getStrVal] format:@"yyyy年MM月dd日"] timeIntervalSince1970]*1000);
    }
    
    if ([NSString isNotBlank:[_memberIDNumber getStrVal]]) {
     
        if ([NSString validateIDCardNumber:[_memberIDNumber getStrVal]]) {
            customer.certificate = [_memberIDNumber getStrVal];
        }
        else {
            [LSAlertHelper showAlert:@"请输入正确的身份证号码！" block:nil];
             return NO;
        }
    }
    customer.weixin = [_wechatNumber getStrVal];
    
    if ([NSString isNotBlank:[_email getStrVal]]) {
        
        if ([NSString isValidateEmail:[_email getStrVal]]) {
            
            customer.email = [_email getStrVal];
        }
        else {
            [LSAlertHelper showAlert:@"请输入正确的邮箱！" block:nil];
             return NO;
        }
    }
    
    customer.address = [_contactAddress getStrVal];
    customer.zipcode = [_postNumber getStrVal];
    customer.job = [_jobType getStrVal];
    customer.company = [_company getStrVal];
    customer.pos = [_duty getStrVal];
    customer.carNo = [_carPlateNumber getStrVal];
    customer.memo = [_remark getStrVal];
    return YES;
}

#pragma mark - UITableView

- (void)setTableHeaderView {
    
    if (!_tabHeaderView) {
        _tabHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 1000.0)];
    }
    else {
        [_tabHeaderView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    
    CGFloat topY = 0.0;
///////  二维火会员信息部分
    {
        if (!_memberInfoTitle) {
            
            _memberInfoTitle = [[ItemTitle alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
            [_memberInfoTitle awakeFromNib];
            [_memberInfoTitle initDelegate:nil event:0 btnArrs:nil];
            _memberInfoTitle.lblName.text = @"会员信息";
            
            // 新增删除button
            UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            delBtn.frame = CGRectMake(_memberInfoTitle.ls_width-60, 12, 50, 24);
            delBtn.titleLabel.font = [UIFont systemFontOfSize:11];
            [delBtn setTitleColor:[ColorHelper getTipColor3] forState:0];
            [delBtn setTitle:@"删除" forState:UIControlStateNormal];
            [delBtn setImage:[UIImage imageNamed:@"ico_del"] forState:UIControlStateNormal];
            delBtn.imageEdgeInsets = UIEdgeInsetsMake(4, 5, 4, 30);
            delBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -32, 0, 0);
            [_memberInfoTitle addSubview:delBtn];
            [delBtn addTarget:self action:@selector(deleteMember:) forControlEvents:UIControlEventTouchUpInside];
        }
        [_tabHeaderView addSubview:_memberInfoTitle];
        _memberInfoTitle.ls_top = topY;
        topY += 48.0;
        
        if (!_memberInfoView) {
            _memberInfoView = [[LSMemberInfoView alloc] initWithFrame:CGRectMake(0, topY, SCREEN_W, 86) delegate:self];
            [_memberInfoView showPhoneNumChangeButton];
        }
        [_tabHeaderView addSubview:_memberInfoView];
        topY = topY + _memberInfoView.ls_height + 10;
    }
    
    {
        if (!_cardDetailTitle) {
            
            _cardDetailTitle = [[ItemTitle alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
            [_cardDetailTitle awakeFromNib];
            [_cardDetailTitle initDelegate:self event:kMBCardDetailEvent btnArrs:@[@"SORT"]];
            _cardDetailTitle.lblName.text = @"卡详情";
        }
        [_tabHeaderView addSubview:_cardDetailTitle];
        _cardDetailTitle.ls_top = topY;
        topY += 48.0;
        
        if (!_wrapper1) {
            _wrapper1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 750.0)];
            _wrapper1.hidden = YES;
        }
        _wrapper1.ls_top = topY;
        
        // 卡信息
        if (!_cardsSummary) {
            _cardsSummary = [LSMemberAccessView memberAccessView:MBAccessCardsInfoDetailPage delegate:self];
        }
        
        // 卡功能管理
        if (!_cardFunctions) {
            _cardFunctions = [LSMemberAccessView memberAccessView:MBAccessFunctions delegate:self];
        }

        // 卡状态
        if (!_cardStatus) {
            _cardStatus = [[ItemValue alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
            [_cardStatus awakeFromNib];
            [_cardStatus initLabel:@"卡状态" withValue:@""];
        }

        //优惠方式
        if (!_primedType) {
            _primedType = [[ItemValue alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
            [_primedType awakeFromNib];
            [_primedType initLabel:@"优惠方式" withValue:@""];
        }

        // 储值明细
        if (!_savingDetail) {
            _savingDetail = [[EditItemList alloc] initWithFrame:
                                 CGRectMake(0, 0, SCREEN_W, 48.0)];
            [_savingDetail initLabel:@"储值明细" withHit:@"" delegate:self];
            _savingDetail.lblVal.hidden = YES;
            _savingDetail.tag = 100;
            _savingDetail.imgMore.image = [UIImage imageNamed:@"ico_next"];
        }
        
        // 积分明细
        if (!_integralDetail) {
            _integralDetail = [[EditItemList alloc] initWithFrame:
                                   CGRectMake(0, 0, SCREEN_W, 48.0)];
            [_integralDetail initLabel:@"积分明细" withHit:@"" delegate:self];
            _integralDetail.tag = 101;
            _integralDetail.lblVal.hidden = YES;
            _integralDetail.imgMore.image = [UIImage imageNamed:@"ico_next"];
        }
        
        
        // 计次卡相关：商超单店才显示
        if ([[Platform Instance] getShopMode] == 1 && [[[Platform Instance] getkey:SHOP_MODE] integerValue] == 102) {
          
            // 计次卡
            if (!_byTimeCard) {
                _byTimeCard = [[EditItemList alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
                [_byTimeCard initLabel:@"计次服务" withHit:nil delegate:self];
                _byTimeCard.imgMore.image = [UIImage imageNamed:@"ico_next"];
            }
            
            // 计次卡充值记录
            if (!_byTimeRechargeRecord) {
                _byTimeRechargeRecord = [[EditItemList alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
                _byTimeRechargeRecord.lblVal.hidden = YES;
                [_byTimeRechargeRecord initLabel:@"计次充值记录" withHit:nil delegate:self];
                _byTimeRechargeRecord.imgMore.image = [UIImage imageNamed:@"ico_next"];
            }

        }
        
        //发卡日期
        if (!_sendTime) {
            _sendTime = [[ItemValue alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
            [_sendTime awakeFromNib];
            [_sendTime initLabel:@"发卡日期" withValue:@""];
        }
        
        //发卡方式
        if (!_sendType) {
            _sendType = [[ItemValue alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
            [_sendType awakeFromNib];
            [_sendType initLabel:@"发卡方式" withValue:@""];
        }
        
        // 发卡门店
        if (!_sendShop) {
            _sendShop = [[ItemValue alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
            [_sendShop awakeFromNib];
            [_sendShop initLabel:@"发卡门店" withValue:@""];
        }

        // 发卡人
        if (!_sendPeople) {
            _sendPeople = [[ItemValue alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];;
            [_sendPeople awakeFromNib];
            [_sendPeople initLabel:@"发卡人" withValue:@"-"];
        }

        if (_wrapper1.hidden == NO) {
            
            _cardsSummary.ls_top = 0.0;
            [_wrapper1 addSubview:_cardsSummary];
            
            if (!_cardFunctions.hidden) {
                _cardFunctions.ls_top = _cardsSummary.ls_bottom;
                [_wrapper1 addSubview:_cardFunctions];
            }

            if ([ObjectUtil isEmpty:_memberCards]) {
                // 未领卡时只显示 cardsSummary
                _wrapper1.ls_height = _cardsSummary.ls_bottom + 10.0;
            }
            else {
                _cardStatus.ls_top = (_cardFunctions.hidden ? _cardsSummary.ls_bottom:_cardFunctions.ls_bottom);
                [_wrapper1 addSubview:_cardStatus];
                
                _primedType.ls_top = _cardStatus.ls_bottom;
                [_wrapper1 addSubview:_primedType];
                
                _savingDetail.ls_top = _primedType.ls_bottom;
                [_wrapper1 addSubview:_savingDetail];
                
                _integralDetail.ls_top = _savingDetail.ls_bottom;
                [_wrapper1 addSubview:_integralDetail];
                
                 // 判断是否有计次卡
                if (_byTimeCard && _byTimeRechargeRecord) {
                    
                    _byTimeCard.ls_top = _integralDetail.ls_bottom;
                    [_wrapper1 addSubview:_byTimeCard];
                    
                    _byTimeRechargeRecord.ls_top = _byTimeCard.ls_bottom;
                    [_wrapper1 addSubview:_byTimeRechargeRecord];
                    
                    _sendTime.ls_top = _byTimeRechargeRecord.ls_bottom;
                    [_wrapper1 addSubview:_sendTime];
                
                } else {
                    
                    _sendTime.ls_top = _integralDetail.ls_bottom;
                    [_wrapper1 addSubview:_sendTime];
                }
                
                _sendType.ls_top = _sendTime.ls_bottom;
                [_wrapper1 addSubview:_sendType];
    
                //1 单店 2门店 3组织机构
                //判断领卡方式0 微店领卡 1实体领卡
                int type = (int)self.memberCardVo.sellerId.length;
                if ([[Platform Instance] getShopMode] != 1) {
                    if (/* DISABLES CODE */ (type)) {
                        _sendShop.ls_top = _sendType.ls_bottom;
                        [_wrapper1 addSubview:_sendShop];
                        
                        _sendPeople.ls_top = _sendShop.ls_bottom;
                        [_wrapper1 addSubview:_sendPeople];
                        
                        _wrapper1.ls_height = _sendPeople.ls_bottom + 10;
                    }else{
                        //在微店领取的会员卡
                        //如果发卡人信息获取不到则隐藏
                        //如果发卡门店取不到则隐藏
                        if (self.memberCardVo.shopEntityName.length > 0) {
                            _sendShop.ls_top = _sendType.ls_bottom;
                            [_wrapper1 addSubview:_sendShop];
                            
                            if (self.memberCardVo.operatorName.length == 0) {
                                _wrapper1.ls_height = _sendShop.ls_bottom + 10;
                            }else{
                                _sendPeople.ls_top = _sendShop.ls_bottom;
                                [_wrapper1 addSubview:_sendPeople];
                                
                                _wrapper1.ls_height = _sendPeople.ls_bottom + 10;
                            }
                        }else{
                            if (self.memberCardVo.operatorName.length == 0) {
                                _wrapper1.ls_height = _sendType.ls_bottom + 10;
                            }else{
                                _sendPeople.ls_top = _sendType.ls_bottom;
                                [_wrapper1 addSubview:_sendPeople];
                                
                                _wrapper1.ls_height = _sendPeople.ls_bottom + 10;
                            }
                        }
                    }
                    
                }else{
                    //在微店领取的会员卡，
                    if (/* DISABLES CODE */ (type)) {
                        _sendPeople.ls_top = _sendType.ls_bottom;
                        [_wrapper1 addSubview:_sendPeople];
                        
                        _wrapper1.ls_height = _sendPeople.ls_bottom + 10;
                    }else{
                        //如果发卡人信息获取不到则隐藏
                        if (self.memberCardVo.operatorName.length == 0) {
                            _wrapper1.ls_height = _sendType.ls_bottom + 10;
                        }else{
                            [_wrapper1 addSubview:_sendPeople];
                            
                            _wrapper1.ls_height = _sendPeople.ls_bottom + 10;
                        }
                    }
                }
                
            }
            [_tabHeaderView addSubview:_wrapper1];
        }
        else {
            _wrapper1.ls_height = 10;
        }
        
        _cardDetailTitle.imgSort.image = [UIImage imageNamed:_wrapper1.hidden ? ExpandIcon : CompactIcon];
    }
    
    topY += _wrapper1.ls_height;

//////// 会员店铺信息部分
    {
        if (!_shopMemberInfoTitle) {
            _shopMemberInfoTitle = [[ItemTitle alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
            [_shopMemberInfoTitle awakeFromNib];
            [_shopMemberInfoTitle initDelegate:self event:kMBShopInfoEvent btnArrs:@[@"SORT"]];
            _shopMemberInfoTitle.imgSort.image = [UIImage imageNamed:ExpandIcon];
            _shopMemberInfoTitle.lblName.text = @"会员补充信息";
        }
        [_tabHeaderView addSubview:_shopMemberInfoTitle];
        _shopMemberInfoTitle.ls_top = topY;
        topY += 48.0;
        
        
        if (!_wrapper2) {
            _wrapper2 = [[UIView alloc] initWithFrame:CGRectMake(0, topY, SCREEN_W, 624.0)];
            _wrapper2.hidden = YES;
        }
        _wrapper2.ls_top = topY;
 
        //会员名 ，必填项
        if (!_memberName) {
            _memberName = [[EditItemText alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
            [_memberName initLabel:@"会员名" withHit:nil isrequest:YES type:0];
            [_memberName editEnabled:_hasEditPower];
            _memberName.notificationType = Notification_UI_Change;
            [_memberName initMaxNum:kMemberNameMaxNum];
            [_memberName initData:@""];
        }
        
        //性别
        if (!_memberSex) {
            _memberSex = [[EditItemList alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
            [_memberSex initLabel:@"性别" withHit:@"" isrequest:NO delegate:self];
            [_memberSex editEnable:_hasEditPower];
            _memberSex.imgMore.hidden = !_hasEditPower;
            [_memberSex initData:@"男" withVal:@"1"];
        }
        
        //生日
        if (!_memberBirthday) {
            
            _memberBirthday = [[EditItemList alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
            [_memberBirthday initLabel:@"生日" withHit:@"" delegate:self];
            [_memberBirthday editEnable:_hasEditPower];
            _memberBirthday.imgMore.hidden = !_hasEditPower;
            [_memberBirthday initData:@"请选择" withVal:@"请选择"];
        }
        
        //身份证
        if (!_memberIDNumber) {
            _memberIDNumber = [[EditItemText alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
            [_memberIDNumber initMaxNum:kPeopleIdMaxNum];
            [_memberIDNumber initLabel:@"身份证" withHit:nil isrequest:NO type:0];
            [_memberIDNumber editEnabled:_hasEditPower];
            _memberIDNumber.notificationType = Notification_UI_Change;
            [_memberIDNumber initData:@""];
        }
        
        //微信
        
        if (!_wechatNumber) {
            _wechatNumber = [[EditItemText alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
            [_wechatNumber initLabel:@"微信" withHit:nil isrequest:NO type:0];
            [_wechatNumber editEnabled:_hasEditPower];
            _wechatNumber.notificationType = Notification_UI_Change;
            [_wechatNumber initData:@""];
        }
        
        // 邮箱
        if (!_email) {
            _email = [[EditItemText alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
            _email.txtVal.keyboardType = UIKeyboardTypeEmailAddress;
            [_email initLabel:@"邮箱" withHit:nil isrequest:NO type:0];
            [_email editEnabled:_hasEditPower];
            _email.notificationType = Notification_UI_Change;
            [_email initData:@""];
        }
        
        // 联系地址
        if (!_contactAddress) {
            _contactAddress = [[EditItemText alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
            [_contactAddress initLabel:@"联系地址" withHit:nil isrequest:NO type:0];
            [_contactAddress editEnabled:_hasEditPower];
            _contactAddress.notificationType = Notification_UI_Change;
            [_contactAddress initData:@""];
        }
        
        // 邮编
        if (!_postNumber) {
            _postNumber = [[EditItemText alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
            _postNumber.txtVal.keyboardType =  UIKeyboardTypeNumberPad;
            [_postNumber initMaxNum:kPostNumberMaxNun]; // 最大6位数字
            [_postNumber editEnabled:_hasEditPower];
            [_postNumber initLabel:@"邮编" withHit:nil isrequest:NO type:0];
            _postNumber.notificationType = Notification_UI_Change;
            [_postNumber initData:@""];

        }
        
        // 职业
        if (!_jobType) {
            _jobType = [[EditItemText alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
            [_jobType initLabel:@"职业" withHit:nil isrequest:NO type:0];
            [_jobType editEnabled:_hasEditPower];
            _jobType.notificationType = Notification_UI_Change;
            [_jobType initData:@""];
        }
        
        // 公司
        if (!_company) {
            _company = [[EditItemText alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
            [_company initLabel:@"公司" withHit:nil isrequest:NO type:0];
            [_company editEnabled:_hasEditPower];
            _company.notificationType = Notification_UI_Change;
            [_company initData:@""];
        }
        
        // 职务
        if (!_duty) {
            _duty = [[EditItemText alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
            [_duty initLabel:@"职务" withHit:nil isrequest:NO type:0];
            [_duty editEnabled:_hasEditPower];
            _duty.notificationType = Notification_UI_Change;
            [_duty initData:@""];
        }
        
        // 车牌号
        if (!_carPlateNumber) {
            _carPlateNumber = [[EditItemText alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
            [_carPlateNumber initMaxNum:kCarNumberMaxNum];
            [_carPlateNumber initLabel:@"车牌号" withHit:nil isrequest:NO type:0];
            [_carPlateNumber editEnabled:_hasEditPower];
            _carPlateNumber.notificationType = Notification_UI_Change;
            [_carPlateNumber initData:@""];
        }
        
        // 备注
        if (!_remark) {
            _remark = [[EditItemText alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
            [_remark initMaxNum:kCommentMaxNum];
            [_remark initLabel:@"备注" withHit:nil isrequest:NO type:0];
            [_remark editEnabled:_hasEditPower];
            _remark.notificationType = Notification_UI_Change;
            [_remark initData:@""];
        }
        
        
        if (_wrapper2.hidden == NO) {
            
            _memberName.ls_top = 0.0;
            [_wrapper2 addSubview:_memberName];
            
            _memberSex.ls_top = _memberName.ls_bottom;
            [_wrapper2 addSubview:_memberSex];
            
            _memberBirthday.ls_top = _memberSex.ls_bottom;
            [_wrapper2 addSubview:_memberBirthday];
            
            _memberIDNumber.ls_top = _memberBirthday.ls_bottom;
            [_wrapper2 addSubview:_memberIDNumber];
            
            _wechatNumber.ls_top = _memberIDNumber.ls_bottom;
            [_wrapper2 addSubview:_wechatNumber];
          
            _email.ls_top = _wechatNumber.ls_bottom;
            [_wrapper2 addSubview:_email];
       
            _contactAddress.ls_top = _email.ls_bottom;
            [_wrapper2 addSubview:_contactAddress];
           
            _postNumber.ls_top = _contactAddress.ls_bottom;
            [_wrapper2 addSubview:_postNumber];
            
            _jobType.ls_top = _postNumber.ls_bottom;
            [_wrapper2 addSubview:_jobType];
            
            _company.ls_top = _jobType.ls_bottom;
            [_wrapper2 addSubview:_company];
            
            _duty.ls_top = _company.ls_bottom;
            [_wrapper2 addSubview:_duty];
        
            _carPlateNumber.ls_top = _duty.ls_bottom;
            [_wrapper2 addSubview:_carPlateNumber];
            
            _remark.ls_top = _carPlateNumber.ls_bottom;
            [_wrapper2 addSubview:_remark];
          
            [_tabHeaderView addSubview:_wrapper2];
            _wrapper2.ls_height = _remark.ls_bottom + 10;
        }
        else {
            _wrapper2.ls_height = 10;
        }
        
        _shopMemberInfoTitle.imgSort.image = [UIImage imageNamed:_wrapper2.hidden ? ExpandIcon : CompactIcon];
    }
    
    topY += _wrapper2.ls_height;
///////// 消费记录部分
    {
        if (!_expenseInfoTitle) {
            _expenseInfoTitle = [[ItemTitle alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
            [_expenseInfoTitle awakeFromNib];
            [_expenseInfoTitle initDelegate:self event:kMBExpenseInfoEvent btnArrs:@[@"SORT"]];
            _expenseInfoTitle.lblName.text = @"消费记录";
        }

        _expenseInfoTitle.imgSort.image = [UIImage imageNamed:_showExpenseInfo ? CompactIcon : ExpandIcon];
        [_tabHeaderView addSubview:_expenseInfoTitle];
        _expenseInfoTitle.ls_top = topY;
        topY += 48.0;
    }
    _tabHeaderView.ls_height = topY;
    _tableView.tableHeaderView = _tabHeaderView;

}

- (void)initTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64.0, SCREEN_W, SCREEN_H-64.0)
                                                  style:UITableViewStylePlain];
    [_tableView registerClass:[LSMemberExpenseInfoCell class] forCellReuseIdentifier:expenseInfoCellId];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.rowHeight = 88.0f;
    _tableView.sectionHeaderHeight = 30.0;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self setTableHeaderView];
    [self.view addSubview:_tableView];
    [_tableView setContentOffset:CGPointZero];
    
    __weak typeof(self) weakSelf = self;
    [_tableView ls_addFooterWithCallback:^{
        [weakSelf getMemberExpendRecords];
    }];
}


- (void)tableViewReload {
    
    [self setTableHeaderView];
    [_tableView reloadData];
}


- (void)endRefresh {
    
    [_tableView headerEndRefreshing];
    [_tableView footerEndRefreshing];
}

// 点击删除会员按钮
- (void)deleteMember:(UIButton *)sender {
    __weak typeof(self) wself = self;
    [LSAlertHelper showSheet:@"确认要删除此会员吗? " cancle:@"取消" cancleBlock:nil selectItems:@[@"确认"] selectdblock:^(NSInteger index) {
        [wself deleteMember];
    }];
}

// 可以优化
- (SMHeaderItem *)getHeader:(NSString *)string {
    
    SMHeaderItem *item = [SMHeaderItem loadFromNib];
    item.lblVal.text = string ? :@"";
    item.panel.backgroundColor = [ColorHelper getTipColor9];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, item.ls_bottom-1, SCREEN_W, 1.0)];
    line.backgroundColor = [ColorHelper getTipColor9];
    [item addSubview:line];
    return item;
}

#pragma mark - UITableViewDataSource/UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (!_showExpenseInfo) {
        return 0; // 未展开消费信息
    }
    else {
        // 展开消费信息，分为有数据和无数据两种情况
        return _allKeys.count ? : 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_showExpenseInfo) {
        return [_orderRemarkDic[_allKeys[section]] count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LSMemberExpenseInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:expenseInfoCellId];
    [cell fillMemberExpandVo:_orderRemarkDic[_allKeys[indexPath.section]][indexPath.row]];
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if ([ObjectUtil isEmpty:_allKeys]) {
        return [self getHeader:@"此会员没有在本店消费"];
    }
    else {
         return [self  getHeader:_allKeys[section]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LSMemberExpandRecordVo *vo = _orderRemarkDic[_allKeys[indexPath.section]][indexPath.row];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:vo.orderId forKey:@"orderId"];
    // 会员服务化新加参数
    [param setValue:vo.shopEntityId forKey:@"shopEntityId"];
    [param setValue:[[Platform Instance] getkey:ENTITY_ID] forKey:@"entityId"];
    [param setValue:vo.orderKind forKey:@"orderKind"];
    LSMemberConsumeDetailController *vc = [[LSMemberConsumeDetailController alloc] init];
    vc.param = param;
    [self pushController:vc from:kCATransitionFromRight];
}


#pragma mark - 相关协议方法
/* IItemTitleEvent
 *  点击展开、收缩按钮
 */
- (void)onTitleSortClick:(NSInteger)event {

    if (event == kMBCardDetailEvent)
    {
        if (_wrapper1.hidden) {
            
            _wrapper1.hidden = NO;
            _wrapper2.hidden = YES;
            _showExpenseInfo = NO;
        }
        else {
            _wrapper1.hidden = YES;
        }
    }
    else if (event == kMBShopInfoEvent)
    {
        if (_wrapper2.hidden) {
            
            _wrapper2.hidden = NO;
            _wrapper1.hidden = YES;
            _showExpenseInfo = NO;
        }
        else {
            _wrapper2.hidden = YES;
        }
    }
    else if (event == kMBExpenseInfoEvent)
    {
        if (!_showExpenseInfo) {
            // 展开会员消费记录
            _showExpenseInfo = YES;
            _wrapper1.hidden = YES;
            _wrapper2.hidden = YES;
            // 显示上拉加载
            _tableView.footerHidden = NO;
            // 刷新
            _lastTime = nil;
            [self getMemberExpendRecords];
        }
        else {
            _showExpenseInfo = NO;
            // 隐藏上拉加载
            _tableView.footerHidden = YES;
        }
    }
    
    [self tableViewReload];
}

// IEditItemListEvent
- (void)onItemListClick:(EditItemList *)obj {
    
    if ([obj isEqual:_memberBirthday]) {
    
        NSDate *pastDate = [NSDate distantPast];
        NSDate *nowDate = [NSDate date];
        NSDate *birthDate = [DateUtils getDate:[obj getStrVal] format:@"yyyy年MM月dd日"];
        if ([ObjectUtil isNull:birthDate]) {
            birthDate = [NSDate date];
        }
        [DatePickerBox show:obj.lblName.text date:birthDate client:self startDate:pastDate endDate:nowDate event:MemberBirthday];
    
    } else if ([obj isEqual:_memberSex]) {
        
        NSArray *sexs = @[[[NameItemVO alloc] initWithVal:@"男" andId:@"1"],
                          [[NameItemVO alloc] initWithVal:@"女" andId:@"2"]];
        NSString *initString = obj.lblVal.text ? : @"男";
        if ([initString isEqualToString:@"女"]) {
            [OptionPickerBox initData:sexs itemId:@"2"];
        }
        else {
            [OptionPickerBox initData:sexs itemId:@"1"];
        }
        [OptionPickerBox show:obj.lblName.text client:self event:MemberSexType];
    
    } else if ([obj isEqual:_savingDetail] || [obj isEqual:_integralDetail]) {
        
        LSMemberSaveDetailViewController *vc = [[LSMemberSaveDetailViewController alloc] init:obj.tag-100 cards:_memberCards selectCard:_memberCardVo];
        [self pushController:vc from:kCATransitionFromRight];
    
    } else if ([obj isEqual:_byTimeRechargeRecord]) {
        
        [MobClick event:@"Member_DetailsPage_ByTimeRechargeRecords_In"];
        LSMemberByTimeRechargeNotesListController *vc = [[LSMemberByTimeRechargeNotesListController alloc] initWithMemberCardVo:_memberCardVo packVo:_memberPackVo];
        [self pushController:vc from:kCATransitionFromRight];
    
    } else if ([obj isEqual:_byTimeCard]) {
        
        [MobClick event:@"Member_DetailsPage_ByTimeService_In"];
        LSByTimeServiceListController *vc = [[LSByTimeServiceListController alloc] initWithListType:LSByTimeServiceNotExpired cardId:_memberCardVo.sId];
        [self pushController:vc from:kCATransitionFromRight];
    }
}


// OptionPickerClient
- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType {
    
    NameItemVO *vo = (NameItemVO *)selectObj;
    if (eventType == MemberSexType) {
        [_memberSex changeData:vo.itemName withVal:vo.itemId];
    }
    [self UIDataChanged:nil];
    return YES;
}

// DatePickerClient
- (BOOL)pickDate:(NSDate *)date event:(NSInteger)event {
    
    if (event == MemberBirthday) {
        NSString *dateString = [DateUtils formateShortChineseDate:date];
        [_memberBirthday changeData:dateString withVal:dateString];
    }
    [self UIDataChanged:nil];
    return YES;
}

// MBAccessViewDelegate
// 滑动，选择指定会员卡
- (void)memberAccessView:(LSMemberAccessView *)view selectdPage:(id)obj {
    
    // 切换会员卡时，前后两张卡的挂失/正常状态发生变化时，进行界面的隐藏与展示操作，挂失时则隐藏卡功能项，正常则显示卡功能项
    if (![_memberCardVo.status isEqualToNumber:[obj status]]) {
        _cardFunctions.hidden = [[obj status] isEqualToNumber:@(2)];
        [self tableViewReload];
    }
    _memberCardVo = (LSMemberCardVo *)obj;
    [self fillData];
}

// 点击指定的功能点
- (void)memberAccessView:(LSMemberAccessView *)view tapFunction:(id)obj {
    
    LSMemberSubmenus *vo = (LSMemberSubmenus *)obj;
    if (vo.subModuleType == MBSubModule_Recharge) {
        NSString *mobile = [_memberPackVo getMemberPhoneNum];
        LSMemberRechargeViewController *vc = [[LSMemberRechargeViewController alloc] init:_memberPackVo phone:mobile selectCard:_memberCardVo.sId];
        [self pushController:vc from:kCATransitionFromRight];
    }
    else if (vo.subModuleType == MBSubModule_Integral) {
        LSMemberIntegralExchangeViewController *vc = [[LSMemberIntegralExchangeViewController alloc] init:_memberPackVo cardId:_memberCardVo.sId];
        [self pushController:vc from:kCATransitionFromRight];
    }
    else if (vo.subModuleType == MBSubModule_BestowIntegral) {
        LSMemberBestowIntegralViewController *vc = [[LSMemberBestowIntegralViewController alloc] init:_memberPackVo cardId:_memberCardVo.sId];
        [self pushController:vc from:kCATransitionFromRight];
    }
    else if (vo.subModuleType == MBSubModule_ChangeCard) {
        NSString *mobile = [_memberPackVo getMemberPhoneNum];
        LSMemberChangeCardViewController *vc = [[LSMemberChangeCardViewController alloc] init:mobile member:_memberPackVo selectCard:_memberCardVo.sId];
         [self pushController:vc from:kCATransitionFromRight];
    }
    else if (vo.subModuleType == MBSubModule_ReturnCard) {
        LSMemberRescindCardViewController *vc = [[LSMemberRescindCardViewController alloc] init:_memberPackVo cardId:_memberCardVo.sId];
        [self pushController:vc from:kCATransitionFromRight];
    }
    else if (vo.subModuleType == MBSubModule_ChangePwd) {
        LSMemberChangePwdViewController *vc = [[LSMemberChangePwdViewController alloc] init:_memberPackVo cardId:_memberCardVo.sId];
        [self pushController:vc from:kCATransitionFromRight];
    }
    else if (vo.subModuleType == MBSubModule_RechargeRedRush) {
        LSMemberSaveDetailViewController *vc = [[LSMemberSaveDetailViewController alloc] init:MBDetailSavingType cards:_memberCards selectCard:_memberCardVo];
        [self pushController:vc from:kCATransitionFromRight];
    }
    else if (vo.subModuleType == MBSubModule_BestowRedRush) {
        LSMemberSaveDetailViewController *vc = [[LSMemberSaveDetailViewController alloc] init:MBDetailIntegralType cards:_memberCards selectCard:_memberCardVo];
        [self pushController:vc from:kCATransitionFromRight];
    }
}

// 点击了重新发卡button
- (void)memberAccessView:(LSMemberAccessView *)view reSendCard:(LSMemberCardVo *)cardVo {
   
    if ([view isEqual:_cardsSummary]) {
        if (cardVo) {
            // 有卡重发此卡
            [self reSendCard:cardVo];
        }
        else {
            
            if ([[Platform Instance] lockAct:ACTION_CARD_ADD]) {
                [LSAlertHelper showAlert:@"您没有[发会员卡]的权限" block:nil];
                return ;
            }
            // 无卡提示发卡
            LSMemberElectronicCardSendViewController *vc = [[LSMemberElectronicCardSendViewController alloc] init:_phoneNum member:nil fromPage:YES];
            [self pushController:vc from:kCATransitionFromRight];
        }
    }
}

// LSMemberInfoViewDelegate
- (void)memberInfoViewHeightChaged {
    [self setTableHeaderView];
}

- (void)memberInfoViewShowPhoneNumChangeNotice {
    [LSAlertHelper showAlert:@"提示" message:MemberDetailPagePhoneNumberChangeNotice cancle:@"我知道了" block:nil];
}

#pragma mark - 网络请求

// 查询会员卡类型数，
- (void)querySmsNumAndKindCardAndQueryCard {

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *entityId = [[Platform Instance] getkey:ENTITY_ID];
    [param setValue:entityId forKey:@"entityId"];
    [param setValue:_phoneNum forKey:@"mobile"];
    [param setValue:@(NO) forKey:@"isNeedAll"];
    
    [BaseService getRemoteLSDataWithUrl:@"customer/querySmsNumAndKindCardAndQueryCard" param:[param mutableCopy] withMessage:nil show:YES CompletionHandler:^(id json) {
        //        LSMemberInfoVo *memberInfoVo = [LSMemberInfoVo getMemberVo:json[@"data"][@"cardQueryVo"][@"customer"]];
        //        LSMemberRegisterVo *registerVo = [LSMemberRegisterVo getMemberRegisterVo:json[@"data"][@"cardQueryVo"][@"customerRegisterVo"]];
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json block:nil];
    }];
}

// 查询会员基本信息
- (void)queryMemberInfo {
    
    NSString *entityId = [[Platform Instance] getkey:ENTITY_ID];
    NSDictionary *param = @{@"entityId":entityId ,@"keyword":_phoneNum ,@"isOnlySearchMobile":@(YES)};
    
    [BaseService getRemoteLSOutDataWithUrl:@"card/queryCustomerInfo" param:[param mutableCopy] withMessage:@"" show:YES CompletionHandler:^(id json) {
        NSArray *array = [LSMemberPackVo getMemberPackVoList:json[@"data"][@"customerList"]];
        if ([ObjectUtil isNotEmpty:array]) {
            _memberPackVo = array.firstObject;
            if ([ObjectUtil isNotEmpty:array]) {
                [self loadMemberCards];
                [self getMemberExpendRecords];
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
    
    [BaseService getRemoteLSDataWithUrl:@"customer/queryCustomerCard" param:param withMessage:@"" show:YES CompletionHandler:^(id json) {
        
        if ([ObjectUtil isNotEmpty:json[@"data"]]) {
            NSMutableArray *types = [[NSMutableArray alloc] init];
            NSMutableArray *cards = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in json[@"data"]) {
                
                LSMemberTypeVo *type = [LSMemberTypeVo getMemberTypeVo:dic[@"kindCard"]];
                LSMemberCardVo *card = [LSMemberCardVo getMemberCardVo:dic[@"card"]];
                // 计次服务次数
                if ([ObjectUtil isNotNull:[dic valueForKey:@"accountcardnum"]]) {
                     card.byTimeServiceTimes = [dic valueForKey:@"accountcardnum"];
                } else {
                    card.byTimeServiceTimes = @0;
                }
               
                card.cardTypeVo = type;
                card.kindCardName = type.name;
                card.filePath = type.filePath;
                card.mode = @(type.mode);
                [types addObject:type];
                [cards addObject:card];
            }
            _memberCardTyps = [types copy];
            _memberCards = [cards copy];
            
            if (_memberCardVo) {
                [_memberCards enumerateObjectsUsingBlock:^(LSMemberCardVo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.sId isEqualToString:_memberCardVo.sId]) {
                        _memberCardVo = obj;
                        *stop = YES;
                    }
                }];
            }
            else {
                _memberCardVo = _memberCards.firstObject;
            }
        }
        else {
            _memberCardVo = nil;
            _memberCards = nil;
            _memberCardTyps = nil;
        }
        [self fillData];
        

    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json block:nil];
    }];
}

// 更新会员基本信息
- (void)updateCustomerInfo {
    
    if ([self checkAndSaveCustomInfo]) {
        NSString *entityId = [[Platform Instance] getkey:ENTITY_ID];
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:entityId forKey:@"entityId"];
        [param setValue:[_memberPackVo.customer memberInfoJsonString] forKey:@"customerJson"];
        
        [BaseService getRemoteLSOutDataWithUrl:@"customer/updateCustomer" param:param withMessage:@"" show:YES CompletionHandler:^(id json) {
            if ([json[@"code"] boolValue]) {
                [self popToLatestViewController:kCATransitionFromLeft];
            }
        } errorHandler:^(id json) {
            [LSAlertHelper showAlert:json block:nil];
        }];
    }
}

// 查询会员消费记录
- (void)getMemberExpendRecords {
  
    if (!_memberPackVo) {
        return;
    }
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:_lastTime forKey:@"lastTime"];
    [param setValue:_memberPackVo.customer.sId forKey:@"customerId"];
    [param setValue:[[Platform Instance] getkey:ENTITY_ID] forKey:@"entityId"];
    [param setValue:[[Platform Instance] getkey:RELEVANCE_ENTITY_ID] forKey:@"shopEntityId"];
    [BaseService getRemoteLSDataWithUrl:@"customerDeal/dealList" param:param withMessage:@"" show:NO CompletionHandler:^(id json) {
        // 对数据按年月进行分组
        if ([ObjectUtil isNotEmpty:json[@"dealRecordList"]]) {
            if (!_orderRemarkDic) {
                _orderRemarkDic = [[NSMutableDictionary alloc] init];
            }
            NSArray *array = [LSMemberExpandRecordVo getMemberExpandRecordList:json[@"dealRecordList"]];
            if ([ObjectUtil isNull:_lastTime]) {
                [_orderRemarkDic removeAllObjects];
            }
            [array enumerateObjectsUsingBlock:^(LSMemberExpandRecordVo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSMutableArray *tempArray = [_orderRemarkDic objectForKey:obj.timeString];
                if (!tempArray) {
                    tempArray = [[NSMutableArray alloc] init];
                    [_orderRemarkDic setObject:tempArray forKey:obj.timeString];
                }
                [tempArray addObject:obj];
            }];
        }
        
        // 降序排列
        _allKeys = [[_orderRemarkDic.allKeys sortedArrayUsingSelector:@selector(compare:)] reverseObjectEnumerator].allObjects;
        _lastTime = json[@"lastTime"];
        [self tableViewReload];
        [self endRefresh];

    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json block:nil];
        [self endRefresh];
    }];
}

// 重新发卡
- (void)reSendCard:(LSMemberCardVo *)card {
  
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:[[Platform Instance] getkey:ENTITY_ID] forKey:@"entityId"];
    [param setValue:card.sId forKey:@"cardId"];
    [param setValue:[_memberPackVo getMemberPhoneNum] forKey:@"mobile"];
    
    [BaseService getRemoteLSDataWithUrl:@"customer/restoreCard" param:param withMessage:@"" show:YES CompletionHandler:^(id json) {
        [LSAlertHelper showStatus:@"发卡成功" afterDeny:2 block:^{
            [self popToViewControllerNamed:@"LSMemberModule" popDirection:kCATransitionFromLeft];
        }];
        
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json block:nil];
    }];
}

// 删除当前会员
- (void)deleteMember {
    
    if ([NSString isBlank:_memberPackVo.customer.sId]) {return;}
    __weak typeof(self) wself = self;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:wself.memberPackVo.customer.sId forKey:@"customKey"];
    [BaseService crossDomanRequestWithUrl:@"customer/del_customer" param:param withMessage:nil show:NO CompletionHandler:^(id json) {
        [wself popToLatestViewController:kCATransitionFromLeft];
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json];
    }];
}

@end
