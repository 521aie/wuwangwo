//
//  CellHeadItem.h
//  RestApp
//
//  Created by zxh on 14-4-28.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#define CELL_HEADER_RADIUS2 4

@interface DHHeadItem1 : UIView
@property (weak, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblVal2;
@property (weak, nonatomic) IBOutlet UILabel *lblVal1;
@property (nonatomic, strong) NSString* col1;
@property (nonatomic, strong) NSString* col2;
@property (nonatomic, strong) NSString* col3;
-(void) initColHead:(NSString*)col1 col2:(NSString*)col2 col3:(NSString*)col3;

-(void) initColLeft:(int)col1 col2:(int)col2 col3:(int)col3;

@end
