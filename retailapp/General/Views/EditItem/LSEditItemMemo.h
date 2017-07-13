//
//  LSEditItemMemo.h
//  retailapp
//
//  Created by guozhi on 2017/3/18.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "EditItemBase.h"
#import "IEditItemMemoEvent.h"
@interface LSEditItemMemo : EditItemBase
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblHit;
@property (weak, nonatomic) IBOutlet UILabel *lblVal;
@property (weak, nonatomic) IBOutlet UIView *line;
@property BOOL isReq;
@property (nonatomic, weak) id<IEditItemMemoEvent> delegate;
@property (nonatomic, assign) BOOL isEdit;
+ (instancetype)editItemMemo;
- (void)initVal:(NSString *)val;
- (void)initLabel:(NSString*)label isrequest:(BOOL)req  delegate:(id<IEditItemMemoEvent>) delegate;
- (void) initData:(NSString*)data;
- (void) changeData:(NSString*)data;
- (void)editEnable:(BOOL)enable;
- (NSString *)getStrVal;
@end
