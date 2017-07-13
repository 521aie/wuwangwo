//
//  WeChatAccountInfo.h
//  retailapp
//
//  Created by diwangxie on 16/4/20.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigateTitle2.h"
@interface AccountInfo : BaseViewController<INavigateEvent>
@property (weak, nonatomic) IBOutlet UIView *titleDiv;
@property (nonatomic, strong) NavigateTitle2 *titileBox;

@property (weak, nonatomic) IBOutlet UITableView *mainGrid;

@end
