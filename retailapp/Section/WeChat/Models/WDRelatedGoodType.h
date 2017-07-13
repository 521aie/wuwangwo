//
//  WDRelatedGoodType.h
//  retailapp
//
//  Created by byAlex on 16/7/20.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INameItem.h"

@interface WDRelatedGoodType : NSObject<INameItem>

@property (nonatomic ,copy) NSString *categoryId;/* <<#desc#>*/
@property (nonatomic ,copy) NSArray *categoryVoList;/* <<#desc#>*/
@property (nonatomic ,copy) NSString *code;/* <<#desc#>*/
@property (nonatomic) NSInteger goodsSum;/* <<#desc#>*/
@property (nonatomic ,copy) NSString *hasGoods;/* <<#desc#>*/
@property (nonatomic ,copy) NSString *lastVer;/* <<#desc#>*/
@property (nonatomic ,copy) NSString *memo;/* <<#desc#>*/
@property (nonatomic ,copy) NSString *microname;/* <<#desc#>*/
@property (nonatomic ,copy) NSString *name;/* <<#desc#>*/
@property (nonatomic ,copy) NSString *parentId;/* <<#desc#>*/
@property (nonatomic ,copy) NSString *parentName;/* <<#desc#>*/
@property (nonatomic ,copy) NSString *sortCode;/* <<#desc#>*/
@property (nonatomic ,copy) NSString *spell;/* <<#desc#>*/

+ (NSArray *)getRelatedGoodTypeList:(NSArray *)arr;
@end
