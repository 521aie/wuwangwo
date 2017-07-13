//
//  WechatAppTopView.m
//  retailapp
//
//  Created by 小龙虾 on 2017/4/18.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "WechatAppTopView.h"
@interface WechatAppTopView ()
//店铺二维码文字
@property (nonatomic, strong)UILabel *lblTit;
//二维码背景图
@property (nonatomic, strong)UIView *bgView;
//二维码图片
@property (nonatomic, strong)UIImageView *imgQrde;
//二维码下方提示
@property (nonatomic, strong)UILabel *tiplbl;
//下滑线
@property (nonatomic, strong)UIView *line;

@end

@implementation WechatAppTopView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createViews];
    }
    return self;
}

-(void)createViews
{
    self.lblTit = [[UILabel alloc] initWithFrame:CGRectMake(11, 10, 156, 21)];
    [self.lblTit setText:@"店铺二维码"];
    [self.lblTit setTextColor:[UIColor blackColor]];
    [self.lblTit setTextAlignment:NSTextAlignmentLeft];
    [self.lblTit setFont:[UIFont systemFontOfSize:15]];
    [self addSubview:self.lblTit];
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_W/2-90, 44, 180, 180)];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bgView];
    
    self.imgQrde = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 170, 170)];
    [self.bgView addSubview:self.imgQrde];
    
    self.tiplbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 227, SCREEN_W, 21)];
    [self.tiplbl setFont:[UIFont systemFontOfSize:13.0]];
    [self.tiplbl setTextAlignment:NSTextAlignmentCenter];
    [self.tiplbl setText:@"微信扫描二维码预览您的微店主页"];
    [self addSubview:self.tiplbl];
    
    self.line = [[UIView alloc] initWithFrame:CGRectMake(10, 258, SCREEN_W-20, 1)];
    self.line.backgroundColor = [UIColor blackColor];
    self.line.alpha = 0.1;
    [self addSubview:self.line];
    
}

-(CGSize)getSzie{
    return self.imgQrde.frame.size;
}

-(CALayer *)getLayer
{
  return self.imgQrde.layer;
}

-(void)createQRCodeWithImg:(UIImage *)img
{
     [self.imgQrde setImage:img];
}



@end
