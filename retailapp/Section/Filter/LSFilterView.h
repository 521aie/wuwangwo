//
//  LSFilterView.h
//  retailapp
//
//  Created by guozhi on 2016/10/25.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSFilterModel.h"
@protocol LSFilterViewDelegate;
@interface LSFilterView : UIView
+ (instancetype)addFilterViewToView:(UIView *)view delegate:(id<LSFilterViewDelegate>)delegate datas:(NSMutableArray<LSFilterModel *> *)datas;
- (void)refreshData;
@end
@protocol LSFilterViewDelegate <NSObject>
@optional
- (void)filterViewdidClickModel:(LSFilterModel *)filterModel;
- (void)filterViewDidClickComfirmBtn;
- (NSMutableArray<LSFilterModel *> *)filterViewDidClickResetBtm;
@end
