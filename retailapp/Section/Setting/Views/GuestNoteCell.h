//
//  NameValueCell.h
//  RestApp
//
//  Created by zxh on 14-4-9.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GuestNoteCellDelegate <NSObject>
- (void)onClick:(UITableViewCell *)item;
@end
@interface GuestNoteCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UIImageView *img;
@property (nonatomic, assign) id<GuestNoteCellDelegate>delegate;

@end
