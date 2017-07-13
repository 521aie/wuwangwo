//
//  RetailTableCell2.h
//  retailapp
//
//  Created by zhangzhiliang on 15/8/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INameValueItem.h"
#import "ISampleListEvent.h"

@interface RetailTableCell2 : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UILabel *lblVal;
@property (nonatomic, strong) IBOutlet UIButton * btnDel;

@property (nonatomic, strong) id<ISampleListEvent> delegate;
@property (nonatomic, strong) id<INameValueItem> obj;
@property (nonatomic, strong) NSString* event;
@property (nonatomic) NSInteger itemMode;

-(void) initDelegate:(id<ISampleListEvent>)temp obj:(id<INameValueItem>)objTemp event:(NSString*)event;

@end
