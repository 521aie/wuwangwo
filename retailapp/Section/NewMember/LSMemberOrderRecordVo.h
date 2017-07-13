//
//  LSMemberOrderRecordVo.h
//  retailapp
//
//  Created by taihangju on 16/9/28.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSMemberInfoVo.h"

@interface LSMemberOrderRecordVo : NSObject

@property (nonatomic ,strong) NSString *orderId;
@property (nonatomic ,strong) NSString *customerRegisterId;
@property (nonatomic ,strong) NSString *entityId;
@property (nonatomic ,strong) NSNumber *createTime;
@property (nonatomic ,strong) NSString *currDate;
@property (nonatomic ,strong) NSString *globalCode;
@property (nonatomic ,strong) NSString *totalpayId;
@property (nonatomic ,strong) NSNumber *amount;
@property (nonatomic ,strong) NSNumber *status;
@property (nonatomic ,strong) NSString *payMode;
@property (nonatomic ,strong)LSMemberRegisterVo *customerRegister;

+ (NSArray *)getMemberOrderRecordVoList:(NSArray *)array;
@end
