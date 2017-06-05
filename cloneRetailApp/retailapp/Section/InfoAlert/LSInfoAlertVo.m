//
//  LSInfoAlertVo.m
//  retailapp
//
//  Created by guozhi on 2016/10/20.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSInfoAlertVo.h"

@implementation LSInfoAlertVo
+ (instancetype)infoAlertVo:(NSString *)title content:(NSString *)content buttonTitle:(NSString *)buttonTitle imagePath:(NSString *)imagePath{
    LSInfoAlertVo *infoAlertVo = [[LSInfoAlertVo alloc] init];
    infoAlertVo.title = title;
    infoAlertVo.content = content;
    infoAlertVo.buttonTitle = buttonTitle;
    infoAlertVo.imagePath = imagePath;
    return infoAlertVo;
}
@end
