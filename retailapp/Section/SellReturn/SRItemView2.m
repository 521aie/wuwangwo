//
//  SRItemView2.m
//  retailapp
//
//  Created by Jianyong Duan on 15/11/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SRItemView2.h"

@implementation SRItemView2

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+ (SRItemView2 *)loadFromNib {
    SRItemView2* itemView = [[[NSBundle mainBundle] loadNibNamed:@"SRItemView2" owner:nil options:nil] objectAtIndex:0];
    return itemView;
}

- (void)setTitle:(NSString *)title value:(NSString *)value {
    self.lblTitle.text = title;
    
    CGFloat _h = 0;
    if ([value respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        [paragraphStyle setLineSpacing:5];
        //        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSParagraphStyleAttributeName:paragraphStyle.copy};
        
        CGRect rect = [value boundingRectWithSize:CGSizeMake(280, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        _h = rect.size.height + 45;
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:value];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [value length])];
        self.lblValue.attributedText = attributedString;
        
    } else {
        CGSize size = [NSString getTextSizeWithText:value font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(280, MAXFLOAT)];
        _h = size.height + 45;
        self.lblValue.text = value;
    }

    CGRect rect = self.frame;
    rect.size.height = MAX(_h, 71);
    self.frame = rect;
}

@end
