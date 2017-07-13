//
//  PopupBoxViewController.m
//  CardApp
//
//  Created by 邵建青 on 14-3-20.
//  Copyright (c) 2014年 ZMSOFT. All rights reserved.
//

#import "PopupBoxViewController.h"

@implementation PopupBoxViewController

- (void)showMoveIn
{
    self.view.hidden = NO;
    CGRect mainContainerFrame = self.mainContainer.frame;
    CGRect viewFrame = self.view.frame;
    self.mainContainer.frame = CGRectMake(mainContainerFrame.origin.x, viewFrame.size.height, mainContainerFrame.size.width, mainContainerFrame.size.height);
    [UIView animateWithDuration:0.2 animations:^{
        self.mainContainer.frame = CGRectMake(mainContainerFrame.origin.x, viewFrame.size.height - mainContainerFrame.size.height, mainContainerFrame.size.width, mainContainerFrame.size.height);
        self.backgroundView.alpha = 0.2;
    } completion:^(BOOL finished) {
        self.mainContainer.frame = CGRectMake(mainContainerFrame.origin.x, viewFrame.size.height - mainContainerFrame.size.height, mainContainerFrame.size.width, mainContainerFrame.size.height);
    }];
}

- (void)hideMoveOut
{
    CGRect mainContainerFrame = self.mainContainer.frame;
    CGRect viewFrame = self.view.frame;
    [UIView animateWithDuration:0.2 animations:^{
        self.mainContainer.frame = CGRectMake(mainContainerFrame.origin.x, viewFrame.size.height, mainContainerFrame.size.width, mainContainerFrame.size.height);
        self.backgroundView.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.view.hidden = YES;
//        [self.view removeFromSuperview];
        self.mainContainer.frame = CGRectMake(mainContainerFrame.origin.x, viewFrame.size.height - mainContainerFrame.size.height, mainContainerFrame.size.width, mainContainerFrame.size.height);
    }];
}

- (void)afterMoveOut:(NSString *)paramAnimationID finished:(NSNumber *)paramFinished context:(void *)paramContext
{
    self.view.hidden = YES;
}

@end
