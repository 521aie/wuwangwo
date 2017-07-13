//
//  HandoverPayTypeVo.h
//  retailapp
//
//  Created by qingmei on 15/9/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HandoverPayTypeVo : NSObject
/**交接班ID*/
@property (nonatomic, strong) NSString *handoverId;
/**支付类型ID*/
@property (nonatomic, assign) NSInteger payTypeId;
/**支付金额*/
@property (nonatomic, strong) NSString *payAmount;
/**支付类型名称*/
@property (nonatomic, strong) NSString *payTypeName;

+ (HandoverPayTypeVo*)convertToUser:(NSDictionary*)dic;

- (NSMutableDictionary *)getDic:(HandoverPayTypeVo *)handoverPayTypeVo;


@end
