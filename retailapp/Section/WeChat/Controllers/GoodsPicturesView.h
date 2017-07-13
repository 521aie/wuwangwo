//
//  WechatStylePictureView.h
//  retailapp
//
//  Created by zhangzt on 15/10/26.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Wechat_MircoGoodsVo.h"

@interface GoodsPicturesView : BaseViewController

@property (nonatomic) int action;
@property (nonatomic, strong) NSString *shopId;
@property (nonatomic,strong) NSString *goodsId;
@property (nonatomic, strong) Wechat_MircoGoodsVo *microGoodsVo;
@end
