//
//  GoodsChoiceView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/9/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>


//服鞋版商品单选页面
@class StyleGoodsVo;
typedef void(^SelectGoodsBack)(StyleGoodsVo* goodsItem);
@interface GoodsSingleChoiceView2 : BaseViewController

@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) NSString *searchType;
@property (nonatomic, strong) NSString *searchCodeType;
@property (nonatomic, strong) NSString *searchCode;
@property (nonatomic, strong) NSString *shopId;
@property (nonatomic, strong) NSString *categoryId;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *currentPage;
@property (nonatomic, copy) SelectGoodsBack selectBlock;

-(void) loaddatas:(NSString*) shopId callBack:(SelectGoodsBack)callBack;
@end

