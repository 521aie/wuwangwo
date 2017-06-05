//
//  GoodsSearchBarView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/7/22.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISearchBarEvent.h"

@interface GoodsSearchBarView : UIView <UITextFieldDelegate, ISearchBarEvent>

@property (nonatomic, strong) IBOutlet UIView *view;

@property(nonatomic, retain) IBOutlet UIView *panel;

@property(nonatomic, retain) IBOutlet UITextField *txtKey;

@property(nonatomic, retain) IBOutlet UIButton *btnSweep;

@property(nonatomic, retain) id<ISearchBarEvent> saleSearchBarEvent;

@property(nonatomic, retain) NSString* event;

- (void)initDelegate:(id<ISearchBarEvent>)delegateTmp;

- (void)initEvent:(NSString*)event;

- (void)initView;

- (void)requestFocus;

- (IBAction)sweepBtnClick:(id)sender;

@end
