//
//  EditItemList2.m
//  retailapp
//
//  Created by diwangxie on 16/4/28.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "EditItemList4.h"
#import "SystemUtil.h"
#import "NSString+Estimate.h"
#import "UIView+Sizes.h"
#import "ColorHelper.h"
#import "SystemUtil.h"

@implementation EditItemList4

@synthesize view;

- (void)awakeFromNib {
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"EditItemList4" owner:self options:nil];
    [self addSubview:self.view];
}

- (void)initFromNib {
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"EditItemList4" owner:self options:nil];
    [self addSubview:self.view];
}

- (void)initCode:(NSDictionary *)dic {
    // 商品名称
    self.lblStyleName.text = [dic objectForKey:@"originalGoodsName"];
    // 商超：条形码 服鞋：店内码，尺码和颜色
    if ([ObjectUtil isNotNull:[dic objectForKey:@"expansion"]]) {
        NSData *data = [[dic objectForKey:@"expansion"] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if ([NSString isNotBlank:[dict objectForKey:@"style_code"]]) {
            self.lblStyleCode.text = [dict objectForKey:@"style_code"];
            self.lblStyleAttribute.text = [dict objectForKey:@"sku"];
        } else if ([NSString isNotBlank:[dict objectForKey:@"bar_code"]]) {
            self.lblStyleCode.text = [dict objectForKey:@"bar_code"];
            self.lblStyleAttribute.text = @"";
        }
    }
    
    if([[dic objectForKey:@"isRatio"] intValue] == 1) {
        self.lblFeeAndCount.text = [NSString stringWithFormat:@"￥%@X%@",[dic objectForKey:@"salesPrice"],[dic objectForKey:@"accountNum"]];
    } else {
        self.lblFeeAndCount.text = [NSString stringWithFormat:@"￥%@X%@",[dic objectForKey:@"price"],[dic objectForKey:@"accountNum"]];
    }
    
    self.lblReturnState.hidden = YES;
    NSString *returnStr = nil;
    if ([ObjectUtil isNotNull:[dic objectForKey:@"returnStatus"]]) {
        returnStr=[self getStatusString:[[dic objectForKey:@"returnStatus"] shortValue]];
        self.lblReturnState.hidden = NO;
        self.lblReturnState.text = returnStr;
    }
    
    if ([ObjectUtil isNotNull:[dic objectForKey:@"returnNum"]]) {
        returnStr = [NSString stringWithFormat:@"%@",[self getStatusString:[[dic objectForKey:@"returnStatus"] shortValue]]];
        self.lblReturnState.text = returnStr;
    }
}

- (float)getHeight {
    return self.line.ls_top + self.line.ls_height + 1;
}

- (NSString *)getStatusString:(short)status {
    NSDictionary *statusDic = @{@"1":@"待审核", @"2":@"退款成功", @"3":@"同意退货", @"4":@"退货中", @"5":@"待退款", @"6":@"拒绝退货", @"7":@"拒绝退款", @"8":@"取消退货", @"9":@"退款失败"};
    NSString *statusString = [statusDic objectForKey:[NSString stringWithFormat:@"%i", status]];
    if ([NSString isNotBlank:statusString]) {
        return statusString;
    } else {
        return @"";
    }
}

@end
