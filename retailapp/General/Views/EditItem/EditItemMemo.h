//
//  EditItemMemo.h
//  RestApp
//
//  Created by zxh on 14-4-18.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditItemBase.h"
#import "EditItemChange.h"
#import "IEditItemMemoEvent.h"

@interface EditItemMemo : EditItemBase<EditItemChange>

@property (nonatomic, weak) id<IEditItemMemoEvent> delegate;
//必填项 设置在 标题左边
@property (nonatomic, strong) IBOutlet UIView *view;
@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UILabel *lblHit;
@property (nonatomic, strong) IBOutlet UIButton *btn;
@property (nonatomic, strong) IBOutlet UITextView *lblVal;
@property (nonatomic, strong) IBOutlet UIView *line;
@property BOOL isReq;
@property (nonatomic) int keyboardType;
@property (weak, nonatomic) IBOutlet UIButton *btnLocation;

@property (nonatomic, assign) BOOL isEdit;
+ (instancetype)editItemMemo;
- (void)initLabel:(NSString*)label isrequest:(BOOL)req delegate:(id<IEditItemMemoEvent>) delegate;

- (void) initLabel:(NSString *)label  withVal:(NSString*)data;
- (void) initData:(NSString*)data;

- (void) changeLabel:(NSString*)label withVal:(NSString*)data;
- (void) changeData:(NSString*)data;

-(IBAction)onFocusClick:(id)sender;
- (void)initLocation:(NSString *)image action:(SEL)selector delegate:(id)delegate ;
//得到具体值.
-(NSString*) getStrVal;
- (void)editEnable:(BOOL)enable;
@end
