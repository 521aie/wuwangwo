//
//  GlobalRender.m
//  retailapp
//
//  Created by hm on 15/6/26.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GlobalRender.h"
#import "UIMenuAction.h"
#import "ActionConstants.h"
#import "NSString+Estimate.h"
#import "INameValueItem.h"
#import "INameItem.h"
#import "NameItemVO.h"

@implementation GlobalRender


+(NSString *)obtainItem:(NSArray *)list itemId:(NSString *)itemId
{
    if(!list || [NSString isBlank:itemId]){
        return @"";
    }
    NSString* itemName=nil;
    for (NameItemVO *item in list) {
        if([item.obtainItemId isEqualToString:itemId]){
            itemName=item.obtainItemName;
            break;
        }
    }
    return itemName;
}

+(NSString *)obtainObjName:(NSMutableArray *)list itemId:(NSString *)itemId
{
    if(!list || [NSString isBlank:itemId]){
        return @"";
    }
    NSString* itemName=nil;
    for (id<INameValueItem> item in list) {
        if([item.obtainItemId isEqualToString:itemId]){
            itemName=[item obtainOrignName];
            break;
        }
    }
    return itemName;
}

+(NSMutableArray *)convertStrs:(NSArray *)souces
{
    NSMutableArray* vos=[NSMutableArray array];
    NSString *item=nil;
    for (id<INameItem> temp in souces) {
        item=[temp obtainItemName];
        [vos addObject:item];
    }
    return vos;
}

+(int)getPos:(NSArray *)list itemId:(NSString *)itemId {
    if(!list || [NSString isBlank:itemId]){
        return 0;
    }
    int pos=0;
    for (id<INameValueItem> temp in list) {
        if([[temp obtainItemId] isEqualToString:itemId]){
            break;
        }
        pos++;
    }
    return pos;
}


+ (NSString *)getAddress:(NSArray *)addressList PId:(NSString *)provinceId CId:(NSString *)cityId  DId:(NSString *)districtId {
    NSString *provinceName= @"";
    NSString *cityName = @"";
    NSString *districtName = @"";
    NSArray *cityArr = nil;
    NSArray *districtArr = nil;
    for (NSInteger i=0; i<addressList.count; i++) {
        NSDictionary *dic = [addressList objectAtIndex:i];
        if ([provinceId isEqualToString:[dic objectForKey:@"provinceId"]]) {
            provinceName = [dic objectForKey:@"provinceName"];
            cityArr = [dic objectForKey:@"cityVoList"];
        }
    }
    for (NSInteger i=0; i<cityArr.count; i++) {
        NSDictionary *dic = [cityArr objectAtIndex:i];
        if ([cityId isEqualToString:[dic objectForKey:@"cityId"]]) {
            cityName = [dic objectForKey:@"cityName"];
            districtArr = [dic objectForKey:@"districtVoList"];
        }
    }
    for (NSInteger i=0; i<districtArr.count; i++) {
        NSDictionary *dic = [districtArr objectAtIndex:i];
        if ([districtId isEqualToString:[dic objectForKey:@"districtId"]]) {
            districtName = [dic objectForKey:@"districtName"];
        }
    }
    if ([provinceId isEqualToString:@"33"]||[provinceId isEqualToString:@"34"]) {
        return [NSString stringWithFormat:@"%@",provinceName];
    }else if ([provinceId isEqualToString:@"32"]) {
        return [NSString stringWithFormat:@"%@%@",provinceName,cityName];
    }else{
        return [NSString stringWithFormat:@"%@%@%@",provinceName,cityName,districtName];
    }
}

+ (NSMutableArray *)listYears {
    
    NSMutableArray *vos = [NSMutableArray array];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents* comps = [calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday) fromDate:[NSDate date]];
    NSInteger maxYear = [comps year];
    
    for (int i = 1990; i <= maxYear; i++)
    {
        NameItemVO *item=[[NameItemVO alloc] initWithVal:[NSString stringWithFormat:@"%d年",i] andId:@(i).stringValue];
        [vos addObject:item];
        
    }
    
    return vos;
}

@end
