//
//  LSGoodsSalesReportVo.h
//  retailapp
//
//  Created by guozhi on 2016/11/23.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSGoodsSalesReportVo : NSObject
/** 分类名字 */
@property (nonatomic, copy) NSString *name;
/** 分类编码 */
@property (nonatomic, copy) NSString *code;
/** 净销量 */
@property (nonatomic, strong) NSNumber *netSales;
/** 净销售额 */
@property (nonatomic, strong) NSNumber *netAmount;
/** 微店分类别名 */
@property (nonatomic, copy) NSString *microName;
@end
