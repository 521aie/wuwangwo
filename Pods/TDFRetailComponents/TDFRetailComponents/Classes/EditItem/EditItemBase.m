//
//  EditItemBase.m
//  RestApp
//  编辑项基类.
//
//  Created by zxh on 14-4-2.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "EditItemBase.h"
#import "UIView+Sizes.h"

@implementation EditItemBase

- (BOOL)isChange {
   
    BOOL isChangeFlag=!(self.currentVal==self.oldVal || [self.currentVal isEqualToString:self.oldVal]);
    self.lblTip.layer.backgroundColor=[UIColor redColor].CGColor;
    self.lblTip.textColor=[UIColor whiteColor];
    self.lblTip.text=@"未保存";
    self.lblTip.layer.cornerRadius = 2;
    [self.lblTip setLs_width:32];
    [self.lblTip setLs_height:12];
    self.baseChangeStatus=isChangeFlag;
    [self.lblTip setHidden:!isChangeFlag];
    if (self.notificationType) {
        [[NSNotificationCenter defaultCenter] postNotificationName:self.notificationType object:self];
    }
    
    return isChangeFlag;
}

//保存完取消 【未保存】状态 用
- (void)setChangedStatus {
    self.oldVal = self.currentVal;
    self.baseChangeStatus=NO;
    [self.lblTip setHidden:YES];
}

- (void)visibal:(BOOL)show
{
    [self setLs_height:show?[self getHeight]:0];
    self.hidden = !show;
}

- (void)clearChange {
    self.oldVal = self.currentVal;
    [self isChange];
}

- (id)loadNibWithowner:(id)owner {
    //由子类重载
    return nil;
}
@end
