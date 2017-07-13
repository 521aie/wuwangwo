//
//  LSCardBackgroundImageVo.h
//  retailapp
//
//  Created by taihangju on 16/9/25.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSCardBackgroundImageVo : NSObject

@property (nonatomic ,strong) NSString *s_Id;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *attachmentId;/*<<#说明#>>*/
@property (nonatomic ,strong) NSNumber *cacheExpireTime;/*<<#说明#>>*/
@property (nonatomic ,strong) NSNumber *createTime;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *filePath;/*<<#说明#>>*/
@property (nonatomic ,strong) NSNumber *sId;/*<<#说明#>>*/
@property (nonatomic ,strong) NSNumber *isValid;/*<<#说明#>>*/
@property (nonatomic ,strong) NSNumber *lastVer;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *name;/*<<#说明#>>*/
@property (nonatomic ,strong) NSNumber *opTime;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *opUserId;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *orign_Id;/*<<#说明#>>*/

+ (NSArray *)getObjectsFrom:(NSArray *)array;
@end
