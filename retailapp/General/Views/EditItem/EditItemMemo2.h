//
//  EditItemMemo2.h
//  retailapp
//
//  Created by hm on 15/9/6.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "EditItemBase.h"
#import "EditItemChange.h"
typedef void(^myBlock)();
@interface EditItemMemo2 : EditItemBase<EditItemChange,UITextViewDelegate>
@property (nonatomic, weak) IBOutlet UIView     *view;
@property (nonatomic, weak) IBOutlet UILabel    *lblName;
@property (nonatomic, weak) IBOutlet UITextView *lblVal;
@property (nonatomic, weak) IBOutlet UIView     *line;
@property (weak, nonatomic) IBOutlet UIButton *btnLocation;
@property BOOL isReq;
@property (nonatomic) int keyboardType;
@property (nonatomic, assign) int num;
/**当输入内容较多时刷新位置*/
@property (nonatomic,copy) myBlock block;

- (void) initLabel:(NSString *)label withPlaceholder:(NSString*)placeholder withReq:(BOOL)req block:(myBlock)block;
- (void) initData:(NSString*)data;
-(void) initMaxNum:(int) num;

//得到具体值.
-(NSString*) getStrVal;
- (void) changeData:(NSString*)data;
- (void)editEnable:(BOOL)enable;
- (void)initLocation:(NSString *)image action:(SEL)selector delegate:(id)delegate;

@end

