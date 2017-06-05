//
//  LSCardTextFontStyle.m
//  retailapp
//
//  Created by taihangju on 16/9/24.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSCardTextFontStyle.h"
#import "Masonry.h"

@implementation LSCardTextFontStyle

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"sId":@"id"};
}

+ (NSArray *)getObjectsFrom:(NSArray *)dics {
    
    return [self mj_objectArrayWithKeyValuesArray:dics];
}
@end
