//
//  AuditRecordDetailCell.h
//  RestApp
//
//  Created by hm on 15/1/29.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuditRecordDetailCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UIView *container;
@property (nonatomic, strong) IBOutlet UIView *auditDateBox; //审核日期
@property (nonatomic, strong) IBOutlet UILabel *lblAuditDateName;
@property (nonatomic, strong) IBOutlet UILabel *lblauditDateVal;

@property (nonatomic, strong) IBOutlet UIView *auditerBox; //审核人
@property (nonatomic, strong) IBOutlet UILabel *lblAuditerName;
@property (nonatomic, strong) IBOutlet UILabel *lblauditerVal;

@property (nonatomic, strong) IBOutlet UIView *operateTypeBox; //操作类型
@property (nonatomic, strong) IBOutlet UILabel *lblOperateType;

@property (nonatomic, strong) IBOutlet UIView *contentBox; //审核不通过原因
@property (nonatomic, strong) IBOutlet UILabel *lblReason;
@property (nonatomic, strong) IBOutlet UITextView *lblContent;
@property (nonatomic, strong) IBOutlet UIView *line;

//@property (nonatomic, strong) IBOutlet UIView *viewBox;

- (void)initLable:(int)eventType result:(int)result reason:(NSString*)reason;
- (void)setContent:(NSString *)content;
- (float)getHeight:(NSString *)content;
@end
