//
//  LSMemberConst.h
//  retailapp
//
//  Created by taihangju on 16/9/30.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#ifndef LSMemberConst_h
#define LSMemberConst_h

typedef NS_ENUM(NSInteger, MemberSubModuleType) {
    
    MBSubModule_HomePage,         // 会员模块主页面
    MBSubModule_MessageMarket,    // 短信营销
    MBSubModule_BirthNotice,      // 生日提醒
    MBSubModule_CardType,         // 会员卡类型
    MBSubModule_RechargeSet,      // 优惠充值设置
    MBSubModule_IntegralSet,      // 积分兑换设置
    MBSubModule_SendCard,         // 发会员卡
    MBSubModule_ChangeCard,       // 会员换卡
    MBSubModule_Recharge,         // 会员充值
    MBSubModule_Integral,         // 积分兑换
    MBSubModule_BestowIntegral,   // 会员赠分
    MBSubModule_ReturnCard,       // 会员退卡
    MBSubModule_ChangePwd,        // 改卡密码
    MBSubModule_CardReport,       // 挂失与解挂
    MBSubModule_ConsumeRecord,    // 消费记录
    MBSubModule_RechargeRedRush,  // 充值红冲(储值明细)
    MBSubModule_BestowRedRush ,   // 赠分红冲(积分明细)
    MBSubModule_SummaryInfo,      // 会员信息汇总
};

// 字符数限制，不做限制默认输入长度是50
#define kCardNumberMinNum       4   // 会员卡号最小允许输入
#define kCardNumberMaxNum       32  // 会员卡号最大允许输入字数
#define kPeopleIdMaxNum         18  // 身份证号15或18位，最大输入位数18位
#define kCardPasswordMaxNum     6   // 会员卡密码长度
#define kMemberNameMaxNum       20  // 会员卡名称长度
#define kCarNumberMaxNum        10  // 车牌号长度
#define kPostNumberMaxNun       6   // 邮编长度
#define kContactAddressMaxNum   100 // 联系地址长度
#define kCommentMaxNum          100 // 备注长度
#define kIsWeChat               2   // 微店
#define kIsEntity               1   // 实体

#define kDefaultCardBackgroundImageName   @"testBack.png"

// 会员模块通知key
#define kReSendDeletedCardNotificationKey  @"kReSendDeletedCardNotification" // 重新发已经删除的卡，用于会员详情页面


// 页面相关文案
#define MemberCardTypeUseSceneDescribe @"提示:用户须知内请描述卡使用规则，如：本卡不能与特价商品或指定商品的优惠活动同时使用。" // 会员卡类型使用场景
#define PasswordSetText @"若设置了卡密码，当收银员为顾客线下结账时需要输入卡密码。"
#define noticeString  @"手机号码作为会员唯一凭证, 发电子会员卡需要先填写会员的手机号码。"
//#define ReturnCardNoticeString @"注：退卡记录可在“报表-会员充值记录”中查看"
#define PrimeRechargeSetNoticeString @"提示: \n1. 店家充值：店家可输入任意充值金额，赠送金额自动累加。例如设置每充值100元送5元，每充值300送20元；则充值200元送10元，充值400送25元；\n2. 微店自助充值：顾客只能选择此处设置的充值金额并享受相应的充值优惠，不能随意输入；"
#define MemberDetailPagePhoneNumberChangeNotice @"请引导顾客扫本店二维码进入微店，在【我的-个人信息】中修改绑定手机号！"
#define SaveDetailNoticeString @"确定要对这条记录需要红冲吗?" // 红冲提示信息
#define ExchangeableNumSetNoticeString @"提示：当数量未输入时，默认在积分兑换时不判断可兑换数量，可无限量兑换。"
#endif /* LSMemberConst_h */
