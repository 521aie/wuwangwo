//
//  EditItemText.h
//  RestApp
//
//  Created by zxh on 14-4-7.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditItemChange.h"
#import "EditItemBase.h"
@protocol EditItemTextDelegate;
@interface EditItemText : EditItemBase<EditItemChange,UITextFieldDelegate>{
    UIView *view;
}
@property (nonatomic, strong) IBOutlet UIView *view;
@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UITextField *txtVal;
@property (nonatomic, strong) IBOutlet UITextView *lblDetail;
@property (nonatomic, strong) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UIImageView *imgIndent;
@property (nonatomic, weak) id<EditItemTextDelegate> delegate;
/**
 *  字数操过时的提示文字
 */
@property (nonatomic, copy) NSString *txtTip;

@property (nonatomic) int num;
@property (nonatomic) int minNum;
@property (nonatomic) int keyboardType;
+ (instancetype)editItemText;
- (void)initLabel:(NSString*)label withHit:(NSString *)_hit isrequest:(BOOL)req type:(UIKeyboardType)keyboardType;
- (void)initIndent:(NSString*)label withHit:(NSString *)_hit isrequest:(BOOL)req type:(UIKeyboardType)keyboardType;
- (void)initIndent:(NSString*)label withHit:(NSString *)_hit isrequest:(BOOL)req indent:(BOOL)indent type:(UIKeyboardType)keyboardType;

//限制最大输入字符长度
-(void) initMaxNum:(int) num;

- (void) initLabel:(NSString *)label  withVal:(NSString*)data;
- (void) initData:(NSString*)data;

- (void) changeLabel:(NSString*)label withVal:(NSString*)data;
- (void) changeData:(NSString*)data;

-(IBAction)onFocusClick:(id)sender;

//得到具体值.
-(NSString*) getStrVal;

- (void)editEnabled:(BOOL)enable;

- (void)initHit:(NSString *)_hit;
- (void)initPlaceholder:(NSString *)_placeholder;


@end

@protocol EditItemTextDelegate <NSObject>

@optional;

- (void)editItemText:(EditItemText *)editItemText textFieldDidChange:(UITextField *)textField;

// 结束编辑时，回调
- (void)editItemTextEndEditing:(EditItemText *)editItem currentVal:(NSString *)val;

- (void)editItemText:(EditItemText *)editItemText textFieldDidEndEditing:(UITextField *)textField;
@end

