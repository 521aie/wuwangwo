//
//  LSPayVo.h
//  retailapp
//
//  Created by guozhi on 16/9/6.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSPayVo : NSObject
/**
 *  支付名称
 */
@property (nonatomic, copy) NSString *name;
/**
 *  支付名称头像
 */
@property (nonatomic, copy) NSString *path;
/**
 *  是否选中
 */
@property (nonatomic, assign) BOOL isSelect;
@end
