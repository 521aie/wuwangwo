//
//  EditItemView.h
//  RestApp
//
//  Created by zxh on 14-4-9.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditItemBase.h"

@interface EditItemView : EditItemBase
{
    UIView *view;
}
@property (nonatomic, strong) IBOutlet UIView *view;
@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UILabel *lblVal;
@property (nonatomic, strong) IBOutlet UITextView *lblDetail;
@property (nonatomic, strong) IBOutlet UIView *line;
+ (instancetype)editItemView;
- (void)initLabel:(NSString*)label withHit:(NSString *)_hit;

- (void) initLabel:(NSString *)label withDataLabel:(NSString*)dataLabel withVal:(NSString*)data;
- (void) initData:(NSString*)dataLabel withVal:(NSString*)data;
- (void)initHit:(NSString *)_hit;
//得到具体值.
-(NSString*) getStrVal;

@end
