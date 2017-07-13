//
//  AlertImageView.h
//  RestApp
//
//  Created by xueyu on 16/1/19.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  AlertImageViewClient<NSObject>
-(void)alertImageClient;
@end
@interface AlertImageView : UIView
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *memssage;
@property (nonatomic, assign) id<AlertImageViewClient> delegate;
-(void)initDataView:(NSString *)message image:(UIImage *)image delegate:(id<AlertImageViewClient>)client view:(UIView *)view;
@end

typedef void(^AlertTextBlock)();
@interface  AlertTextView: UIView
@property (nonatomic, strong)UIView *background;
//@property (nonatomic, strong)UILabel *title;
@property (nonatomic, strong)UILabel *contentxt;
- (instancetype)initWithContent:(NSString *)content  location:(CGPoint)point;
-(void)setBackColor:(UIColor *)backColor alpha:(CGFloat)alpha textColor:(UIColor *)textColor;
-(void)setViewSizeFont:(UIFont *)font label:(CGFloat)labelWidth;
-(void)showAlertView;
-(void)dismissAfterTimeInterval:(CGFloat)interval alertFinish:(AlertTextBlock)alertBlock;
@end