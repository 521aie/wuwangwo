//
//  LSGoodsPurchaseDetailHeaderView.h
//  retailapp
//
//  Created by guozhi on 2017/1/14.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LSGoodsPurchaseVo;

@interface LSGoodsPurchaseDetailHeaderView : UIView
+ (instancetype)goodsPurchaseDetailHeaderView;
- (void)setObj:(LSGoodsPurchaseVo *)obj time:(NSString *)time imgUrl:(NSString *)imgUrl;
@end
