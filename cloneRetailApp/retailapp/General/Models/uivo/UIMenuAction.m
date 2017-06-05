//
//  UIMenuAction.m
//  retailapp
//
//  Created by hm on 15/6/26.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "UIMenuAction.h"
#import "NSString+Estimate.h"
@implementation UIMenuAction
- (id)init:(NSString *)nameTemp detail:(NSString *)detailTemp img:(NSString*) imgTemp code:(NSString*)codeTemp
{
    self.name=nameTemp;
    self.img=imgTemp;
    self.code=codeTemp;
    self.detail=[NSString isNotBlank:detailTemp]?detailTemp:@"";
    return self;
}
@end
