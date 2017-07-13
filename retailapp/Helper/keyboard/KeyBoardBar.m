//
//  KeyBoardBar.m
//  CardApp
//
//  Created by 邵建青 on 13-12-23.
//  Copyright (c) 2013年 ZMSOFT. All rights reserved.
//

#import "KeyBoardBar.h"
#import "SystemUtil.h"

#define HIDE_BTN_HEIGHT 32

@implementation KeyBoardBar

- (id)initWithFrame:(CGRect)frame client:(id<KeyBoardBarClient>)client
{
    self = [super initWithFrame:frame];
    if (self) {
        keyBoardBarClient = client;
        UIButton *hideBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_W - HIDE_BTN_HEIGHT, 0, HIDE_BTN_HEIGHT, HIDE_BTN_HEIGHT)];
        [hideBtn setImage:[UIImage imageNamed:@"ico_kb.png"] forState:UIControlStateNormal];
        [self addSubview:hideBtn];
        [hideBtn addTarget:self action:@selector(hideBtClick:) forControlEvents:UIControlEventTouchDown];
    }
    return self;
}

- (void)hideBtClick:(id)sender
{
    [SystemUtil hideKeyboard];
    //[keyBoardBarClient hideKeyBorad];
}

@end
