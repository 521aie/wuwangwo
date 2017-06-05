//
//  WechatAppTopView.h
//  retailapp
//
//  Created by 小龙虾 on 2017/4/18.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WechatAppTopView : UIView
-(void)createQRCodeWithImg:(UIImage *)img;
-(CGSize)getSzie;
-(CALayer *)getLayer;

@end
