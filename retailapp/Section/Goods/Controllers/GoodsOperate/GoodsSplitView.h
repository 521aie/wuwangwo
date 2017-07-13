//
//  GoodsSplitView.h
//  retailapp
//
//  Created by guozhi on 16/2/23.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
typedef NS_ENUM(NSInteger,Action) {
    ActionAddEvent,
    ActionEditEvent,
};

@interface GoodsSplitView : LSRootViewController
/**区分添加和编辑*/
@property (nonatomic, assign) Action action;
/**编辑需要用到的商品Id*/
@property (nonatomic, copy) NSString *goodsId;
/*页面标题*/
@property (nonatomic, copy) NSString *title1;
@end
