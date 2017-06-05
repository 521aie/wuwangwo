//
//  UIMenuAction.h
//  retailapp
//
//  Created by hm on 15/6/26.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIMenuAction : NSObject
@property (nonatomic, copy) NSString * _id;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * detail;
@property (nonatomic, copy) NSString * img;
@property (nonatomic, copy) NSString * code;
@property (nonatomic) BOOL isLock;
- (id)init:(NSString *)nameTemp detail:(NSString *)detailTemp img:(NSString*) imgTemp code:(NSString*)codeTemp;
@end
