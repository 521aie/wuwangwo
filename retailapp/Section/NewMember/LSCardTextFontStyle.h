//
//  LSCardTextFontStyle.h
//  retailapp
//
//  Created by taihangju on 16/9/24.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSCardTextFontStyle : NSObject

@property (nonatomic ,strong) NSString *sId;/*<<#说明#>>*/
@property (nonatomic ,strong) NSNumber *lastVar;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *dicId;/*<<#说明#>>*/
@property (nonatomic ,strong) NSNumber *sortCode;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *name;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *val;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *attachmentId;/*<<#说明#>>*/
@property (nonatomic ,strong) NSNumber *attachmentVer;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *systemTypeId;/*<<#说明#>>*/
@property (nonatomic ,strong) NSNumber *isValid;/*<<#说明#>>*/
@property (nonatomic ,strong) NSNumber *createTime;/*<<#说明#>>*/
@property (nonatomic ,strong) NSNumber *opTime;/*<<#说明#>>*/

+ (NSArray *)getObjectsFrom:(NSArray *)dics;
@end
