//
//  UIViewController+LSHelp.h
//  retailapp
//
//  Created by guozhi on 2017/3/7.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (LSHelp) 
/** <#注释#> */
@property (nonatomic, copy) NSString *helpCode;
/**
 帮助按钮

 @param code 哪个页面的帮助按钮
 */
- (void)configHelpButton:(NSString *)helpCode;
@end
