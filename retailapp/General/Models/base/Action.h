//
//  Action.h
//  retailapp
//
//  Created by zhangzhiliang on 15/8/9.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "ITreeNode.h"
#import "ObjectUtil.h"
#import "BaseAction.h"
#import "INameValueItem.h"

@interface Action : BaseAction<ITreeNode, INameValueItem>

@property (nonatomic) short state;

- (BOOL)isSelected;

- (void)setIsSelected:(BOOL)isSelected;

@end
