//
//  Platform.h
//  retailapp
//
//  Created by hm on 15/6/25.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MemberSearchCondition.h"

@interface Platform : NSObject


+ (Platform *)Instance;

/** 播放视频列表(存放的是LSVideoVo对象 如有不明白请看帮助视频列表) */
@property (nonatomic, strong) NSArray *helpVideoList;

//Action字典项配置.
- (NSDictionary *)getActDic;
- (BOOL)lockAct:(NSString *)actCode;
- (void)setActDic:(NSDictionary *)dic;


//统计数量Dic
-(NSString *)countObject:(NSString *)code;
-(NSMutableDictionary *)getCountDic;
-(void)countDic:(NSMutableDictionary *)map;

//设置店铺模式
- (void)setShopMode:(short)mode;
- (short)getShopMode;
//设置微店状态
- (void)setMicroShopStatus:(short)status;
- (short)getMicroShopStatus;

//扫码付款和园区入驻是否显示
/**扫码付款和园区入驻是否显示 0不显示 1显示*/
- (void)setScanPayStatus:(short)status;
- (short)getScanPayStatus;

//会员卡类型一览
- (NSMutableArray *)getKindCardList;
- (void)setKindCardList:(NSMutableArray *)list;

//图片地址
- (void)setFileName:(NSString *)_fileName;
- (NSString *)getFileName;

//会员信息筛选页面
- (void)setMemberSearchCondition:(MemberSearchCondition *)condition;
- (MemberSearchCondition *)getMemberSearchCondition;
//所在地区地址
- (void)setAddressList:(NSArray*)arr;
- (NSArray*)getAddressList;

//机构类型
- (void)setShopTypeList:(NSMutableArray*)arr;
- (NSMutableArray*)getShopTypeList;

//机构是否有仓库
- (void)setHasWarehouse:(BOOL)status;
- (short)getHasWarehouse;

//屏幕高度
- (void)screenHeight:(int)height;
- (int)getScreenHeight;

//配置相关
- (NSString *)getkey:(NSString *)key;
- (void)saveKeyWithVal:(NSString *)key withVal:(id)val;
- (void)resetDefaults;

//微店款式列表
- (NSMutableArray *)getMicroStyleList;
-(void)setMicroStyleList:(NSMutableArray*) list;

////是不是连锁总部用户,只针对连锁有意义，单店即使总部用户也为：false
- (BOOL)isTopOrg;
- (void)setIsTopOrg:(BOOL)value;

- (NSString *)getToken;

// 获取背景图片
+ (UIImage *)getBgImage;
@end
