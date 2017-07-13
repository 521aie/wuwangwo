//
//  EditItemMemo2.m
//  retailapp
//
//  Created by hm on 15/9/6.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "EditItemMemo2.h"
#import "NSString+Estimate.h"
#import "UIView+Sizes.h"
#import "KeyBoardUtil.h"
#import "ColorHelper.h"
#import "LSAlertHelper.h"
#import "KeyBoardUtil.h"

@interface EditItemMemo2 ()

@property (nonatomic,copy) NSString* placeStr;
@property (nonatomic, assign) BOOL req;
@property (nonatomic,weak) UILabel *placeholderLabel; //这里先拿出这个label以方便我们后面的使用

@end

@implementation EditItemMemo2

-(void) awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"EditItemMemo2" owner:self options:nil];
    [self addSubview:self.view];
    [KeyBoardUtil initWithTarget:self.lblVal];
}

- (void) initLabel:(NSString *)label withPlaceholder:(NSString*)placeholder withReq:(BOOL)req block:(myBlock)block
{
    self.req = req;
    self.block = block;
    self.lblName.text = label;
    [self initPlaceHolder];
    self.placeStr = placeholder;
    self.placeholderLabel.text = placeholder;
    self.placeholderLabel.textColor = self.req ? [UIColor redColor] : [UIColor grayColor];
    [self initVal:placeholder];
    
    self.lblVal.textContainer.lineFragmentPadding = 0;
}

- (void)initPlaceHolder {
    UILabel *placeholderLabel = [[UILabel alloc]initWithFrame:CGRectMake(2, 8, self.lblVal.frame.size.width - 4, 13)];//添加一个占位label
    placeholderLabel.backgroundColor= [UIColor clearColor];
    placeholderLabel.font = [UIFont systemFontOfSize:13];
    [self.lblVal addSubview:placeholderLabel];
    self.placeholderLabel = placeholderLabel;
    
    
}


- (void) initData:(NSString*)data
{
    self.oldVal=([NSString isBlank:data]) ? @"" :data;
    self.currentVal=([NSString isBlank:data]) ? @"" :data;
    self.placeholderLabel.hidden = ![NSString isBlank:data];
    self.lblVal.text=self.currentVal;
    self.lblVal.textColor =  [ColorHelper getBlueColor];
    if ([NSString isBlank:data]) {
        [self initVal:self.placeholderLabel.text];
    } else {
        [self initVal:data];
    }
    

}

- (void) changeData:(NSString*)data
{
    self.currentVal=([NSString isBlank:data]) ? @"" :data;
    self.lblVal.text=([NSString isBlank:data])? @"":data;
    self.placeholderLabel.hidden = ![NSString isBlank:data];
    if ([NSString isBlank:data]) {
        [self initVal:self.placeholderLabel.text];
    } else {
        [self initVal:data];
    }
    [self changeStatus];
}
- (float) getHeight
{
    return self.line.ls_top+self.line.ls_height+1;
}
- (void)initVal:(NSString *)val
{
    self.lblVal.ls_size = [self getStringRectInTextView:val inTextView:self.lblVal];
    [self.line setLs_top:self.lblVal.ls_top+self.lblVal.ls_height+2];
    [self setLs_height:self.line.ls_top+1];
    
}


- (void)textViewDidChange:(UITextView *)textView {
    self.placeholderLabel.hidden = ![NSString isBlank:textView.text];
    int maxLength = self.num == 0 ? 200 : self.num;
    if (textView.text.length >= maxLength) {
        textView.text = [textView.text substringToIndex:maxLength];
        [self initVal:textView.text];
        [LSAlertHelper showAlert:[NSString stringWithFormat:@"字数限制在%d字以内！", maxLength]];
    }
    [self initVal:textView.text];
    self.block();
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [self changeData:self.lblVal.text];
    return YES;
}

-(void) initMaxNum:(int) num {
    self.num = num;
}


-(void) changeStatus
{
    [super isChange];
}

-(void) clearChange{
    self.oldVal=self.currentVal;
    [self changeStatus];
}

-(NSString*) getStrVal
{
    return self.currentVal;
}

- (void)editEnable:(BOOL)enable
{
    self.lblVal.textColor = enable?[ColorHelper getBlueColor]:[ColorHelper getTipColor6];
    self.lblVal.editable = enable;
}
- (void)initLocation:(NSString *)image action:(SEL)selector delegate:(id)delegate {
    if ([NSString isNotBlank:image]) {
        [self.btnLocation setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    }
    self.btnLocation.hidden = NO;
    [self.btnLocation addTarget:delegate action:selector forControlEvents:UIControlEventTouchUpInside];
}

- (CGSize)getStringRectInTextView:(NSString *)text inTextView:(UITextView *)textView {
    CGFloat contentW = CGRectGetWidth(textView.frame);
    CGFloat broadW = textView.contentInset.left + textView.contentInset.right + textView.textContainerInset.left + textView.textContainerInset.right + textView.textContainer.lineFragmentPadding + textView.textContainer.lineFragmentPadding;
    CGFloat broadH = textView.contentInset.top + textView.contentInset.bottom + textView.textContainerInset.top + textView.textContainerInset.bottom +  textView.textContainer.lineFragmentPadding;
    contentW = contentW - broadW;
    NSMutableParagraphStyle *paragraphStype = [[NSMutableParagraphStyle alloc] init];
    paragraphStype.lineBreakMode = textView.textContainer.lineBreakMode;
    NSDictionary *dic = @{NSFontAttributeName:textView.font,NSParagraphStyleAttributeName:[paragraphStype copy]};
    CGSize inSize = CGSizeMake(contentW, MAXFLOAT);
    CGSize calculatedSize = [text boundingRectWithSize:inSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    CGSize adjustSize = CGSizeMake(textView.ls_width, calculatedSize.height + broadH);
    return adjustSize;
    
}
@end
