//
//  FooterListView6.h
//  retailapp
//
//  Created by yanguangfu on 15/11/13.  
//  Copyright © 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FooterListEvent.h"

@interface FooterListView7 : UIView
@property (strong, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic) IBOutlet UIImageView *imgBatch;
@property (strong, nonatomic) IBOutlet UIButton *btnBatch;

@property (strong, nonatomic) IBOutlet UIImageView *imgExport;
@property (strong, nonatomic) IBOutlet UIButton *btnExport;
@property (nonatomic,strong) id<FooterListEvent> delegate;

-(void) initDelegate:(id<FooterListEvent>) delegate btnArrs:(NSArray*) arr;

- (IBAction)onBatchClickEvent:(id)sender;
- (IBAction)onExportClickEvent:(id)sender;

@end
