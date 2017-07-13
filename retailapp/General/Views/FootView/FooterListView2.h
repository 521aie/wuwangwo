//
//  FooterListView2.h
//  retailapp
//
//  Created by zhangzhiliang on 15/8/26.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FooterListEvent.h"

@interface FooterListView2 : UIView

@property (nonatomic, strong) IBOutlet UIView *view;

@property (nonatomic, strong) IBOutlet UIImageView *imgEdit;
@property (nonatomic, strong) IBOutlet UIButton *btnEdit;

@property (nonatomic, strong) IBOutlet UIImageView *imgAdd;
@property (nonatomic, strong) IBOutlet UIButton *btnAdd;

@property (nonatomic,strong) id<FooterListEvent> delegate;

-(void) initDelegate:(id<FooterListEvent>) delegate btnArrs:(NSArray*) arr;

- (IBAction) onEditClickEvent:(id)sender;
- (IBAction) onAddClickEvent:(id)sender;

@end
