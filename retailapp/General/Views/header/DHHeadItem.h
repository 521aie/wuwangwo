//
//  CellHeadItem.h
//  RestApp
//
//  Created by zxh on 14-4-28.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INameValueItem.h"


@interface DHHeadItem : UIView

@property (nonatomic, retain) IBOutlet UIView *panel;
@property (nonatomic, retain) IBOutlet UILabel *lblName;

@property (nonatomic, retain) id<INameValueItem> item;

- (void)initWithData:(id<INameValueItem>)item;
- (void)initWithTitle:(NSString *)itemTemp;

@end
