//
//  EditItemText2.h
//  retailapp
//
//  Created by zhangzhiliang on 15/7/15.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditItemChange.h"
#import "EditItemBase.h"
typedef void(^myBlock)();
@protocol EditItemText2Delegate <NSObject>

- (void)showButtonTag:(NSInteger)tag;

@end

@interface EditItemText2 : EditItemBase<EditItemChange,UITextFieldDelegate>{
    UIView *view;
}
@property (nonatomic, strong) IBOutlet UIView *view;
@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UITextField *txtVal;
@property (nonatomic, strong) IBOutlet UIButton *btnButton;
@property (nonatomic, strong) IBOutlet UIView *line;
@property (nonatomic) int keyboardType;
@property (nonatomic,assign) id<EditItemText2Delegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *lblDetail;
@property (nonatomic) int num;
/**当输入内容较多时刷新位置*/
@property (nonatomic,copy) myBlock block;
//限制最大输入字符长度
-(void) initMaxNum:(int) num;

- (void)initLabel:(NSString*)label withHit:(NSString *)hit withType:(NSString*) typeName showTag:(int)tag delegate:(id<EditItemText2Delegate>)delegate;
- (void)initLabel:(NSString*)label withHit:(NSString *)hit isrequest:(BOOL)req type:(UIKeyboardType)keyboardType withType:(NSString*) typeName showTag:(int)tag delegate:(id<EditItemText2Delegate>)delegate;

- (void) initLabel:(NSString *)label  withVal:(NSString*)data;
- (void) initData:(NSString*)data;

- (void) changeLabel:(NSString*)label withVal:(NSString*)data;
- (void) changeData:(NSString*)data;

-(IBAction)onFocusClick:(id)sender;

-(void) initPosition:(NSUInteger)num;

//得到具体值.
-(NSString*) getStrVal;
- (void)editEnabled:(BOOL)enable;
+ (instancetype)editItemText;
@end
