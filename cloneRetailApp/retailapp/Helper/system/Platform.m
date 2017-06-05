

//
//  Platform.m
//  retailapp
//
//  Created by hm on 15/6/25.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Platform.h"
#import "MemberSearchCondition.h"
#import "SignUtil.h"
#import "DateUtils.h"

@implementation Platform

static NSDictionary *actDic;
static NSMutableDictionary *countDic;
static NSMutableArray *kindCardList;
static MemberSearchCondition *memberSearchCondition;
static NSMutableArray *microStyleList;

static int sheight;
//1 单店 2门店 3组织机构
static short shopMode;
//微店状态 0未开通 1申请中 2已开通 3暂停中 4关闭 5拒绝；默认开通微店后仅2和4在用
static short microShopStatus;
//扫码付款和园区入驻是否显示 0不显示 1显示
static short scanPayStatus;
/**图片地址*/
static NSString* fileName;
static NSArray* addressList;
static NSMutableArray* shopTypeList;

//是否有仓库
static bool hasWarehouse;
//是不是总部用户
static bool isTopOrg;

+ (Platform *)Instance
{
    static Platform *instance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark- 总部图片地址
- (void)setFileName:(NSString*)_fileName
{
    fileName = _fileName;
}
- (NSString*)getFileName
{
    return fileName;
}

#pragma mark- 所在地区
- (void)setAddressList:(NSArray*)arr
{
    addressList = arr;
}
- (NSArray*)getAddressList
{
    return addressList;
}

#pragma mark- 机构类型
- (void)setShopTypeList:(NSMutableArray *)arr
{
    shopTypeList = arr;
}
- (NSMutableArray*)getShopTypeList
{
    return shopTypeList;
}

#pragma mark- shopMode
- (void)setShopMode:(short)mode
{
    shopMode = mode;
}
- (short)getShopMode
{
    return shopMode;
}


#pragma mark- 机构是否有仓库
- (void)setHasWarehouse:(BOOL)status
{
    hasWarehouse = status;
}
- (short)getHasWarehouse
{
    return hasWarehouse;
}

#pragma mark- 微店状态
- (void)setMicroShopStatus:(short)status
{
    microShopStatus = status;
}
- (short)getMicroShopStatus
{
    return microShopStatus;
}

#pragma mark- 扫码付款和园区入驻是否显示
- (void)setScanPayStatus:(short)status
{
    scanPayStatus = status;
}

- (short)getScanPayStatus
{
    return scanPayStatus;
}

#pragma mark- actionMap
- (NSDictionary *)getActDic
{
    return actDic;
}

-(void)setActDic:(NSDictionary *)dic
{
    actDic = dic;
}

#pragma mark- kindCardList
- (void)setKindCardList:(NSMutableArray *)list
{
    kindCardList = list;
}

-(NSMutableArray*) getKindCardList
{
    return kindCardList;
}

#pragma mark- kindCardList
- (NSMutableArray *)getMicroStyleList {
    return microStyleList;
}

- (void)setMicroStyleList:(NSMutableArray *)list {
    microStyleList = list;
}

#pragma mark- memberSearchCondition
- (void)setMemberSearchCondition:(MemberSearchCondition *)condition
{
    memberSearchCondition = condition;
}

- (MemberSearchCondition *)getMemberSearchCondition
{
    return memberSearchCondition;
}

#pragma mark-  countMap
- (void)countDic:(NSMutableDictionary *)map
{
    countDic = map;
}

- (NSMutableDictionary *)getCountDic
{
    return countDic;
}

- (NSString *)countObject:(NSString *)code
{
    NSString *str=[countDic objectForKey:code];
    return str == nil?@"0":str;
}

//权限控制入口
- (BOOL)lockAct:(NSString *)actCode
{
    //主页物流模块是否加锁
    if ([actCode isEqualToString:MODULE_MATERIAL_FLOW]) {
        //由于装箱单显示需要调用接口查询用装箱单标识 故物流模块暂时不控制
        return NO;
    }
    //库存模块权限
    if ([actCode isEqualToString:MODULE_STOCK]) {
        BOOL isLock = [ObjectUtil isNull:[actDic objectForKey:ACTION_STOCK_SEARCH]] &&
        [ObjectUtil isNull:[actDic objectForKey:ACTION_STOCK_ADJUST]] &&
        [ObjectUtil isNull:[actDic objectForKey:ACTION_STOCK_CHECK_SEARCH]];
        // 服鞋
        if ([[Platform Instance] getkey:SHOP_MODE].integerValue == 101) {
            isLock = isLock && [ObjectUtil isNull:[actDic objectForKey:ACTION_STOCK_SUMMARIZE_SEARCH]];
        }
        
        // 商超才有提醒设置
        if ([[[Platform Instance] getkey:SHOP_MODE] integerValue] == 102) {
            isLock = isLock && [ObjectUtil isNull:[actDic objectForKey:ACTION_REMIND_SETTING]];
        }
        // 组织机构才有"仓库管理"
        if ([[Platform Instance] getShopMode] == 3) {
            isLock = isLock && [ObjectUtil isNull:[actDic objectForKey:ACTION_WARE_HOUSE_MANAGE]];
        }
        //通过小权限判断大权限
        return isLock;
    }
    
    //商品管理
    if ([actCode isEqualToString:PAD_GOODS] || [actCode isEqualToString:GOODS_INFO_MANAGE] || [actCode isEqualToString:GOODS_STYLE_MANAGE]) {
        return NO;
    }
    
    //员工管理
    if ([actCode isEqualToString:PAD_EMPLOYEE]) {
        //通过小权限判断大权限
        return (([ObjectUtil isNull:[actDic objectForKey:ACTION_EMPLOYEE_ACTION]])&&
                ([ObjectUtil isNull:[actDic objectForKey:ACTION_EMPLOYEE_MANAGE]])&&
                ([ObjectUtil isNull:[actDic objectForKey:ACTION_STOCK_CHECK]])&&
                ([ObjectUtil isNull:[actDic objectForKey:ACTION_STOCK_CHECK_SEARCH]]));
    }
    
    //营销管理
    if ([actCode isEqualToString:PAD_MARKET]) {
        //通过小权限判断大权限
        return (([ObjectUtil isNull:[actDic objectForKey:ACTION_SPECIAL_PRICE]])&&
                ([ObjectUtil isNull:[actDic objectForKey:ACTION_MATCH_SWAP]])&&
                ([ObjectUtil isNull:[actDic objectForKey:ACTION_MATCH_DECREASE]])&&
                ([ObjectUtil isNull:[actDic objectForKey:ACTION_SALES_BINDING]])&&
                ([ObjectUtil isNull:[actDic objectForKey:ACTION_SALES_N_DISCOUNT]])&&
                ([ObjectUtil isNull:[actDic objectForKey:ACTION_SALES_COUPON]])&&
                ([ObjectUtil isNull:[actDic objectForKey:ACTION_SALES_BIRTHDAY]]));
    }
    
    // 会员权限
    if ([actCode isEqualToString:PAD_MEMBER]) {
        //通过小权限判断大权限 ,如果所有的小权限都没有，则首页会员不可进入
        return (
                ([ObjectUtil isNull:[actDic objectForKey:ACTION_CARD_ADD]])&&
                ([ObjectUtil isNull:[actDic objectForKey:ACTION_CARD_EDIT]])&&
                ([ObjectUtil isNull:[actDic objectForKey:ACTION_CARD_SEARCH]])&&
                ([ObjectUtil isNull:[actDic objectForKey:ACTION_CARD_CHARGE_PROMOTION]])&&
                ([ObjectUtil isNull:[actDic objectForKey:ACTION_CARD_CHARGE]])&&
                ([ObjectUtil isNull:[actDic objectForKey:ACTION_POINT_EXCHANGE]])&&
                ([ObjectUtil isNull:[actDic objectForKey:ACTION_CARD_REPORT_LOSS]])&&
                ([ObjectUtil isNull:[actDic objectForKey:ACTION_CARD_CATEGORY]]) &&
                ([ObjectUtil isNull:[actDic objectForKey:ACTION_SMS_SEND]]) &&
                ([ObjectUtil isNull:[actDic objectForKey:ACTION_BIRTHDAY_REMIND]]) &&
                ([ObjectUtil isNull:[actDic objectForKey:ACTION_CARD_UNDO_CHARGE]]) &&
                ([ObjectUtil isNull:[actDic objectForKey:ACTION_CARD_CLOSE]]) &&
                ([ObjectUtil isNull:[actDic objectForKey:ACTION_CARD_INFO_COLLECT]]) &&
                ([ObjectUtil isNull:[actDic objectForKey:ACTION_CARD_CHANGE]]) &&
                ([ObjectUtil isNull:[actDic objectForKey:ACTION_CARD_GIVE_DEGREE]]) &&
                ([ObjectUtil isNull:[actDic objectForKey:ACTION_CARD_CHANGE_PASSWORD]]) &&
                ([ObjectUtil isNull:[actDic objectForKey:ACTION_CARD_UNDO_GIVE_DEGREE]]) &&
                ([ObjectUtil isNull:[actDic objectForKey:ACTION_CARD_CONSUME_RECORD]])&&
                ([ObjectUtil isNull:[actDic objectForKey:ACTION_ACCOUNTCARD_SET]])&&
                ([ObjectUtil isNull:[actDic objectForKey:ACTION_ACCOUNTCARD_CHARGE]])&&
                ([ObjectUtil isNull:[actDic objectForKey:ACTION_ACCOUNTCARD_REFUND]])
                );
    }
    // 会员权限->会员模块
    if ([actCode isEqualToString:PAD_MEMBER_POINT_SET]) {
        return ([ObjectUtil isNull:[actDic objectForKey:ACTION_GIFT_GOODS_COUNT_SETTING]]&&[ObjectUtil isNull:[actDic objectForKey:ACTION_POINT_EXCHANGE_SET]]);
    }
    
    //报表
    if ([actCode isEqualToString:PAD_REPORT]) {
        //通过小权限判断大权限
        return (([ObjectUtil isNull:[actDic objectForKey:ACTION_HANDOVER_SEARCH]])&&
                ([ObjectUtil isNull:[actDic objectForKey:ACTION_SHOP_RECEIPT_REPORT]])&&
                ([ObjectUtil isNull:[actDic objectForKey:ACTION_ACHIEVEMENT_REPORT]])&&
                ([ObjectUtil isNull:[actDic objectForKey:ACTION_PERFORMANCE_SEARCH]])&&
                ([ObjectUtil isNull:[actDic objectForKey:ACTION_SELL_SEARCH]])&&
                ([ObjectUtil isNull:[actDic objectForKey:ACTION_GOODS_CATEGORY_SALE]])&&
                ([ObjectUtil isNull:[actDic objectForKey:ACTION_GOODS_SELL_REPORT]])&&
                ([ObjectUtil isNull:[actDic objectForKey:ACTION_REPORT_DAILY]])&&
                ([ObjectUtil isNull:[actDic objectForKey:ACTION_MEMBER_CONSUMPTION_SEARCH]])&&
                ([ObjectUtil isNull:[actDic objectForKey:ACTION_CARD_CHARGE_SEARCH]])&&
                ([ObjectUtil isNull:[actDic objectForKey:ACTION_MEMBER_EXCHANGE_SEARCH]])&&
                ([ObjectUtil isNull:[actDic objectForKey:ACTION_CARD_OPERATE]])&&
                ([ObjectUtil isNull:[actDic objectForKey:ACTION_STOCK_ORDER_REPORT]])&&
                ([ObjectUtil isNull:[actDic objectForKey:ACTION_SUPPLY_ORDER_REPORT]])&&
                ([ObjectUtil isNull:[actDic objectForKey:ACTION_STOCK_BALANCE_REPORT]])&&
                 ([ObjectUtil isNull:[actDic objectForKey:ACTION_ACCOUNTCARD_CHARGE_SEARCH]])
                );
    }
    
    /*
     *   微店模块
     */
    if ([actCode isEqualToString:PAD_WECHAT]) {//微店暂不控制
        return NO;
    }
    
    //顾客评价
    if ([actCode isEqualToString:PAD_COMMENT]) {//顾客评价暂不控制
        return NO;
    }
    
    //扫码结账
    if ([actCode isEqualToString:PAD_SCANCODE]) {
        return ([ObjectUtil isNull:[actDic objectForKey:ACTION_SCANNING_RECEIVABLES]]);
    }
    
    //电子收款账户
    if ([actCode isEqualToString:PAD_PAYMENT]) {
        return [ObjectUtil isNull:[actDic objectForKey:ACTION_WEI_PAY_SEARCH]] && [ObjectUtil isNull:[actDic objectForKey:ACTION_WEI_PAY_SUMMARIZE_SEARCH]];
    }
    
    //退货类别无权限控制
    if ([actCode isEqualToString:MATERIAL_RETURN_TYPE]) {
        return NO;
    }
    //店家信息没有设置权限
    if ([actCode isEqualToString:ACTION_SHOP_INFO]) {
        return NO;
    }
    
    return ([ObjectUtil isNull:[actDic objectForKey:actCode]]);
}


#pragma screen.heigh
- (void)screenHeight:(int)height
{
    sheight=height;
}

- (int)getScreenHeight
{
    return sheight;
}

#pragma config
- (NSString *)getkey:(NSString *)key
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    return [settings objectForKey:key];
}

- (void)saveKeyWithVal:(NSString *)key withVal:(id)val
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:key];
    if (val == nil || [val isEqual:[NSNull null]]) {
        return;
    } else {
        [settings setValue:val forKey:key];
    }
    [settings synchronize];
}

//重置NSUserDefaults
- (void)resetDefaults
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [settings dictionaryRepresentation];
    /**start*/
    
    // 下面删除的不会再登陆的时候删除
    NSMutableArray *allKeys = [NSMutableArray arrayWithArray:[dic allKeys]];
    [allKeys removeObject:@"user"];
    [allKeys removeObject:@"code"];
    [allKeys removeObject:SERVER_API];
    [allKeys removeObject:SERVER_API_OUT];
    [allKeys removeObject:SERVER_API_OUT_SECERT];
    [allKeys removeObject:SERVER_API_NAME];
    [allKeys removeObject:BG_FILE];
    [allKeys removeObject:MAIL_PATH];
#ifdef DEBUG
    [allKeys removeObject:PASS];
#endif
    
    for (NSString *key in allKeys) {
        if (!([key hasPrefix:SYSTEM_NOFITICATION] || [key hasSuffix:@"-failure"] || [key hasSuffix:@"-success"] || [key hasSuffix:kCategoryName] || [key hasSuffix:kCategoryId])) {//此值开头的数据不可清除 因为系统通知首页需要标志是否是最新的信息 后台不提供接口只能前段处理-failure-success电子收款明细要判断进入哪个页面这个值不能清除 添加商品的分类默认是上一次保存商品的分类需要存储到本地不可删除
            [settings removeObjectForKey:key];
            [settings synchronize];
        }
    }
}

//是不是连锁总部用户， 只针对连锁有意义
- (BOOL)isTopOrg {
    return isTopOrg;
}

- (void)setIsTopOrg:(BOOL)value {
    isTopOrg = value;
}

- (NSString *)getToken
{
    NSDate *date = [[NSDate alloc] init];
    NSString *dateStr=[DateUtils formateDate3:date ];
    long long dateLong=[DateUtils formateDateTime2:dateStr];
    
    //    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSString *token = [NSString stringWithFormat:@"%@%tu",[[Platform Instance] getkey:SHOP_ID],dateLong];
    return [SignUtil convertPassword:token];
}

// 获取背景图片
+ (UIImage *)getBgImage {
    NSString *imageName = [[Platform Instance] getkey:BG_FILE];
    if([NSString isBlank:imageName]) {
        imageName = @"bg_01b";
    }
    UIImage *image = [UIImage imageNamed:imageName];
    return image;
}

@end
