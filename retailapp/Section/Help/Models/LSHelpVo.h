//
//  LSHelpVo.h
//  retailapp
//
//  Created by guozhi on 2017/3/8.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSHelpVo : NSObject
/** 帮助页面标题 */
@property (nonatomic, copy) NSString *title;
/** code 唯一标志 将来根据这个来找播放视频链接 */
@property (nonatomic, copy) NSString *code;
/** 内容list */
@property (nonatomic, strong) NSArray *list;

+ (instancetype)helpVoWithCode:(NSString *)code;
@end
