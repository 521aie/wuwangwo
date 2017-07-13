//
//  LSEditItemText.h
//  retailapp
//
//  Created by guozhi on 2017/3/16.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "EditItemBase.h"
@protocol EditItemTextDelegate;
@interface LSEditItemText : EditItemBase<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UITextField *txtVal;
@property (weak, nonatomic) IBOutlet UILabel *lblDetail;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (nonatomic, weak) id<EditItemTextDelegate> delegate;
/** 是否显示未保存按钮 */
@property (nonatomic, assign) BOOL isShowStatus;
+ (instancetype)editItemText;
/**
 *  字数操过时的提示文字
 */
@property (nonatomic, copy) NSString *txtTip;
@property (nonatomic) int num;
@property (nonatomic) int minNum;

/**
 赋值

 @param label 左侧名称
 @param _hit 详情
 @param req 是否必填
 @param keyboardType 键盘类型
 */
- (void)initLabel:(NSString *)label withHit:(NSString *)_hit isrequest:(BOOL)req type:(UIKeyboardType)keyboardType;


/**
 给右侧的TextField赋值如果与上次的不一样不会显示未保存标签

 @param data 给右侧赋值
 */
- (void)initData:(NSString *)data;

/**
 给右侧的TextField赋值如果与上次的不一样会显示未保存标签

 @param data 给右侧赋值
 */
- (void)changeData:(NSString *)data;

/**
 快速获取右侧的值

 @return 右侧的值
 */
- (NSString *)getStrVal;

/**
 限制最大输入的字数

 @param num 
 */
- (void)initMaxNum:(int)num;


/**
 是否可以编辑

 @param enable 
 */
- (void)editEnabled:(BOOL)enable;

/**
 是否先未保存按钮 默认显示

 @param showSatus 
 */
- (void)showStatus:(BOOL)showSatus;

- (void)initPlaceholder:(NSString *)_placeholder;
- (void)changeLabel:(NSString *)label withVal:(NSString *)data;
@end


@protocol EditItemTextDelegate <NSObject>

@optional;

- (void)editItemText:(LSEditItemText *)editItemText textFieldDidChange:(UITextField *)textField;

// 结束编辑时，回调
- (void)editItemTextEndEditing:(LSEditItemText *)editItem currentVal:(NSString *)val;

- (void)editItemText:(LSEditItemText *)editItemText textFieldDidEndEditing:(UITextField *)textField;
@end
