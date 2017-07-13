//
//  ColumnHead.h
//  RestApp
//
//  Created by zxh on 14-7-9.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColumnHead : UIView

@property (nonatomic, strong) IBOutlet UIView *view;
@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UILabel *lblVal;

@property (nonatomic,strong) NSString* col1;
@property (nonatomic,strong) NSString* col2;

-(void) initColHead:(NSString*)col1 col2:(NSString*)col2;
-(void) initColLeft:(int)col1 col2:(int)col2;
-(void) visibal:(BOOL)visibal;

@end
