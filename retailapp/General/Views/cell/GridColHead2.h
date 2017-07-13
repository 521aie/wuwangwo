//
//  GridColHead2.h
//  retailapp
//
//  Created by zhangzhiliang on 15/7/14.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#define CELL_HEADER_RADIUS2 4

@interface GridColHead2 : UITableViewCell

@property (nonatomic, strong) IBOutlet UIView *view;
@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UILabel *lblVal1;
@property (nonatomic, strong) IBOutlet UILabel *lblVal2;

@property (nonatomic, strong) NSString* col1;
@property (nonatomic, strong) NSString* col2;
@property (nonatomic, strong) NSString* col3;

-(void) initColHead:(NSString*)col1 col2:(NSString*)col2 col3:(NSString*)col3;

-(void) initColLeft:(int)col1 col2:(int)col2 col3:(int)col3;


@end
