//
//  SmsExistItem.h
//  RestApp
//
//  Created by zxh on 14-11-10.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ISmsDelegate;

@interface SmsRemainNumItem : UIView
{
    id<ISmsDelegate> smsDelegate;
}
@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UILabel *lblVal;
@property (nonatomic, strong) IBOutlet UILabel *lblDetail;
@property (nonatomic, strong) IBOutlet UIView *line;
@property (nonatomic, strong) IBOutlet UIButton *btn;
@property (nonatomic, strong) NSString* currentVal;
+ (instancetype)smsRetainNumItem;
- (void)initLabel:(NSString*)label withHit:(NSString *)_hit delegate:(id<ISmsDelegate>)delegate;

- (void)initData:(NSString*)dataLabel withVal:(NSString*)data;

- (NSString*)getStrVal;

- (float)getHeight;

- (IBAction)btnMoney:(id)sender;
- (void)showChargeBtn:(BOOL)isShow;
@end

@protocol ISmsDelegate <NSObject>
- (void)startCharge:(int)remainNum;

@end
