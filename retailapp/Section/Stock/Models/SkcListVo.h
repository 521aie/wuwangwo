//
//  SkcListVo.h
//  retailapp
//
//  Created by guozhi on 15/10/22.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SkcListVo : NSObject
@property (nonatomic, copy) NSString *skcCode;  //skc码
@property (nonatomic, copy) NSString *colorVal; //颜色值
@property (nonatomic, copy) NSString *colorNumber;//颜色值


@property (nonatomic, strong) NSNumber *hangTagPrice; //吊牌价 BigDecimal
@property (nonatomic, strong) NSNumber *purchasePrice; //颜色价格 BigDecimal
@property (nonatomic, strong) NSNumber *supplyPrice; //供货价 BigDecimal
@property (nonatomic, strong) NSNumber *maxValidSupplyPriceRate; //最高有效供货折扣率 BigDecimal
@property (nonatomic, strong) NSNumber *shopWeeksales; //门店周销量 BigDecimal
@property (nonatomic, strong) NSNumber *microShopWeekSales; //微店周销量 BigDecimal
@property (nonatomic, strong) NSArray *sizeList;



@property (nonatomic, strong) NSNumber *recommendCount; //推荐订量 BigDecimal
@property (nonatomic, strong) NSNumber *totalCount;
@property (nonatomic, strong) NSNumber *totalMoney;
@property (nonatomic, strong) NSNumber *powerTotalMoney;
@property (nonatomic, strong) NSNumber *totalAdjust; //总调整
@property (nonatomic, strong) NSNumber *supplyDiscountRate; //供货折扣率 BigDecimal
@property (nonatomic, assign) BOOL isChange; 


@property (nonatomic, strong) NSMutableArray *tfDhList;
@property (nonatomic, strong) NSMutableArray *oldDhList;
@property (nonatomic, strong) UILabel *labelTotalCount;
@property (nonatomic, strong) UILabel *labelTotalMoney;
@property (nonatomic, strong) UILabel *labelNowCount;
/**记录供货价的textField*/
@property (nonatomic, strong) UITextField *textField;
/**记录供货价的值*/
@property (nonatomic, assign) float oldValue;

@end
