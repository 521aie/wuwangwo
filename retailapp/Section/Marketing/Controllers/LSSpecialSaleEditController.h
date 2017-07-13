//
//  LSSpecialSaleEditController.h
//  retailapp
//
//  Created by guozhi on 2016/10/29.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSSpecialSaleEditController : UIViewController
@property (nonatomic, copy) NSString* isCanDeal;
@property (nonatomic, copy) NSString *shopId;
- (instancetype)initWithSalesId:(NSString *)salesId salePriceId:(NSString *)salePriceId action:(int)action;
@end
