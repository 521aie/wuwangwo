//
//  GoodsCommentReportVo.h
//  retailapp
//
//  Created by Jianyong Duan on 15/11/3.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

@interface GoodsCommentReportVo : Jastor

//goodscommentReportid			商品评论Id			Integer
@property (nonatomic) NSInteger goodscommentReportid;

//shopId			店铺Id			String
@property (nonatomic, copy) NSString *shopId;

@property (nonatomic) NSInteger shopType;

//goodsId			商品ID			String
@property (nonatomic, copy) NSString *goodsId;

//goodsName			商品名/款式名			String
@property (nonatomic, copy) NSString *goodsName;

//goodsCode			条形码/款号			String
@property (nonatomic, copy) NSString *goodsCode;

//picPath			商品图片路径			String
@property (nonatomic, copy) NSString *picPath;

//goodCount			好评数			Integer
@property (nonatomic) NSInteger goodCount;

//mediumCount			中评数			Integer
@property (nonatomic) NSInteger mediumCount;

//badCount			差评数			Integer
@property (nonatomic) NSInteger badCount;

//totalCount			总评数			Integer
@property (nonatomic) NSInteger totalCount;

//feedbackRate			好评率			String
@property (nonatomic, copy) NSString *feedbackRate;

@end
