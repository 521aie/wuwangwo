//
//  EmployeeUserVo.m
//  retailapp
//
//  Created by qingmei on 15/9/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "EmployeeUserVo.h"
#import "UserAttachmentVo.h"
//接口文档中为UserVo,但是登陆模块中已有UserVo,这里改为EmployeeUserVo
@implementation EmployeeUserVo
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"userAttachmentList"]) {
        NSArray *arr = (NSArray *)value;
        NSMutableArray *userAttachmentList = [NSMutableArray array];
        if (nil != arr) {
            for (NSDictionary *dic in arr) {
                UserAttachmentVo *vo = [[UserAttachmentVo alloc]initWithDictionary:dic];
                [userAttachmentList addObject:vo];
            }
        }
        self.userAttachmentList = userAttachmentList;
    }
    else{
        [super setValue:value forKey:key];
    }
    
}

+ (EmployeeUserVo*)convertToUser:(NSDictionary*)dic{
    
    if ([ObjectUtil isNotEmpty:dic]) {
        EmployeeUserVo *employeeUserVo = [[EmployeeUserVo alloc]init];
        
        employeeUserVo.userId = [ObjectUtil getStringValue:dic key:@"userId"];
        employeeUserVo.userName = [ObjectUtil getStringValue:dic key:@"userName"];
        employeeUserVo.name = [ObjectUtil getStringValue:dic key:@"name"];
        employeeUserVo.staffId = [ObjectUtil getStringValue:dic key:@"staffId"];
        employeeUserVo.inDate = [ObjectUtil getLonglongValue:dic key:@"inDate"];
        
        employeeUserVo.mobile = [ObjectUtil getStringValue:dic key:@"mobile"];
        employeeUserVo.sex = [ObjectUtil getIntegerValue:dic key:@"sex"];
        employeeUserVo.birthday = [ObjectUtil getIntegerValue:dic key:@"birthday"];
        employeeUserVo.identityNo = [ObjectUtil getStringValue:dic key:@"identityNo"];
        employeeUserVo.identityTypeId = [ObjectUtil getIntegerValue:dic key:@"identityTypeId"];
        
        employeeUserVo.address = [ObjectUtil getStringValue:dic key:@"address"];
        employeeUserVo.shopId = [ObjectUtil getStringValue:dic key:@"shopId"];
        employeeUserVo.shopCode = [ObjectUtil getStringValue:dic key:@"shopCode"];
        employeeUserVo.shopType = [ObjectUtil getIntegerValue:dic key:@"shopType"];
        employeeUserVo.shopName = [ObjectUtil getStringValue:dic key:@"shopName"];
        employeeUserVo.roleId = [ObjectUtil getStringValue:dic key:@"roleId"];
        employeeUserVo.pwd = [ObjectUtil getStringValue:dic key:@"pwd"];
        employeeUserVo.keyWord = [ObjectUtil getStringValue:dic key:@"keyWord"];
        
        employeeUserVo.lastVer = [ObjectUtil getIntegerValue:dic key:@"lastver"];
        employeeUserVo.roleName = [ObjectUtil getStringValue:dic key:@"roleName"];
        employeeUserVo.shopEntityId = [ObjectUtil getStringValue:dic key:@"shopEntityId"];
        //详情时头像与身份证一起放在attachmentList中,添加时默认为空可以不处理
        //employeeUserVo.fileName = [ObjectUtil getStringValue:dic key:@"fileName"];
        //employeeUserVo.file = [ObjectUtil getStringValue:dic key:@"file"];
        //employeeUserVo.fileOperate = [ObjectUtil getIntegerValue:dic key:@"fileOperate"];
        
        
        NSArray *arrAttachmentList = [dic objectForKey:@"userAttachmentList"];
        if ([ObjectUtil isNotEmpty:arrAttachmentList]) {
            NSMutableArray *arrList = [[NSMutableArray alloc]initWithCapacity:arrAttachmentList.count];
            for (NSDictionary *dicPayType in arrAttachmentList) {
                [arrList addObject:[UserAttachmentVo convertToUser:dicPayType]];
            }
            employeeUserVo.userAttachmentList = arrList;
        }
        else{
            NSLog(@"EmployeeUserVo.attachmentList Is empty. Create it.");
            NSMutableArray *arr = [NSMutableArray array];
            employeeUserVo.userAttachmentList = arr;
        }

        NSDictionary *dicserHandoverVo = [dic objectForKey:@"userHandoverVo"];
        if ([ObjectUtil isNotEmpty:dicserHandoverVo]) {
            employeeUserVo.userHandoverVo = [UserHandoverVo convertToUser:dicserHandoverVo];
        }
        else{
            NSLog(@"EmployeeUserVo.userHandoverVo Is null.");
        }
        
        NSArray *arr = [dic objectForKey:@"handoverPayTypeList"];
        if ([ObjectUtil isNotEmpty:arr]) {
            NSMutableArray *arrList = [[NSMutableArray alloc]initWithCapacity:arr.count];
            for (NSDictionary *dicPayType in arr) {
                [arrList addObject:[HandoverPayTypeVo convertToUser:dicPayType]];
            }
            employeeUserVo.handoverPayTypeList = arrList;
        }
        else{
            NSLog(@"EmployeeUserVo.handoverPayTypeList Is empty.");
        }
        
        return employeeUserVo;
    }
    return nil;
}

- (NSMutableDictionary *)getDic:(EmployeeUserVo *)employeeUserVo {
  
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:[ObjectUtil isNull:employeeUserVo.userId]?[NSNull null]:employeeUserVo.userId forKey:@"userId"];
    [dic setValue:[ObjectUtil isNull:employeeUserVo.userName]?[NSNull null]:employeeUserVo.userName forKey:@"userName"];
    [dic setValue:[ObjectUtil isNull:employeeUserVo.name]?[NSNull null]:employeeUserVo.name forKey:@"name"];
    [dic setValue:[ObjectUtil isNull:employeeUserVo.staffId]?[NSNull null]:employeeUserVo.staffId forKey:@"staffId"];
    [dic setValue:[NSNumber numberWithLongLong:employeeUserVo.inDate] forKey:@"inDate"];
    [dic setValue:[ObjectUtil isNull:employeeUserVo.mobile]?[NSNull null]:employeeUserVo.mobile forKey:@"mobile"];
    [dic setValue:[NSNumber numberWithInteger:employeeUserVo.sex] forKey:@"sex"];
    [dic setValue:[NSNumber numberWithInteger:employeeUserVo.birthday] forKey:@"birthday"];
    [dic setValue:[ObjectUtil isNull:employeeUserVo.identityNo]?[NSNull null]:employeeUserVo.identityNo forKey:@"identityNo"];
    [dic setValue:[NSNumber numberWithInteger:employeeUserVo.identityTypeId] forKey:@"identityTypeId"];
    [dic setValue:[ObjectUtil isNull:employeeUserVo.address]?[NSNull null]:employeeUserVo.address forKey:@"address"];
    [dic setValue:[ObjectUtil isNull:employeeUserVo.shopId]?[NSNull null]:employeeUserVo.shopId forKey:@"shopId"];
    [dic setValue:[NSNumber numberWithInteger:employeeUserVo.shopType] forKey:@"shopType"];
    [dic setValue:[ObjectUtil isNull:employeeUserVo.shopName]?[NSNull null]:employeeUserVo.shopName forKey:@"shopName"];
    [dic setValue:[ObjectUtil isNull:employeeUserVo.shopCode]?[NSNull null]:employeeUserVo.shopCode forKey:@"shopCode"];
    [dic setValue:[ObjectUtil isNull:employeeUserVo.roleId]?[NSNull null]:employeeUserVo.roleId forKey:@"roleId"];
    [dic setValue:[ObjectUtil isNull:employeeUserVo.pwd]?[NSNull null]:employeeUserVo.pwd forKey:@"pwd"];
    [dic setValue:[ObjectUtil isNull:employeeUserVo.keyWord]?[NSNull null]:employeeUserVo.keyWord forKey:@"keyWord"];
    [dic setValue:[NSNumber numberWithInteger:employeeUserVo.lastVer] forKey:@"lastver"];
    [dic setValue:[ObjectUtil isNull:employeeUserVo.roleName]?[NSNull null]:employeeUserVo.roleName forKey:@"roleName"];
    [dic setValue:[ObjectUtil isNull:employeeUserVo.fileName]?[NSNull null]:employeeUserVo.fileName forKey:@"fileName"];
    [dic setValue:[ObjectUtil isNull:employeeUserVo.shopEntityId]?[NSNull null]:employeeUserVo.shopEntityId forKey:@"shopEntityId"];
    NSMutableArray *arrAttachmentList = [[NSMutableArray alloc]initWithCapacity:employeeUserVo.userAttachmentList.count];
    if ([ObjectUtil isNotEmpty:employeeUserVo.userAttachmentList]) {
        for (UserAttachmentVo *tempVo in employeeUserVo.userAttachmentList) {
            [arrAttachmentList addObject:[tempVo getDic:tempVo]];
        }
    }
    [dic setValue:[ObjectUtil isNull:arrAttachmentList]?[NSNull null]:arrAttachmentList forKey:@"userAttachmentList"];
    
 
    [dic setValue:[ObjectUtil isNull:employeeUserVo.userHandoverVo]?[NSNull null]:[employeeUserVo.userHandoverVo getDic:employeeUserVo.userHandoverVo]forKey:@"userHandoverVo"];

    NSMutableArray *arrPayList = [[NSMutableArray alloc]initWithCapacity:employeeUserVo.handoverPayTypeList.count];
    for (HandoverPayTypeVo *tempVo in employeeUserVo.handoverPayTypeList) {
        [arrPayList addObject:[tempVo getDic:tempVo]];
    }
    [dic setValue:[ObjectUtil isNull:arrPayList]?[NSNull null]:arrPayList forKey:@"handoverPayTypeList"];

    
    
    
    return dic;
}

@end
