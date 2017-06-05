//
//  LSMemberSubmenus.h
//  retailapp
//
//  Created by taihangju on 16/9/7.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSMemberSubmenus : NSObject

@property (nonatomic ,copy) NSString *icon;/*<子模块图标 名称>*/
@property (nonatomic ,copy) NSString *name;/*<子模块 名称>*/
@property (nonatomic ,copy) NSString *relatedClass;/*<子模块对应的相关类名>*/
@property (nonatomic ,assign) NSInteger subModuleType;/*<子模块 type>*/
@property (nonatomic ,strong) NSString *actionCode;/*<会员部分权限控制 actionCode>*/

+ (NSArray *)memberSubmenus;
+ (NSArray *)memberCardFunctions;
- (void)statisticsUMengEvent;
@end
