//
//  LSBarCodeMark.h
//  retailapp
//
//  Created by guozhi on 2017/2/3.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSBarCodeMark : NSObject
/** 参数值 */
@property (nonatomic, assign) int val;
/** 标志位 1：启用 2：关闭 */
@property (nonatomic, assign) int flag;
@end
