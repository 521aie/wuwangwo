//
//  SortTableViewCell.h
//  retailapp
//
//  Created by guozhi on 16/2/18.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SortTableViewCell2 : UITableViewCell
@property (nonatomic,assign) CGFloat h;
@property (weak, nonatomic) IBOutlet UIView *line;
- (void)setInitView:(NSString *) filePath styleName:(NSString *) styleName styleCode:(NSString*) styleCode;
@end
