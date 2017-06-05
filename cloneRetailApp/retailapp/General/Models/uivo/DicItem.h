//
//  DicItem.h
//  retailapp
//
//  Created by zhangzhiliang on 15/8/6.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"
#import "INameValueItem.h"

@interface DicItem : Jastor<INameValueItem>

/**
 * <code>名称</code>.
 */
@property (nonatomic,retain) NSString *name;

/**
 * <code>值</code>.
 */
@property (nonatomic,retain) NSString *val;

/**
 * <code>id</code>.
 */
@property (nonatomic,retain) NSString *dicId;

/**
 * <code>id</code>.
 */
//@property (nonatomic,retain) NSString *dicId;

@end
