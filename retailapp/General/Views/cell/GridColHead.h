//
//  GridColHead.h
//  RestApp
//
//  Created by zxh on 14-7-14.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CELL_HEADER_RADIUS2 4
@interface GridColHead : UITableViewCell

@property (nonatomic, strong) IBOutlet UIView *view;
@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UILabel *lblVal;
@property (nonatomic, strong) NSString *col1;
@property (nonatomic, strong) NSString *col2;
+ (instancetype)gridColHead;
- (void)initColHead:(NSString *)col1 col2:(NSString *)col2;
- (void)initColLeft:(int)col1 col2:(int)col2;
@end
