//
//  LSFilterItem.h
//  retailapp
//
//  Created by guozhi on 2016/10/25.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSFilterItem : NSObject
/** 标题 */
@property (nonatomic, copy) NSString *itemName;
/** Id */
@property (nonatomic, copy) NSString *itemId;
+ (instancetype)filterItem:(NSString *)itemName itemId:(NSString *)itemId;
@end
