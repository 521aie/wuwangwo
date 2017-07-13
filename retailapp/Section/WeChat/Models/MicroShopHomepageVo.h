//
//  MicroShopHomepageVo.h
//  retailapp
//
//  Created by diwangxie on 16/4/29.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MicroShopHomepageVo : NSObject

//输入字段
@property (nonatomic,strong) NSString * homePageId;/*<微店主页主表ID*/
@property (nonatomic,strong) NSString *fileName;/*<文件名*/
@property (nonatomic,strong) NSString *file; /*<文件流*/
@property (nonatomic) NSInteger setType; /*<设置类型：1~6*/
@property (nonatomic) NSInteger hasRelevance;/*<是否关联商品0：不关联 1：关联*/
@property (nonatomic,strong) NSString *relevanceId;/*<关联ID setType：6时，必须*/
@property (nonatomic) NSInteger relevanceType;/*<关联类型 setType：6时，必须*/
@property (nonatomic) NSInteger lastVer; /*<版本号*/
@property (nonatomic) NSMutableArray *microShopHomepageDetailVoArr;/*<setType：1-5时，必须使用*/

//输出字段
@property (nonatomic,strong) NSString *filePath;/*<图片下载地址*/
@property (nonatomic,strong) NSString *styleName;/*<款式名称 setType：6时，服鞋用*/
@property (nonatomic,strong) NSString *goodsName;/*<商品名称 setType：6时，商超用*/
@property (nonatomic,strong) NSString *styleCode;/*<款式编号 setType：6时，服鞋用*/
@property (nonatomic,strong) NSString *goodsBarCode;/*<商品条形码 setType：6时，商超用*/
@property (nonatomic) NSInteger relevanceCount;/*<关联商品数量*/
@property (nonatomic) double relevanceWeixinPrice;/*<微店价格*/
@property (nonatomic) NSInteger sortCode;/*<图片顺序码*/
@property (nonatomic) long long opTime;/*<操作时间*/
@property (nonatomic ,copy) NSString *cateGoryName;/* <类别名称*/

// json字典数组 -> 对象数组
+ (NSMutableArray *)getMicroShopHomepageVos:(NSArray *)arr;
// json字典->对象
+(MicroShopHomepageVo *)convertToMicroGoodsVo:(NSDictionary *)dic;
// 对象->json字典
- (NSDictionary *)convertToDictionary;
@end

