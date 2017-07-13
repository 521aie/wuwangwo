//
//  MicroOrderDealVo.m
//  retailapp
//
//  Created by yumingdong on 15/10/18.
//  Copyright © 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "MicroOrderDealVo.h"

@implementation MicroOrderDealVo

-(NSString*) obtainItemId {
    return self.shopId;
}
-(NSString*) obtainItemName {
    return self.name;
}
-(NSString*) obtainItemValue {
    return self.code;
}

@end
