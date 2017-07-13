//
//  PopupBoxViewController.h
//  CardApp
//
//  Created by 邵建青 on 14-3-20.
//  Copyright (c) 2014年 ZMSOFT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopupBoxViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIView *backgroundView;
@property (nonatomic, retain) IBOutlet UIView *mainContainer;

- (void)showMoveIn;

- (void)hideMoveOut;

- (void)afterMoveOut:(NSString *)paramAnimationID finished:(NSNumber *)paramFinished context:(void *)paramContext;

@end
