//
//  MicroShopInfoVo.h
//  retailapp
//
//  Created by taihangju on 2017/3/15.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MicroShopInfoVo : NSObject

@property (nonatomic, strong) NSString *microShopName;/**<微店名>*/
@property (nonatomic, strong) NSString *introduce;/**<店家简介>*/
@property (nonatomic, strong) NSString *shortUrl;/**<店家微店分享url>*/
@property (nonatomic, strong) NSString *logoPath;/**<店家logo>*/

// dic --> model
+ (instancetype)microShopInfoVoFrom:(NSDictionary *)keyValues;
@end
