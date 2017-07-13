//
//  ShopCommentReportVo.m
//  retailapp
//
//  Created by Jianyong Duan on 15/11/2.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "ShopCommentReportVo.h"
 
@implementation ShopCommentReportVo

//等级
- (NSInteger)levelTotal {
    return self.goodCount - self.badCount;
}


//购物环境 描述相符
- (float)shoppingOrDescriptionScore:(NSInteger)type {
    if (type == 0) {
        return self.shoppingScore;
    } else {
        return self.descriptionScore;
    }
}

- (NSInteger)shoppingOrDescriptionCompare:(NSInteger)type {
    if (type == 0) {
        return self.shoppingCompare;
    } else {
        return self.descriptionCompare;
    }
}

//售后服务 物流服务
- (float)servicOrshippingScore:(NSInteger)type {
    if (type == 0) {
        return self.serviceScore;
    } else {
        return self.shippingScore;
    }
}

- (NSInteger)servicOrshippingCompare:(NSInteger)type {
    if (type == 0) {
        return self.serviceCompare;
    } else {
        return self.shippingCompare;
    }
}

@end
