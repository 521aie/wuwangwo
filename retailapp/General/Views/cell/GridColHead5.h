//
//  GridColHead5.h
//  retailapp
//
//  Created by zhangzhiliang on 15/9/14.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GridColHead5 : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *lblVal;
@property (nonatomic, strong) IBOutlet UILabel *lblTip;

-(void) initColHead:(NSString*)val;

@end
