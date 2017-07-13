//
//  LSWechatGoodBatchSelectViewController.h
//  retailapp
//
//  Created by guozhi on 16/8/29.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSWechatGoodBatchSelectViewController : UIViewController
/**
 *  搜索框内容
 */
@property (nonatomic, copy) NSString *searchCode;
/**
 *  分类Id
 */
@property (nonatomic, strong) NSString *categoryId;
/**
 *  seaechType 1：按输入关键字查询 2：按筛选条件查询
 */
@property (nonatomic, assign) int searchType;

@property (nonatomic, retain) NSString *shopId;
@end
