//
//  LSMemberCardListController.h
//  retailapp
//
//  Created by guozhi on 2016/10/28.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//
typedef void (^CallBlock) (NSMutableArray *list);
#import <UIKit/UIKit.h>

@interface LSMemberCardListController : UIViewController
- (void)loadData:(NSMutableArray *)datas callBlock:(CallBlock)callBlock;
@end
