//
//  FooterListView6.h
//  retailapp
//
//  Created by yanguangfu on 15/11/13.  
//  Copyright © 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FooterListEvent.h"

@interface FooterListView8 : UIView
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIButton *btnSort;
@property (weak, nonatomic) IBOutlet UIImageView *imgSort;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
@property (weak, nonatomic) IBOutlet UIImageView *imgAdd;

@property (nonatomic,strong) id<FooterListEvent> delegate;

-(void) initDelegate:(id<FooterListEvent>) delegate btnArrs:(NSArray*) arr;

- (IBAction)onSortClickEvent:(id)sender;
- (IBAction)onAddClickEvent:(id)sender;

@end
