//
//  GoodsBatchChoiceView2.h
//  retailapp
//
//  Created by zhangzhiliang on 15/10/29.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>


//服鞋商品批量选择
typedef void(^SelectBatchBack)(NSMutableArray* styleGoodsList);
@interface GoodsBatchChoiceView2 : BaseViewController

@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) NSString *searchType;
@property (nonatomic, strong) NSString *searchCodeType;
@property (nonatomic, strong) NSString *searchCode;
@property (nonatomic, strong) NSString *shopId;
@property (nonatomic, strong) NSString *categoryId;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *currentPage;
@property (nonatomic, copy) SelectBatchBack selectBatchBack;

- (void)loaddatas:(NSString *)shopId callBack:(SelectBatchBack)callBack;
- (void)clearCheckStatus;
@end
