//
//  JsonHelper.h
//  RestApp
//
//  Created by zxh on 14-3-26.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

/**
    这个工具类主要是实现json与对象之间的相互转换，方便网络传输，OC刚开始弄，用法写的详细点，避免以后忘记.
    1.第1个方法是 用于对象转换为字符串。实例化一个对象，就可以转成字符串了。
      例子：
        NSString* temp=[JsonHelper transJson:user];
        NSLog(@"user is %@",temp);
 
    2.第2个方法是 用于字符串转换为对象.也要先临时实例化一个对象，字符串转成相应的对象。
      例子：
        NSString* temp=[JsonHelper transJson:user];
        NSLog(@"user is %@",temp);
 
        User *user2=[JsonHelper transObj:temp obj:[User alloc]];
 
        NSLog(@"new user is %@",user2.username);
 
    3.第3个方法是 用于字符串转换为对象.也要先临时实例化一个对象，字符串转成相应的对象。
 
 */
#import <Foundation/Foundation.h>

@class Jastor;
@interface JsonHelper : NSObject

+(NSString *) transJson:(Jastor *) obj;

+(NSString*) arrTransJson:(NSMutableArray*)arrs;

+(id) transObj:(NSString *) str obj:(Jastor *)obj;

+(id) dicTransObj:(NSDictionary *) dic obj:(Jastor *)obj;

+(NSDictionary*) transMap:(NSString *) str;

+(NSArray *) transList:(NSString *) str;

+(NSMutableArray *) transList:(NSArray *) arr objName:(NSString *)obj;

+ (NSDictionary*)getObjectData:(id)obj;

+(NSArray*) transDictionaryList:(NSMutableArray*) objList;

+(NSDictionary*) transDictionary:(Jastor *) obj;

+(NSDictionary*) transDictionary2:(Jastor *) obj;


//------供应链新增json转换方法--------

// 转换特殊对象的Json字符串.
+ (NSString*)arrObjTransJson:(NSMutableArray*)arrs;

//集合Json字符串转对象列表.
+(NSMutableArray*)transListByString:(NSString*)str objName:(NSString*)obj;

//对象列表转Json字符串.
+(NSString*) arrObjArrTransJson:(NSMutableArray*)paraArrs;

//------员工新增json转换方法--------
+(NSString*) dicObjTransToJson:(NSDictionary*)paraDic;

@end
