//
//  EditItemText.m
//  RestApp
//
//  Created by zxh on 14-4-7.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "EditItemText.h"
#import "SystemUtil.h"
#import "NSString+Estimate.h"
#import "UIView+Sizes.h"
#import "ColorHelper.h"
#import "KeyBoardUtil.h"
#import "Platform.h"
#import "ColorHelper.h"
#import "LSAlertHelper.h"

@implementation EditItemText
@synthesize view;

- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"EditItemText" owner:self options:nil];
    [self addSubview:self.view];
    self.txtVal.returnKeyType=UIReturnKeyDone;
    self.txtVal.delegate=self;
    self.txtVal.text=@"";
    [KeyBoardUtil initWithTarget:self.txtVal];
    self.lblDetail.text=@"";
    self.currentVal = @"";
    self.oldVal = @"";
    [self.txtVal addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

+ (instancetype)editItemText {
    EditItemText *view = [[EditItemText alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48)];
    return view;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

#pragma  initHit.
- (void)initHit:(NSString *)_hit{
    self.lblDetail.text=_hit;
    [self.lblDetail setTextColor:[ColorHelper getTipColor6]];
    if([NSString isBlank:_hit]){
        [self.lblDetail setLs_height:0];
        [self.line setLs_top:46];
        self.lblName.ls_top = 13.0;
        self.txtVal.ls_top = 9.0;
    } else {
        [self.lblDetail sizeToFit];
        [self.line setLs_top:(self.lblDetail.ls_top+self.lblDetail.ls_height+2)];
    }
    
    [self.view setLs_height:[self getHeight]];
    [self setLs_height:[self getHeight]];
}

- (void)initLabel:(NSString *)label withHit:(NSString *)_hit isrequest:(BOOL)req type:(UIKeyboardType)keyboardType{
   
    self.lblName.text = label;
    [self initHit:_hit];
    self.keyboardType = keyboardType;
    UIColor *color = req?[UIColor redColor]:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    NSString* hitStr = req?@"必填":@"可不填";
    if ([self.txtVal respondsToSelector:@selector(setAttributedPlaceholder:)]) {
       self.txtVal.attributedPlaceholder = [[NSAttributedString alloc] initWithString:hitStr attributes:@{NSForegroundColorAttributeName: color}];
    } else {
        self.txtVal.placeholder = hitStr;
    }
    if (keyboardType) {
        self.txtVal.keyboardType = keyboardType;
    }else{
        
    }
    [self initStretchWidth:label];
}

- (void)initPlaceholder:(NSString *)_placeholder {
    UIColor *color = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    if ([self.txtVal respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        self.txtVal.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_placeholder attributes:@{NSForegroundColorAttributeName: color}];
    } else {
        self.txtVal.placeholder=_placeholder;
    }
}

- (void)initIndent:(NSString *)label withHit:(NSString *)_hit isrequest:(BOOL)req type:(UIKeyboardType)keyboardType {
    [self initIndent:label withHit:_hit isrequest:req indent:YES type:keyboardType];
}

- (void)initIndent:(NSString *)label withHit:(NSString *)_hit isrequest:(BOOL)req indent:(BOOL)indent type:(UIKeyboardType)keyboardType {
    self.imgIndent.hidden = !indent;
    self.lblName.text=label;
    
    if (indent) {
        [self.lblName setLs_left:30];
        [self.lblTip setLs_left:30];
        self.lblDetail.frame = CGRectMake(25, 32, 226, 40);
    } else {
        self.lblDetail.frame = CGRectMake(5, 32, 241, 40);
    }
    
    self.lblDetail.text=nil;
    self.lblDetail.font = [UIFont systemFontOfSize:11];
    self.lblDetail.textContainerInset = UIEdgeInsetsZero;
    self.lblDetail.text=_hit;
    [self.lblDetail setTextColor:[ColorHelper getTipColor6]];
    if ([NSString isBlank:_hit]) {
        [self.lblDetail setLs_height:0];
        [self.line setLs_top:46];
    } else {
        [self.lblDetail sizeToFit];
        [self.line setLs_top:(self.lblDetail.ls_top+self.lblDetail.ls_height+2)];
    }
    [self.view setLs_height:[self getHeight]];
    [self setLs_height:[self getHeight]];
    
    self.keyboardType=keyboardType;
    UIColor *color = req?[UIColor redColor]:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    NSString *hitStr=req?@"必填":@"可不填";
    if ([self.txtVal respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        self.txtVal.attributedPlaceholder = [[NSAttributedString alloc] initWithString:hitStr attributes:@{NSForegroundColorAttributeName: color}];
    } else {
        self.txtVal.placeholder=hitStr;
    }
    if (keyboardType) {
        self.txtVal.keyboardType=keyboardType;
    }
    
    if (indent) {
        NSDictionary *attribute = @{NSFontAttributeName: self.lblName.font};
        CGRect rect = [label boundingRectWithSize:CGSizeMake(320,2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
        self.lblName.frame = CGRectMake(30, 10, rect.size.width, rect.size.height);
        [self.txtVal setLs_left:(30+rect.size.width+10)];
        CGFloat width = self.view.ls_width-(30+rect.size.width+10+9);
        [self.txtVal setLs_width:width];
    } else {
        [self initStretchWidth:label];
    }
}

- (float)getHeight{
    return self.line.ls_top+self.line.ls_height+1;
}

- (void)initStretchWidth:(NSString *)label
{
    NSDictionary *attribute = @{NSFontAttributeName: self.lblName.font};
    CGRect rect = [label boundingRectWithSize:CGSizeMake(320,2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    if (rect.size.height > 21.0) {
        self.lblName.frame = CGRectMake(11, 10, rect.size.width, rect.size.height);
        [self.txtVal setLs_left:(11+rect.size.width+10)];
        CGFloat width = self.view.ls_width-(11+rect.size.width+10+9);
        [self.txtVal setLs_width:width];
    }
    else {
        self.lblName.ls_top = 13.0;
    }
}

- (void)initMaxNum:(int)num {
    self.num = num;
}

#pragma mark - textfield.delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
//    printf("===>%s\n" ,string.UTF8String);
    NSString *tfContent = textField.text;
    if ([NSString stringContainsEmoji:&tfContent]) {
        [LSAlertHelper showAlert:@"暂不支持表情符！"];
        textField.text = tfContent;
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (self.tag == 1000) {
        [self initData:self.txtVal.text];
    } else {
          [self changeData:self.txtVal.text];
    }
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField {
    int maxlength = self.num == 0 ? 50 : self.num;
    maxlength = maxlength < 0 ? 0 : maxlength;//加这句话是为了控制输入字数为0的情况
    NSString *txt = textField.text;
    if(txt.length>maxlength){
        textField.text=[txt substringToIndex:maxlength];
        NSString *str = self.txtTip ? self.txtTip :[NSString stringWithFormat:@"字数限制在%d字以内！", maxlength];
        [LSAlertHelper showAlert:str];
    }
    self.currentVal = textField.text;
    [super isChange];
    if ([self.delegate respondsToSelector:@selector(editItemText:textFieldDidChange:)]) {
        [self.delegate editItemText:self textFieldDidChange:textField];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    // 控制输入长度，默认50
    if (self.num == 0) {
        if (textField.text.length > 50) {
            textField.text = [textField.text substringToIndex:50];
        }
    }
    else {
        if (textField.text.length > self.num) {
            textField.text = [textField.text substringToIndex:self.num];
        }
    }
    
    //结束编辑 回调
    if ([self.delegate respondsToSelector:@selector(editItemTextEndEditing:currentVal:)]) {
        [self.delegate editItemTextEndEditing:self currentVal:self.txtVal.text];
    }
}

- (IBAction)onFocusClick:(id)sender {
    [self.txtVal becomeFirstResponder];
}

#pragma initUI
- (void)initLabel:(NSString *)label withVal:(NSString *)data {
    self.oldVal=([NSString isBlank:data]) ? @"" :data;
    self.currentVal=([NSString isBlank:data]) ? @"" :data;
    [self changeLabel:label withVal:data];
}

- (void)initData:(NSString *)data {
    self.oldVal=([NSString isBlank:data]) ? @"" :data;
    self.currentVal=([NSString isBlank:data]) ? @"" :data;
    [self changeData:data];
}

#pragma  ui is changing.
- (void)changeLabel:(NSString *)label withVal:(NSString *)data {
    self.lblName.text = ([NSString isBlank:label]) ? @"" :label;
    [self changeData:data];
}

- (void)changeData:(NSString *)data {
    self.currentVal=([NSString isBlank:data]) ? @"" :data;
    self.txtVal.text=self.currentVal;
    [self changeStatus];
    
}


#pragma data

- (NSString *)getStrVal {
    return self.currentVal;
}


#pragma change status
-(void) changeStatus
{
    BOOL __unused flag=[super isChange];
//    [self.lblName setTextColor:(flag?[UIColor redColor]:[UIColor blackColor])];
}


-(void)clearChange{
    self.oldVal=self.currentVal;
    [self changeStatus];
}

- (void)editEnabled:(BOOL)enable
{
    self.txtVal.enabled = enable;
    self.txtVal.textColor = enable?[ColorHelper getBlueColor]:[ColorHelper getTipColor6];
}

@end
