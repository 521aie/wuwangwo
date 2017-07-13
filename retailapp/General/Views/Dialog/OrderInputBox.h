//
//  OrderInputBox.h
//  retailapp
//
//  Created by hm on 15/12/26.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "PopupBoxViewController.h"


@class InputTarget;

@protocol OrderInputBoxDelegate <NSObject>
@required
- (void)selectTarget:(InputTarget *)inputTarget;
- (void)deSelectTarget:(InputTarget *)inputTarget;
@optional
- (void)inputOkClick:(NSString *)num textField:(UITextField *)textField;
@end


@interface OrderInputBox : PopupBoxViewController
@property (nonatomic) BOOL isFirstTime;
@property (nonatomic, weak) IBOutlet UILabel *lblVal;
@property (nonatomic, retain) IBOutlet UIButton* btnDot;
@property (nonatomic, retain) IBOutlet UIButton* btnSymbol;
@property (nonatomic, strong) InputTarget *inputTarget;
@property (nonatomic, weak) id<OrderInputBoxDelegate> delegate;
@property (nonatomic, assign) BOOL isFloat;
@property (nonatomic, assign) BOOL isSymbol;
@property (nonatomic, assign) NSInteger integerLimit;
@property (nonatomic, assign) NSInteger digitLimit;
@property (nonatomic, copy) NSString *inputNum;


+ (void)initOrderInputBox;

+ (void)show:(InputTarget *)inputTarget delegate:(id<OrderInputBoxDelegate>)delegate isFloat:(BOOL)isFloat isSymbol:(BOOL)isSymbol;

+ (void)limitInputNumber:(NSInteger)integerLimit digitLimit:(NSInteger)digitLimit;

- (IBAction)btnClick:(id)sender;

- (IBAction)btnBackClick:(id)sender;

- (IBAction)confirmBtnClick:(id)sender;

- (IBAction)cancelBtnClick:(id)sender;

@end
