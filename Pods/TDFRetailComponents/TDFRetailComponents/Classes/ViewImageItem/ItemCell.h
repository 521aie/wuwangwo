//
//  ItemCell.h
//  retailapp
//
//  Created by guozhi on 15/10/14.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemCell : UIView
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblVal;
- (void)initLable:(NSString *)title withVal:(NSString *)val;
@end
