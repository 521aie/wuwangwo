//
//  MemoInputBox.h
//  RestApp
//
//  Created by zxh on 14-4-18.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
@protocol MemoInputClient;
@interface MemoInputView : LSRootViewController<UITextFieldDelegate,UITextViewDelegate>


@property (nonatomic, retain) IBOutlet UITextView *txtMemo;
@property (nonatomic, retain) IBOutlet UILabel *lblTip;
@property (nonatomic, copy) NSString * titleName;

@property (weak, nonatomic) IBOutlet UILabel *lblPlaceHolder;
@property (nonatomic, copy) NSString *placeHolder;

@property (nonatomic) id<MemoInputClient> delegate;
@property int event;
@property int lenLimit;

- (void)limitShow:(NSInteger)eventTemp delegate:(id<MemoInputClient>)delegate title:(NSString*)titleName val:(NSString*)val limit:(int)limit;
@end


@protocol MemoInputClient <NSObject>

- (void)finishInput:(int)event content:(NSString*)content;

@end
