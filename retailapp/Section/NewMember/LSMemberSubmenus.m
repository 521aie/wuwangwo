//
//  LSMemberSubmenus.m
//  retailapp
//
//  Created by taihangju on 16/9/7.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberSubmenus.h"
#import "LSMemberConst.h"
#import "MobClick.h"

@implementation LSMemberSubmenus

// 会员主页面 主模块入口
+ (NSArray *)memberSubmenus {
    
    NSArray *array = nil;
    NSMutableArray *menusArr = [[NSMutableArray alloc] init];
   
    {
        array = @[[LSMemberSubmenus submenu:@"短信营销" icon:@"ico_duanxinyingxiao" className:@"LSSmsMarketingViewController"
                                       type:MBSubModule_MessageMarket action:ACTION_SMS_SEND],
                  [LSMemberSubmenus submenu:@"生日提醒" icon:@"ico_shengritixing" className:@"LSBrithdayReminderViewController"
                                       type:MBSubModule_BirthNotice action:ACTION_BIRTHDAY_REMIND],
                  ];
        [menusArr addObject:array];
    }
    {
        //连锁机构用户登录，会员模块主页直接根据“积分兑换设置”开关来判断是否加锁
        if ([[Platform Instance] getShopMode] == 3) {
            array = @[[LSMemberSubmenus submenu:@"会员卡类型" icon:@"ico_huiyuankaleixing" className:@"LSMemberCardTypeListViewController"
                                           type:MBSubModule_CardType action:ACTION_CARD_CATEGORY],
                      [LSMemberSubmenus submenu:@"充值优惠设置" icon:@"ico_chongzhiyouhui" className:@"LSMemberRechargeRuleListViewController"
                                           type:MBSubModule_RechargeSet action:ACTION_CARD_CHARGE_PROMOTION],
                      [LSMemberSubmenus submenu:@"积分兑换设置" icon:@"ico_jifenduihuanshezhi" className:@"LSMemberIntegralSetViewController"
                                           type:MBSubModule_IntegralSet action:ACTION_POINT_EXCHANGE_SET]
                      ];
        } else {
            
            // 单店模式和连锁门店用户，积分兑换设置模块加锁通过“积分兑换设置”和“积分商品数量设置”两个小功能判断(新定义的大权限：PAD_MEMBER_POINT_SET)，都关闭则加锁，否则可以进入
            // 计次卡目前只是商超单店有
            if ([[Platform Instance] getShopMode] == 1 && [[[Platform Instance] getkey:SHOP_MODE] integerValue] == 102) {
                array = @[[LSMemberSubmenus submenu:@"会员卡类型" icon:@"ico_huiyuankaleixing" className:@"LSMemberCardTypeListViewController"
                                               type:MBSubModule_CardType action:ACTION_CARD_CATEGORY],
                          [LSMemberSubmenus submenu:@"充值优惠设置" icon:@"ico_chongzhiyouhui" className:@"LSMemberRechargeRuleListViewController"
                                               type:MBSubModule_RechargeSet action:ACTION_CARD_CHARGE_PROMOTION],
                          [LSMemberSubmenus submenu:@"积分兑换设置" icon:@"ico_jifenduihuanshezhi" className:@"LSMemberIntegralSetViewController"
                                               type:MBSubModule_IntegralSet action:PAD_MEMBER_POINT_SET],
                          [LSMemberSubmenus submenu:@"计次服务设置" icon:@"ico_jicikafuwu"
                                          className:@"LSMemberMeterViewController"
                                               type:MBSubModule_IntegralSet action:ACTION_ACCOUNTCARD_SET]];
            } else {
             
                array = @[[LSMemberSubmenus submenu:@"会员卡类型" icon:@"ico_huiyuankaleixing" className:@"LSMemberCardTypeListViewController"
                                               type:MBSubModule_CardType action:ACTION_CARD_CATEGORY],
                          [LSMemberSubmenus submenu:@"充值优惠设置" icon:@"ico_chongzhiyouhui" className:@"LSMemberRechargeRuleListViewController"
                                               type:MBSubModule_RechargeSet action:ACTION_CARD_CHARGE_PROMOTION],
                          [LSMemberSubmenus submenu:@"积分兑换设置" icon:@"ico_jifenduihuanshezhi" className:@"LSMemberIntegralSetViewController"
                                               type:MBSubModule_IntegralSet action:PAD_MEMBER_POINT_SET]];
            }
           
        }
        [menusArr addObject:array];
    }
    {
        array = @[[LSMemberSubmenus submenu:@"发会员卡" icon:@"ico_fahuiyuanka" className:@"LSMemberCheckViewController"
                                       type:MBSubModule_SendCard action:ACTION_CARD_ADD],
                  [LSMemberSubmenus submenu:@"会员换卡" icon:@"ico_huiyuanhuanka" className:@"LSMemberCheckViewController"
                                       type:MBSubModule_ChangeCard action:ACTION_CARD_CHANGE],
                  [LSMemberSubmenus submenu:@"储值充值" icon:@"ico_huiyuanchongzhi" className:@"LSMemberCheckViewController"
                                       type:MBSubModule_Recharge action:ACTION_CARD_CHARGE],
                  [LSMemberSubmenus submenu:@"积分兑换" icon:@"ico_jifenduihuan" className:@"LSMemberCheckViewController"
                                       type:MBSubModule_Integral action:ACTION_POINT_EXCHANGE],
                  [LSMemberSubmenus submenu:@"会员赠分" icon:@"ico_huiyuanzengfen" className:@"LSMemberCheckViewController"
                                       type:MBSubModule_BestowIntegral action:ACTION_CARD_GIVE_DEGREE],
                  [LSMemberSubmenus submenu:@"会员退卡" icon:@"ico_huiyuantuika" className:@"LSMemberCheckViewController"
                                       type:MBSubModule_ReturnCard action:ACTION_CARD_CLOSE],
                  [LSMemberSubmenus submenu:@"改卡密码" icon:@"ico_gaikamima" className:@"LSMemberCheckViewController"
                                       type:MBSubModule_ChangePwd action:ACTION_CARD_CHANGE_PASSWORD],
                  [LSMemberSubmenus submenu:@"挂失与解挂" icon:@"ico_guashiyujiegua" className:@"LSMemberCheckViewController"
                                       type:MBSubModule_CardReport action:ACTION_CARD_REPORT_LOSS],
//                  [LSMemberSubmenus submenu:@"消费记录" icon:@"ico_xiaofeijilu" className:@"LSMemberExpendRecordViewController"
//                                       type:MBSubModule_ConsumeRecord]
                  ];
        [menusArr addObject:array];
    }
    return [menusArr copy];
}

// 会员详情页，8个功能入口项
+ (NSArray *)memberCardFunctions {
   
   NSArray *array = @[[LSMemberSubmenus submenu:@"储值充值" icon:@"ico_huiyuanchongzhi"
                          className:@"LSMemberRechargeViewController"
                                           type:MBSubModule_Recharge action:ACTION_CARD_CHARGE],
                      [LSMemberSubmenus submenu:@"积分兑换" icon:@"ico_jifenduihuan" className:@"LSMemberIntegralExchangeViewController"
                                           type:MBSubModule_Integral action:ACTION_POINT_EXCHANGE],
                      [LSMemberSubmenus submenu:@"会员赠分" icon:@"ico_huiyuanzengfen" className:@"LSMemberBestowIntegralViewController"
                                           type:MBSubModule_BestowIntegral action:ACTION_CARD_GIVE_DEGREE],
                      [LSMemberSubmenus submenu:@"会员换卡" icon:@"ico_huiyuanhuanka" className:@"LSMemberChangeCardViewController"
                                           type:MBSubModule_ChangeCard action:ACTION_CARD_CHANGE],
                      [LSMemberSubmenus submenu:@"会员退卡" icon:@"ico_huiyuantuika" className:@"LSMemberRescindCardViewController"
                                           type:MBSubModule_ReturnCard action:ACTION_CARD_CLOSE],
                      [LSMemberSubmenus submenu:@"改卡密码" icon:@"ico_gaikamima" className:@"LSMemberChangeCardViewController"
                                           type:MBSubModule_ChangePwd action:ACTION_CARD_CHANGE_PASSWORD],
                      [LSMemberSubmenus submenu:@"储值红冲" icon:@"ico_chongzhihongchong" className:@"LSMemberSaveDetailViewController"
                                           type:MBSubModule_RechargeRedRush action:ACTION_CARD_UNDO_CHARGE],
                      [LSMemberSubmenus submenu:@"赠分红冲" icon:@"ico_zengfenhongchong" className:@"LSMemberSaveDetailViewController"
                                           type:MBSubModule_BestowRedRush action:ACTION_CARD_UNDO_GIVE_DEGREE]
                      ];
    return array;
}

+ (LSMemberSubmenus *)submenu:(NSString *)title icon:(NSString *)icon className:(NSString *)class type:(MemberSubModuleType)type action:(NSString *)actionCode {    
    LSMemberSubmenus *menu = [[LSMemberSubmenus alloc] init];
    menu.icon = icon;
    menu.name = title;
    menu.relatedClass = class;
    menu.subModuleType = type;
    menu.actionCode = actionCode;
    return menu;
}


// 会员模块主功能页面统计点击进入子模块的次数
- (void)statisticsUMengEvent {
    
    if ([_relatedClass isEqualToString:@"LSMemberMeterViewController"]) {
        [MobClick event:@"Member_ByTimeServiceSet_In"];
    }
}

@end
