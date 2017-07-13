//
//  ModuleConfigView.m
//  retailapp
//
//  Created by taihangju on 16/6/8.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "ModuleConfigView.h"
#define kMarginGap        8.0f //距离父view左右两边边缘的距离
#define kModulesGap       5.0f //模块之间的间距
#define kTitleLabelHeight 15.0f//模块所属的分类的标题，如“日常运维”、“后台设置”
#define KTitleLableTop 30.0f //标题距离上方的距离
#define KTitleLableBottom 10.0f //标题距离下方横线的距离
#define kLineH (1.0f/[UIScreen mainScreen].scale) //横线的高度
#define kLineBottom 10.0f //横线的距离
#define kLineMargin 10.0f //横线距离左边的距离

@interface ModuleConfigView()
@property (nonatomic, strong) ShopInfoVO *shopInfoVO;

@end
@implementation ModuleConfigView

- (instancetype)init:(ModuleConfigType)type top:(CGFloat)topY title:(NSString *)title owner:(id)agent shopInfoVo:(ShopInfoVO *)shopInfoVO;
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.shopInfoVO = shopInfoVO;
        [self modules:type];
        CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
        CGFloat moduleHeight = (screenWidth - 2*kMarginGap - 3*kModulesGap)/4;
        CGFloat totalHeight  = kTitleLabelHeight + ((_modules.count-1)/4 + 1)*(moduleHeight+kModulesGap) + KTitleLableTop + KTitleLableBottom + kLineH + kLineBottom;
        self.frame = CGRectMake(0, topY, CGRectGetWidth([UIScreen mainScreen].bounds), totalHeight);
        self.delegate = agent;
        CGFloat y = KTitleLableTop;
        UILabel *titleLabel      = [[UILabel alloc] initWithFrame:CGRectMake(0, y, screenWidth, kTitleLabelHeight)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font          = [UIFont boldSystemFontOfSize:15];
        titleLabel.textColor     = [UIColor whiteColor];
        titleLabel.text          = title;
        [self addSubview:titleLabel];
        
        y = y + titleLabel.ls_height;
        y = y + KTitleLableBottom;
        
        //横线
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(kLineMargin, y, SCREEN_W - 2 *kLineMargin, kLineH)];
        line.backgroundColor = [[ColorHelper getWhiteColor] colorWithAlphaComponent:0.2];
        [self addSubview:line];
        y = y + line.ls_height;
        
        y = y + kLineBottom;
        
        self.totalHeight = totalHeight;
        for (NSInteger i = 0; i < _modules.count; i++) {
            
            CGRect itemFrame   = CGRectMake(kMarginGap+(moduleHeight+kModulesGap)*(i%4),
                                            y+(i/4)*(moduleHeight+kModulesGap), moduleHeight, moduleHeight);
            NSDictionary *dic = _modules[i];
            ModuleView *module = [ModuleView creatModule:dic[@"icon"] title:dic[@"item"] frame:itemFrame];
            module.button.tag = i;
            [module.button addTarget:self action:@selector(moduleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            // 有无权限指示image
            module.limitImageView.hidden = ![[Platform Instance] lockAct:dic[@"code"]];
            [self addSubview:module];
        }
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

// ModuleView 对象点击调用该方法
- (void)moduleButtonAction:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(moduleConfigView:action:actionName:)]) {
        [self.delegate moduleConfigView:self action:self.modules[button.tag][@"code"] actionName:self.modules[button.tag][@"item"]];
    }
}

/**
 *  根据ModuleConfigType获取对应的数据
 *
 *  @param type 后台设置或者日常运维
 */
- (void)modules:(ModuleConfigType)type
{
    if (type == ModuleDailyRun) {
        
        NSMutableArray* dailyItems = [NSMutableArray array];

        //连锁模式，只有总部admin用户登录时才显示电子收款账户;门店用户需要显示“电子收款明细”模块
        if ( [[Platform Instance] isTopOrg] || [[Platform Instance] getShopMode] != 3)
        {
            // 显示微信支付或者支付宝支付
            if (self.shopInfoVO.displayWxPay == 1 || self.shopInfoVO.displayAlipay == 1 || self.shopInfoVO.displayQQ == 1) {
                [dailyItems addObject:@{@"item":@"电子收款账户" ,@"detail":@"" ,@"icon":@"ico_elect_pay" ,@"code":PAD_PAYMENT}];
            }
        }
        
        [dailyItems addObject:@{@"item":@"会员" ,@"detail":@"" ,@"icon":@"ico_nav_huiyuan" ,@"code":PAD_MEMBER}];
        [dailyItems addObject:@{@"item":@"营销" ,@"detail":@"" ,@"icon":@"ico_nav_cuxiao" ,@"code":PAD_MARKET}];
        [dailyItems addObject:@{@"item":@"报表" ,@"detail":@"" ,@"icon":@"ico_nav_baobiao" ,@"code":PAD_REPORT}];
        
        // 连锁模式，机构用户 (包括总部)登录，隐藏主页“微店”菜单
        if (([[Platform Instance] getShopMode] == 1 || [[Platform Instance] getShopMode] == 2) && [[Platform Instance] getMicroShopStatus] == 2) {
            [dailyItems addObject:@{@"item":@"微店" ,@"detail":@"" ,@"icon":@"ico_nav_weidian" ,@"code":PAD_WECHAT}];
        }
        
      
        // 开启微店才会显示顾客评价，顾客评价来源于微店用户评论
        if (([[Platform Instance] getMicroShopStatus] == 2 && ([[Platform Instance] getShopMode] != 3)) || [[Platform Instance] getShopMode] == 3) {
            [dailyItems addObject:@{@"item":@"顾客评价" ,@"detail":@"" ,@"icon":@"ico_nav_gukepingjia" ,@"code":PAD_COMMENT}];
        }
        self.modules = [dailyItems copy];
    }else if (type == ModuleBackgroundSet){
        NSMutableArray *bgSetItems = [NSMutableArray array];
        [bgSetItems addObject:@{@"item":@"商品" ,@"detail":@"" ,@"icon":@"ico_nav_shangpin" ,@"code":PAD_GOODS}];
        [bgSetItems addObject:@{@"item":@"出入库" ,@"detail":@"" ,@"icon":@"ico_nav_wuliu" ,@"code":MODULE_MATERIAL_FLOW}];
        [bgSetItems addObject:@{@"item":@"库存" ,@"detail":@"" ,@"icon":@"ico_nav_kucun" ,@"code":MODULE_STOCK}];
        [bgSetItems addObject:@{@"item":@"员工" ,@"detail":@"" ,@"icon":@"ico_nav_yuangong" ,@"code":PAD_EMPLOYEE}];
        if ([[Platform Instance] getScanPayStatus] == 1) {
            [bgSetItems addObject:@{@"item":@"扫码收款" ,@"detail":@"" ,@"icon":@"ico_nav_scancode" ,@"code":PAD_SCANCODE}];
        }
        
        self.modules = [bgSetItems copy];
    }
}


@end

@implementation ModuleView

+ (ModuleView *)creatModule:(NSString *)imageName title:(NSString *)title frame:(CGRect)frame
{
    ModuleView *module         = [[ModuleView alloc] initWithFrame:frame];
    module.backgroundColor     = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    module.layer.masksToBounds = YES;
    module.layer.cornerRadius  = 5.0f;
    
    // 模块icon
    CGFloat labelHeight = 22.0f;
    CGFloat height = CGRectGetHeight(module.bounds)- labelHeight;
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(frame)-height)/2, 0, height, height)];
    imgV.image        = [UIImage imageNamed:imageName];
    [module addSubview:imgV];
    
    // 小模块标题
    CGFloat gapToImgV = 3.0f; // label距离imagv底部距离
    UILabel *label      = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(frame) - labelHeight - gapToImgV, CGRectGetWidth(frame) ,labelHeight)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor     = [UIColor whiteColor];
    label.font          = [UIFont systemFontOfSize:11.0f];
    label.text          = title;
    [module addSubview:label];

    // 最上层的button响应用户点击事件
    UIButton *button       = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    button.frame           = module.bounds;
    module.button          = button;
    [module addSubview:button];
    
    // 权限 指示ImageView
    UIImageView *limitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width - 15, 2, 15, 15)];
    limitImageView.image = [UIImage imageNamed:@"ico_pw_w"];
    limitImageView.hidden = YES;
    module.limitImageView = limitImageView;
    [module addSubview:limitImageView];
    return module;
}

@end
