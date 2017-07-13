//
//  SelectItemList.h
//  retailapp
//
//  Created by guozhi on 16/5/15.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
#import "INameItem.h"
typedef void (^CallBlock)(id<INameItem>item);
@interface SelectItemList : LSRootViewController
- (instancetype)initWithtxtTitle:(NSString *)txtTitle txtPlaceHolder:(NSString *)txtPlaceHolder;
- (void)selectId:(NSString *)selectId list:(NSMutableArray *)list callBlock:(CallBlock)callBlock;
@end
