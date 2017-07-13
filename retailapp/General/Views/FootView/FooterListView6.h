//
//  FooterListView6.h
//  retailapp
//
//  Created by yanguangfu on 15/11/13.  
//  Copyright © 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FooterListEvent.h"

@interface FooterListView6 : UIView
@property (strong, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic) IBOutlet UIImageView *imgAdd;
@property (strong, nonatomic) IBOutlet UIButton *btnAdd;

@property (strong, nonatomic) IBOutlet UIImageView *imgScan;
@property (strong, nonatomic) IBOutlet UIButton *btnScan;
@property (nonatomic,strong) id<FooterListEvent> delegate;

-(void) initDelegate:(id<FooterListEvent>) delegate btnArrs:(NSArray*) arr;

- (IBAction)onScanClickEvent:(id)sender;
- (IBAction)onAddClickEvent:(id)sender;

@end
