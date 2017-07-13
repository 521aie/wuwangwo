//
//  NavigateTitle2.h
//  retailapp
//
//  Created by hm on 15/6/26.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INavigateEvent.h"

@interface NavigateTitle2 : UIView

@property (nonatomic, weak) id<INavigateEvent> delegate;
@property (nonatomic, strong) IBOutlet UILabel *lblTitle;
@property (nonatomic, strong) IBOutlet UIButton *btnBack;
@property (nonatomic, strong) IBOutlet UIButton *btnUser;
@property (nonatomic, strong) IBOutlet UILabel *lblLeft;
@property (nonatomic, strong) IBOutlet UILabel *lblRight;
@property (nonatomic, strong) IBOutlet UIImageView *imgBack;
@property (nonatomic, strong) IBOutlet UIImageView *imgMore;

//@property (nonatomic, assign) BOOL isResign;

+ (NavigateTitle2 *)navigateTitle:(id<INavigateEvent>)host;
- (void)initWithName:(NSString *)title backImg:(NSString *)backImgPath moreImg:(NSString *)moreImgPath;


- (void)btnVisibal:(BOOL)show direct:(Direct_Flag)flag;
- (void)navVisibal:(BOOL)show direct:(Direct_Flag)flag;
- (void)loadImg:(NSString *)img direct:(Direct_Flag)flag;
- (void)editTitle:(BOOL)change act:(NSInteger)action;

- (IBAction)btnMoreClick:(id)sender;
- (IBAction)btnBackClick:(id)sender;

@end


