//
//  GoodsMicroEditView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/7/30.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WechatGoodsDetailsView : UIViewController


@property (nonatomic, strong) NSString* shopId;
@property (nonatomic, strong) NSString* goodsId;
/**
 *  模式 编辑 ACTION_CONSTANTS_EDIT 添加 ACTION_CONSTANTS_ADD默认是编辑模式
 */
@property (nonatomic, assign) int action;
@end
