//
//  microShopHomepageDetailVoArrVo.h
//  retailapp
//
//  Created by diwangxie on 16/4/29.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

////输入参数
//@property (nonatomic,strong) NSString *id;
//@property (nonatomic,strong) NSString *microShopHomepageId;
//@property (nonatomic,strong) NSString *relevanceId;
//@property (nonatomic) NSInteger relevanceType;
//
////输出参数
//@property (nonatomic) NSInteger sortCode;
//@property (nonatomic,strong) NSString *styleName;
//@property (nonatomic,strong) NSString *styleCode;
//@property (nonatomic,strong) NSString *goodsBarCode;
//@property (nonatomic,strong) NSString *goodsName;
//@property (nonatomic,strong) NSString *cateGoryName;
//

@interface MicroShopHomepageDetailVo : NSObject

// 参考Class-> MicroShopHomepageVo
@property (nonatomic ,copy) NSString *id;/*<关联主表ID*/
@property (nonatomic ,copy) NSString *microShopHomepageId;/* <<#desc#>*/
//@property (nonatomic ,copy) NSString *entityId;/* <<#desc#>*/
@property (nonatomic ,copy) NSString *relevanceId;/* <关联的ID（款式ID，商品ID，类别ID*/
@property (nonatomic) NSInteger relevanceType;/* <关联类别*/

@property (nonatomic) NSInteger sortCode;/* <排序码*/
@property (nonatomic ,copy) NSString *styleName;/* <款式名称*/
@property (nonatomic ,copy) NSString *styleCode;/* <款式编号*/
@property (nonatomic ,copy) NSString *goodsBarCode;/* <商品条形码*/
@property (nonatomic ,copy) NSString *goodsName;/* <商品名称*/
@property (nonatomic ,copy) NSString *cateGoryName;/* <类别名称*/

+(MicroShopHomepageDetailVo *)convertTomicroShopHomepageDetailVoArrVo:(NSDictionary *)dic;
- (NSDictionary *)convertToDictionary;
@end
