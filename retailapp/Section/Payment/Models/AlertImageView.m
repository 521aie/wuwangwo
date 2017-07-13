//
//  AlertImageView.m
//  RestApp
//
//  Created by xueyu on 16/1/19.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "AlertImageView.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
@implementation AlertImageView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,60, 60)];
        self.imgView.layer.cornerRadius = 30;
        self.imgView.layer.masksToBounds = YES;
        self.imgView.center = self.center;
        self.memssage = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width,30)];
        self.memssage.center = CGPointMake(self.center.x,self.center.y + 50);
        self.memssage.textAlignment = NSTextAlignmentCenter;
        self.memssage.font = [UIFont systemFontOfSize:15];
        self.memssage.textColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.imgView];
        [self addSubview:self.memssage];
    }
    return self;    
}

-(void)initDataView:(NSString *)message image:(UIImage *)image  delegate:(id<AlertImageViewClient>)client view:(UIView *)view{
   
    self.imgView.image = image;
    self.delegate = client;
    self.memssage.text = message;
    self.alpha = 0;
    [view addSubview:self];
    [UIView animateWithDuration:2.5 delay:0.5 usingSpringWithDamping:0.5 initialSpringVelocity:5.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 1;
     } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.delegate alertImageClient];
    }];

}

@end



@interface AlertTextView()
@property (nonatomic, copy)NSString *content;
@property (nonatomic, assign)CGPoint point;//弹窗位置
@property (nonatomic, assign)CGFloat labelWidth;//弹窗宽度
@property (nonatomic, strong)UIFont *fontSize;//字体大小
@end
@implementation AlertTextView
- (instancetype)initWithContent:(NSString *)content  location:(CGPoint)point
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.background = [[UIView alloc]init];
        self.background.backgroundColor = [UIColor whiteColor];
        self.background.layer.cornerRadius = 8.0f;
        self.background.layer.masksToBounds = YES;
        self.contentxt = [[UILabel alloc]init];
        self.contentxt.textAlignment = NSTextAlignmentCenter;
        self.contentxt.backgroundColor = [UIColor clearColor];
        self.labelWidth = SCREEN_WIDTH-80;
        self.fontSize = [UIFont systemFontOfSize:13];
        self.contentxt.text = content;
        self.contentxt.numberOfLines = 0;
        self.content = content;
        self.point = point;
        self.contentxt.font = self.fontSize;
        [self addSubview:self.background];
        [self addSubview:self.contentxt];
        [self updateView];
    }
    return self;
}
#pragma mark 更新UI
-(void)updateView {
    CGRect contentRect = CGRectMake(40,self.point.y,self.labelWidth, [self textHeight:self.content]);
    self.contentxt.frame = contentRect;
    self.contentxt.center = self.point;
    CGRect backRect = CGRectMake(30,self.point.y-10,self.labelWidth+20,[self totalHeight:self.content]);
    self.background.frame = backRect;
    self.background.center = self.contentxt.center;
}
- (CGFloat)totalHeight:(NSString *)content
{
    CGFloat staticHeight = 10 + 10;
    CGFloat dynamicHeight = [self textHeight:content];
    return staticHeight + dynamicHeight;
}

-(CGFloat)textHeight:(NSString *)string
{
    NSDictionary *dict = @{NSFontAttributeName:self.fontSize};
    CGRect rect = [string boundingRectWithSize:CGSizeMake(self.labelWidth,2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return rect.size.height;
}


-(void)setBackColor:(UIColor *)backColor alpha:(CGFloat)alpha textColor:(UIColor *)textColor{
    self.background.backgroundColor = backColor;
    self.background.alpha = alpha;
    self.contentxt.textColor = textColor;
}

-(void)setViewSizeFont:(UIFont *)font label:(CGFloat)labelWidth{
  
    if (font) {
         self.fontSize = font;
        self.contentxt.font = font;
    }
    if (labelWidth > 0) {
        self.labelWidth = labelWidth;

    }
       [self updateView];

}
#pragma mark
-(void)showAlertView{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}
-(void)dismissAfterTimeInterval:(CGFloat)interval alertFinish:(AlertTextBlock)alertBlock
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (alertBlock) {
           alertBlock();
        }
        [self removeFromSuperview];
    });
}
@end

