//
//  LSGoodsBatchViewController.h
//  retailapp
//
//  Created by guozhi on 16/9/13.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
@interface LSGoodsBatchViewController : LSRootViewController
@property (nonatomic,strong) NSString *shopId;
@property (nonatomic, retain) NSString *searchType;

@property (nonatomic, retain) NSString *searchCode;

@property (nonatomic, retain) NSString *barCode;


@property (nonatomic, retain) NSString *categoryId;
@end
