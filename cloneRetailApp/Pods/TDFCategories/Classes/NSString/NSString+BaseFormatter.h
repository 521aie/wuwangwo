//
//  NSString+BaseFormatter.h
//  Pods
//
//  Created by tripleCC on 11/4/16.
//
//

#import <Foundation/Foundation.h>
#import "NSString+BaseOperation.h"

@interface NSString (BaseFormatter)
/** 10/10.000 -> 10.00 */
- (NSString *)tdf_leave2Decimal;
// 10/10.000 -> 10.00
- (NSString *)tdf_price;
// 10 -> ¥10
- (NSString *)tdf_prefixRMB;
// 10 -> 10元
- (NSString *)tdf_suffixYuan;
// 10 -> 金额10
- (NSString *)tdf_prefixJinE;
@end
