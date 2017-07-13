//
//  CustomerReturnPayVo.h
//  retailapp
//
//  Created by diwangxie on 16/5/13.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomerReturnPayVo : NSObject

@property (nonatomic) short payType;  /*<退款方式： 1 银行 2、微信 3、支付宝>*/
@property (nonatomic,copy) NSString  *payTypeName;
@property (nonatomic,copy) NSString  *payAccount;      //退款帐号
@property (nonatomic,copy) NSString  *bankProvince;      //开户城市
@property (nonatomic,copy) NSString  *bankCity;
@property (nonatomic,copy) NSString  *accountName;     // 退款人
@property (nonatomic,copy) NSString  *bankName;        // 银行名
@property (nonatomic,copy) NSString  *branchName;   // 开户支行

+(CustomerReturnPayVo *)convertToCustomerReturnPayVo:(NSDictionary*)dic;

+(NSDictionary*)getDictionaryData:(CustomerReturnPayVo *)customerReturnPayVo;

@end
