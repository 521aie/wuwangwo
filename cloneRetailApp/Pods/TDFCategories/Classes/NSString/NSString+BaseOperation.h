//
//  NSString+BaseOperation.h
//  Pods
//
//  Created by tripleCC on 11/4/16.
//
//

#import <Foundation/Foundation.h>

// 实现点语法，如果字符串为nil，会崩溃

@interface NSString (BaseOperation)
/** a + b -> ab */
- (NSString *)tdf_suffix:(NSString *)aString;

/** a + b -> ba */
- (NSString *)tdf_prefix:(NSString *)aString;

/** a + ( , ) -> (a) */
- (NSString *)tdf_wrapLeft:(NSString *)lString right:(NSString *)rString;

/** a + ' -> 'a' */
- (NSString *)tdf_wrap:(NSString *)aString;

/** 是否为空（not，调用者为nil时，结果还是正确的） */
- (BOOL)tdf_notEmpty;
@end
