//
//  ITextStepperField.h
//  retailapp
//
//  Created by zhangzhiliang on 15/7/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


@class TextStepperField;
@protocol ITextStepperField <NSObject>

//变化事件.
- (void)onStepperChangeClick:(TextStepperField*)obj;

- (void)onTextFieldChangeClick:(TextStepperField*)obj;

//变化至0时删除
-(void) delObjEvent:(NSString*)event;
@end
