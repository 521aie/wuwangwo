//
//  LSEditItemRadio.h
//  retailapp
//
//  Created by guozhi on 2017/3/21.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "EditItemBase.h"
#import "IEditItemRadioEvent.h"
@interface LSEditItemRadio : EditItemBase
@property (nonatomic, weak) id<IEditItemRadioEvent> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblDetail;
@property (weak, nonatomic) IBOutlet UIView *line;
+ (instancetype)editItemRadio;
- (void)initLabel:(NSString *)label withHit:(NSString *)hit;
- (void)initLabel:(NSString *)label withHit:(NSString *)hit
         delegate:(id<IEditItemRadioEvent>)delegate;
- (void)initLabel:(NSString *)label withVal:(NSString *)data withHit:(NSString *)hit;
- (void)initLabel:(NSString *)label withVal:(NSString *)data;
- (void)initData:(NSString *)data;
- (void)changeData:(NSString *)data;
- (void)editable:(BOOL)enable;
- (BOOL)getVal;
- (NSString *)getStrVal;
@end
