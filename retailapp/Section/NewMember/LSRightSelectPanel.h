//
//  LSRightSelectPanel.h
//  retailapp
//
//  Created by taihangju on 16/10/7.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INameItem.h"

@protocol LSRightSelectPanelDelegate;
@interface LSRightSelectPanel : UIView

+ (instancetype)rightSelectPanel:(NSString *)title delegate:(id<LSRightSelectPanelDelegate>)delegate;
- (void)addToView:(UIView *)view;
- (void)loadDataList:(NSArray *)dataArray;
@end

@protocol LSRightSelectPanelDelegate <NSObject>

- (void)rightSelectPanel:(LSRightSelectPanel *)panel select:(id<INameItem>)obj;
@end
