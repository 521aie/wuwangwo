//
//  ShopCommentTop.m
//  retailapp
//
//  Created by 小龙虾 on 2017/4/19.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "ShopCommentTop.h"
#import "ShopCommentIem.h"
#import "ShopCommentReportVo.h"


@interface ShopCommentTop ()
//店铺名称
@property(nonatomic, strong)UILabel *lblShopname;
//好评度
@property(nonatomic, strong)UILabel *lblGood;
//服务态度
@property(nonatomic, strong)ShopCommentIem *attitude;
//描述相符
@property(nonatomic, strong)ShopCommentIem *describe;
//物流服务
@property(nonatomic, strong)ShopCommentIem *logistics;
@end
@implementation ShopCommentTop

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
    self.imgViewShop = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 60, 60)];
    [self addSubview:self.imgViewShop];
    
    self.lblShopname = [[UILabel alloc] initWithFrame:CGRectMake(98, 15, 214, 21)];
    [self.lblShopname setTextAlignment:NSTextAlignmentLeft];
    [self.lblShopname setFont:[UIFont systemFontOfSize:14.0]];
    [self addSubview:self.lblShopname];
    
    self.lblGood = [[UILabel alloc] initWithFrame:CGRectMake(98, 38, 88, 11)];
    [self.lblGood setTextAlignment:NSTextAlignmentLeft];
    [self.lblGood setFont:[UIFont systemFontOfSize:10.0]];
    [self addSubview:self.lblGood];
    
    self.attitude = [[ShopCommentIem alloc] initWithFrame:CGRectMake(98, 56, SCREEN_W-98, 11)];
    [self addSubview:self.attitude];
    
    self.describe = [[ShopCommentIem alloc] initWithFrame:CGRectMake(98, 75, SCREEN_W-98, 11)];
    [self addSubview:self.describe];
    
    self.logistics = [[ShopCommentIem alloc] initWithFrame:CGRectMake(98, 94, SCREEN_W-98, 11)];
    [self addSubview:self.logistics];
}

-(void)upDataName:(NSString *)name
{
    self.lblShopname.text = name;
}

-(void)upDataInfo:(ShopCommentReportVo *)model andType:(int)type
{
    self.lblGood.text = [NSString stringWithFormat:@"好评率%@", model.feedbackRate];
    [self.attitude showTip:@"服务态度" andScore:model.attitudeScore];
    if (type) {
        [self.describe showTip:@"描述相符" andScore:[model shoppingOrDescriptionScore:type]];
        [self.logistics showTip:@"物流服务" andScore:[model servicOrshippingScore:type]];
    }else{
        [self.describe showTip:@"购物环境" andScore:[model shoppingOrDescriptionScore:type]];
        [self.logistics showTip:@"售后服务" andScore:[model servicOrshippingScore:type]];
    }
}

@end
