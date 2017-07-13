//
//  OpenProtocolView.h
//  retailapp
//
//  Created by Jianyong Duan on 15/10/10.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NavigateTitle2;

@interface OpenProtocolView : BaseViewController

@property (nonatomic) NavigateTitle2 *titleBox;
@property (weak, nonatomic) IBOutlet UIView *titleDiv;

@end
