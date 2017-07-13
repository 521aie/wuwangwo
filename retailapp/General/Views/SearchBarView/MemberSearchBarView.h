//
//  MemberSearchBarView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/7/8.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISearchBarEvent.h"

@interface MemberSearchBarView : UIView<UITextFieldDelegate, ISearchBarEvent>

@property (nonatomic, strong) IBOutlet UIView *view;

@property(nonatomic, retain) IBOutlet UIView *panel;

@property(nonatomic, retain) IBOutlet UITextField *txtKey;

@property(nonatomic, retain) id<ISearchBarEvent> saleSearchBarEvent;

- (void)initDelegate:(id<ISearchBarEvent>)delegateTmp;

- (void)initView;

//- (void)requestFocus;

@end

