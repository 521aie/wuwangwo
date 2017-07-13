//
//  ActionVo.h
//  retailapp
//
//  Created by qingmei on 15/9/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Jastor.h"

@interface ActionVo : Jastor
/**权限ID*/
@property (nonatomic, assign) NSInteger actionId;           //权限ID
/**权限名*/
@property (nonatomic, strong) NSString *actionName;         //权限名
/**权限CODE*/
@property (nonatomic, strong) NSString *actionCode;         //权限CODE
/**字典vo列表*/
@property (nonatomic, strong) NSArray *dicVoList;           //字典vo列表
/**权限数据类型系统参数*/
@property (nonatomic, assign) NSInteger actionDataType;     //权限数据类型系统参数

/**权限类别*/
@property (nonatomic, assign) NSInteger actionType;
/**权限数据类型系统参数*/
@property (nonatomic, assign) NSInteger choiceFlag;





//因为编辑的时候只传有改变得值如有不懂请联系果汁
/**权限数据类型系统参数*/
@property (nonatomic, assign) NSInteger oldChoiceFlag;
/**权限数据类型系统参数*/
@property (nonatomic, assign) NSInteger oldActionDataType;     //权限数据类型系统参数
/** 是否改变 */
@property (nonatomic, assign) BOOL isChange;


+ (ActionVo *)convertToUser:(NSDictionary*)dic;
- (NSMutableDictionary *)getDic:(ActionVo *)actionVo;
- (id)copy;
@end
