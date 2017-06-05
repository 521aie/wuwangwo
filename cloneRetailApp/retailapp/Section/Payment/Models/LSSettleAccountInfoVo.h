//
//  LSSettleAccountInfoVo.h
//  retailapp
//
//  Created by guozhi on 2016/12/2.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSSettleAccountInfoVo : NSObject
/** 商户entityId */
@property (nonatomic, copy) NSString *entityId;
/** 账户状态：0，未进件；1，已进件；2，进件失败 */
@property (nonatomic, strong) NSNumber *authStatus;
/** 进件消息 */
@property (nonatomic, copy) NSString *authMessage;
/** 审核状态；0；默认；1，审核中；2，审核通过；3，审核失败 */
@property (nonatomic, strong) NSNumber *auditStatus;
/** 审核时间 */
@property (nonatomic, copy) NSString *auditMessage;
/** 审核时间 */
@property (nonatomic, strong) NSNumber *auditTime;
/** 审核操作时间 */
@property (nonatomic, strong) NSNumber *opTime;
/** 审核人 */
@property (nonatomic, copy) NSString *auditor;
@end
