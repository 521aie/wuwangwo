//
//  FooterMultiView.h
//  RestApp
//
//  Created by zxh on 14-6-25.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FooterMultiEvent <NSObject>

// 选择全部
- (void)checkAllEvent;
// 全不选
- (void)notCheckAllEvent;
@end

@interface FooterMultiView : UIView

@property (nonatomic, strong) IBOutlet UIView *view;
@property (nonatomic, strong) IBOutlet UIImageView *imgChkAll;
@property (nonatomic, strong) IBOutlet UIButton *btnChk;
@property (nonatomic, strong) IBOutlet UIImageView *imgNotChkAll;
@property (nonatomic, strong) IBOutlet UIButton *btnNotChk;

@property (nonatomic,strong) id<FooterMultiEvent> delegate;

-(void) initDelegate:(id<FooterMultiEvent>) delegateTemp;

- (IBAction) onCheckAllClickEvent:(id)sender;

- (IBAction) onNotCheckAllClickEvent:(id)sender;

+ (FooterMultiView *)footerMuiltSelectView:(id<FooterMultiEvent>)delegate;
@end


