//
//  ScanPayView.h
//  retailapp
//
//  Created by guozhi on 16/1/21.
//  Copyright (c) 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
#import "ISearchBarEvent.h"

@interface ScanPayView : LSRootViewController<ISearchBarEvent>
- (void)loadScanView;
@end
