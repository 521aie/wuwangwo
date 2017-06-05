//
//  GoodsCommentVo.h
//  retailapp
//
//  Created by Jianyong Duan on 15/11/3.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

@interface GoodsCommentVo : Jastor

//goodsCommentid			商品评论Id			Integer
@property (nonatomic) NSInteger goodsCommentid;

//comment			评论内容			String
@property (nonatomic, copy) NSString *comment;

//commentLevel			评论等级			String
@property (nonatomic, copy) NSString *commentLevel;

//customerName			评论人			String
@property (nonatomic, copy) NSString *customerName;

//skuInfo			sku信息			String
@property (nonatomic, copy) NSString *skuInfo;

//commentTime			评论时间			String
@property (nonatomic, copy) NSString *commentTime;
//customerTel			评论手机号		String
@property (nonatomic, copy) NSString *customerTel;

@end
