//
//  JsonHelper.m
//  RestApp
//
//  Created by zxh on 14-3-26.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "JsonHelper.h"
#import "JastorRuntimeHelper.h"
#import "NSString+Estimate.h"
#import "Jastor.h"
#import "JSonKit.h"
#import "Base.h"


@implementation JsonHelper

+(NSString*) arrTransJson:(NSMutableArray*)arrs{
    if (arrs==nil) {
        arrs=[NSMutableArray array];
    }
    NSString *returnString = [arrs JSONString];
    return returnString;
}

//对象转换为json对象.
+(NSString *) transJson:(Jastor *) obj{
    NSMutableDictionary *returnDic = [[NSMutableDictionary alloc] init];
    NSArray *array =[JastorRuntimeHelper propertyNames:[obj class]];
    for (NSString *key in array) {
        if([key isEqualToString:@"description"] || [key isEqualToString:@"debugDescription"] || [key isEqualToString:@"superclass"]){
            continue;
        }
        [returnDic setValue:[obj valueForKey:key] forKey:key];
    }
    NSString *returnString = [returnDic JSONString];
    return returnString;
}


//json转对象方法.
+(id) transObj:(NSString *) str obj:(Jastor *)obj{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *result = [data objectFromJSONData];
    return [obj initWithDictionary:result];//Jastor中的转化函数
}

//json转对象方法.
+(id) dicTransObj:(NSDictionary *) dic obj:(Jastor *)obj{
    if (dic==nil || [dic isEqual:[NSNull null]] || [dic count]==0) {
        return nil;
    }
    return [obj initWithDictionary:dic];//Jastor中的转化函数
}

//集合对象转化.
+(NSMutableArray *) transList:(NSArray *) arr objName:(NSString *)obj
{
    NSMutableArray* list=[NSMutableArray array];
    if (arr == nil || [arr isEqual:[NSNull null]] || [arr count]==0) {
        return list;
    }
    for(int i=0;i<[arr count];i++){
        Base* objTarget=[self dicTransObj:[arr objectAtIndex:i] obj:[NSClassFromString(obj) new]];
        [list addObject:objTarget];
    }
    arr=nil;
    return list;
}

//转换成字典项.
+(NSDictionary*) transMap:(NSString *) str{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    return [data objectFromJSONData];
}

//转换成数组.
+(NSArray *) transList:(NSString *) str{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    return [data objectFromJSONData];
}

//对象转换成字典项.
+(NSDictionary*) transDictionary:(Jastor *) obj
{
     NSDictionary* data = [[NSDictionary alloc]init];
    if(obj==nil){
        return data;
    }
    
    NSString *str = [JsonHelper transJson:obj];
    data = [JsonHelper transMap:str];
    return data;
}

//对象转换成字典项.
+(NSDictionary*) transDictionary2:(Jastor *) obj
{
    NSDictionary* data = [[NSDictionary alloc]init];
    if(obj==nil){
        return data;
    }
    
//    NSString* str=[[NSString alloc] init];
//    str = [JsonHelper transJson:obj];
    data = [JsonHelper getObjectData:obj];
    return data;
}

+(NSArray*) transDictionaryList:(NSMutableArray*) objList
{
    NSMutableArray* strArray = [[NSMutableArray alloc] init];
    if(objList==nil || objList.count==0){
        return strArray;
    }
    
    for (id obj in objList) {
        NSString *str = [JsonHelper transJson:obj];
        NSDictionary *data = [JsonHelper transMap:str];
        [strArray addObject:data];
    }
    
    return strArray;
}


//-------------------供应链新增----------------------------
// 转换特殊对象的Json字符串.
+ (NSString*) arrObjTransJson:(NSMutableArray*)paraArrs
{
    NSMutableString* str=[[NSMutableString alloc] init];
    if(paraArrs==nil || paraArrs.count==0){
        return str;
    }
    [str appendString:@"["];
    for (id obj in paraArrs) {
        if (![str isEqualToString:@"["]) {
            [str appendString:@","];
        }
        [str appendString:[JsonHelper transJson:obj]];
    }
    [str appendString:@"]"];
    return str;
}

//集合Json字符串转对象列表.
+(NSMutableArray*)transListByString:(NSString*)str objName:(NSString*)obj
{
    NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
    __autoreleasing NSError* error = nil;
    NSArray* result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error != nil) return nil;
    
    return [self transList:result objName:obj];
}

//复杂的对象(包含列表对象)列表转Json字符串.
+(NSString*) arrObjArrTransJson:(NSMutableArray*)paraArrs
{
    NSString* str=[[NSMutableString alloc] init];
    NSMutableString* mutStr=[[NSMutableString alloc] init];
    if(paraArrs==nil || paraArrs.count==0){
        return str;
    }
    [mutStr appendString:@"["];
    for (id obj in paraArrs) {
        if (![mutStr isEqualToString:@"["]) {
            [mutStr appendString:@","];
        }
        NSString* jsonStr = [self getJsonStr:obj];
        [mutStr appendString:jsonStr];
    }
    [mutStr appendString:@"]"];
    return mutStr;
}

//------员工新增json转换方法--------
+(NSString*) dicObjTransToJson:(NSDictionary*)paraDic{
    NSMutableString* mutStr=[[NSMutableString alloc] init];
    if (paraDic == nil || paraDic.allKeys.count == 0) {
        return nil;
    }
    [mutStr appendString:@"{"];
    for (NSString *key in paraDic.allKeys)
    {
        [mutStr appendString:key.JSONString];
        [mutStr appendString:@":"];
        
        id obj = [paraDic objectForKey:key];
        if ([obj isKindOfClass:[NSArray class]]) {
            
        }else if ([obj isKindOfClass:[NSDictionary class]]){
            
        }
        else{
            
        }
    }
    return mutStr;
}

+ (NSString*)getJsonStr:(id)obj
{
    NSDictionary *returnDic = [self getObjectData:obj];
    return [returnDic JSONString];
}

//通过对象返回一个NSDictionary，键是属性名称，值是属性值。
+ (NSDictionary*)getObjectData:(id)obj
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSArray *array =[JastorRuntimeHelper propertyNames:[obj class]];
    for (NSString *key in array) {
        
        if([key isEqualToString:@"description"] || [key isEqualToString:@"debugDescription"]
           || [key isEqualToString:@"superclass"]) {
            continue;
        }
        
        id value = [obj valueForKey:key];
        
        if(value == nil)
        {
            value = [NSNull null];
        }
        else
        {
            value = [self getObjectInternal:value];
        }
        [dic setValue:value forKey:key];
    }
    
    return dic;
}

+ (id)getObjectInternal:(id)obj
{
    if([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNull class]])
    {
        return obj;
    }
    
    if ([obj isKindOfClass:[NSNumber class]]) {
        
        NSNumber *val = obj;
        
        if (strcmp([obj objCType], @encode(float)) == 0 || strcmp([obj objCType], @encode(double)) == 0)
        {
            return [NSString stringWithFormat:@"%.2f",[val doubleValue]];
            
        }else if (strcmp([obj objCType], @encode(long long)) == 0){
            
            return [NSString stringWithFormat:@"%lld",[val longLongValue]];
            
        }else if (strcmp([obj objCType], @encode(long)) == 0){
            
            return [NSString stringWithFormat:@"%ld",[val longValue]];
            
        }
        return [NSString stringWithFormat:@"%d",[val intValue]];
    }
    
    if([obj isKindOfClass:[NSArray class]])
    {
        NSArray *objarr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        for(int i = 0;i < objarr.count; i++)
        {
            [arr setObject:[self getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];
        }
        return arr;
    }
    
    if([obj isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *objdic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        for(NSString *key in objdic.allKeys)
        {
            [dic setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
        }
        return dic;
    }
    return [self getObjectData:obj];
}


@end
