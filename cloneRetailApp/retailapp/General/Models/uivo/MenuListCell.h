//
//  MenuListCell.h
//  retailapp
//
//  Created by 果汁 on 15/9/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"
@interface MenuListCell : Jastor
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *val;
@property (nonatomic, assign) BOOL isSelcted;
@property (nonatomic, strong) NSNumber *userBankId;
- (instancetype)initName:(NSString *)name val:(NSString *)val;
@end
