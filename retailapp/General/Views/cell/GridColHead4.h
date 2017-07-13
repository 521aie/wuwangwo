//
//  GridColHead4.h
//  retailapp
//
//  Created by zhangzhiliang on 15/9/1.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISampleListEvent.h"
#define CELL_HEADER_RADIUS2 4

@interface GridColHead4 : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UIButton *btnEdit;
@property (strong, nonatomic) IBOutlet UIButton *btnAdd;

@property (weak, nonatomic) id<ISampleListEvent>delegate;
@property (nonatomic) int event;
@property (nonatomic, strong) NSString *objId;

+ (id)getInstance:(UITableView *)tableView;
- (void)initColHead:(NSString *)col1 col2:(NSString *)col2 event:(int)event;
@end
