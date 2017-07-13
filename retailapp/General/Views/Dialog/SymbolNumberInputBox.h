//
//  SymbolNumberInputBox.h
//  RestApp
//
//  Created by hm on 15/3/17.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "PopupBoxViewController.h"

@protocol SymbolNumberInputClient;
@class AppController;
@interface SymbolNumberInputBox : PopupBoxViewController
{
    __weak id<SymbolNumberInputClient> symbolNumberInputClient;
    
    NSArray *data;
    
    NSInteger event;
    
    NSInteger integerLimit;
    
    NSInteger digitLimit;
}

@property (nonatomic) BOOL isFirstTime;
@property (nonatomic) BOOL symbol;
@property (nonatomic) BOOL isFloat;
@property (nonatomic, retain) IBOutlet UILabel* lblTitle;
@property (nonatomic, retain) IBOutlet UILabel* lblVal;
@property (nonatomic, retain) IBOutlet UIButton* btnDot;
@property (nonatomic, retain) IBOutlet UIView* background;
@property (nonatomic, retain) IBOutlet UIButton* btnSymbol;
+ (void)initData:(NSString *)data;

+ (void)initNumberInputBox;

+ (void)show:(NSString *)title client:(id<SymbolNumberInputClient>) client isFloat:(BOOL)isFloat isSymbol:(BOOL)isSymbol event:(NSInteger)event;

+ (void)limitInputNumber:(NSInteger)integerLimit digitLimit:(NSInteger)digitLimit;

+ (void)hide;

- (IBAction)btnClick:(id)sender;

- (IBAction)btnBackClick:(id)sender;

- (IBAction)confirmBtnClick:(id)sender;

- (IBAction)cancelBtnClick:(id)sender;

@end

@protocol SymbolNumberInputClient <NSObject>

- (void) numberClientInput:(NSString*)val event:(NSInteger)eventType;

@end
