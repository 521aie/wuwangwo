//
//  LSBarChartVo.h
//  retailapp
//
//  Created by guozhi on 16/8/23.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSBarChartVo : NSObject
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) double maxValue;
@property (nonatomic, assign) double value;
@property (nonatomic, assign) double value2;
@property (nonatomic, copy) NSString *key;

@end
