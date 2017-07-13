//
//  LSCardOperateListVo.h
//  retailapp
//
//  Created by wuwangwo on 17/1/6.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSCardOperateListVo : NSObject
@property (nonatomic, copy) NSString *customerName; //会员姓名
@property (nonatomic, copy) NSString *kindCardName; //会员卡类型
@property (nonatomic, copy) NSString *cardCode; //会员卡号
@property (nonatomic, strong) NSNumber *opTime; //操作时间
@property (nonatomic, strong) NSNumber *action; //操作类型（2:挂失，3:解挂，4:退卡，8:换卡）
@property (nonatomic, copy) NSString *id;
//@property (nonatomic, strong) NSNumber *currDate;
@property (nonatomic, strong) NSArray *customerOpLogList;

- (instancetype)initWithDictionary:(NSDictionary *)json;
@end

