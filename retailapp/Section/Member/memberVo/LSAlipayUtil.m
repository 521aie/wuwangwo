//
//  LSAlipayUtil.m
//  retailapp
//
//  Created by guozhi on 16/9/6.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSAlipayUtil.h"
#import "AlertBox.h"

@implementation LSAlipayUtil
+ (void)payFinish:(NSDictionary*)resultDic
{
    NSString *status=[resultDic objectForKey:@"resultStatus"];
    NSString *memo=[resultDic objectForKey:@"memo"];
    if ([status isEqualToString:@"9000"]) {
        NSString* reulst=[resultDic objectForKey:@"result"];
        NSMutableDictionary* dic=[self convertDic:reulst];
        NSString* subject=[dic objectForKey:@"subject"];
        if ([subject isEqualToString:@"短信营销"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Sms_Pay_Finish object:dic] ;
        }
    } else if ([status isEqualToString:@"6001"]) {
        [AlertBox show:@"本次支付已取消。"];
    } else {
        [AlertBox show:memo];
    }
}

//生成key;
+ (NSMutableDictionary*)convertDic:(NSString*)source
{
    source=[source stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    NSArray* sources = [source componentsSeparatedByString: @"&"];
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    NSArray* pairs;
    if (sources!=nil && sources.count>0) {
        for (NSString* str in sources) {
            pairs=[str componentsSeparatedByString: @"="];
            [dic setValue:[pairs objectAtIndex:1] forKey:[pairs objectAtIndex:0]];
        }
    }
    
    
    return dic;
}
@end
