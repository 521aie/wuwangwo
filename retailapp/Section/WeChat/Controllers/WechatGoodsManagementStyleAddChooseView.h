//
//  WechatGoodsManagementStyleAddChooseView.h
//  retailapp
//
//  Created by zhangzt on 15/10/20.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WechatModule;
typedef void(^CallBack)(NSString*str);
@interface WechatGoodsManagementStyleAddChooseView : BaseViewController
{
    WechatModule *parent;
}

@property (nonatomic, strong) CallBack callBack;

@end
