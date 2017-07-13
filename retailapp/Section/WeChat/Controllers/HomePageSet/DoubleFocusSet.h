//
//  WeChatHomeSetDoubleFocus.h
//  retailapp
//
//  Created by diwangxie on 16/4/23.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoubleFocusSet : BaseViewController

- (void)setHomepageId:(NSString *)pageId sortCode:(NSInteger)code block:(void (^)())block;
@end
