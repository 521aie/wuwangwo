//
//  LSMemberSearchBar.h
//  retailapp
//
//  Created by taihangju on 16/9/6.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSMemberSearchBar : UIView

/**
 *  指定创建 LSMemberSearchBar 的方法
 *
 *  @param block 查询 调用block
 */
+ (LSMemberSearchBar *)memberSearchBar:(void(^)(NSString *queryString))block;
- (void)setSearchWord:(NSString *)keyword;
@end
