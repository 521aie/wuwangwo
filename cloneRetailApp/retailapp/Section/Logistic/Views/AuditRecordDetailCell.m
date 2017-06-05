//
//  AuditRecordDetailCell.m
//  RestApp
//
//  Created by hm on 15/1/29.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "AuditRecordDetailCell.h"
#import "UIView+Sizes.h"


@implementation AuditRecordDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)initLable:(int)eventType result:(int)result reason:(NSString*)reason
{
    self.lblAuditDateName.text =(eventType==1)? @"收货时间":@"退货时间";
    
    self.lblAuditerName.text = (eventType==1)?@"收货人":@"退货人";
    
    switch (eventType) {
            
        case 1:
            
            self.lblReason.text = (result==0)?@"拒绝收货原因":@"反确认收货原因";
            
            break;
            
        case 2:
            
            self.lblReason.text = (result==0)?@"拒绝退货原因":@"反确认退货原因";
            
            break;
            
        default:
            break;
    }
}

- (void)setContent:(NSString *)content{
    
    self.lblContent.text=nil;
    [self.lblContent setLs_width:300];
    self.lblContent.text=content;
    if([NSString isBlank:content]){
        [self.lblContent setLs_height:0];
    }
    float height=self.lblContent.ls_height;
    height=height+10;  //设置线的高度.
    [self.line setLs_top:height];
    height=height+21;
    height=height+48;
    if ([NSString isBlank:content]) {
        [self.contentBox setLs_height:0];
        [self.contentBox setAlpha:0];
    }else{
        [self.contentBox setLs_height:height];
    }
    self.backgroundColor = [UIColor clearColor];
}

- (float)getHeight:(NSString *)content
{
//    self.lblContent.text = content;
    
    //获取原始UITextView的frame
    CGRect orgRect=self.lblContent.frame;
    
    self.lblContent.font = [UIFont systemFontOfSize:13.0f];
    
    //计算文本的大小
    CGSize size = [content boundingRectWithSize:CGSizeMake(orgRect.size.width,CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.lblContent.font,NSFontAttributeName, nil] context:nil].size;
    
    //UITextView在上下左右分别有一个8px的padding
    orgRect.size.height = size.height + 24;

    //重设UITextView的frame
    self.lblContent.frame = orgRect;
    
    self.lblContent.text = content;

    self.lblContent.textColor = [UIColor darkGrayColor];
    
    if([NSString isBlank:content]){
        
        [self.lblContent setLs_height:0];
        
    }
    
    float height=self.lblContent.ls_height+10+self.lblReason.ls_height+10;
    
    [self.line setLs_top:height];
   
    if ([NSString isBlank:content]) {
        
        [self.contentBox setLs_height:0];
        
        [self.contentBox setAlpha:0];
        
    }else{
        
        [self.contentBox setLs_height:height];
    }
   
    height=self.auditDateBox.ls_height+self.auditerBox.ls_height+self.operateTypeBox.ls_height+self.contentBox.ls_height;
    
    [self.contentView setLs_height:height];
    
    return height;
}

@end
