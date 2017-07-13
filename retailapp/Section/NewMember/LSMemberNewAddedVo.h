//
//  LSMemberNewAddedVo.h
//  retailapp
//
//  Created by taihangju on 2016/11/9.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSMemberNewAddedVo : NSObject

@property (nonatomic ,strong) NSString *date;/*<查询日期>*/
@property (nonatomic ,strong) NSString *customerRegisterId;/*<二维火会员id>*/
@property (nonatomic ,strong) NSString *customerId;/*<会员id>*/
@property (nonatomic ,strong) NSString *name;/*<会员名称>*/
@property (nonatomic ,strong) NSString *imageUrl;/*<会员图像>*/
@property (nonatomic ,strong) NSString *mobile;/*<手机号>*/
@property (nonatomic ,strong) NSString *cardNames;/*<已领卡>*/
@property (nonatomic ,strong) NSString *cardNum;/*<已领会员卡数>*/
/** <#注释#> */
@property (nonatomic, copy) NSString *customerName;

+ (NSArray *)memberNewAddedVoList:(NSArray *)keyValuesArray;
@end
