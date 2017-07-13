//
//  TicketReviewController.h
//  retailapp
//
//  Created by taihangju on 16/8/31.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "BaseViewController.h"
typedef enum {
    SmallTicketType58mm, //58mm宽
    SmallTicketType80mm  //80mm宽
}SmallTicketType;
@interface TicketReviewController : BaseViewController
/** 小票类型 */
@property (nonatomic, assign) SmallTicketType type;
@end
