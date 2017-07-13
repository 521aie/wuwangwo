//
//  GoodsSingleAttributeEditView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/8/11.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"

@class GoodsModule, AttributeVo, AttributeGroupVo, AttributeValVo;
typedef void(^goodsSingleAttributeEditBack) (AttributeVo* attributeVo, int fromViewTag);

@interface GoodsSingleAttributeEditView : LSRootViewController
@property (nonatomic) int action;
@property (nonatomic, strong) AttributeValVo *attributeValVo;
@property (nonatomic, strong) AttributeVo *attributeVo;
@property (nonatomic, copy) goodsSingleAttributeEditBack goodsSingleAttributeEditBack;

-(void) loaddatas:(AttributeVo *) attributeVo attributeGroupVoList:(NSMutableArray*) attributeGroupVoList attributeValVo:(AttributeValVo*) attributeValVo action:(int) action callBack:(goodsSingleAttributeEditBack) callBack;
@end
