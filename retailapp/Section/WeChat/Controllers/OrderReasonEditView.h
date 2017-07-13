//
//  OrderReasonEditView.h
//  retailapp
//
//  Created by Jianyong Duan on 15/12/9.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigateTitle2.h"

@interface OrderReasonEditView : BaseViewController

//input
@property (nonatomic, strong) NSMutableArray *reasonList;

@property (nonatomic,weak) IBOutlet UIView* titleDiv;
@property (nonatomic, strong) NavigateTitle2* titleBox;

@property (weak, nonatomic) IBOutlet UITableView *mainGrid;

- (IBAction)addReasonClick:(id)sender;

@end
