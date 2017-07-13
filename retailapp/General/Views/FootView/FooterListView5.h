//
//  FooterListView3.h
//  retailapp
//
//  Created by zhangzhiliang on 15/9/30.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FooterListEvent.h"

@interface FooterListView5 : UIView

@property (nonatomic, strong) IBOutlet UIView *view;
@property (nonatomic, strong) IBOutlet UIImageView *imgExport;
@property (nonatomic, strong) IBOutlet UIButton *btnExport;
@property (weak, nonatomic) IBOutlet UIImageView *imgHelp;
@property (weak, nonatomic) IBOutlet UIButton *btnHelp;
@property (weak, nonatomic) IBOutlet UIImageView *imgUnauto;
@property (weak, nonatomic) IBOutlet UIImageView *imgUnautoing;
@property (weak, nonatomic) IBOutlet UIButton *btnUnauto;
@property (weak, nonatomic) IBOutlet UILabel *labTime;




@property (nonatomic,strong) id<FooterListEvent> delegate;

-(void) initDelegate:(id<FooterListEvent>) delegate btnArrs:(NSArray*) arr;

- (IBAction)onUnautoClickEvent:(id)sender;

- (IBAction) onExportClickEvent:(id)sender;
- (IBAction) onHelpClickEvent:(id)sender;
/**正在生成按钮是否可见*/
- (void)isVisibal:(BOOL)isVisibal;

@end
